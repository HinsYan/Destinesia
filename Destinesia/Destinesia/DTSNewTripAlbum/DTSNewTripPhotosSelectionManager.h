//
//  DTSNewTripPhotosSelectionManager.h
//  Destinesia
//
//  Created by Chris Hu on 16/9/17.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelNewTripAlbumPhoto.h"
#import "DTSNewTripAlbumUploader.h"

@interface DTSNewTripPhotosSelectionManager : NSObject

@property (nonatomic, strong) NSString *currentAlbumID;

// 仅在新建专辑返回至个人专辑页之后才reload其UICollectionView，防止跳动
@property (nonatomic, assign) BOOL isNewTripAlbumCreated;


// 选中的封面
@property (nonatomic, strong) ModelNewTripAlbumPhoto *selectedCoverPhotoModel;

// 使用包含ModelNewTripAlbumPhoto对象的数组来存储当前选择照片. 其中即包含localIdentifier及photoDesc.
@property (nonatomic, strong) NSMutableArray<ModelNewTripAlbumPhoto *> *selectedPhotoModels;

+ (instancetype)sharedInstance;

// 返回remove的photo的indexOfSelectedCell
- (NSInteger)removeNewTripPhotoAtIndexPath:(NSIndexPath *)indexPathToRemove;
- (void)resetSelectedPhotos;

- (void)updateSelectedCoverForSize:(CGSize)size WithCompletionBlock:(DTSAlbumManagerFetchImageCompletionBlock)completionBlock;

- (BOOL)createPreviewNewTripAlbum; // TODO: preview的暂时也存入realm, 后续再优化

- (BOOL)createNewTripAlbum;

@end
