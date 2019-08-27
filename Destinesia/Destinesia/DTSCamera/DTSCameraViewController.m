//
//  DTSCameraViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSCameraViewController.h"

#import <Photos/Photos.h>

#import "HomeViewController.h"
#import "DTSWelcomeViewController.h"
#import "DTSTripAlbumsViewController.h"
#import "DTSLocalTripAlbumsViewController.h"

#import "GPUImage.h"
#import "DTSGPUImageFilterManager.h"

#import "DTSSlider.h"
#import "DTSCameraFocusView.h"
#import "DTSCameraWatermark.h"

#import "DTSOrientationMonitor.h"

#import "AnimatorCameraPushPop.h"

#import "DTSFilterView.h"

#import "DTSPermission.h"

#import "DTSLocalTripAlbumsManager.h"

#import "DTSAlbumListViewController.h"

#import "DTSAlbumPreviewViewController.h"


typedef NS_ENUM(NSInteger, CameraProportionType) {
    kCameraProportionType11,
    kCameraProportionType34,
    kCameraProportionTypeFill,
};

typedef NS_ENUM(NSInteger, DTSFilterType) {
    kDTSFilterType_None = 0,
    kDTSFilterType_BW,
    kDTSFilterType_Newspaper,
    kDTSFilterType_Magazine,
};

typedef NS_ENUM(NSInteger, DTSCameraWatermarkStye) {
    kDTSCameraWatermarkStye_Both = 0,
    kDTSCameraWatermarkStye_WatermarkOnly,
    kDTSCameraWatermarkStye_GridOnly,
    kDTSCameraWatermarkStye_None,
};

typedef NS_ENUM(NSInteger, DTSCameraSliderTag) {
    kDTSCameraSliderTag_Exposure = 1001,
    kDTSCameraSliderTag_Sharpen,
    kDTSCameraSliderTag_Brightness,
};

@interface DTSCameraViewController () <
    DTSWelcomeViewControllerDelegate,
    GPUImageVideoCameraDelegate,
    DTSSliderDelegate,
    DTSLocationDelegate,
    UINavigationControllerDelegate,
    DTSFilterViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnTripAlbums;


@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;

@property (weak, nonatomic) IBOutlet UIButton *btnAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btnRotate;

@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;


@property (assign, nonatomic) DTSFilterType dtsFilterType;

@end

@implementation DTSCameraViewController {
    
    GPUImageView *previewView;
    GPUImageStillCamera *stillCamera;
    
    GPUImageFilterPipeline *filterPipeline;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageSharpenFilter *sharpenFilter;
    GPUImageBrightnessFilter *brightnessFilter;
    
    UILabel *lbExposure;
    DTSSlider *exposureSlider;
    
    // stillCamera -> filter -> sharpenSlider -> brightnessFilter -> previewView
    
    UILabel *lbSharpen;
    DTSSlider *sharpenSlider;
    
    UILabel *lbBrightness;
    DTSSlider *brightnessSlider;
    
    DTSCameraFocusView *cameraFocusView;
    
    DTSCameraWatermark *cameraWatermark;
    
    UIImageView *cameraGrid;
    
    DTSCameraWatermarkStye dtsCameraWatermarkStyle;
    CameraProportionType cameraProportionType;
    
    DTSFilterView *_filterView;
    
    
    __block dispatch_once_t onceTokenForPhotoSaved; // 保存至相册只显示一次
    
    
    UIDeviceOrientation deviceOrientation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DTSLocation sharedInstance] startLocation];
    
    [DTSLocation sharedInstance].delegate = self;
    
    [self initCameraView];
    
    [self initExposureSlider];
    
    [self initWatermark];
    [self initCameraGrid];
    
    [self initSwipeGesture];
    
    dtsCameraWatermarkStyle = kDTSCameraWatermarkStye_Both;
    _dtsFilterType = kDTSFilterType_None;
    
    [self initSharpenFilter];
    
    [self initBrightnessFilter];
    
    if (![DTSUserDefaults isWelcomeShown]) {
        [DTSUserDefaults setIsWelcomeShown:YES];
        [self showWelcomeView];
    }
    
    [self initFilterView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self rebindFilterViewAndDataSourceManager];
    
    [[DTSOrientationMonitor sharedInstance] beginOrientationMonitor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [DTSToastUtil toastWithText:@"点击右下角的按钮, 可以切换滤镜"];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [stillCamera startCameraCapture];
    
    [self addNotifications];
    
    deviceOrientation = [DTSOrientationMonitor sharedInstance].deviceOrientation;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [stillCamera stopCameraCapture];
    
    [self resetExposureBias];
    
    [self resetSharpen];
    
    [self resetBrigheness];
    
    [[DTSOrientationMonitor sharedInstance] endOrientationMonitor];
    
    [self removeNotifications];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)addNotifications {
    [self listenAVCaptureDeviceSubjectAreaDidChangeNotification];
    [self listenDeviceOrientationChangeNotification];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDTSOrientationMonitorDidChangeNotification object:nil];
}

