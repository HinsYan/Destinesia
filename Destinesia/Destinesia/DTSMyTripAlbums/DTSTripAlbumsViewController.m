//
//  DTSTripAlbumsViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsViewController.h"

#import "DTSLoginViewController.h"
#import "DTSTripDetailViewController.h"
#import "DTSNewTripAlbumCreationViewController.h"

#import "DTSTripAlbumsView.h"

#import "AnimatorTripAlbumToDetail.h"
#import "NSString+DTSCategory.h"

typedef NS_ENUM(NSInteger, MyTripAlbumsLoginAction) {
    kMyTripAlbumsLoginAction_None = 0,
    kMyTripAlbumsLoginAction_NewTrip,
};

@interface DTSTripAlbumsViewController () <

    UINavigationControllerDelegate,
    DTSLoginViewControllerDelegate,
    DTSTripAlbumsViewDelegate,
    DTSTripAlbumsManagerDelegate,
    DTSNewTripAlbumUploaderDelegate
>

@property (weak, nonatomic) IBOutlet UIView *viewTripAlbumsOutline;

@property (weak, nonatomic) IBOutlet UIView *viewTripAlbumCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTripAlbumCount;

@property (weak, nonatomic) IBOutlet UIView *viewTripMileCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTripMileCount;

@property (weak, nonatomic) IBOutlet UIView *viewTotalLikeCount;
@property (weak, nonatomic) IBOutlet UILabel *lbTotalLikeCount;

@property (weak, nonatomic) IBOutlet UIImageView *iconUserGrade;
@property (weak, nonatomic) IBOutlet UILabel *lbUsername;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation DTSTripAlbumsViewController {

    UIView *backgroundView;
    
    DTSTripAlbumsView *tripAlbumsView;
    
    UIImageView *bgImageView;
    UIImageView *viewMyTripAlbumsNone;
    
    UITapGestureRecognizer *logoutGesture;
    
    UIView *maskView;
    UIButton *btnCancel;
    UIButton *btnLogout;
    UIButton *btnFilm;  // 相机胶卷
    UIButton *btnAlbum; // 手机相册
    
    RealmAccount *currentLoginAccount;
    
    MyTripAlbumsLoginAction myTripAlbumsLoginAction;
    
    BOOL isFirstEnter; // 首次进入检测是否有未上传专辑
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isFirstEnter = YES;
    
    [self initViewTripAlbumsOutline];
    
    [self initBackgroundView];
    
    [self initTripAlbumsView];
    
    [[DTSTripAlbumsManager sharedInstance] requestMyTripAlbumsFromServer];
    
    [self updateViewTripAlbumsOutline];
    
    myTripAlbumsLoginAction = kMyTripAlbumsLoginAction_None;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![DTSUserDefaults isContinueUploading] && isFirstEnter) {
        isFirstEnter = NO;
        [self tipToContinuePublishTripAlbums];
    }
    
    [self updateCurrentLoginAccountInfo];
    
    [self reloadData];
    
    [DTSNewTripAlbumUploader sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [DTSNewTripAlbumUploader sharedInstance].delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeMaskViewWithAnimation];
}

- (void)initViewTripAlbumsOutline {
//    _viewTripAlbumsOutline.backgroundColor = RGBAHEX(0x08CDCC, 0.9);
    
    // TODO:
//    UIView *gradientView = [[UIView alloc] initWithFrame:_viewTripAlbumsOutline.bounds];
//    [_viewTripAlbumsOutline insertSubview:gradientView atIndex:0];

    // 先在底部添加渐变颜色
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = gradientView.bounds;
//    [gradientView.layer addSublayer:gradientLayer];
//    
//    // 渐变layer, 需要设置colors数组, 有时候需要设置locations数组
//    gradientLayer.startPoint = CGPointMake(0.5, 0);
//    gradientLayer.endPoint = CGPointMake(0.5, 1);
//    
//    gradientLayer.colors = @[(__bridge id)RGBAHEX(0x08CDCC, 0.9).CGColor, (__bridge id)RGBAHEX(0x08CDCC, 0.5).CGColor];
//    
//    // 不加locations数组, 则默认为线性均匀的渐变.
//    gradientLayer.locations = @[@0.f, @1.f];
    
    
    [self initBtnLogin];
    
    _btnLogin.hidden = NO;
    _lbUsername.hidden = YES;
    _iconUserGrade.hidden = YES;
    
    NSString *myTripMileCount = @"0 km";
    _lbTripMileCount.attributedText = [self attributedStringTripMileCount:myTripMileCount];
}

