//
//  DTSAssetsGridViewController.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePhotoKitViewController.h"
#import "DTSPhotoKitManager.h"

#import "DTSAlbumModel.h"

@protocol DTSAssetGridSelectedDelegate <NSObject>

@optional
- (void)assetGridSelected:(UIViewController *)picker didFinishPickingMediaWithImage:(UIImage *)originalImage;

@end


@interface DTSAssetsGridViewController : BasePhotoKitViewController

@property (nonatomic, strong) DTSAlbumModel *albumModel;

@property (nonatomic, assign) id<DTSAssetGridSelectedDelegate> gridDelegate;

// 所有的assets
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;

@property (nonatomic, strong) UIView    *topView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *btnLeft;
@property (nonatomic, strong) UIButton  *btnRight;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

- (void)actionBtnLeft:(UIButton *)sender;
- (void)actionBtnRight:(UIButton *)sender;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
