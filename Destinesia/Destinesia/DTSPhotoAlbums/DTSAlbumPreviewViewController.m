//
//  DTSAlbumPreviewViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/2.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSAlbumPreviewViewController.h"
#import "DTSNewTripAlbumCreationViewController.h"
#import "DTSCameraWatermark.h"

// cell之间的间隔
#define kCellOffset 1

#define kHeightToolBar 55

#define kHeightCollectionView 60


@interface DTSAlbumPreviewViewController ()

@end

@implementation DTSAlbumPreviewViewController
{
    UIImageView *_previewImageView;
    
    DTSCameraWatermark *cameraWatermark;
    
    UIView *_toolBar;
    
    UIButton *_btnBack;
    UIButton *_btnGrid;
    UIButton *_btnDelete;
    
    NSIndexPath *currentSelectedAssetIndexPathPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWatermark];
    
    self.topView.hidden = YES;
    
    [self initToolBar];
    
    [self customUICollectionView];
    
    [self initPreviewImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initPreviewImageView
{
    _previewImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:_previewImageView atIndex:0];
    _previewImageView.image = [UIImage imageNamed:@"LaunchScreen.jpg"];
    
    currentSelectedAssetIndexPathPath = [NSIndexPath indexPathForItem:self.assetsFetchResults.count - 1 inSection:0];
    [self updatePreviewImageAtIndexPath:currentSelectedAssetIndexPathPath];
    
    [self.collectionView scrollToItemAtIndexPath:currentSelectedAssetIndexPathPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self.collectionView reloadItemsAtIndexPaths:@[currentSelectedAssetIndexPathPath]];
}

- (void)updatePreviewImageAtIndexPath:(NSIndexPath *)indexPath
{
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    
    __block BOOL isPhotoInCloud = NO;
    
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:imageRequestOptions
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
        if ([info[@"PHImageResultIsInCloudKey"] boolValue] && result == nil) {
            isPhotoInCloud = YES;
        } else {
            _previewImageView.image = [result dts_imageFitTargetSize:kDTSScreenSize];
            
            currentSelectedAssetIndexPathPath = indexPath;
            
            [self updateWatermarkAtAssetIndexPath:currentSelectedAssetIndexPathPath];
        }
                                                }];
    
    if (isPhotoInCloud) {
        [DTSToastUtil toastWithText:@"iCloud云相册的照片，需要先下载到系统相册，再重试哦~"];
    }
}

#pragma mark - Watermark

- (void)initWatermark {
    cameraWatermark= [[DTSCameraWatermark alloc] initWithFrame:CGRectMake(0, 0, kDTSScreenWidth, 60)];
    [self.view addSubview:cameraWatermark];
    
    [self updateWatermarkAtAssetIndexPath:currentSelectedAssetIndexPathPath];
    
    [cameraWatermark.timer invalidate];
    cameraWatermark.timer = nil;
}

- (void)updateWatermarkAtAssetIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    cameraWatermark.lbDate.text = [[DTSDateFormatter sharedInstance] stringDateFormatted:asset.creationDate];
    
    CLLocation *location = asset.location;
    cameraWatermark.lbLocation.text = [NSString stringWithFormat:@"%f, %f", location.coordinate.longitude, location.coordinate.latitude];
}

#pragma mark - ToolBar

- (void)initToolBar
{
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kDTSScreenHeight - kHeightToolBar, kDTSScreenWidth,  kHeightToolBar)];
    [self.view addSubview:_toolBar];
    
    // add blur effect
    UIImageView *bgImageView= [[UIImageView alloc] initWithFrame:_toolBar.bounds];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"iconStar_3.png"];
    [_toolBar addSubview:bgImageView];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = bgImageView.bounds;
    [_toolBar addSubview:effectView];
    
    [self initToolBarBtns];
}

- (void)initToolBarBtns
{
    CGFloat heightBtn = kHeightToolBar;
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, heightBtn, heightBtn)];
    [_btnBack setImage:[UIImage imageNamed:@"btnBack"] forState:UIControlStateNormal];
    [_toolBar addSubview:_btnBack];
    
    _btnGrid = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(_toolBar.frame) - heightBtn) / 2, 0, heightBtn, heightBtn)];
    [_btnGrid setImage:[UIImage imageNamed:@"btnFilter"] forState:UIControlStateNormal];
    [_toolBar addSubview:_btnGrid];
    
    _btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_toolBar.frame) - heightBtn, 0, heightBtn, heightBtn)];
    [_btnDelete setImage:[UIImage imageNamed:@"btnSettings"] forState:UIControlStateNormal];
    [_toolBar addSubview:_btnDelete];
    
    [_btnBack addTarget:self action:@selector(actionBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    [_btnGrid addTarget:self action:@selector(actionBtnGrid:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDelete addTarget:self action:@selector(actionBtnDelete:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionBtnBack:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionBtnGrid:(UIButton *)sender
{
    DTSNewTripAlbumCreationViewController *newTripAlbumCreationVC = [[DTSNewTripAlbumCreationViewController alloc] init];
    newTripAlbumCreationVC.albumModel = self.albumModel;
    [self.navigationController pushViewController:newTripAlbumCreationVC animated:YES];
}

- (void)actionBtnDelete:(UIButton *)sender
{
    [DTSToastUtil toastWithText:@"暂未完成删除照片操作"];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    currentSelectedAssetIndexPathPath = indexPath;
    
    [self updatePreviewImageAtIndexPath:indexPath];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)customUICollectionView
{
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.frame = CGRectMake(0,
                                           kDTSScreenHeight - kHeightToolBar - kHeightCollectionView,
                                           kDTSScreenWidth,
                                           kHeightCollectionView);
    [self.view bringSubviewToFront:self.collectionView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == currentSelectedAssetIndexPathPath) {
        return CGSizeMake(60, kHeightCollectionView);
    }
    
    return CGSizeMake(30, kHeightCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellOffset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellOffset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
