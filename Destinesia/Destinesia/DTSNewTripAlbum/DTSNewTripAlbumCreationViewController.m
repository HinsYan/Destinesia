//
//  DTSNewTripAlbumCreationViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSNewTripAlbumCreationViewController.h"
#import "DTSTripDetailViewController.h"
#import "DTSPhotoThumbCell.h"
#import "ViewTripDetailWatermark.h"
#import "RealmAccountManager.h"
#import "DTSTripAlbumsManager.h"


// 新建旅行专辑的三步
typedef NS_ENUM(NSInteger, ENUM_NewTripAlbumStep) {
    kNewTripAlbumStep_1 = 1,    // 新建专辑页选择照片, 则需要多选加序号
    kNewTripAlbumStep_2,        // 新建专辑页选择封面
    kNewTripAlbumStep_3         // 预览和创建
};


@interface DTSNewTripAlbumCreationViewController ()

@property (nonatomic, assign) ENUM_NewTripAlbumStep kNewTripAlbumStep;

@property (nonatomic, strong) UIView *viewPreviewNewTripAlbum;

@end

@implementation DTSNewTripAlbumCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DTSNewTripPhotosSelectionManager sharedInstance].isNewTripAlbumCreated = NO;
    
    [self setNewTripAlbumStep:kNewTripAlbumStep_1];
    
    self.collectionView.allowsMultipleSelection = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTopBarBtns {
    UIImage *imageClose = [UIImage imageNamed:@"btnClose"];
    UIImage *imageBack = [UIImage imageNamed:@"btnBack"];
    
    // 从Camera进入NewTripAlbum, 且Step 1的时候, btnBack的图片要替换
    if (_goToNewTripAlbumFromSource == kGoToNewTripAlbumFromSource_Camera &&
        _kNewTripAlbumStep == kNewTripAlbumStep_1) {
        [self.btnLeft setImage:imageClose forState:UIControlStateNormal];
    } else {
        [self.btnLeft setImage:imageBack forState:UIControlStateNormal];
    }
}

- (void)actionBtnLeft:(UIButton *)sender
{
    switch (_kNewTripAlbumStep) {
        case kNewTripAlbumStep_1:
            [[DTSNewTripPhotosSelectionManager sharedInstance] resetSelectedPhotos];
            
//            // Step 1时, 点击返回要考虑两种情况: 返回至Camera或TripAlbums
//            switch (_goToNewTripAlbumFromSource) {
//                case kGoToNewTripAlbumFromSource_Camera:
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                    break;
//                case kGoToNewTripAlbumFromSource_TripAlbums:
//                    [self.navigationController popViewControllerAnimated:YES];
//                    break;
//                default:
//                    break;
//            }
            [super actionBtnLeft:sender];
            break;
        case kNewTripAlbumStep_2:
            [self setNewTripAlbumStep:kNewTripAlbumStep_1];
            break;
        case kNewTripAlbumStep_3:
            [self setNewTripAlbumStep:kNewTripAlbumStep_2];
        default:
            break;
    }
}

