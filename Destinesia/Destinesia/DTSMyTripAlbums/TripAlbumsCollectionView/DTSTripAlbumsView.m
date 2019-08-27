//
//  DTSTripAlbumsView.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSTripAlbumsView.h"

@interface DTSTripAlbumsView () <

    DTSTripAlbumsVerticalDelegate
>

@end


@implementation DTSTripAlbumsView {

    DTSTripAlbumsVertical *tripAlbumsVertal;
}

- (instancetype)initWithFrame:(CGRect)frame withTopEdgeInset:(CGFloat)topEdgeInset
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initTripAlbumsWithTopEdgeInset:topEdgeInset];
    }
    return self;
}

- (void)initTripAlbumsWithTopEdgeInset:(CGFloat)topEdgeInset {
    tripAlbumsVertal = [[DTSTripAlbumsVertical alloc] initWithFrame:self.frame withTopEdgeInset:topEdgeInset];
    tripAlbumsVertal.delegate = self;
    [self addSubview:tripAlbumsVertal];
}

#pragma mark - <DTSTripAlbumsVerticalDelegate>

- (void)DTSTripAlbumsVerticalDelegateDidSelectAlbum:(NSString *)albumID {
    if (_delegate && [_delegate respondsToSelector:@selector(DTSTripAlbumsViewDelegateDidSelectAlbum:)]) {
        [_delegate DTSTripAlbumsViewDelegateDidSelectAlbum:albumID];
    }
}

- (void)reloadData {
    [tripAlbumsVertal reloadData];
}

#pragma mark - publish 进度

- (void)albumPublished:(NSString *)albumID
{
    [tripAlbumsVertal albumPublished:albumID];
}

@end
