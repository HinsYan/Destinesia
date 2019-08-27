//
//  DTSAssetsGridViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSAssetsGridViewController.h"
#import "DTSPhotoThumbCell.h"


// cell之间的间隔
#define kCellOffset 2
// 一行几个cell
#define kCellCountOfALine 3

#define kHeightTopView 44


@interface DTSAssetsGridViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    PHPhotoLibraryChangeObserver
>

@property (nonatomic, assign) CGSize assetGridThumbnailSize;

@property (assign, nonatomic) BOOL isSelectedImage;        //是否已经选择

@end

@implementation DTSAssetsGridViewController
{
    dispatch_once_t onceToken;
    BOOL isCollectionViewLoaded;  /**< collectionView是否已加载数据 */
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit];
    
    [self initTopView];

    [self initUICollectionView];
    
    _isSelectedImage = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commonInit
{
    CGFloat width = (kDTSScreenWidth - 6.f)/4.f;
    CGFloat scale = [UIScreen mainScreen].scale;
    if ([[[UIDevice currentDevice] model] hasPrefix:@"iPad"] && [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.3) {
        scale = 3.5f;
    }
    NSInteger value = width*scale;
    _assetGridThumbnailSize = (CGSize){value,value};
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)setAlbumModel:(DTSAlbumModel *)albumModel
{
    _albumModel = albumModel;
    _assetsFetchResults = _albumModel.fetchResult;
    
    _titleLabel.text = _albumModel.albumName;
}

#pragma mark - UI Event

- (void)initTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDTSScreenWidth, kHeightTopView)];
    _topView.backgroundColor = kUIColorMain;
    [self.view addSubview:_topView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:_topView.frame];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_topView addSubview:_titleLabel];
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kHeightTopView)];
    [_btnLeft setTitle:@"Left" forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_btnLeft addTarget:self action:@selector(actionBtnLeft:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnLeft];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_topView.frame) - 60, 0, 60, kHeightTopView)];
    [_btnRight setTitle:@"Right" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_btnRight addTarget:self action:@selector(actionBtnRight:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnRight];
}

- (void)actionBtnLeft:(UIButton *)sender
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionBtnRight:(UIButton *)sender {

}

#pragma mark - UICollectionView

- (void)initUICollectionView
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGRect frame = CGRectMake(0, 44, kDTSScreenWidth, kDTSScreenHeight - 44);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DTSPhotoThumbCell" bundle:nil] forCellWithReuseIdentifier:kDTSPhotoThumbCell];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)configureCell:(DTSPhotoThumbCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = _assetsFetchResults[indexPath.row];
    [[DTSPhotoKitManager sharedInstance] cancelImageRequest:cell.imageRequestID];
    cell.imageRequestID = [[DTSPhotoKitManager sharedInstance] requestImageForAsset:asset
                                                                       targetSize:_assetGridThumbnailSize
                                                                      contentMode:PHImageContentModeAspectFill
                                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                        if (result) {
                                                                            cell.thumbImageView.image = result;
                                                                            cell.imageRequestID = 0;
                                                                        }
                                                                    }];
}


//  Bugfix 9.3 iPad size太小无法加载缩略图
- (void)reloadDataForCell:(DTSPhotoThumbCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (kDTSScreenWidth - 6.f)/4.f;
    CGFloat scale = 3.5f;
    _assetGridThumbnailSize = (CGSize){width*scale,width*scale};
    
    PHAsset *asset = _assetsFetchResults[indexPath.row];
    [[DTSPhotoKitManager sharedInstance] cancelImageRequest:cell.imageRequestID];
    cell.imageRequestID = [[DTSPhotoKitManager sharedInstance] requestImageForAsset:asset
                                                                       targetSize:_assetGridThumbnailSize
                                                                      contentMode:PHImageContentModeAspectFill
                                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                        cell.thumbImageView.image = result;
                                                                        cell.imageRequestID = 0;
                                                                    }];

}

- (void)animationWithImage:(UIImage *)image
                startFrame:(CGRect)startFrame
                  endFrame:(CGRect)endFrame
                  isZoomIn:(BOOL)zoomIn
                completion:(void (^ __nullable)(void))completion
{
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:contentView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = !zoomIn;
    [contentView addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = startFrame;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:imageView];

    [self.view insertSubview:contentView aboveSubview:self.collectionView];
    [UIView animateWithDuration:.25f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         imageView.frame = endFrame;
                         bgView.alpha = zoomIn;
                     } completion:^(BOOL finished) {
                         [contentView removeFromSuperview];
                         if (completion) {
                             completion();
                         }
                     }];
}

