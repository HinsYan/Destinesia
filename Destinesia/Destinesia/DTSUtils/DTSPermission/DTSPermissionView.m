//
//  DTSPermissionView.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/23.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSPermissionView.h"

@implementation DTSPermissionView

- (instancetype)initWithPermissionType:(DTSPermissionType)permissionType
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DTSPermissionView" owner:nil options:nil];
    self = [arr firstObject];
    self.frame = CGRectMake(0, 0, kDTSScreenWidth, kDTSScreenWidth);
    
    if (self) {
        NSString *tip, *allow;
        switch (permissionType) {
            case kDTSPermissionType_Camera:
                tip = @"Destinesia需要相机权限";
                allow = @"允许使用相机";
                break;
            case kDTSPermissionType_Album:
                tip = @"Destinesia需要相册权限";
                allow = @"允许使用相册";
                break;
            case kDTSPermissionType_Location:
                tip = @"Destinesia需要定位权限";
                allow = @"允许使用定位";
                break;
            default:
                break;
        }
        
        _lbTip.text = tip;
        [_btnAllow setTitle:allow forState:UIControlStateNormal];
    }
    
    return self;
}

- (IBAction)actionBtnAllow:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"app-settings:"]];
}

@end
