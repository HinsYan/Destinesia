//
//  DTSAlbumListViewController.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePhotoKitViewController.h"
#import "DTSAssetsGridViewController.h"

typedef void(^SelectedImage)(UIImage *currentImage);

@interface DTSAlbumListViewController : BasePhotoKitViewController<DTSAssetGridSelectedDelegate>

@property (nonatomic, copy) SelectedImage selectImage;

@property (nonatomic, strong) UIView    *topView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *btnLeft;
@property (nonatomic, strong) UIButton  *btnRight;

@property (nonatomic, strong) UITableView *tableView;

- (void)actionBtnLeft:(UIButton *)sender;
- (void)actionBtnRight:(UIButton *)sender;

@end
