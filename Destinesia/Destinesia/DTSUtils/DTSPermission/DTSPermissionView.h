//
//  DTSPermissionView.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>


// 权限类型
typedef NS_ENUM(NSInteger, DTSPermissionType) {
    kDTSPermissionType_Camera = 0,
    kDTSPermissionType_Album,
    kDTSPermissionType_Location,
};


@interface DTSPermissionView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@property (weak, nonatomic) IBOutlet UIButton *btnAllow;

- (instancetype)initWithPermissionType:(DTSPermissionType)permissionType;

@end
