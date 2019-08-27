//
//  DTSLocalTripAlbumsViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/16.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSLocalTripAlbumsViewController.h"
#import "DTSLocalTripAlbumsDataSourceManager.h"

#import "DTSTripDetailViewController.h"
#import "AnimatorLocalTripAlbumsToDetail.h"

@interface DTSLocalTripAlbumsViewController () <

    UINavigationControllerDelegate,
    DTSLocalTripAlbumsDataSourceManagerDelegate,
    DTSLoalTripAlbumsManagerDelegate
>

@property (weak, nonatomic) IBOutlet UIView *viewTripAlbumsOutline;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UILabel *lbLocation;

@property (weak, nonatomic) IBOutlet UILabel *lbLocalUserCount;

@property (weak, nonatomic) IBOutlet UILabel *lbLocalAlbumCount;

@end

@implementation DTSLocalTripAlbumsViewController {

    UIView *backgroundView;
    UIImageView *bgImageView;
    
    UIImageView *viewMyTripAlbumsNone;
    
    UICollectionView *collectionView;
    DTSLocalTripAlbumsDataSourceManager *localTripAlbumsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewTripAlbumsOutline];
    
    [self initBackgroundView];
    
    [self initLocalTripAlbumInfo];
    
    [self initCollectionView];
    
    // 用于网络请求之后更新
    [DTSLocalTripAlbumsManager sharedInstance].delegate = self;
    
    [[DTSLocalTripAlbumsManager sharedInstance] updateLocalTripAlbums];
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
    
    [self updateLocalTripAlbumInfo];
}

- (IBAction)actionClose:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initViewTripAlbumsOutline {
    _viewTripAlbumsOutline.backgroundColor = RGBAHEX(0x08CDCC, 0.9);
}

- (void)initBackgroundView {
    backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:backgroundView belowSubview:_viewTripAlbumsOutline];
    
    // add blur effect
    bgImageView = [[UIImageView alloc] initWithFrame:backgroundView.bounds];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"LaunchScreen.jpg"];
    [backgroundView addSubview:bgImageView];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = bgImageView.bounds;
    [backgroundView addSubview:effectView];
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

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    collectionView = [[UICollectionView alloc] initWithFrame:backgroundView.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [backgroundView addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"DTSLocalTripAlbumsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kDTSLocalTripAlbumsCollectionViewCellIdentifier];
    
    localTripAlbumsController = [[DTSLocalTripAlbumsDataSourceManager alloc] init];
    localTripAlbumsController.delegate = self;
    collectionView.dataSource = localTripAlbumsController;
    collectionView.delegate = localTripAlbumsController;
}

- (void)initLocalTripAlbumInfo {
    _lbLocation.text = @"";
}

- (void)updateLocalTripAlbumInfo {
    ModelLocalTripAlbums *localTripAlbumsInfo = [DTSLocalTripAlbumsManager sharedInstance].localTripAlbumsInfo;
    
    _lbLocation.attributedText = [self attributedStringLocalLocation];
    
    _lbLocalAlbumCount.text = [NSString stringWithFormat:@"%ld", (long)localTripAlbumsInfo.albumsCount];
    _lbLocalUserCount.text =  [NSString stringWithFormat:@"%ld", (long)localTripAlbumsInfo.userCount];
    
    if (localTripAlbumsInfo.albums.count > 0) {
        RealmAlbum *firstAlbum = [localTripAlbumsInfo.albums firstObject];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:firstAlbum.albumCoverPhotoID] placeholderImage:[UIImage imageNamed:@"LaunchScreen.jpg"]];
        
        [self removeViewMyTripAlbumsNone];
    } else {
        [self initViewMyTripAlbumsNone];
    }
}

- (NSMutableAttributedString *)attributedStringLocalLocation {
    NSString *localLocation = [DTSLocalTripAlbumsManager sharedInstance].localLocation;
    if (!localLocation) {
        return nil;
    }
    
    NSMutableAttributedString *attributedLocalLocation = [[NSMutableAttributedString alloc] initWithString:localLocation];
    NSRange rangeOfLastComma = [localLocation rangeOfString:@"," options:NSBackwardsSearch];
    if (rangeOfLastComma.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:localLocation];
    }
    
    NSUInteger countrylocation = rangeOfLastComma.location + 2;
    NSUInteger countryLength = localLocation.length - (rangeOfLastComma.location + 2);
    NSRange countryRange = NSMakeRange(countrylocation, countryLength);
    [attributedLocalLocation addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:countryRange];
    
    return attributedLocalLocation;
}

#pragma mark - local trip albums

#pragma mark - <DTSLoalTripAlbumsManagerDelegate>

- (void)DTSLocalTripAlbumsManagerReloadData
{
    [collectionView reloadData];
}

#pragma mark - <DTSLocalTripAlbumsDataSourceManagerDelegate>

- (void)DTSLocalTripAlbumsDataSourceManagerDelegateDidSelectAlbum:(NSString *)albumID {
    DTSTripDetailViewController *tripDetailVC = [[DTSTripDetailViewController alloc] init];
    // TODO: 使用albumID
    tripDetailVC.albumID = albumID;
//    self.navigationController.delegate = self;
    [self.navigationController pushViewController:tripDetailVC animated:YES];
}

#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    AnimatorLocalTripAlbumsToDetail *anim = [[AnimatorLocalTripAlbumsToDetail alloc] init];
    
    if (operation == UINavigationControllerOperationPush) {
        anim.animatorTransitionType = kAnimatorTransitionTypePush;
        return nil;
    } else {
        anim.animatorTransitionType = kAnimatorTransitionTypePop;
        return nil;
    }
    
    NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
    if (indexPaths.count == 0) {
        return nil;
    }
    
    NSIndexPath *selectedIndexPath = indexPaths[0];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:selectedIndexPath];
    
    // 一定要加上convertPoint:toView:操作
    anim.itemCenter = [collectionView convertPoint:cell.center toView:self.view];
    anim.itemSize = cell.frame.size;
    
    ModelLocalTripAlbums *localTripAlbumsInfo = [DTSLocalTripAlbumsManager sharedInstance].localTripAlbumsInfo;
    
    RealmAlbum *album = [localTripAlbumsInfo.albums objectAtIndex:selectedIndexPath.item];
    anim.imageURL = album.albumCoverPhotoID;
    
    return anim;
}

@end