- (void)actionBtnRight:(UIButton *)sender
{
    [super actionBtnRight:sender];
    
    switch (_kNewTripAlbumStep) {
        case kNewTripAlbumStep_1:
            if ([DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels.count > 0) {
                [self setNewTripAlbumStep:kNewTripAlbumStep_2];
            } else {
                [DTSToastUtil toastWithText:@"请先为专辑选择一些照片"];
            }
            break;
        case kNewTripAlbumStep_2:
            if ([DTSNewTripPhotosSelectionManager sharedInstance].selectedCoverPhotoModel) {
                [self setNewTripAlbumStep:kNewTripAlbumStep_3];
            } else {
                [DTSToastUtil toastWithText:@"请先为专辑选择一张封面"];
            }
            break;
        case kNewTripAlbumStep_3:
            [self createNewTripAlbum];
        default:
            break;
    }
}

#pragma mark - new trip creation steps

- (void)setNewTripAlbumStep:(ENUM_NewTripAlbumStep)step
{
    _kNewTripAlbumStep = step;
    
    switch (_kNewTripAlbumStep) {
        case kNewTripAlbumStep_1:
            self.titleLabel.text = @"Step 1\n为专辑挑选照片";
            [self.btnLeft setTitle:@"返回" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"下一步" forState:UIControlStateNormal];
            
            [self gotoNewTripAlbumStep1];
            break;
        case kNewTripAlbumStep_2:
            self.titleLabel.text = @"Step 2\n为专辑选择一张封面";
            [self.btnLeft setTitle:@"上一步" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"下一步" forState:UIControlStateNormal];
            
            [self gotoNewTripAlbumStep2];
            break;
        case kNewTripAlbumStep_3:
            self.titleLabel.text = @"Step 3\n创建专辑";
            [self.btnLeft setTitle:@"上一步" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"创建" forState:UIControlStateNormal];
            
            [self gotoNewTripAlbumStep3];
        default:
            break;
    }
}

- (void)gotoNewTripAlbumStep1
{
    [self resetAlbumForPhotoSelection];
}

- (void)resetAlbumForPhotoSelection {
    NSLog(@"resetAlbumForPhotoSelection");
    
    self.collectionView.allowsMultipleSelection = YES;
    
    // 重置已选cover的cell
    ModelNewTripAlbumPhoto *selectedCoverPhotoModel = [DTSNewTripPhotosSelectionManager sharedInstance].selectedCoverPhotoModel;
    if (selectedCoverPhotoModel) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedCoverPhotoModel.indexOfAlbumDataSource inSection:0];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    // 选中已选photo的cell
    for (ModelNewTripAlbumPhoto *modelPhoto in [DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:modelPhoto.indexOfAlbumDataSource inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        
        DTSPhotoThumbCell *cell = (DTSPhotoThumbCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        NSInteger photoIndex = modelPhoto.indexOfSelectedCell;
        NSString *photoIndexString;
        if (photoIndex < 10) {
            photoIndexString = [NSString stringWithFormat:@"0%ld", (long)photoIndex];
        } else {
            photoIndexString = [NSString stringWithFormat:@"%ld", (long)photoIndex];
        }
        cell.lbPhotoIndex.text = photoIndexString;
    }
}

/**
 *  根据back or step来更新相册中cell
 *
 *  @param ifUpdate YES - 从step 1进入step 2, 要更新cell; NO - 从step 3返回至step 2, 不更新cell
 */
- (void)gotoNewTripAlbumStep2 {
    [_viewPreviewNewTripAlbum removeFromSuperview];
    _viewPreviewNewTripAlbum = nil;
    
    [self resetAlbumForCoverSelection];
}

- (void)resetAlbumForCoverSelection {
    NSLog(@"resetAlbumForCoverSelection");
    
    self.collectionView.allowsMultipleSelection = NO;
    
    // 重置已选photo的cell
    for (ModelNewTripAlbumPhoto *modelPhoto in [DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:modelPhoto.indexOfAlbumDataSource inSection:0];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    // 选中已选cover的cell
    ModelNewTripAlbumPhoto *selectedCoverPhotoModel = [DTSNewTripPhotosSelectionManager sharedInstance].selectedCoverPhotoModel;
    if (selectedCoverPhotoModel) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedCoverPhotoModel.indexOfAlbumDataSource inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        
        DTSPhotoThumbCell *cell = (DTSPhotoThumbCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.lbPhotoIndex.text = @"F";
        cell.btnEdit.hidden = YES;
    }
    
}

- (void)gotoNewTripAlbumStep3 {
    ModelNewTripAlbumPhoto *coverModel = [DTSNewTripPhotosSelectionManager sharedInstance].selectedCoverPhotoModel;
    NSLog(@"cover : %ld, indexPath : %ld", (long)coverModel.indexOfSelectedCell, (long)coverModel.indexOfAlbumDataSource);
    for (ModelNewTripAlbumPhoto *photoModel in [DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels) {
        NSLog(@"photo : %ld, indexPath : %ld", (long)photoModel.indexOfSelectedCell, (long)photoModel.indexOfAlbumDataSource);
    }
    
    [self initTripAlbumPreview];
}

- (void)initTripAlbumPreview
{
    if (!_viewPreviewNewTripAlbum) {
        _viewPreviewNewTripAlbum = [[UIView alloc] initWithFrame:self.collectionView.frame];
        [self.view addSubview:_viewPreviewNewTripAlbum];
        
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _viewPreviewNewTripAlbum.bounds;
        [_viewPreviewNewTripAlbum addSubview:effectView];
        
        CGRect previewRect = CGRectMake((CGRectGetWidth(_viewPreviewNewTripAlbum.frame) - 200) / 2, 40, 200, 350);
        UIView *previewCover = [[UIView alloc] initWithFrame:previewRect];
        [_viewPreviewNewTripAlbum addSubview:previewCover];
        
        UIImageView *imageViewPreviewNewTripAlbumCover = [[UIImageView alloc] initWithFrame:previewCover.bounds];
        imageViewPreviewNewTripAlbumCover.contentMode = UIViewContentModeScaleAspectFit;
        [previewCover addSubview:imageViewPreviewNewTripAlbumCover];
        // TODO: 预览图片为封面, 添加水印
        [[DTSNewTripPhotosSelectionManager sharedInstance] updateSelectedCoverForSize:PHImageManagerMaximumSize WithCompletionBlock:^(UIImage *selectedCover) {
            
            imageViewPreviewNewTripAlbumCover.image = [selectedCover dts_imageFitTargetSize:imageViewPreviewNewTripAlbumCover.frame.size];
            
        }];
        
        // 添加水印        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ViewTripDetailWatermark" owner:nil options:nil];
        ViewTripDetailWatermark *watermark = [arr firstObject];
        watermark.frame = CGRectMake(0, CGRectGetHeight(previewCover.frame) - 200, CGRectGetWidth(previewCover.frame), 200);
        [previewCover addSubview:watermark];
        RealmAccount *currentLoginAccount = [RealmAccountManager currentLoginAccount];
        watermark.lbAuthor.text = currentLoginAccount.username;
        watermark.iconUserGrade.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconStar_%ld.png", (long)currentLoginAccount.authorGrade]];
        NSString *currentCity = [DTSLocation sharedInstance].currentCity;
        NSArray *cityStr = [currentCity componentsSeparatedByString:@", "];
        if (cityStr.count == 3) {
            watermark.lbCity.text       = cityStr[0];
            watermark.lbProvince.text   = cityStr[1];
            watermark.lbCountry.text    = cityStr[2];
        }
        watermark.lbDate.text = [[DTSDateFormatter sharedInstance] stringShortDateFormatted:[NSDate date]];
        
        // 预览button
        UIButton *btnPreview = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        [btnPreview setTitle:@"预览" forState:UIControlStateNormal];
        [btnPreview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnPreview.layer.cornerRadius = 5.f;
        btnPreview.layer.borderWidth = 1.f;
        btnPreview.layer.borderColor = [UIColor whiteColor].CGColor;
        btnPreview.backgroundColor = kUIColorMain;
        btnPreview.center = CGPointMake(previewCover.center.x, CGRectGetMaxY(previewCover.frame) + 40);
        [btnPreview addTarget:self action:@selector(gotoPreview:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPreviewNewTripAlbum addSubview:btnPreview];
    }
}

// TODO: 新建专辑, step之间来回切换时cell的标记

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    
    __block BOOL isPhotoInCloud = NO;
    PHAsset *selectedPHAsset = self.assetsFetchResults[indexPath.item];
    [[PHImageManager defaultManager] requestImageForAsset:selectedPHAsset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:imageRequestOptions
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                
                                                if ([info[@"PHImageResultIsInCloudKey"] boolValue] && result == nil) {
                                                    DTSLog(@"PHImageResultIsInCloudKey");
                                                    isPhotoInCloud = YES;
                                                }
                                                
                                            }];
    if (isPhotoInCloud) {
        [DTSToastUtil toastWithText:@"iCloud云相册的照片，需要先下载到系统相册，再重试哦~"];
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        return;
    }
    
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    NSString *localIdentifier = selectedPHAsset.localIdentifier;
    NSArray *arr = [localIdentifier componentsSeparatedByString:@"/"];
    if (arr.count > 0) {
        localIdentifier = [arr firstObject];
    }
    
    ModelNewTripAlbumPhoto *newTripAlbumPhoto = [[ModelNewTripAlbumPhoto alloc] init];
    newTripAlbumPhoto.indexOfAlbumDataSource = indexPath.item;
    newTripAlbumPhoto.localIdentifier = localIdentifier;
    
    newTripAlbumPhoto.createDate    = 123466756765;
    newTripAlbumPhoto.longitude     = selectedPHAsset.location.coordinate.longitude;
    newTripAlbumPhoto.latitude      = selectedPHAsset.location.coordinate.latitude;
    
    switch (_kNewTripAlbumStep) {
        case kNewTripAlbumStep_1:
        {
            [[DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels addObject:newTripAlbumPhoto];
            newTripAlbumPhoto.indexOfSelectedCell = [DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels.count;
            [self collectionView:collectionView updateCellInfoViaAddIndexPath:indexPath];
            break;
        }
        case kNewTripAlbumStep_2:
        {
            [DTSNewTripPhotosSelectionManager sharedInstance].selectedCoverPhotoModel = newTripAlbumPhoto;
            DTSPhotoThumbCell *cell = (DTSPhotoThumbCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.lbPhotoIndex.text = @"F";
            cell.btnEdit.hidden = YES;
            break;
        }
        case kNewTripAlbumStep_3:
            break;
        default:
            break;
    }
    NSLog(@"done");
}

// 每次只更新一个cell
- (void)collectionView:(UICollectionView *)collectionView updateCellInfoViaAddIndexPath:(NSIndexPath *)indexPath
{
    DTSPhotoThumbCell *cell = (DTSPhotoThumbCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger photoIndex = [DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels.count;
    NSString *photoIndexString;
    if (photoIndex < 10) {
        photoIndexString = [NSString stringWithFormat:@"0%ld", (long)photoIndex];
    } else {
        photoIndexString = [NSString stringWithFormat:@"%ld", (long)photoIndex];
    }
    cell.lbPhotoIndex.text = photoIndexString;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    
    switch (_kNewTripAlbumStep) {
        case kNewTripAlbumStep_1:
        {
            [self collectionView:collectionView updateCellInfoViaRemoveIndexPath:indexPath];
            break;
        }
        case kNewTripAlbumStep_2:
            
            break;
        case kNewTripAlbumStep_3:
            break;
        default:
            break;
    }
}

// 每次可能更新多个cell
- (void)collectionView:(UICollectionView *)collectionView updateCellInfoViaRemoveIndexPath:(NSIndexPath *)indexPathToRemove {
    NSInteger selectionIndexOfCellToRemove = [[DTSNewTripPhotosSelectionManager sharedInstance] removeNewTripPhotoAtIndexPath:indexPathToRemove];
    
    // 更新其他的已选photo
    for (ModelNewTripAlbumPhoto *modelPhoto in [DTSNewTripPhotosSelectionManager sharedInstance].selectedPhotoModels) {
        if (modelPhoto.indexOfSelectedCell + 1 > selectionIndexOfCellToRemove) {
            
            DTSPhotoThumbCell *cellToUpdate = (DTSPhotoThumbCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:modelPhoto.indexOfAlbumDataSource inSection:0]];
            
            NSLog(@"cell to update : %ld", (long)modelPhoto.indexOfAlbumDataSource);
            
            modelPhoto.indexOfSelectedCell -= 1;
            
            // 更新其他受影响的cell的photoIndex.
            NSString *photoIndexString;
            if (modelPhoto.indexOfSelectedCell < 10) {
                photoIndexString = [NSString stringWithFormat:@"0%ld", (long)modelPhoto.indexOfSelectedCell];
            } else {
                photoIndexString = [NSString stringWithFormat:@"%ld", (long)modelPhoto.indexOfSelectedCell];
            }
            cellToUpdate.lbPhotoIndex.text = photoIndexString;
        }
    }
}

- (void)createNewTripAlbum {
    // 先上传到服务器, 失败了再在realm中存储.
    [DTSToastUtil loadingWithOperationBlock:^{
        [[DTSNewTripPhotosSelectionManager sharedInstance] createNewTripAlbum];
    } withCompletionBlock:^{
        [DTSToastUtil toastWithText:@"正在后台上传专辑照片中..."];
        
        [self resetAll];
        
        [self backToTripAlbums];
    }];
}

-(void)backToTripAlbums {
    [[DTSTripAlbumsManager sharedInstance] requestMyTripAlbumsFromServer];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)resetAll
{
    [[DTSNewTripPhotosSelectionManager sharedInstance] resetSelectedPhotos];
}

- (void)gotoPreview:(UIButton *)sender {
    // 暂时先保存到realm中, 标记为preview. 之后删除
    [DTSToastUtil loadingWithOperationBlock:^{
        [[DTSNewTripPhotosSelectionManager sharedInstance] createPreviewNewTripAlbum];
    } withCompletionBlock:^{
//        [self resetAll]; // 不能reset
        
        DTSTripDetailViewController *tripDetailVC = [[DTSTripDetailViewController alloc] init];
        tripDetailVC.albumID = [DTSNewTripPhotosSelectionManager sharedInstance].currentAlbumID;
        
        if (self.navigationController) {
            [self.navigationController pushViewController:tripDetailVC animated:YES];
        } else {
            [self presentViewController:tripDetailVC animated:YES completion:nil];
        }
    }];
}

@end