- (CGRect)showRectWithFrame:(CGRect)frame image:(UIImage *)image
{
    CGSize viewSize = frame.size;
    CGSize imageSize = image.size;
    CGFloat showWidth, showHeight;
    showHeight = viewSize.height;
    showWidth = imageSize.width / imageSize.height * showHeight;
    if(showWidth > viewSize.width)
    {
        showWidth = viewSize.width;
        showHeight = imageSize.height / imageSize.width * showWidth;
    }

    CGFloat showOriginalX = (viewSize.width - showWidth)/2.f + frame.origin.x;
    CGFloat showOriginalY = (viewSize.height - showHeight)/2.f + frame.origin.y;
    return (CGRect){showOriginalX,showOriginalY,showWidth,showHeight};
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    isCollectionViewLoaded = YES;
    return _assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DTSPhotoThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDTSPhotoThumbCell
                                                                     forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_once(&onceToken, ^{
        NSIndexPath *tIndexPath = [NSIndexPath indexPathForItem:_assetsFetchResults.count-1
                                                      inSection:0];
        [_collectionView scrollToItemAtIndexPath:tIndexPath
                                atScrollPosition:UICollectionViewScrollPositionBottom
                                        animated:NO];
    });

}

- (void)didSelectPHAssetAtIndexPath:(NSIndexPath *)indexPath
{
    //  图片提前缓存
    __weak typeof(self) weakSelf = self;
    [[DTSPhotoKitManager sharedInstance] requestImageForAsset:_assetsFetchResults[indexPath.item]
                                                  targetSize:PHImageManagerMaximumSize
                                                 contentMode:PHImageContentModeAspectFill
                                               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                   
         __strong typeof(weakSelf) strongSelf = weakSelf;
         
         if( [info objectForKey:@"PHImageFileURLKey"] && strongSelf.isSelectedImage)
         {
             if( strongSelf.gridDelegate && [_gridDelegate respondsToSelector:@selector(assetGridSelected:didFinishPickingMediaWithImage:)])
             {
                 strongSelf.isSelectedImage = NO;
                 [_gridDelegate assetGridSelected:strongSelf didFinishPickingMediaWithImage:result];
             }
         }
                                                   
     }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isSelectedImage = YES;
    
    [self didSelectPHAssetAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kDTSScreenWidth - kCellOffset * (kCellCountOfALine - 1)) / kCellCountOfALine;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kCellOffset, 0, kCellOffset, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellOffset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellOffset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kDTSScreenWidth, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    // Get the new fetch result.
    self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!isCollectionViewLoaded) {
            return ;
        }
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            
            NSArray<NSIndexPath *> * removedPaths = [[collectionChanges removedIndexes] aapl_indexPathsFromIndexesWithSection:0];
            NSArray<NSIndexPath *> * insertedPaths = [[collectionChanges insertedIndexes] aapl_indexPathsFromIndexesWithSection:0];
            NSArray<NSIndexPath *> * changedPaths = [[collectionChanges changedIndexes] aapl_indexPathsFromIndexesWithSection:0];
            
            BOOL shouldReload = NO;
            
            if ((changedPaths != nil) + (removedPaths != nil) + (insertedPaths!= nil) > 1) {
                shouldReload = YES;
            }
            
            if (shouldReload) {
                [collectionView reloadData];
                
            } else {
                
                @try {
                    [collectionView performBatchUpdates:^{
                        if ([removedPaths count] > 0) {
                            [collectionView deleteItemsAtIndexPaths:removedPaths];
                        }
                        
                        if ([insertedPaths count] > 0) {
                            [collectionView insertItemsAtIndexPaths:insertedPaths];
                        }
                        
                        if ([changedPaths count] > 0) {
                            [collectionView reloadItemsAtIndexPaths:changedPaths];
                        }
                    } completion:nil];
                    
                }
                @catch (NSException *exception) {
                    [collectionView reloadData];
                }


            }
        }
    });
}

@end
