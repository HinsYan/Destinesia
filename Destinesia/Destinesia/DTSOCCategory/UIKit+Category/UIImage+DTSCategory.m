//
//  UIImage+DTSCategory.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/6.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

@implementation UIImage (DTSCategory)

- (BOOL)dts_saveImageToFile:(NSString *)filePath compressionFactor:(CGFloat)compressionFactor {
    NSData *imageData;
    if ([filePath hasSuffix:@".jpeg"]) {
        imageData = UIImageJPEGRepresentation(self, compressionFactor);
    } else {
        imageData = UIImagePNGRepresentation(self);
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath] &&
        [fileManager isDeletableFileAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    if ([fileManager createFileAtPath:filePath contents:imageData attributes:nil]) {
        return [imageData writeToFile:filePath atomically:YES];
    }
    
    return NO;
}

- (UIImage *)dts_imageScaledToSize:(CGSize)size withOriginalRatio:(BOOL)isWithOriginalRatio {
    CGSize sizeFinal = size;
    
    if (isWithOriginalRatio) {
        CGFloat ratioOriginal = self.size.width / self.size.height;
        CGFloat ratioTemp = size.width / size.height;
        
        if (ratioOriginal < ratioTemp) {
            sizeFinal.width = size.height * ratioOriginal;
        } else if (ratioOriginal > ratioTemp) {
            sizeFinal.height = size.width / ratioOriginal;
        }
    }
    
    UIGraphicsBeginImageContext(sizeFinal);
    [self drawInRect:CGRectMake(0, 0, sizeFinal.width, sizeFinal.height)];
    UIImage *imageScaled = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageScaled;
}

- (UIImage *)dts_imageRotatedByDegress:(CGFloat)degress {
    CGFloat radians = M_PI * degress / 180.0f;
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    rotatedViewBox.transform = CGAffineTransformMakeRotation(radians);
    
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create bitmap context.
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and.
    CGContextTranslateCTM(context, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
    
    // Rotate the image context
    CGContextRotateCTM(context, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(-self.size.width / 2.0, -self.size.height / 2.0, self.size.width, self.size.height), self.CGImage);
    
    UIImage *imageRotated = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRotated;
}

- (UIImage *)dts_imageMirrored {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextTranslateCTM(context, width, height);
    CGContextConcatCTM(context, CGAffineTransformMakeScale(-1, -1));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)dts_imageWithCornerRadius:(CGFloat)cornerRadius {
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContext(self.size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius] addClip];
    
    // Draw the image
    [self drawInRect:frame];
    
    UIImage *imageWithCornerRadius = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageWithCornerRadius;
}

- (UIImage *)dts_imageRatioed {
    CGFloat widthImage, heightImage;
    CGRect rectRatioed;
    
    if (self.size.height / self.size.width < kDTSScreenHeight / kDTSScreenWidth) {
        // 图片的height过小, 剪裁其width, 而height不变
        heightImage = self.size.height;
        widthImage = heightImage * kDTSScreenWidth / kDTSScreenHeight;
        rectRatioed = CGRectMake((self.size.width - widthImage) / 2, 0, widthImage, heightImage);
    } else {
        // 图片的width过小, 剪裁其height, 而width不变
        widthImage = self.size.width;
        heightImage = widthImage * kDTSScreenHeight / kDTSScreenWidth;
        rectRatioed = CGRectMake(0, (self.size.height - heightImage) / 2, widthImage, heightImage);
    }
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, rectRatioed);
    UIImage *imageRatioed = [[UIImage alloc] initWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    return imageRatioed;
}

- (UIImage *)dts_imageFitTargetSize:(CGSize)targetSize {
    CGFloat widthImage, heightImage;
    CGRect rectRatioed;
    
    if (self.size.height / self.size.width < targetSize.height / targetSize.width) {
        // 图片的height过小, 剪裁其width, 而height不变
        heightImage = self.size.height;
        widthImage = heightImage * targetSize.width / targetSize.height;
        rectRatioed = CGRectMake((self.size.width - widthImage) / 2, 0, widthImage, heightImage);
    } else {
        // 图片的width过小, 剪裁其height, 而width不变
        widthImage = self.size.width;
        heightImage = widthImage * targetSize.height / targetSize.width;
        rectRatioed = CGRectMake(0, (self.size.height - heightImage) / 2, widthImage, heightImage);
    }
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, rectRatioed);
    UIImage *imageRatioed = [[UIImage alloc] initWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    return imageRatioed;
}

@end