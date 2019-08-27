//
//  AnimatorTripAlbumToDetail.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/28.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "AnimatorBaseTransition.h"

@interface AnimatorTripAlbumToDetail : AnimatorBaseTransition

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGPoint itemCenter;

// image的identifier或URL
@property (nonatomic, copy) NSString *imageIdentifier;

@end
