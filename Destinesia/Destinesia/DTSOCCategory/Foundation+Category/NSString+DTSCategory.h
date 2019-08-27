//
//  NSString+DTSCategory.h
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DTSCategory)

- (NSAttributedString *)attributedStringWithLineSpacing:(CGFloat)lineSpaceing
                                        withFontSpacing:(CGFloat)fontSpacing;

@end
