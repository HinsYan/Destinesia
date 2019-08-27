//
//  BasePhotoKitViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "BasePhotoKitViewController.h"

@interface BasePhotoKitViewController ()

@end

@implementation BasePhotoKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
