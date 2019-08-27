//
//  DTSNewTripAlbumUploader.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealmAlbum.h"


typedef void(^DTSNewTripAlbumUploaderCompletionBlock)(BOOL isSuccessful);


@protocol DTSNewTripAlbumUploaderDelegate <NSObject>

- (void)DTSNewTripAlbumUploaderAlbumPublished:(NSString *)albumID;

@end


@interface DTSNewTripAlbumUploader : NSObject

@property (nonatomic, weak) id<DTSNewTripAlbumUploaderDelegate> delegate;

+ (instancetype)sharedInstance;

- (BOOL)uploadAlbum:(NSString *)albumID
withCompletionBlock:(DTSNewTripAlbumUploaderCompletionBlock)completionBlock;

@end
