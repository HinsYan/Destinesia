//
//  UIImage+DTSCategory.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/6.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DTSCategory)

/**
Save UIImage to file

- parameter filePath:          file path
- parameter compressionFactor: compression factor, only useful for JPEG format image.

- returns: YES or NO
*/
- (BOOL)dts_saveImageToFile:(NSString *)filePath compressionFactor:(CGFloat)compressionFactor;

/**
Scale UIImage to specified size.

- parameter size:              specified size
- parameter withOriginalRatio: whether the result UIImage should keep the original ratio

- returns: UIImage scaled
*/
- (UIImage *)dts_imageScaledToSize:(CGSize)size withOriginalRatio:(BOOL)isWithOriginalRatio;

/**
Rotate UIImage to specified degress

- parameter degress: degress to rotate

- returns: UIImage rotated
*/
- (UIImage *)dts_imageRotatedByDegress:(CGFloat)degress;

/**
 Mirror UIImage
 
 - returns: UIImage mirrored
 */
- (UIImage *)dts_imageMirrored;

/**
 UIImage with corner radius without Off-Screen Rendering.
 Much better than setting layer.cornerRadius and layer.masksToBounds.
 
 - parameter cornerRadius: corner radius
 
 - returns: UIImage
 */
- (UIImage *)dts_imageWithCornerRadius:(CGFloat)cornerRadius;

/**
 *  Ratio image to fit the screen ratio.
 *
 *  @return UIImage
 */
- (UIImage *)dts_imageRatioed;

/**
 *  Ratio image to fit size.
 *  先按照比例进行裁剪, 然后缩放至目标尺寸.
 *
 *  @return UIImage
 */
- (UIImage *)dts_imageFitTargetSize:(CGSize)targetSize;

@end