- (BOOL)checkDTSAlbum {
    if (![DTSAlbumManager isAlbumExisting:APP_NAME]) {
        return [DTSAlbumManager createAlbum:APP_NAME];
    }
    return YES;
}

- (void)showPermissionViewCamera {
    DTSPermissionView *permissionView = [[DTSPermissionView alloc] initWithPermissionType:kDTSPermissionType_Camera];
    permissionView.center = self.view.center;
    [self.view addSubview:permissionView];
}

#pragma mark - TopBar

- (IBAction)actionGoHome:(UIButton *)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeVC = [main instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentViewController:homeVC animated:YES completion:nil];
}

- (IBAction)actionGotoMyAlbum:(UIButton *)sender {
    [self gotoMyAlbum];
}

#pragma mark - ToolBar

- (IBAction)actionCapture:(UIButton *)sender {
    [self checkDTSAlbum];
    
    // TODO: 拍照结果图的尺寸不是9:16
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withOrientation:UIImageOrientationUp withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error == nil) {
            NSLog(@"%@", NSStringFromCGSize(processedImage.size));
            
            [stillCamera pauseCameraCapture];
            
            __block UIView *maskView = [[UIView alloc] initWithFrame:previewView.bounds];
            maskView.backgroundColor = [UIColor blackColor];
            [self.view insertSubview:maskView aboveSubview:previewView];
            
            processedImage = [self adjustImageOrientationAndRatio:processedImage];
            
            [DTSAlbumManager saveImage:processedImage toAlbum:APP_NAME];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [maskView removeFromSuperview];
                maskView = nil;
                
                dispatch_once(&onceTokenForPhotoSaved, ^{
                    [DTSToastUtil toastWithText:@"已保存至Destinesia胶卷"];
                });
                
                [stillCamera resumeCameraCapture];
            });
        }
    }];
}

- (UIImage *)adjustImageOrientationAndRatio:(UIImage *)image {
    UIImage *processedImage = image;
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            processedImage = [image dts_imageRatioed];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            processedImage = [image dts_imageRotatedByDegress:180];
            break;
        case UIDeviceOrientationLandscapeLeft:
            processedImage = [image dts_imageRotatedByDegress:-90];
            break;
        case UIDeviceOrientationLandscapeRight:
            processedImage = [image dts_imageRotatedByDegress:90];
            break;
        case UIDeviceOrientationFaceUp:
            break;
        case UIDeviceOrientationFaceDown:
            break;
        default:
            
            break;
    }
    return processedImage;
}

- (IBAction)actionAlbum:(UIButton *)sender {
    [self checkDTSAlbum];
    
    [self gotoDTSPhotoAlbums];
}