- (NSMutableAttributedString *)attributedStringTripMileCount:(NSString *)myTripMileCount {
    NSMutableAttributedString *attributedTripMileCount = [[NSMutableAttributedString alloc] initWithString:myTripMileCount];
    NSRange rangeOfKm = [myTripMileCount rangeOfString:@"km"];
    [attributedTripMileCount addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeOfKm];
    
    return attributedTripMileCount;
}

- (void)initBtnLogin {
    _btnLogin.layer.cornerRadius = 5.0f;
    _btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnLogin.layer.borderWidth = 1.0f;
}

- (void)updateViewTripAlbumsOutline {
    currentLoginAccount = [[DTSAccountManager sharedInstance] currentLoginAccount];
    // 未登录
    if (currentLoginAccount == nil) {
        _btnLogin.hidden = NO;
        _lbUsername.hidden = YES;
        _iconUserGrade.hidden = YES;
        
        [self updateCurrentLoginAccountInfo];
        
        [self removeLogOutTapGesture];
        
        return;
    }
    
    _btnLogin.hidden = YES;
    _lbUsername.hidden = NO;
    _iconUserGrade.hidden = NO;
    
    [self updateCurrentLoginAccountInfo];
    
    [[DTSTripAlbumsManager sharedInstance] updateMyTripAlbumsFromRealm];
    
    [self reloadData];
    
    [self addLogOutTapGesture];
    
    [[DTSTripAlbumsManager sharedInstance] startCachingAssetsOfTripAlbumCovers];
}

- (void)updateCurrentLoginAccountInfo {
    if ([DTSTripAlbumsManager sharedInstance].myTripAlbums.count == 0) {
        [self initViewMyTripAlbumsNone];
    } else {
        [self removeViewMyTripAlbumsNone];
    }
    
    NSInteger myTripAlbumsTotalMiles = [DTSTripAlbumsManager sharedInstance].myTripAlbumsTotalMiles;
    NSInteger myTripAlbumsTotalLikes = [DTSTripAlbumsManager sharedInstance].myTripAlbumsTotalLikes;
    
    // TODO: 加描边
//    NSString *userName = [currentLoginAccount.username uppercaseString];
    NSString *userName = [@"STEFANIE CHEUANG" uppercaseString];
    _lbUsername.attributedText = [userName attributedStringWithLineSpacing:0.f withFontSpacing:1.f];
    
    _iconUserGrade.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconStar_%ld.png", (long)currentLoginAccount.authorGrade]];
    
    _lbTripAlbumCount.text = [NSString stringWithFormat:@"%ld", (long)[DTSTripAlbumsManager sharedInstance].myTripAlbums.count];
    _lbTotalLikeCount.text = [NSString stringWithFormat:@"%ld", (long)myTripAlbumsTotalLikes];
    
    NSString *myTripMileCount = [NSString stringWithFormat:@"%ld km", (long)myTripAlbumsTotalMiles];
    NSMutableAttributedString *attributedTripMileCount = [[NSMutableAttributedString alloc] initWithString:myTripMileCount];
    NSRange rangeOfKm = [myTripMileCount rangeOfString:@"km"];
    [attributedTripMileCount addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeOfKm];
    
    _lbTripMileCount.attributedText = attributedTripMileCount;
}

- (void)addLogOutTapGesture {
    logoutGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionLogout:)];
    
    _lbUsername.userInteractionEnabled = YES;
    [_lbUsername addGestureRecognizer:logoutGesture];
}

- (void)removeLogOutTapGesture {
    if (logoutGesture) {
        [_lbUsername removeGestureRecognizer:logoutGesture];
        logoutGesture = nil;
    }
}

- (void)initBackgroundView {
    backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:backgroundView atIndex:0];
    
    // add blur effect
    // TODO: first album cover
    bgImageView = [[UIImageView alloc] initWithFrame:backgroundView.bounds];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"Model.png"];
    [backgroundView addSubview:bgImageView];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = bgImageView.bounds;
    [backgroundView addSubview:effectView];
    
    UIView *maskViewGreen = [[UIView alloc] initWithFrame:backgroundView.frame];
    maskViewGreen.backgroundColor = RGBHEX(0x00AB99);
    maskViewGreen.alpha = 0.2f;
    [backgroundView addSubview:maskViewGreen];
}

