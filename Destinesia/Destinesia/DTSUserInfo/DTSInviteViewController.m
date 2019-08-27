//
//  DTSInviteViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/27.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSInviteViewController.h"

#import "ViewInviteCode.h"
#import "ViewInviteUserInfo.h"
#import "ViewInviteWelcome.h"

#import "UIApplication+DTSCategory.h"

#import "DTSUserInfoManager.h"

#import "DTSWelcomeViewController.h"

@interface DTSInviteViewController () <

    DTSWelcomeViewControllerDelegate,
    ViewInviteCodeDelegate,
    ViewInviteUserInfoDelegate,
    ViewInviteWelcomeDelegate,
    UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UILabel *lbAuthentication;

@property (weak, nonatomic) IBOutlet UIView *viewInvite;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewInvite;

@property (strong, nonatomic) ViewInviteCode *viewInviteCode;
@property (strong, nonatomic) ViewInviteUserInfo *viewInviteUserInfo;
@property (strong, nonatomic) ViewInviteWelcome *viewInviteWelcome;

@end

@implementation DTSInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewInviteWelcome.delegate = self;
    
    [self initUI];
    
    [self initScrollViewInvite];
    
    if (![DTSUserDefaults isWelcomeShown]) {
        [DTSUserDefaults setIsWelcomeShown:YES];
        [self showWelcomeView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateScrollViewLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -

- (void)updateScrollViewLayout {
    _scrollViewInvite.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame));
    
    CGFloat offsetX = 0.0f;
    _viewInviteCode.frame = CGRectMake(offsetX, 0, CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame));
    offsetX += CGRectGetWidth(_scrollViewInvite.frame);
    
    _viewInviteUserInfo.frame = CGRectMake(offsetX, 0, CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame));
    offsetX += CGRectGetWidth(_scrollViewInvite.frame);
    
    _viewInviteWelcome.frame = CGRectMake(offsetX, 0, CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame));
}

- (void)initUI {
    _btnOK.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnOK.layer.borderWidth = 2.0f;
    _btnOK.layer.cornerRadius = 5.0f;
    
    _lbAuthentication.lineBreakMode = NSLineBreakByWordWrapping;
    _lbAuthentication.numberOfLines = 2;
    _lbAuthentication.text = @"Authentication \n 验证身份";
}

- (IBAction)actionSkip:(UIButton *)sender {
    [self gotoCamera];
}

- (IBAction)actionOK:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"确认"]) {
        [_viewInviteCode verifyInviteCode];
    } else if ([sender.titleLabel.text isEqualToString:@"提交"]) {
        [_viewInviteUserInfo completeUserInfo];
    }
}

- (void)initScrollViewInvite {
    _scrollViewInvite.delegate = self;
    _scrollViewInvite.pagingEnabled = YES;
    _scrollViewInvite.scrollEnabled = NO;
    _scrollViewInvite.bounces = NO;
    _scrollViewInvite.showsHorizontalScrollIndicator = NO;
    _scrollViewInvite.showsVerticalScrollIndicator = NO;
    _scrollViewInvite.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame));
    
    CGFloat offsetX = 0.0f;
    _viewInviteCode = [[ViewInviteCode alloc] initWithFrame:CGRectMake(offsetX, 0, CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame))];
    [_scrollViewInvite addSubview:_viewInviteCode];
    _viewInviteCode.delegate = self;
    
    offsetX += CGRectGetWidth(_scrollViewInvite.frame);
    
    _viewInviteUserInfo = [[ViewInviteUserInfo alloc] initWithFrame:CGRectMake(offsetX, 0, CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame))];
    [_scrollViewInvite addSubview:_viewInviteUserInfo];
    _viewInviteUserInfo.delegate = self;
    
    offsetX += CGRectGetWidth(_scrollViewInvite.frame);
    
    _viewInviteWelcome = [[ViewInviteWelcome alloc] initWithFrame:CGRectMake(offsetX, 0, CGRectGetWidth(_scrollViewInvite.frame), CGRectGetHeight(_scrollViewInvite.frame))];
    [_scrollViewInvite addSubview:_viewInviteWelcome];
    _viewInviteWelcome.delegate = self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)switchToInviteCode {
    [_scrollViewInvite setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [_viewInviteCode beginInputInviteKey];
}

- (void)switchToInviteUserInfo {
    _btnSkip.hidden = YES;
    
    [_scrollViewInvite setContentOffset:CGPointMake(CGRectGetWidth(_scrollViewInvite.frame), 0) animated:YES];
    
    [_viewInviteUserInfo beginInputUsername];
}

- (void)switchToInviteWelcome {
    _btnOK.hidden = YES;
    
    [_scrollViewInvite setContentOffset:CGPointMake(2 * CGRectGetWidth(_scrollViewInvite.frame), 0) animated:YES];
}

- (void)gotoCamera {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *cameraNav = [main instantiateViewControllerWithIdentifier:@"DTSCameraNavigationController"];
    [self presentViewController:cameraNav animated:YES completion:nil];
}

#pragma mark - <ViewInviteCodeDelegate>

- (void)ViewInviteCodeActionDone:(NSString *)verifyCode
{
    [_btnOK setTitle:@"提交" forState:UIControlStateNormal];
    [_btnOK setTitle:@"提交" forState:UIControlStateHighlighted];
    
    [DTSAccountManager sharedInstance].verifyCode = verifyCode;
    
    [self switchToInviteUserInfo];
}

#pragma mark - <ViewInviteUserInfo>

- (void)ViewInviteUserInfoActionDone {
    _btnOK.hidden = YES;
    
    [self switchToInviteWelcome];
}

#pragma mark - <ViewInviteWelcomeDelegate>

- (void)ViewInviteWelcomeActionGotoCamera {
    [self gotoCamera];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [self switchToInviteCode];
}

- (void)DTSWelcomeViewControllerSkip {
    [self switchToInviteCode];
}

@end