#pragma mark  --- loadDTSPhotoKit
-(void)gotoDTSPhotoAlbums {
    // 首先同步相册
    NSArray *albums = [[DTSPhotoKitManager sharedInstance] syncAlbums];
    
    if (!albums.count) {
        NSLog(@"No albums");
    }
    
    DTSAlbumModel *dtsAlbumModel;
    
    for (DTSAlbumModel *albumModel in albums) {
        if ([albumModel.albumName isEqualToString:APP_NAME]) {
            dtsAlbumModel = albumModel;
            
            if (albumModel.assetsCount == 0) {
                [DTSToastUtil toastWithText:@"Destinesia 相册中暂时还没有照片，赶紧拍一张吧~"];
                return;
            }
            
            break;
        }
    }
    
    if (!dtsAlbumModel) {
        DTSLog(@"相册错误");
        return;
    }
    
    DTSAlbumPreviewViewController *preViewVC = [[DTSAlbumPreviewViewController alloc] init];
    preViewVC.albumModel = dtsAlbumModel;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:preViewVC];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)actionFilter:(UIButton *)sender {
    if (_filterView.alpha == 0.f) {
        [UIView animateWithDuration:0.5 animations:^{
            _filterView.alpha = 1.f;
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _filterView.alpha = 0.f;
        } completion:nil];
    }
    
    return;
    
    switch (_dtsFilterType) {
        case kDTSFilterType_None:
            [self setDtsFilterType:kDTSFilterType_BW];
            [DTSToastUtil toastWithText:@"B & W"];
            break;
        case kDTSFilterType_BW:
            [self setDtsFilterType:kDTSFilterType_Newspaper];
            [DTSToastUtil toastWithText:@"Newspaper"];
            break;
        case kDTSFilterType_Newspaper:
            [self setDtsFilterType:kDTSFilterType_Magazine];
            [DTSToastUtil toastWithText:@"Magazine"];
            break;
        case kDTSFilterType_Magazine:
            [self setDtsFilterType:kDTSFilterType_None];
            [DTSToastUtil toastWithText:@"None"];
            break;
        default:
            break;
    }
}

- (IBAction)actionSettings:(UIButton *)sender {
    switch (dtsCameraWatermarkStyle) {
        case kDTSCameraWatermarkStye_Both:
            dtsCameraWatermarkStyle = kDTSCameraWatermarkStye_WatermarkOnly;
            cameraWatermark.hidden = NO;
            cameraGrid.hidden = YES;
            break;
        case kDTSCameraWatermarkStye_WatermarkOnly:
            dtsCameraWatermarkStyle = kDTSCameraWatermarkStye_GridOnly;
            cameraWatermark.hidden = YES;
            cameraGrid.hidden = NO;
            break;
        case kDTSCameraWatermarkStye_GridOnly:
            dtsCameraWatermarkStyle = kDTSCameraWatermarkStye_None;
            cameraWatermark.hidden = YES;
            cameraGrid.hidden = YES;
            break;
        case kDTSCameraWatermarkStye_None:
            dtsCameraWatermarkStyle = kDTSCameraWatermarkStye_Both;
            cameraWatermark.hidden = NO;
            cameraGrid.hidden = NO;
            break;
        default:
            break;
    }
}

// 镜头反了
- (IBAction)actionRotate:(UIButton *)sender {
    [stillCamera rotateCamera];
}

- (void)actionProportion:(UIButton *)sender {
    switch (cameraProportionType) {
        case kCameraProportionType11:
            cameraProportionType = kCameraProportionType34;
            break;
        case kCameraProportionType34:
            cameraProportionType = kCameraProportionTypeFill;
            break;
        case kCameraProportionTypeFill:
            cameraProportionType = kCameraProportionType11;
            break;
        default:
            break;
    }
}


#pragma mark - Camera View

- (void)initCameraView {
    previewView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    // 保持与iOS系统相机的位置一致。
    cameraProportionType = kCameraProportionType34;
    previewView.backgroundColor = [UIColor blackColor];
    previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view insertSubview:previewView atIndex:0];
    
    [self addFocusTapGesture];
    
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    stillCamera.delegate = self;
    
    // TODO: 不加滤镜, 如何获取图片？
//    [stillCamera addTarget:previewView];
    //
    
    // 添加滤镜
    // GPUImageStillCamera (output) -> GPUImageFilter (input, output) -> GPUImageView (input)
    // GPUImagePicture (output)     —> GPUImageFilter (input, output) —> GPUImageView (input)
    
    [self setDtsFilterType:kDTSFilterType_None];
}

