//
//  HomeViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "HomeViewController.h"
#import "DTSCameraViewController.h"
#import "DTSInviteViewController.h"
#import "FilterTestViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController {

    UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUIImageView];
    
    [self addBtnCamera];
    
    [self addBtnAlbum];
    
    [self addFilterTest];
    
    [self addBtnInvite];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)addUIImageView {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (void)addBtnCamera {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    [btn setTitle:@"Camera" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionCamera:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [self.view addSubview:btn];
}

- (void)actionCamera:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    DTSCameraViewController *cameraVC = [main instantiateViewControllerWithIdentifier:@"DTSCameraViewController"];
//    cameraVC.delegate = self;
//    [self presentViewController:cameraVC animated:YES completion:nil];
}

- (void)addBtnAlbum {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    [btn setTitle:@"Album" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionAlbum:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [self.view addSubview:btn];
}

- (void)actionAlbum:(UIButton *)sender {

}

- (void)addBtnInvite {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    [btn setTitle:@"Invite" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionInvite:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [self.view addSubview:btn];
}

- (void)actionInvite:(UIButton *)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTSInviteViewController *inviteVC = [main instantiateViewControllerWithIdentifier:@"DTSInviteViewController"];
    [self presentViewController:inviteVC animated:YES completion:nil];
}

- (void)addFilterTest {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [btn setTitle:@"滤镜测试专用" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionFilterTest:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [self.view addSubview:btn];
}

- (void)actionFilterTest:(UIButton *)sender {
    FilterTestViewController *filterTestVC = [[FilterTestViewController alloc] init];
    [self presentViewController:filterTestVC animated:YES completion:nil];
}

@end
