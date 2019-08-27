//
//  DTSGPUImageNewspaperFilter.m
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSGPUImageNewspaperFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageLookupFilter.h"

@implementation DTSGPUImageNewspaperFilter

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:@"LUT_Newspaper.png"];
    
    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
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