- (void)initExposureSlider {
    exposureSlider = [[DTSSlider alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    exposureSlider.center = CGPointMake(CGRectGetWidth(self.view.frame) - 30, self.view.center.y);
    exposureSlider.value = 0.5f;
    [self.view addSubview:exposureSlider];
    exposureSlider.delegate = self;
    exposureSlider.tag = kDTSCameraSliderTag_Exposure;
    
    exposureSlider.csThumbImage = [UIImage imageNamed:@"sliderHandler"];
    exposureSlider.csMinimumTrackTintColor = [UIColor redColor];
    exposureSlider.csMaximumTrackTintColor = [UIColor lightGrayColor];
    // Please use CSSliderTrackTintType_Divide after csMinimumTrackTintColor and csMaximumTrackTintColor set already. Please do not set minimumValueImage and maximumValueImage.
    exposureSlider.trackTintType = kDTSSliderTrackTintType_Linear;
    
    exposureSlider.sliderDirection = kDTSSliderDirection_Vertical;
    
    
    lbExposure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    lbExposure.center = CGPointMake(exposureSlider.center.x, exposureSlider.center.y - 120);
    lbExposure.textAlignment = NSTextAlignmentCenter;
    lbExposure.textColor = kUIColorMain;
    lbExposure.text = @"50";
    [self.view addSubview:lbExposure];
}

- (void)resetExposureBias {
    [stillCamera.inputCamera lockForConfiguration:nil];
    [stillCamera.inputCamera setExposureTargetBias:0 completionHandler:nil];
    [stillCamera.inputCamera unlockForConfiguration];
}

- (void)initSharpenFilter
{
    sharpenSlider = [[DTSSlider alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    sharpenSlider.center = CGPointMake(30, self.view.center.y);
    sharpenSlider.value = 0.5f;
    [self.view addSubview:sharpenSlider];
    sharpenSlider.delegate = self;
    sharpenSlider.tag = kDTSCameraSliderTag_Sharpen;
    
    sharpenSlider.csThumbImage = [UIImage imageNamed:@"sliderHandler"];
    sharpenSlider.csMinimumTrackTintColor = [UIColor redColor];
    sharpenSlider.csMaximumTrackTintColor = [UIColor lightGrayColor];
    // Please use CSSliderTrackTintType_Divide after csMinimumTrackTintColor and csMaximumTrackTintColor set already. Please do not set minimumValueImage and maximumValueImage.
    sharpenSlider.trackTintType = kDTSSliderTrackTintType_Linear;
    
    sharpenSlider.sliderDirection = kDTSSliderDirection_Vertical;
    
    
    lbSharpen = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    lbSharpen.center = CGPointMake(sharpenSlider.center.x, sharpenSlider.center.y - 120);
    lbSharpen.textAlignment = NSTextAlignmentCenter;
    lbSharpen.textColor = kUIColorMain;
    lbSharpen.text = @"50";
    [self.view addSubview:lbSharpen];
    
    sharpenFilter = [[GPUImageSharpenFilter alloc] init];
    // Sharpness ranges from -4.0 to 4.0, with 0.0 as the normal level
    sharpenFilter.sharpness = 0.0f;
    
//    [stillCamera addTarget:sharpenFilter];
    

    
    [filter addTarget:sharpenFilter];
}

- (void)resetSharpen
{
    sharpenFilter.sharpness = 0.0f;
}

- (void)initBrightnessFilter {
    brightnessSlider = [[DTSSlider alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    brightnessSlider.center = CGPointMake(self.view.center.x, self.view.center.y);
    brightnessSlider.value = 0.5f;
    [self.view addSubview:brightnessSlider];
    brightnessSlider.delegate = self;
    brightnessSlider.tag = kDTSCameraSliderTag_Brightness;
    
    brightnessSlider.csThumbImage = [UIImage imageNamed:@"sliderHandler"];
    brightnessSlider.csMinimumTrackTintColor = [UIColor redColor];
    brightnessSlider.csMaximumTrackTintColor = [UIColor lightGrayColor];
    // Please use CSSliderTrackTintType_Divide after csMinimumTrackTintColor and csMaximumTrackTintColor set already. Please do not set minimumValueImage and maximumValueImage.
    brightnessSlider.trackTintType = kDTSSliderTrackTintType_Linear;
    
    brightnessSlider.sliderDirection = kDTSSliderDirection_Vertical;
    
    
    lbBrightness = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    lbBrightness.center = CGPointMake(brightnessSlider.center.x, brightnessSlider.center.y - 120);
    lbBrightness.textAlignment = NSTextAlignmentCenter;
    lbBrightness.textColor = kUIColorMain;
    lbBrightness.text = @"50";
    [self.view addSubview:lbBrightness];
    
    brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    // Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
    brightnessFilter.brightness = 0.0f;
    
    [sharpenFilter addTarget:brightnessFilter];
    [brightnessFilter addTarget:previewView];
}

- (void)resetBrigheness {
    brightnessFilter.brightness = 0.0f;
}

#pragma mark - Watermark

- (void)initWatermark {
    cameraWatermark= [[DTSCameraWatermark alloc] initWithFrame:CGRectMake(0, 0, kDTSScreenWidth, 60)];
    [self.view addSubview:cameraWatermark];
}

- (void)initCameraGrid {
    cameraGrid = [[UIImageView alloc] initWithFrame:self.view.frame];
    cameraGrid.alpha = 0.3f;
    cameraGrid.image = [UIImage imageNamed:@"camera_grid"];
    [self.view addSubview:cameraGrid];
}

#pragma mark - 横竖屏旋转

- (void)deviceOrientationChanged:(NSNotification *)sender {
    deviceOrientation = [DTSOrientationMonitor sharedInstance].deviceOrientation;
    switch (deviceOrientation)
    {
        case UIDeviceOrientationPortrait:
        {
            [self deviceRotationWithAngel:0];
            
            [UIView animateWithDuration:0.3 animations:^{
                cameraWatermark.alpha = 0.f;
            } completion:^(BOOL finished) {
                cameraWatermark.transform = CGAffineTransformMakeRotation(0);
                cameraWatermark.frame = CGRectMake(0, 0, CGRectGetWidth(cameraWatermark.frame), CGRectGetHeight(cameraWatermark.frame));
                
                [UIView animateWithDuration:0.3 animations:^{
                    cameraWatermark.alpha = 1.f;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
//            [self deviceRotationWithAngel:M_PI];
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            [self deviceRotationWithAngel:M_PI_2];
            
            [UIView animateWithDuration:0.3 animations:^{
                cameraWatermark.alpha = 0.f;
            } completion:^(BOOL finished) {
                cameraWatermark.transform = CGAffineTransformMakeRotation(M_PI_2);
                cameraWatermark.frame = CGRectMake(0, 0, CGRectGetWidth(cameraWatermark.frame), CGRectGetHeight(cameraWatermark.frame));
                
                [UIView animateWithDuration:0.3 animations:^{
                    cameraWatermark.alpha = 1.f;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            break;
        }
        case UIDeviceOrientationLandscapeRight:
//            [self deviceRotationWithAngel:-M_PI_2];
            break;
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        default:
            break;
    }
}

- (void)deviceRotationWithAngel:(float)angel{
    [UIView animateWithDuration:0.3 animations:^{
        _btnCapture.transform = CGAffineTransformMakeRotation(angel);
        _btnTripAlbums.transform = CGAffineTransformMakeRotation(angel);
        _btnAlbum.transform = CGAffineTransformMakeRotation(angel);
        _btnRotate.transform = CGAffineTransformMakeRotation(angel);
        _btnSettings.transform = CGAffineTransformMakeRotation(angel);
        _btnFilter.transform = CGAffineTransformMakeRotation(angel);
    }];
}

#pragma mark - <DTSLocationDelegate>

- (void)DTSLocationDoneWithLocation:(CLLocation *)location withCity:(NSString *)city {
    [cameraWatermark updateCameraWatermarkCity:city];
}

- (void)DTSLocationFail {

}

#pragma mark - DTSSliderDelegate

- (void)DTSSliderValueChanged:(DTSSlider *)sender {
    switch (sender.tag) {
        case kDTSCameraSliderTag_Exposure:
        {
            CGFloat bias = -1.5f + sender.value * (1.5f - (-1.5f));
            [stillCamera.inputCamera lockForConfiguration:nil];
            [stillCamera.inputCamera setExposureTargetBias:bias completionHandler:nil];
            [stillCamera.inputCamera unlockForConfiguration];
            
            DTSLog(@"exposureTargetBias : %f", stillCamera.inputCamera.exposureTargetBias);
            
            NSInteger v = 100 * sender.value;
            lbExposure.text = [NSString stringWithFormat:@"%ld", (long)v];
            break;
        }
        case kDTSCameraSliderTag_Sharpen:
        {
            CGFloat sharpness = -4.0f + sender.value * (4.0f - (-4.0f));
            sharpenFilter.sharpness = sharpness;
            
            NSLog(@"sharpness : %f", sharpenFilter.sharpness);
            
            NSInteger v = 100 * sender.value;
            lbSharpen.text = [NSString stringWithFormat:@"%ld", (long)v];
            break;
        }
        case kDTSCameraSliderTag_Brightness:
        {
            CGFloat brightness = -1.0f + sender.value * (1.0f - (-1.0f));
            brightnessFilter.brightness = brightness;
            
            NSLog(@"brightness : %f", brightnessFilter.brightness);
            
            NSInteger v = 100 * sender.value;
            lbBrightness.text = [NSString stringWithFormat:@"%ld", (long)v];
        }
        default:
            break;
    }

}

- (void)DTSSliderTouchDown:(DTSSlider *)sender {
    
}

- (void)DTSSliderTouchUp:(DTSSlider *)sender {
    
}

- (void)DTSSliderTouchCancel:(DTSSlider *)sender {
    
}

#pragma mark - DTS Filter

- (void)setDtsFilterType:(DTSFilterType)dtsFilterType {
    if (filter) {
        [stillCamera removeTarget:filter];
    }
    
    _dtsFilterType = dtsFilterType;
    switch (_dtsFilterType) {
        case kDTSFilterType_None:
            filter = [[GPUImageBrightnessFilter alloc] init];
            break;
        case kDTSFilterType_BW:
            filter = [[DTSGPUImageBWFilter alloc] init];
            break;
        case kDTSFilterType_Newspaper:
            filter = [[DTSGPUImageNewspaperFilter alloc] init];
            break;
        case kDTSFilterType_Magazine:
            filter = [[DTSGPUImageMagazineFilter alloc] init];
            break;
        default:
            break;
    }
//    [filter addTarget:previewView];
    [stillCamera addTarget:filter];
}

#pragma mark - Camera Settings

- (void)addFocusTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionFocus:)];
    [previewView addGestureRecognizer:tapGesture];
}

- (void)actionFocus:(UITapGestureRecognizer *)sender {
    if (_filterView.alpha != 0.f) {
        [UIView animateWithDuration:0.5 animations:^{
            _filterView.alpha = 0.f;
        } completion:nil];
    }
    
    if (!stillCamera.inputCamera.isFocusPointOfInterestSupported ||
        !stillCamera.inputCamera.isExposurePointOfInterestSupported) {
        return;
    }
    
    CGPoint touchpoint = [sender locationInView:previewView];
    
    if (!cameraFocusView) {
        cameraFocusView = [[DTSCameraFocusView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [self.view addSubview:cameraFocusView];
    }
    cameraFocusView.center = touchpoint;
    
    [cameraFocusView beginAnimation];
    
    [stillCamera.inputCamera lockForConfiguration:nil];
    
    stillCamera.inputCamera.focusPointOfInterest = touchpoint;
    stillCamera.inputCamera.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    stillCamera.inputCamera.exposurePointOfInterest = touchpoint;
    stillCamera.inputCamera.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    
    exposureSlider.value = 0.5f;
    
    [stillCamera.inputCamera unlockForConfiguration];
}

- (void)listenAVCaptureDeviceSubjectAreaDidChangeNotification {
    [stillCamera.inputCamera lockForConfiguration:nil];
    stillCamera.inputCamera.subjectAreaChangeMonitoringEnabled = YES;
    [stillCamera.inputCamera unlockForConfiguration];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionAVCaptureDeviceSubjectAreaDidChange:)
                                                 name:AVCaptureDeviceSubjectAreaDidChangeNotification
                                               object:nil];
}

- (void)actionAVCaptureDeviceSubjectAreaDidChange:(NSNotification *)notification {
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self setupFocusMode:AVCaptureFocusModeContinuousAutoFocus
              exposeMode:AVCaptureExposureModeContinuousAutoExposure
                 atPoint:devicePoint
subjectAreaChangeMonitoringEnabled:YES];
}

- (void)setupFocusMode:(AVCaptureFocusMode)focusMode exposeMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point subjectAreaChangeMonitoringEnabled:(BOOL)subjectAreaChangeMonitoringEnabled {
    
    [stillCamera.inputCamera lockForConfiguration:nil];
    if (stillCamera.inputCamera.isFocusPointOfInterestSupported) {
        stillCamera.inputCamera.focusPointOfInterest = point;
        stillCamera.inputCamera.focusMode = focusMode;
    }
    
    if (stillCamera.inputCamera.isExposurePointOfInterestSupported) {
        stillCamera.inputCamera.exposurePointOfInterest = point;
        stillCamera.inputCamera.exposureMode = exposureMode;
    }
    
    stillCamera.inputCamera.subjectAreaChangeMonitoringEnabled = subjectAreaChangeMonitoringEnabled;
    
//    exposureSlider.value = 0.5f;
    [stillCamera.inputCamera unlockForConfiguration];
}

- (void)listenDeviceOrientationChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChanged:)
                                                 name:kDTSOrientationMonitorDidChangeNotification
                                               object:nil];
}

#pragma mark - GPUImageVideoCameraDelegate

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
}


#pragma mark - Swipe Gesture

- (void)initSwipeGesture {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipeGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [previewView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipeGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [previewView addGestureRecognizer:swipeRight];
}

- (void)actionSwipeGesture:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self gotoMyAlbum];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self gotoLocalAlbum];
    }
}

- (void)gotoMyAlbum {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTSTripAlbumsViewController *myTripAlbums = [main instantiateViewControllerWithIdentifier:@"DTSTripAlbumsViewController"];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:myTripAlbums animated:YES];
}

- (void)gotoLocalAlbum {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTSLocalTripAlbumsViewController *localTripAlbumsVC = [main instantiateViewControllerWithIdentifier:@"DTSLocalTripAlbumsViewController"];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:localTripAlbumsVC animated:YES];
}

#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    AnimatorCameraPushPop *cameraPushPop = [[AnimatorCameraPushPop alloc] init];
    
    if (operation == UINavigationControllerOperationPush) {
        cameraPushPop.animatorTransitionType = kAnimatorTransitionTypePush;
    } else {
        cameraPushPop.animatorTransitionType = kAnimatorTransitionTypePop;
    }
    
    return cameraPushPop;
}

