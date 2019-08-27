//
//  DTSBaseGPUImageFilter.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSBaseGPUImageFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageLookupFilter.h"

@implementation DTSBaseGPUImageFilter

- (id)initWithLUT:(UIImage *)LUTImage {
    if (!(self = [super init]))
    {
        return nil;
    }
    
    lookupImageSource = [[GPUImagePicture alloc] initWithImage:LUTImage];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupImageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

@end
