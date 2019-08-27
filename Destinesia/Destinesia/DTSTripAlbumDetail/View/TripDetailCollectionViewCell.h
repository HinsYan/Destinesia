//
//  TripDetailCollectionViewCell.h
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "CollectionViewCellBaseXXNibBridge.h"

static NSString * const kTripDetailCollectionViewCellIdentifier = @"kTripDetailCollectionViewCellIdentifier";

@interface TripDetailCollectionViewCell : CollectionViewCellBaseXXNibBridge

- (void)setPhotoID:(NSString *)photoID ofAlbum:(NSString *)albumID;

@end