#pragma mark - Welcome

- (void)showWelcomeView {
    DTSWelcomeViewController *welcomeVC = [[DTSWelcomeViewController alloc] init];
    welcomeVC.view.backgroundColor = kUIColorMain;
    welcomeVC.delegate = self;
    [self addChildViewController:welcomeVC];
    [self.view addSubview:welcomeVC.view];
}

#pragma mark - DTSWelcomeViewControllerDelegate

- (void)DTSWelcomeViewControllerDone {
    NSLog(@"%s", __func__);
}

- (void)DTSWelcomeViewControllerSkip {
    NSLog(@"%s", __func__);
}

#pragma mark - tool bar
#pragma mark - DTSFilterView

- (void)initFilterView {
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_toolBar.frame) - 120, kDTSScreenWidth, 120);
    _filterView = [[DTSFilterView alloc] initWithFrame:frame];
    [self.view addSubview:_filterView];
    _filterView.alpha = 0.f;
    _filterView.delegate = self;
    
    UIImage *theOriginalImage = [UIImage imageNamed:@"Model.png"];
    // 要先设置theOriginalImage, 然后再执行prepareFilteredImages
    _filterView.theOriginalImage = theOriginalImage;
    [_filterView prepareFilteredImages];
}

- (void)rebindFilterViewAndDataSourceManager {
    [DTSFilterViewDataSourceManager sharedInstance].collectionView = _filterView.collectionView;
    [DTSFilterViewDataSourceManager sharedInstance].delegate = _filterView;
}

