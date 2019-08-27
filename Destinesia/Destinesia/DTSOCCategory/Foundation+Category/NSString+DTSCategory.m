//
//  NSString+DTSCategory.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation NSString (DTSCategory)

- (NSAttributedString *)attributedStringWithLineSpacing:(CGFloat)lineSpaceing
                                        withFontSpacing:(CGFloat)fontSpacing
{
    NSUInteger length = self.length;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    if (lineSpaceing > 0) {
        style.lineSpacing = lineSpaceing;
    }
    
    //    style.paragraphSpacing = 100;
    //    style.lineHeightMultiple = 1.5f;
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    
    //    [attrString addAttribute:NSKernAttributeName value:@0.7 range:NSMakeRange(0, length)];
    
    long number = fontSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attrString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attrString length])];
    CFRelease(num);
    
    return attrString;
}

@end
