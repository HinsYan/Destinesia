//
//  DTSBaseGPUImageFilter.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

/** A photo filter based on LUT */

@interface DTSBaseGPUImageFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

- (id)initWithLUT:(UIImage *)LUTImage;

@end