#pragma mark - <DTSFilterViewDelegate>

- (void)DTSFilterViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (filter) {
//        [brightnessFilter removeTarget:filter];
        
        [filter removeTarget:sharpenFilter];
        
        [stillCamera removeTarget:filter];
        
//        [sharpenFilter removeTarget:filter];
    }
    
    NSString *filterName = [DTSFilterViewDataSourceManager sharedInstance].dtsFilters[indexPath.item];
    
    if ([filterName hasPrefix:@"IF"] && [filterName hasSuffix:@"Filter"]) {
        filter = [[NSClassFromString(filterName) alloc] init];
        
        filterName = [filterName stringByReplacingOccurrencesOfString:@"IF" withString:@""];
        filterName = [filterName stringByReplacingOccurrencesOfString:@"Filter" withString:@""];
    } else {
        filter = [DTSGPUImageFilterManager filterViaLUTImage:[UIImage imageNamed:[NSString stringWithFormat:@"LUT_%@.png", filterName]]];
    }
    
//    [filter addTarget:previewView];
//    [brightnessFilter addTarget:filter];
//    [sharpenFilter addTarget:filter];
    [filter addTarget:sharpenFilter];
    
    [stillCamera addTarget:filter];
    
    [DTSToastUtil toastWithText:filterName withShowTime:0.5f];
}

@end
