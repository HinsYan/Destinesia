//
//  DTSNewTripAlbumUploader.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/29.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSNewTripAlbumUploader.h"
#import <Qiniu/QiniuSDK.h>
#import <Qiniu/QN_GTM_Base64.h>

#import <CommonCrypto/CommonCrypto.h>
#import "RealmAlbumManager.h"
#import "DTSPhotoKitManager.h"


typedef void(^QiniuUploadPhotoCompletionBlock)(QNResponseInfo *info, NSString *key, NSDictionary *resp);


@interface DTSNewTripAlbumUploader ()

@property (nonatomic, strong) NSString *accessKey;

@property (nonatomic, strong) NSString *secretKey;

@property (nonatomic, strong) NSString *scope;

@property (nonatomic, assign) NSInteger liveTime; // 天

@property (nonatomic, strong) NSString *qiniuToken;

@property (nonatomic, strong) QNUploadManager *uploadManager;

@end

@implementation DTSNewTripAlbumUploader

+ (instancetype)sharedInstance {
    static DTSNewTripAlbumUploader *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTSNewTripAlbumUploader alloc] init];
        
        [sharedInstance initQiniu];
    });
    return sharedInstance;
}

#pragma mark - Qiniu related

- (void)initQiniu
{
    self.accessKey = @"jC_WNab1ERjF9scpwVywDg0x9EnBPhUHZPL8GzZh";
    self.secretKey = @"LJNTUfXGclkFLiX7kDZgXXSOAYRK_YtxWXHCwD9-";
    self.scope = @"testqiniu";
    
    self.liveTime = 1;
    
    [self generateQiniuToken];
    
    _uploadManager = [[QNUploadManager alloc] init];
}

- (void)generateQiniuToken
{
    // http://www.tuicool.com/articles/BRriAnb
    NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
    [authInfo setObject:self.scope forKey:@"scope"];
    [authInfo setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] + self.liveTime * 24 * 3600]
                 forKey:@"deadline"];
    
    NSData *jsonData =
    [NSJSONSerialization dataWithJSONObject:authInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *encodedString = [self urlSafeBase64Encode:jsonData];
    
    NSString *encodedSignedString = [self HMACSHA1:self.secretKey text:encodedString];
    
    self.qiniuToken =
    [NSString stringWithFormat:@"%@:%@:%@", self.accessKey, encodedSignedString, encodedString];
    
    NSLog(@"done");
}

- (NSString *)urlSafeBase64Encode:(NSData *)text
{
    NSString *base64 =
    [[NSString alloc] initWithData:[QN_GTM_Base64 encodeData:text] encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}

- (NSString *)HMACSHA1:(NSString *)key text:(NSString *)text
{
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    return hash;
}

#pragma mark - upload album

- (BOOL)uploadAlbum:(NSString *)albumID
withCompletionBlock:(DTSNewTripAlbumUploaderCompletionBlock)completionBlock
{
    BOOL isSuccessful = NO;
    
    // TODO : QINIU
    // 上传cover，仅通过albumID
    [self uploadCoverPhotoOfRealmAlbum:albumID];
    
    // 上传照片
    RealmAlbum *album = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    for (RealmPhoto *realmPhoto in album.photos) {
        [self uploadPhoto:realmPhoto.photoID ofAlbum:albumID];
    }
    
    if (completionBlock) {
        completionBlock(isSuccessful);
    }
    
    isSuccessful = YES;
    
    return isSuccessful;
}

- (BOOL)uploadCoverPhotoOfRealmAlbum:(NSString *)albumID
{
    RealmAlbum *album = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    NSString *albumCoverPhotoID = album.albumCoverPhotoID;
    
    [[DTSPhotoKitManager sharedInstance] requestImageForAssetLocalIdentifier:albumCoverPhotoID
                                                                  targetSize:PHImageManagerMaximumSize
                                                                 contentMode:PHImageContentModeAspectFit
                                                               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    
       [self uploadPhotoToQiniu:result
                         forKey:albumCoverPhotoID
            withCompletionBlock:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
           // 以下代码执行在main queue中。
           RealmAlbum *realmAlbumMainQueue = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
           BOOL isAlbumCoverPhotoUploaded = NO;
           if (realmAlbumMainQueue && [[resp objectForKey:@"key"] isEqualToString:key]) {
               isAlbumCoverPhotoUploaded = YES;
               DTSLog(@"cover upload ok : %@, %@", realmAlbumMainQueue.albumID, realmAlbumMainQueue.albumCoverPhotoID);
           } else {
               if (info.error.code == 614) {
                   isAlbumCoverPhotoUploaded = YES;
                   DTSLog(@"cover already exist ... ");
               } else {
                   [DTSDiskUtil saveImageToPhotosDir:result withPhotoID:albumCoverPhotoID];
                   
                   DTSLog(@"cover upload fail : %@, %@", realmAlbumMainQueue.albumID, realmAlbumMainQueue.albumCoverPhotoID);
               }
           }
           
           RLMRealm *realm = [RLMRealm defaultRealm];
           [realm transactionWithBlock:^{
               realmAlbumMainQueue.isAlbumCoverPhotoUploaded = isAlbumCoverPhotoUploaded;
               if (realmAlbumMainQueue.isAlbumCoverPhotoUploaded) {
                   realmAlbumMainQueue.coverPhotoURL = [NSString stringWithFormat:@"%@%@", DTS_QINIU_BASE_URL, albumCoverPhotoID];
               }
           }];
           
           [self tryToPublishTripAlbum:albumID];
       }];
                                                                   
    }];
    
    return YES;
}

