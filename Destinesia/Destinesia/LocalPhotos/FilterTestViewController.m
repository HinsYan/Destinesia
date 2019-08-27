//
//  FilterTestViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/30.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "FilterTestViewController.h"
#import "LocalPhotosViewController.h"

#import "DTSFilterView.h"

@interface FilterTestViewController () <

    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    LocalPhotosViewControllerDelegate,
    DTSFilterViewDelegate
>

@end

@implementation FilterTestViewController {

    UIImageView *imageView;
    
    UIImage *theOriginalImage;
    UIImage *theFilteredImage;
    
    DTSFilterView *_filterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLaunchScreen];
    
    [self addUIImageView];
    
    [self addBtnClose];
    [self addBtnAlbum];
    [self addLocalPhotos];
    
    [self addBtnCompare];
    
    [self initFilterView];
    
    UIImage *bwImage = [DTSGPUImageFilterManager bwFilteredImage:theOriginalImage];
    UIImage *lomoImage = [[DTSGPUImageFilterManager filter1977] imageByFilteringImage:theOriginalImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_filterView selectFilterItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)addUIImageView {
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    theOriginalImage = [UIImage imageNamed:@"Model.png"];
    theFilteredImage = theOriginalImage;
    imageView.image = theOriginalImage;
}

- (void)addLaunchScreen {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"LaunchScreen.jpg"];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bgImageView];
    
    // add blur effect
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.view.frame;
    [self.view addSubview:effectView];
}

#pragma mark - top bar

- (void)addBtnClose {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitle:@"Close" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 10.f;
    [self.view addSubview:btn];
}

- (void)actionClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[DTSGPUImageFilterManager sharedInstance] removeAllCachedFilteredImages];
    }];
}

- (void)addBtnAlbum {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kDTSScreenWidth - 60, 0, 60, 40)];
    [btn setTitle:@"Album" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionAlbum:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 10.f;
    [self.view addSubview:btn];
}

- (void)actionAlbum:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage *savedImage = editedImage ? editedImage : originalImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil); // 保存到系统相册
    }
    
    theOriginalImage = savedImage;
    theFilteredImage = savedImage;
    
    // 重新cache滤镜效果图
    [[DTSGPUImageFilterManager sharedInstance] removeAllCachedFilteredImages];
    [_filterView prepareFilteredImages];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        imageView.image = theOriginalImage;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - local photo

- (void)addLocalPhotos {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [btn setTitle:@"Local Photo" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionLocalPhoto:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 10.f;
    btn.center = CGPointMake(self.view.center.x, btn.center.y);
    [self.view addSubview:btn];
}

- (void)actionLocalPhoto:(UIButton *)sender {
    LocalPhotosViewController *localPhotos = [[LocalPhotosViewController alloc] init];
    localPhotos.delegate = self;
    [self presentViewController:localPhotos animated:YES completion:nil];
}

#pragma mark - <LocalPhotosViewControllerDelegate>

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    theOriginalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)indexPath.item]];
    theFilteredImage = theOriginalImage;
    imageView.image = theOriginalImage;
    
    // 重新cache滤镜效果图
    [[DTSGPUImageFilterManager sharedInstance] removeAllCachedFilteredImages];
    [_filterView prepareFilteredImages];
}

#pragma mark - compare

- (void)addBtnCompare {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kDTSScreenWidth - 100, kDTSScreenHeight - 150, 100, 40)];
    [btn setTitle:@"Compare" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionBeginCompare:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(actionEndCompare:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(actionEndCompare:) forControlEvents:UIControlEventTouchUpOutside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 10.f;
    [self.view addSubview:btn];
}

- (void)actionBeginCompare:(UIButton *)sender {
    imageView.image = theOriginalImage;
}

- (void)actionEndCompare:(UIButton *)sender {
    imageView.image = theFilteredImage;
}

#pragma mark - tool bar
#pragma mark - DTSFilterView

- (void)initFilterView {
    _filterView = [[DTSFilterView alloc] initWithFrame:CGRectMake(0, kDTSScreenHeight - 120, kDTSScreenWidth, 120)];
    [self.view addSubview:_filterView];
    _filterView.delegate = self;
    
    // 要先设置theOriginalImage, 然后再执行prepareFilteredImages
    _filterView.theOriginalImage = theOriginalImage;
    [_filterView prepareFilteredImages];
}

#pragma mark - <DTSFilterViewDelegate>

- (void)DTSFilterViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSString *filterName = [DTSFilterViewDataSourceManager sharedInstance].dtsFilters[indexPath.item];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([filterName hasPrefix:@"IF"] && [filterName hasSuffix:@"Filter"]) {
            IFImageFilter *instagramFilter = [[NSClassFromString(filterName) alloc] init];
            theFilteredImage = [instagramFilter imageByFilteringImage:theOriginalImage];
            
            filterName = [filterName stringByReplacingOccurrencesOfString:@"IF" withString:@""];
            filterName = [filterName stringByReplacingOccurrencesOfString:@"Filter" withString:@""];
        } else {
            theFilteredImage = [DTSGPUImageFilterManager filteredImage:theOriginalImage viaLUTImage:[UIImage imageNamed:[NSString stringWithFormat:@"LUT_%@.png", filterName]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = theFilteredImage;
            [DTSToastUtil toastWithText:filterName withShowTime:0.5f];
        });
    });
}

@end
