//
//  DTSGPUImageBWFilter.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@class GPUImagePicture;

/** A GPUImage filter based on LUT_BW.png */

@interface DTSGPUImageBWFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end