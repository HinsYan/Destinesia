//
//  DTSGPUImageFilterManager.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSGPUImageFilterManager.h"
#import "DTSBaseGPUImageFilter.h"

@interface DTSGPUImageFilterManager ()

@property (nonatomic, strong) NSArray<Class> *instagramFilters;

@end

@implementation DTSGPUImageFilterManager

+ (instancetype)sharedInstance {
    static DTSGPUImageFilterManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSGPUImageFilterManager alloc] init];
        sharedInstance.cachedFilteredImages = [[YYThreadSafeArray alloc] init];
        
        sharedInstance.instagramFilters = [IFImageFilter allFilterClasses];
    });
    return sharedInstance;
}

- (void)removeAllCachedFilteredImages {
    return;
    [_cachedFilteredImages removeAllObjects];
}

+ (GPUImageFilterGroup *)filterBW {
    return [[DTSGPUImageBWFilter alloc] init];
}

+ (UIImage *)bwFilteredImage:(UIImage *)originImage {
    return [[self filterBW] imageByFilteringImage:originImage];
}

+ (GPUImageFilterGroup *)filterNewspaper {
    return [[DTSGPUImageNewspaperFilter alloc] init];
}

+ (UIImage *)newspaperFilteredImage:(UIImage *)originImage {
    return [[self filterNewspaper] imageByFilteringImage:originImage];
}

+ (GPUImageFilterGroup *)filterMagazine {
    return [[DTSGPUImageMagazineFilter alloc] init];
}

+ (UIImage *)magazineFilteredImage:(UIImage *)originImage {
    return [[self filterMagazine] imageByFilteringImage:originImage];
}

+ (GPUImageFilter *)blurFilter {
    return [[GPUImageGaussianBlurFilter alloc] init];
}

+ (UIImage *)blurFilteredImage:(UIImage *)originImage {
    return [[self blurFilter] imageByFilteringImage:originImage];
}

#pragma mark - Test Filters

+ (GPUImageFilterGroup *)filterMoonlight {
    return [[DTSGPUImageMoonlightFilter alloc] init];
}

+ (UIImage *)moonlightFilteredImage:(UIImage *)originImage {
    return [[self filterMoonlight] imageByFilteringImage:originImage];
}

+ (GPUImageFilterGroup *)filterViaLUTImage:(UIImage *)LUTImage {
    return [[DTSBaseGPUImageFilter alloc] initWithLUT:LUTImage];
}

+ (UIImage *)filteredImage:(UIImage *)originImage viaLUTImage:(UIImage *)LUTImage {
    return [[self filterViaLUTImage:LUTImage] imageByFilteringImage:originImage];
}

#pragma mark - Instagram Filters

+ (IFImageFilter *)filter1977 {
    return [[IF1977Filter alloc] init];
}

+ (UIImage *)filter1977Image:(UIImage *)originImage {
    return [[self filter1977] imageByFilteringImage:originImage];
}

@end
