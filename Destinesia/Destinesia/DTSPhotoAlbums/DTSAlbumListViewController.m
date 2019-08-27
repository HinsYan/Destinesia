//
//  DTSAlbumListViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/26.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSAlbumListViewController.h"

#import "DTSAlbumCoverCell.h"
#import "DTSPhotoKitManager.h"

#define kHeightTopView 44

#define DTSAlbumCoverHeight 88

@interface DTSAlbumListViewController ()<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) NSArray *albumArray;

@property (nonatomic, assign) CGSize albumCoverSize;

@end

@implementation DTSAlbumListViewController
{
    NSIndexPath *_selectedIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    [self initTopView];

    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)commonInit
{
    _albumCoverSize = CGSizeMake(kDTSScreenScale, DTSAlbumCoverHeight*kDTSScreenScale);
    
    _albumArray = [[DTSPhotoKitManager sharedInstance] albumArray];
}

#pragma mark - UI Event

- (void)initTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDTSScreenWidth, kHeightTopView)];
    _topView.backgroundColor = kUIColorMain;
    [self.view addSubview:_topView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:_topView.frame];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_topView addSubview:_titleLabel];
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kHeightTopView)];
    [_btnLeft setTitle:@"Left" forState:UIControlStateNormal];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_btnLeft addTarget:self action:@selector(actionBtnLeft:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnLeft];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_topView.frame) - 60, 0, 60, kHeightTopView)];
    [_btnRight setTitle:@"Right" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_btnRight addTarget:self action:@selector(actionBtnRight:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnRight];
}

- (void)actionBtnLeft:(UIButton *)sender
{
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionBtnRight:(UIButton *)sender {
    
}

#pragma mark - UITableView

- (void)initTableView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGRect frame = CGRectMake(0, 44, kDTSScreenWidth, kDTSScreenHeight - 44);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DTSAlbumCoverCell" bundle:nil] forCellReuseIdentifier:kDTSAlbumCoverCell];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)configureCell:(DTSAlbumCoverCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DTSAlbumModel *albumModel = _albumArray[indexPath.row];
    if (albumModel.isCameraRoll) {
        // TODO:
    }
    
    cell.albumNameLabel.text = albumModel.albumName;
    cell.albumAssetsCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)albumModel.assetsCount];
    [albumModel cancelAlbumCoverRequest:cell.imageRequestID];
    cell.imageRequestID = [albumModel asyncFetchAlbumCoverWithImageSize:_albumCoverSize
                                                          resultHandler:^(UIImage * _Nullable result) {
                                                              cell.coverImageView.image = result;
                                                              cell.imageRequestID = 0;
                                                          }];
}

- (void)updateUI
{
    _albumArray = [[DTSPhotoKitManager sharedInstance] syncAlbums];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DTSAlbumCoverHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTSAlbumCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kDTSAlbumCoverCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    
    DTSAssetsGridViewController *assetsGridVC = [[DTSAssetsGridViewController alloc] init];
    assetsGridVC.albumModel = _albumArray[_selectedIndexPath.row];
    assetsGridVC.gridDelegate = self;
    
    [self.navigationController pushViewController:assetsGridVC animated:YES];
}

#pragma mark - Navigation

- (void)assetGridSelected:(UIViewController *)picker didFinishPickingMediaWithImage:(UIImage *)originalImage
{
    if(self.selectImage) {
        self.selectImage(originalImage);
    }
}

@end
