//
//  DTSTripDetailViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/11.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripDetailViewController.h"
#import "DTSTripAlbumsManager.h"
#import "DTSLocalTripAlbumsManager.h"
#import "ViewTripDetailWatermark.h"
#import "MBProgressHUD.h"
#import "DTSTripDetailDataSourceManager.h"

#import "ViewTripDetailCover.h"


// 获取当地专辑详情后回调
typedef void(^CompletionBlock)(id responseObject);


@interface DTSTripDetailViewController ()
<
    DTSTripDetailDataSourceManagerDelegate,
    MBProgressHUDDelegate
>

@end

@implementation DTSTripDetailViewController {

    ViewTripDetailCover *_tripDetailCover;
    UISwipeGestureRecognizer *coverLeftSwipeGesture;
    UISwipeGestureRecognizer *coverRightSwipeGesture;
    
    UIView *_maskView; // 封面下边的透明蒙版
    UISwipeGestureRecognizer *maskViewRightSwipeGesture; // 右滑展示封面
    UISwipeGestureRecognizer *maskViewLeftSwipeGesture; // 左滑展示照片
    
    UISwipeGestureRecognizer *swipeGestureOfPhotoDetailView;
    
    // 展示每张照片
    UICollectionView *_collectionView;
    DTSTripDetailDataSourceManager *_tripDetailDataSourceManager;
    
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self album_view];
    
    [self initCollectionView];
    
    [self initTripDetailCover];
    
    [self initMaskViewBelowCover];
    
    [self getTripAlbum];
}

// 增加专辑浏览量
- (void)album_view
{
    NSDictionary *parameters = @{
                                 @"token": [DTSUserDefaults userToken],
                                 @"albumId": _albumID,
                                 @"deviceNO": [DTSUserDefaults deviceNO],
                                 };
    [DTSHTTPRequest album_view:parameters withCompletionBlock:nil withErrorBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)getTripAlbum {
    // TODO: 通过albumID来判断是服务端返回的或是本地realm数据库存储的
    // 服务端请求的album，需要更新realm中存储的photos
    if (![_albumID containsString:@"Album_"]) {
        [self getTripAlbumFromServer];
    }
}

- (void)getTripAlbumFromServer
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在努力加载中...";
    [self requestTripAlbum:_albumID
       withCompletionBlock:^(id responseObject) {
           if ([NSJSONSerialization isValidJSONObject:responseObject]) {
               
               /*
                从专辑列表取到的只是album list，不包含RealmPhoto照片信息。
                因此根据id获取到专辑详情后，需要更新存储的album。
                */
               if ([RealmAlbumManager deleteRealmAlbumOfAlbumID:_albumID]) {
                   RealmAlbum *realmAlbum = [RealmAlbumManager realmAlbumFromJSON:responseObject];
                   [RealmAlbumManager addRealmAlbum:realmAlbum];
                   
                   // 必须要更新
                   [[DTSTripAlbumsManager sharedInstance] updateMyTripAlbumsFromRealm];
                   
                   _tripDetailCover.albumID = _albumID;
                   _tripDetailDataSourceManager.albumID = _albumID;
               }
           }
           
           hud.delegate = nil;
           [hud hideAnimated:YES];
    }];
}

- (void)requestTripAlbum:(NSString *)albumID
     withCompletionBlock:(CompletionBlock)completionBlock
{
    NSDictionary *pamermeters = @{
                                  @"token": [DTSUserDefaults userToken],
                                  @"id": albumID,
                                  };
    [DTSHTTPRequest album_detail:pamermeters withCompletionBlock:^(id responseObject) {
        if (completionBlock) {
            completionBlock(responseObject);
        }
    } withErrorBlock:^(id responseObject) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        if (![responseObject isKindOfClass:[NSError class]]) {
            DTSLog(@"%@", [responseObject objectForKey:@"code"]);
            [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
        }
    }];
}

#pragma mark - <MBProgressHUDDelegate>

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [DTSToastUtil toastWithText:@"网络异常，请稍后重试~"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self back];
    });
}