- (BOOL)uploadPhoto:(NSString *)photoID ofAlbum:(NSString *)albumID
{
    [[DTSPhotoKitManager sharedInstance] requestImageForAssetLocalIdentifier:photoID
                                                                  targetSize:PHImageManagerMaximumSize
                                                                 contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        [self uploadPhotoToQiniu:result
                          forKey:photoID
             withCompletionBlock:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
                // 以下代码执行在main queue中。
                RealmPhoto *realmPhotoMainQueue = [RealmAlbumManager realmPhotoOfID:photoID ofAlbum:albumID];
                BOOL isPhotoUploaded = NO;
                if (realmPhotoMainQueue && [[resp objectForKey:@"key"] isEqualToString:key]) {
                    isPhotoUploaded = YES;
                    DTSLog(@"photo upload ok : %@, %@", realmPhotoMainQueue.albumID, realmPhotoMainQueue.photoID);
                } else {
                    if (info.error.code == 614) {
                        isPhotoUploaded = YES;
                        DTSLog(@"photo already exist ... ");
                    } else {
                        [DTSDiskUtil saveImageToPhotosDir:result withPhotoID:photoID];
                    
                        DTSLog(@"photo upload fail : %@, %@", realmPhotoMainQueue.albumID, realmPhotoMainQueue.photoID);
                    }
                }
                
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm transactionWithBlock:^{
                    realmPhotoMainQueue.isPhotoUploaded = isPhotoUploaded;
                    if (realmPhotoMainQueue.isPhotoUploaded) {
                        realmPhotoMainQueue.photoURL = [NSString stringWithFormat:@"%@%@", DTS_QINIU_BASE_URL, photoID];
                    }
                }];
                
                [self tryToPublishTripAlbum:albumID];
             }];
        
    }];
    
    return YES;
}

// 旅行专辑是否能够publish
- (void)tryToPublishTripAlbum:(NSString *)albumID
{
    RealmAlbum *album = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    if (!album.isAlbumCoverPhotoUploaded) {
        return;
    }
    
    for (RealmPhoto *photo in album.photos) {
        if (!photo.isPhotoUploaded) {
            return;
        }
    }
    
    // 所有照片都上传了才可以publish
    [self publishTripAlbum:albumID];
}

- (void)publishTripAlbum:(NSString *)albumID
{
    RealmAlbum *album = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    NSMutableArray *picList = [NSMutableArray array];
    for (RealmPhoto *photo in album.photos) {
        NSDictionary *photoDict = @{
                                    @"name": @"",
                                    @"type": @1,
                                    @"path": [NSString stringWithFormat:@"%@%@", DTS_QINIU_BASE_URL, photo.photoID],
                                    @"description": photo.photoDesc,
                                    @"longitude": @(photo.longitude),
                                    @"latitude": @(photo.latitude),
                                    @"altitude": @(photo.altitude),
                                    };
        [picList addObject:photoDict];
    }
    
    NSDictionary *parameters = @{
                                 @"token": [DTSUserDefaults userToken],
                                 @"name": @"this is a album",
                                 @"description": @"Great Day",
                                 @"longitude": @(album.longitude),
                                 @"latitude": @(album.latitude),
                                 @"altitude": @(album.altitude),
                                 @"cover": [NSString stringWithFormat:@"%@%@", DTS_QINIU_BASE_URL, album.albumCoverPhotoID],
                                 @"picList": picList,
                                 };
    
    
    [DTSHTTPRequest album_save:parameters withCompletionBlock:^(id responseObject) {
        
        if (responseObject && [responseObject objectForKey:@"id"]) {
            DTSLog(@"trip album published and delete from realm: %@", albumID);
            // TODO: publish之后直接delete会导致tripAlbums界面有问题。在网络请求刷新个人专辑页之后删除。
            // [RealmAlbumManager deleteRealmAlbumOfAlbumID:albumID];
            
            RealmAlbum *album = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                album.isPublished = YES;
                album.createDate = [[responseObject objectForKey:@"createDate"] doubleValue];
            }];
            
            if (_delegate && [_delegate respondsToSelector:@selector(DTSNewTripAlbumUploaderAlbumPublished:)]) {
                [_delegate DTSNewTripAlbumUploaderAlbumPublished:albumID];
            }
        }
    } withErrorBlock:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSError class]]) {
            DTSLog(@"%@", [responseObject objectForKey:@"code"]);
            [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
        } else {
            
        }
    }];
}

#pragma mark - upload photo to qiniu

- (void)uploadPhotoToQiniu:(UIImage *)photo
                    forKey:(NSString *)key
       withCompletionBlock:(QiniuUploadPhotoCompletionBlock)completionBlock
{
    NSData *photoData = UIImageJPEGRepresentation(photo, 0.5f);
    
    [_uploadManager putData:photoData
                        key:key
                      token:self.qiniuToken // @"从服务端SDK获取"; 这里是客户端生成
                   complete:completionBlock
                     option:nil];
}

@end