- (void)initViewMyTripAlbumsNone {
    if (!viewMyTripAlbumsNone) {
        CGRect frame = CGRectMake(0,
                                  CGRectGetMaxY(_viewTripAlbumsOutline.frame),
                                  CGRectGetWidth(backgroundView.frame),
                                  CGRectGetHeight(backgroundView.frame) - CGRectGetMaxY(_viewTripAlbumsOutline.frame));
        viewMyTripAlbumsNone = [[UIImageView alloc] initWithFrame:frame];
        // TODO: 图片待替换
        viewMyTripAlbumsNone.image = [UIImage imageNamed:@"myTripAlbumsNone"];
        [backgroundView addSubview:viewMyTripAlbumsNone];
    }
}

- (void)removeViewMyTripAlbumsNone {
    [viewMyTripAlbumsNone removeFromSuperview];
    viewMyTripAlbumsNone = nil;
}

- (void)initTripAlbumsView {
    [DTSTripAlbumsManager sharedInstance].delegate = self;
    
    tripAlbumsView = [[DTSTripAlbumsView alloc] initWithFrame:backgroundView.bounds
                                             withTopEdgeInset:CGRectGetHeight(_viewTripAlbumsOutline.frame)];
    tripAlbumsView.delegate = self;
    [backgroundView addSubview:tripAlbumsView];
    
    if ([DTSTripAlbumsManager sharedInstance].myTripAlbums.count == 0) {
        [self initViewMyTripAlbumsNone];
    }
}

- (void)reloadData
{
    [[DTSTripAlbumsManager sharedInstance] updateMyTripAlbumsFromRealm];
    
    [self updateCurrentLoginAccountInfo];
    
    if ([DTSNewTripPhotosSelectionManager sharedInstance].isNewTripAlbumCreated) {
        [tripAlbumsView reloadData];
    }
}

#pragma mark - <DTSTripAlbumsManagerDelegate>

- (void)DTSTripAlbumsManagerReloadData
{
    [self reloadData];
}

#pragma mark - <DTSTripAlbumsViewDelegate>

- (void)DTSTripAlbumsViewDelegateDidSelectAlbum:(NSString *)albumID {
    DTSTripDetailViewController *tripDetailVC = [[DTSTripDetailViewController alloc] init];
    // 直接传入有效的albumID
    tripDetailVC.albumID = albumID;
//    [self startCachingAssetsOfAlbum:albumID];
//    self.navigationController.delegate = self;
    [self.navigationController pushViewController:tripDetailVC animated:YES];
}

- (void)startCachingAssetsOfAlbum:(NSString *)albumID
{
    NSMutableArray *localIdentifiers = [NSMutableArray array];
    
    RealmAlbum *album = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    [localIdentifiers addObject:album.albumCoverPhotoID];
    
    for (RealmPhoto *photo in album.photos) {
        [localIdentifiers addObject:photo.photoID];
    }
    
    [[DTSPhotoKitManager sharedInstance] startCachingImagesForAssetLocalIdentifiers:localIdentifiers targetSize:PHImageManagerMaximumSize];
}

#pragma mark - Action

- (IBAction)actionClose:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionLogin:(UIButton *)sender {
    myTripAlbumsLoginAction = kMyTripAlbumsLoginAction_None;
    [self actionDidLogin];
}

- (void)actionDidLogin {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTSLoginViewController *loginVC = [main instantiateViewControllerWithIdentifier:@"DTSLoginViewController"];
    loginVC.delegate = self;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)actionLogout:(UITapGestureRecognizer *)sender {
    [self initMaskView];
    
    [self initLogoutView];
    
    [self showMaskViewWithAnimation];
}

- (void)initMaskView {
    if (maskView) {
        return;
    }
    
    maskView = [[UIView alloc] initWithFrame:self.view.frame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.f;
    [self.view addSubview:maskView];
    
    // add blur effect
    UIImageView *blurBgImageView = [[UIImageView alloc] initWithFrame:maskView.bounds];
    blurBgImageView.contentMode = UIViewContentModeScaleToFill;
    blurBgImageView.image = [UIImage imageNamed:@"LaunchScreen.jpg"];
    [maskView addSubview:blurBgImageView];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = maskView.bounds;
    [maskView addSubview:effectView];
    
    CGFloat offsetLeft = 10;
    CGFloat heightBtn = 40;
    CGRect frameBtnCancel = CGRectMake(offsetLeft,
                                       CGRectGetHeight(maskView.frame) - 60,
                                       CGRectGetWidth(maskView.frame) - offsetLeft * 2,
                                       heightBtn);
    btnCancel = [[UIButton alloc] initWithFrame:frameBtnCancel];
    btnCancel.backgroundColor = [UIColor whiteColor];
    btnCancel.layer.cornerRadius = 5.0f;
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:kUIColorMain forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:btnCancel];
}

