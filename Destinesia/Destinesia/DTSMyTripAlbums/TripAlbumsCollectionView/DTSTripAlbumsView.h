//
//  DTSTripAlbumsView.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTSTripAlbumsVertical.h"

@protocol DTSTripAlbumsViewDelegate <NSObject>

- (void)DTSTripAlbumsViewDelegateDidSelectAlbum:(NSString *)albumID;

@end

@interface DTSTripAlbumsView : UIView

@property (nonatomic, weak) id<DTSTripAlbumsViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withTopEdgeInset:(CGFloat)topEdgeInset;

- (void)reloadData;

#pragma mark - publish 进度

- (void)albumPublished:(NSString *)albumID;

@end