#pragma mark - Trip Cover

- (void)initTripDetailCover
{
    _tripDetailCover = [[ViewTripDetailCover alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_tripDetailCover];
    _tripDetailCover.albumID = _albumID;
    
    [self addCoverGesture];
}

- (void)addCoverGesture
{
    if (!coverLeftSwipeGesture) {
        coverLeftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionCoverLeftSwipeGesture:)];
        coverLeftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [_tripDetailCover addGestureRecognizer:coverLeftSwipeGesture];
    }
    
    if (!coverRightSwipeGesture) {
        coverRightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionCoverRightSwipeGesture:)];
        coverRightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [_tripDetailCover addGestureRecognizer:coverRightSwipeGesture];
    }

}

- (void)removeCoverGesture
{
    if (coverLeftSwipeGesture) {
        [_tripDetailCover removeGestureRecognizer:coverLeftSwipeGesture];
        coverLeftSwipeGesture = nil;
    }
    
    if (coverRightSwipeGesture) {
        [_tripDetailCover removeGestureRecognizer:coverRightSwipeGesture];
        coverRightSwipeGesture = nil;
    }
}

- (void)actionCoverLeftSwipeGesture:(UISwipeGestureRecognizer *)sender {
    [UIView animateWithDuration:1.f animations:^{
        _tripDetailCover.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(_tripDetailCover.frame), 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)actionCoverRightSwipeGesture:(UISwipeGestureRecognizer *)sender {
    [self back];
}

#pragma mark - mask view below cover

- (void)initMaskViewBelowCover {
    _maskView = [[UIView alloc] initWithFrame:_tripDetailCover.bounds];
    [self.view insertSubview:_maskView belowSubview:_tripDetailCover];
    _maskView.userInteractionEnabled = YES;
    _maskView.backgroundColor = [UIColor clearColor];
    
    [self addMaskViewGesture];
}

- (void)addMaskViewGesture {
    maskViewRightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionMaskViewSwipeGesture:)];
    maskViewRightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_maskView addGestureRecognizer:maskViewRightSwipeGesture];
    
    maskViewLeftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionMaskViewSwipeGesture:)];
    maskViewLeftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_maskView addGestureRecognizer:maskViewLeftSwipeGesture];
}

- (void)removeMaskViewGesture
{
    if (maskViewRightSwipeGesture) {
        [_maskView removeGestureRecognizer:maskViewRightSwipeGesture];
        maskViewRightSwipeGesture = nil;
    }
    
    if (maskViewLeftSwipeGesture) {
        [_maskView removeGestureRecognizer:maskViewLeftSwipeGesture];
        maskViewLeftSwipeGesture = nil;
    }
}

- (void)actionMaskViewSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [_collectionView setContentOffset:CGPointMake(kWidthPhotoDetailDesc, 0) animated:YES];
        
        _maskView.userInteractionEnabled = NO;
        
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:1.f animations:^{
            _tripDetailCover.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - actions

- (void)back
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Trip Photos UICollectionView

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = NO;
    _collectionView.bounces = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TripDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kTripDetailCollectionViewCellIdentifier];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TripDetailCollectionReusableFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kTripDetailCollectionReusableFooterIdentifier];
    
    
    _tripDetailDataSourceManager = [[DTSTripDetailDataSourceManager alloc] init];
    _tripDetailDataSourceManager.delegate = self;
    _tripDetailDataSourceManager.albumID = _albumID;
    _tripDetailDataSourceManager.collectionView = _collectionView;
    
    _collectionView.dataSource = _tripDetailDataSourceManager;
    _collectionView.delegate = _tripDetailDataSourceManager;
}

#pragma mark - <DTSTripDetailDataSourceManagerDelegate>

- (void)DTSTripDetailScrollViewDidScroll:(CGFloat)offset
{
    if (offset == 0) {
        _maskView.userInteractionEnabled = YES;
    }
}

@end
