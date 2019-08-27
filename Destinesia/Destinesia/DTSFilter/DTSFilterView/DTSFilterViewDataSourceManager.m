//
//  DTSFilterViewDataSourceManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/19.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSFilterViewDataSourceManager.h"

@interface DTSFilterViewDataSourceManager ()

@end

@implementation DTSFilterViewDataSourceManager {

    NSArray *_testFilters;
    NSArray *_instagramFilters;
}

+ (instancetype)sharedInstance {
    static DTSFilterViewDataSourceManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        [sharedInstance initDataSource];
    });
    return sharedInstance;
}


- (void)initDataSource {
    _testFilters = @[
                     @"Original", @"BW", @"Newspaper", @"Magazine",
                     @"01", @"02", @"03", @"04", @"05", @"06",
                     ];
    _instagramFilters = @[
                          @"IFSutroFilter",
                          @"IFAmaroFilter",
                          @"IFRiseFilter",
                          @"IFHudsonFilter",
                          @"IFXproIIFilter",
                          @"IFSierraFilter",
                          @"IFLomofiFilter",
                          @"IFEarlybirdFilter",
                          @"IFToasterFilter",
                          @"IFBrannanFilter",
                          @"IFInkwellFilter",
                          @"IFWaldenFilter",
                          @"IFHefeFilter",
                          @"IFValenciaFilter",
                          @"IFNashvilleFilter",
                          @"IF1977Filter",
                          @"IFLordKelvinFilter",
                          ];
    _dtsFilters = [NSMutableArray arrayWithArray:_testFilters];
    [_dtsFilters addObjectsFromArray:_instagramFilters];
}

- (void)prepareFilteredImages {
    if ([DTSGPUImageFilterManager sharedInstance].cachedFilteredImages.count > 0) {
        return;
    }
    
    UIImage *thumbnailImage = [_theOriginalImage dts_imageScaledToSize:CGSizeMake(60, 80) withOriginalRatio:YES];
    
    if (!thumbnailImage) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSString *filterName in _testFilters) {
            UIImage *lutImage = [UIImage imageNamed:[NSString stringWithFormat:@"LUT_%@.png", filterName]];
            UIImage *filteredImage = [DTSGPUImageFilterManager filteredImage:thumbnailImage viaLUTImage:lutImage];
            [[DTSGPUImageFilterManager sharedInstance].cachedFilteredImages addObject:filteredImage];
        }
        
        for (NSString *instagramFilterName in _instagramFilters) {
            IFImageFilter *instagramFilter = [[NSClassFromString(instagramFilterName) alloc] init];
            UIImage *filteredImage = [instagramFilter imageByFilteringImage:thumbnailImage];
            [[DTSGPUImageFilterManager sharedInstance].cachedFilteredImages addObject:filteredImage];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
            
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
        
    });
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dtsFilters.count;
}

- (DTSFilterCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DTSFilterCollectionViewCell *cell = (DTSFilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kDTSFilterCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < [DTSGPUImageFilterManager sharedInstance].cachedFilteredImages.count &&
        [[DTSGPUImageFilterManager sharedInstance].cachedFilteredImages objectAtIndex:indexPath.item]) {
        cell.imageView.image = [[DTSGPUImageFilterManager sharedInstance].cachedFilteredImages objectAtIndex:indexPath.item];
    }
    
    NSString *filterName = _dtsFilters[indexPath.item];
    if ([filterName hasPrefix:@"IF"] && [filterName hasSuffix:@"Filter"]) {
        filterName = [filterName stringByReplacingOccurrencesOfString:@"IF" withString:@""];
        filterName = [filterName stringByReplacingOccurrencesOfString:@"Filter" withString:@""];
    }
    cell.label.text = filterName;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(DTSFilterViewDataSourceManagerDidSelectItemAtIndexPath:)]) {
        [_delegate DTSFilterViewDataSourceManagerDidSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60.0f, 100.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(5, 15, 0, 10);
    } else if (section == _dtsFilters.count - 1) {
        return UIEdgeInsetsMake(5, 0, 0, 15);
    } else {
        return UIEdgeInsetsMake(5, 0, 0, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6.0f;
}

@end
