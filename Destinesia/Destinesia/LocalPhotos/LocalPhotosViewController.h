//
//  LocalPhotosViewController.h
//  Destinesia
//
//  Created by Chris Hu on 16/8/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

// Used to compare filter effect

#import <UIKit/UIKit.h>

@protocol LocalPhotosViewControllerDelegate <NSObject>

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface LocalPhotosViewController : UIViewController

@property (nonatomic, weak) id<LocalPhotosViewControllerDelegate> delegate;

@end
