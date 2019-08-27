//
//  LocalPhotosViewController.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "LocalPhotosViewController.h"
#import "LocalPhotosCollectionViewCell.h"

@interface LocalPhotosViewController () <

    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@end

@implementation LocalPhotosViewController

static NSString * const reuseIdentifier = @"LocalPhotosCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kUIColorMain;
    
    [self addBtnClose];
    
    [self initCollectionView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBtnClose {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btn setTitle:@"Close" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)actionClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, kDTSScreenWidth, kDTSScreenHeight - 40) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"LocalPhotosCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (LocalPhotosCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LocalPhotosCollectionViewCell *cell = (LocalPhotosCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)indexPath.item]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
            [_delegate didSelectItemAtIndexPath:indexPath];
        }
    }];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 120);
}

@end
