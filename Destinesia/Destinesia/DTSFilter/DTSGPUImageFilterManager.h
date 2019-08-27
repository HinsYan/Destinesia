//
//  DTSGPUImageFilterManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DTSGPUImageBWFilter.h"
#import "DTSGPUImageNewspaperFilter.h"
#import "DTSGPUImageMagazineFilter.h"

#import "DTSGPUImageMoonlightFilter.h"

#import "InstaFilters.h"

#import "YYThreadSafeArray.h"

@interface DTSGPUImageFilterManager : NSObject


@property (nonatomic, strong) YYThreadSafeArray *cachedFilteredImages;

+ (instancetype)sharedInstance;

- (void)removeAllCachedFilteredImages;

+ (GPUImageFilterGroup *)filterBW;
+ (UIImage *)bwFilteredImage:(UIImage *)originImage;

+ (GPUImageFilterGroup *)filterNewspaper;
+ (UIImage *)newspaperFilteredImage:(UIImage *)originImage;

+ (GPUImageFilterGroup *)filterMagazine;
+ (UIImage *)magazineFilteredImage:(UIImage *)originImage;

+ (GPUImageFilter *)blurFilter;
+ (UIImage *)blurFilteredImage:(UIImage *)originImage;

#pragma mark - Test Filters

+ (GPUImageFilterGroup *)filterMoonlight;
+ (UIImage *)moonlightFilteredImage:(UIImage *)originImage;

+ (GPUImageFilterGroup *)filterViaLUTImage:(UIImage *)LUTImage;

+ (UIImage *)filteredImage:(UIImage *)originImage viaLUTImage:(UIImage *)LUTImage;

#pragma mark - Instagram Filters 

+ (IFImageFilter *)filter1977;
+ (UIImage *)filter1977Image:(UIImage *)originImage;

@end