- (void)showMaskViewWithAnimation {
    if (!maskView) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        maskView.alpha = 1.f;
    }];
}

- (void)removeMaskViewWithAnimation {
    if (!maskView) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        maskView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        maskView = nil;
    }];
}

- (void)actionCancel:(UIButton *)sender {
    [self removeMaskViewWithAnimation];
}

- (void)initLogoutView {
    CGFloat offsetLeft = 10;
    CGFloat heightBtn = 40;
    CGRect frameBtnLogout = CGRectMake(offsetLeft,
                                       CGRectGetHeight(maskView.frame) - 110,
                                       CGRectGetWidth(maskView.frame) - offsetLeft * 2,
                                       heightBtn);
    btnLogout = [[UIButton alloc] initWithFrame:frameBtnLogout];
    btnLogout.backgroundColor = [UIColor whiteColor];
    btnLogout.layer.cornerRadius = 5.0f;
    [btnLogout setTitle:@"退出账户" forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(actionDidLogout:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:btnLogout];
}

- (void)actionDidLogout:(UIButton *)sender {
    if ([[DTSAccountManager sharedInstance] logout]) {
        _btnLogin.hidden = NO;
        _lbUsername.hidden = YES;
        _iconUserGrade.hidden = YES;
        
        [[DTSTripAlbumsManager sharedInstance] reset];
        
        [self reloadData];
        
        [self updateViewTripAlbumsOutline];
    }
    
    [self removeMaskViewWithAnimation];
}

- (void)initNewTripActionView {
    CGFloat offsetLeft = 10;
    CGFloat heightBtn = 40;
    
    UILabel *lbSelectPhotoSource = [[UILabel alloc] initWithFrame:CGRectMake(offsetLeft, CGRectGetHeight(maskView.frame) - 190, CGRectGetWidth(maskView.frame) - offsetLeft * 2, 30)];
    lbSelectPhotoSource.text = @"请选择照片来源";
    lbSelectPhotoSource.textAlignment = NSTextAlignmentCenter;
    lbSelectPhotoSource.textColor = kUIColorMain;
    lbSelectPhotoSource.font = [UIFont systemFontOfSize:15.f];
    [maskView addSubview:lbSelectPhotoSource];
    
    CGRect frameNewTripActionView = CGRectMake(offsetLeft,
                                               CGRectGetHeight(maskView.frame) - 160,
                                               CGRectGetWidth(maskView.frame) - offsetLeft * 2,
                                               heightBtn * 2 + 1);
    
    UIView *newTripActionView = [[UIView alloc] initWithFrame:frameNewTripActionView];
    newTripActionView.backgroundColor = [UIColor lightGrayColor];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:newTripActionView.bounds
                                           byRoundingCorners:UIRectCornerAllCorners
                                                 cornerRadii:(CGSize){5.0f, 5.0f}].CGPath;
    newTripActionView.layer.mask = maskLayer;
    [maskView addSubview:newTripActionView];
    
    btnFilm = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(newTripActionView.frame), heightBtn)];
    btnFilm.backgroundColor = [UIColor whiteColor];
    [btnFilm setTitle:@" 相机胶卷" forState:UIControlStateNormal];
    [btnFilm setTitleColor:kUIColorMain forState:UIControlStateNormal];
    [btnFilm setImage:[UIImage imageNamed:@"btnFilm"] forState:UIControlStateNormal];
    [btnFilm addTarget:self action:@selector(actionFilm:) forControlEvents:UIControlEventTouchUpInside];
    [newTripActionView addSubview:btnFilm];
    
    btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(0, heightBtn + 1, CGRectGetWidth(newTripActionView.frame), heightBtn)];
    btnAlbum.backgroundColor = [UIColor whiteColor];
    [btnAlbum setTitle:@" 手机相册" forState:UIControlStateNormal];
    [btnAlbum setTitleColor:kUIColorMain forState:UIControlStateNormal];
    [btnAlbum setImage:[UIImage imageNamed:@"btnAlbum"] forState:UIControlStateNormal];
    [btnAlbum addTarget:self action:@selector(actionAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [newTripActionView addSubview:btnAlbum];
}

- (void)actionFilm:(UIButton *)sender {
    [self gotoNewTripAlbumWithSource:kDTSAlbumSource_Destinesia];
}

- (void)actionAlbum:(UIButton *)sender {
    [self gotoNewTripAlbumWithSource:kDTSAlbumSource_Album];
}

- (void)gotoNewTripAlbumWithSource:(DTSAlbumSource)dtsAlbumSource {
    NSString *albumName;
    switch (dtsAlbumSource) {
        case kDTSAlbumSource_Album:
            albumName = kSystemAlbum;
            break;
        default:
            albumName = APP_NAME;
            break;
    }
    
    // 首先同步相册
    NSArray *albums = [[DTSPhotoKitManager sharedInstance] syncAlbums];
    
    if (!albums.count) {
        NSLog(@"No albums");
    }
    
    DTSNewTripAlbumCreationViewController *newTripAlbumCreationVC = [[DTSNewTripAlbumCreationViewController alloc] init];
    for (DTSAlbumModel *albumModel in albums) {
        DTSLog(@"albumName : %@", albumModel.albumName);
        DTSLog(@"assetsCount : %lu", (unsigned long)albumModel.assetsCount);
        DTSLog(@"fetchResult count : %lu", albumModel.fetchResult.count);
        
        if ([albumModel.albumName isEqualToString:albumName]) {
            newTripAlbumCreationVC.albumModel = albumModel;
            break;
        }
    }
    
    if (!newTripAlbumCreationVC.albumModel && albums.count > 0) {
        newTripAlbumCreationVC.albumModel = albums[0];
    }
    
    [self.navigationController pushViewController:newTripAlbumCreationVC animated:YES];
}

- (IBAction)actionNewTrip:(UIButton *)sender {
    if (currentLoginAccount) {
        [self actionDidNewTrip];
    } else {
        myTripAlbumsLoginAction = kMyTripAlbumsLoginAction_NewTrip;
        [self actionDidLogin];
    }
}

- (void)actionDidNewTrip {
    [self initMaskView];
    
    [self initNewTripActionView];
    
    [self showMaskViewWithAnimation];
}

- (void)tipToContinuePublishTripAlbums
{
    RLMResults *albumsUnPublished = [RealmAlbumManager queryRealmAlbumWhere:@"albumID BEGINSWITH 'RealmAlbum_'"];
    if (albumsUnPublished.count == 0) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前有未成功上传的专辑，是否继续上传？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *upload = [UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [DTSUserDefaults setIsContinueUploading:YES];
        
        for (RealmAlbum *album in albumsUnPublished) {
            [[DTSNewTripAlbumUploader sharedInstance] uploadAlbum:album.albumID withCompletionBlock:nil];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:upload];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <DTSNewTripAlbumUploaderDelegate>

- (void)DTSNewTripAlbumUploaderAlbumPublished:(NSString *)albumID
{
    DTSLog(@"album published ok : %@", albumID);
    
    [tripAlbumsView albumPublished:albumID];
}

#pragma mark - <DTSLoginViewControllerDelegate>

- (void)DTSLoginViewControllerDelegateLoginOK {
    DTSLog(@"DTSLoginViewControllerDelegateLoginOK");
    
    [[DTSTripAlbumsManager sharedInstance] requestMyTripAlbumsFromServer];
    
    [self updateViewTripAlbumsOutline];
    
    switch (myTripAlbumsLoginAction) {
        case kMyTripAlbumsLoginAction_None:
            break;
        case kMyTripAlbumsLoginAction_NewTrip:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self actionDidNewTrip];
            });
            break;
        }
        default:
            break;
    }
}

- (void)DTSLoginViewControllerDelegateLoginFail {
    NSLog(@"DTSLoginViewControllerDelegateLoginFail");
}

#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    AnimatorTripAlbumToDetail *anim = [[AnimatorTripAlbumToDetail alloc] init];
    
    if (operation == UINavigationControllerOperationPush) {
        anim.animatorTransitionType = kAnimatorTransitionTypePush;
    } else {
        anim.animatorTransitionType = kAnimatorTransitionTypePop;
    }
    
    return anim;
}

@end
