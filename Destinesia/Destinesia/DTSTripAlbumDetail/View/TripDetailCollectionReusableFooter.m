//
//  TripDetailCollectionReusableFooter.m
//  Destinesia
//
//  Created by Chris Hu on 16/10/4.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "TripDetailCollectionReusableFooter.h"
#import "UIApplication+DTSCategory.h"
#import "RealmAccountManager.h"
#import "RealmAlbumManager.h"
#import <CoreText/CoreText.h>

@implementation TripDetailCollectionReusableFooter
{
    RealmAlbum *_realmAlbum;
    RealmPhoto *_realmPhoto;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)actionBack:(UIButton *)sender {
    UINavigationController *currentNav = (UINavigationController *)[[UIApplication sharedApplication] dts_currentViewController];
    [currentNav popViewControllerAnimated:YES];
}

- (void)setPhotoID:(NSString *)photoID ofAlbum:(NSString *)albumID
{
    _realmAlbum = [RealmAlbumManager realmAlbumOfAlbumID:albumID];
    _realmPhoto = [RealmAlbumManager realmPhotoOfID:photoID ofAlbum:albumID];
    
    [self updateDetail];
}

- (void)setPhotoDesc:(NSString *)string
     withLineSpacing:(CGFloat)lineSpaceing
     withFontSpacing:(CGFloat)fontSpacing
{
    _lbPhotoDetail.attributedText = [self attributedString:string
                                           withLineSpacing:lineSpaceing
                                           withFontSpacing:fontSpacing];
}

- (void)setDistrict:(NSString *)string withLineSpacing:(CGFloat)lineSpaceing withFontSpacing:(CGFloat)fontSpacing
{
    _lbStreet.attributedText = [self attributedString:string
                                      withLineSpacing:lineSpaceing
                                      withFontSpacing:fontSpacing];
}

- (NSAttributedString *)attributedString:(NSString *)string
                         withLineSpacing:(CGFloat)lineSpaceing
                         withFontSpacing:(CGFloat)fontSpacing
{
    NSUInteger length = string.length;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
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

- (void)updateDetail
{
//    _lbAuthor.text = _realmAlbum.author;
//    _lbCity.text = _realmPhoto.city;
    
    _lbLikeCount.text = [NSString stringWithFormat:@"%ld", (long)_realmPhoto.likeCount];
    
    _isLiked = _realmPhoto.isLiked;
    
    if ([_realmAlbum.author isEqualToString:[RealmAccountManager currentLoginAccount].username]) {
        _btnVote.enabled = NO;
    } else {
        _btnVote.enabled = YES;
    }
    
    _lbPhotoDetail.attributedText = [self attributedString:@"虽然在这趟全国骑行之旅中，我并不太关注速度问题，但还是希望能尽可能没有负担。这样在抵达阿巴拉契亚山脉后，我的双腿才不会太过劳累。下面是我的打包清单。" withLineSpacing:15.f withFontSpacing:1.f];

    _lbStreet.attributedText = [self attributedString:@"ROOM 29, NO. 108, WALLSTREE" withLineSpacing:0.f withFontSpacing:1.f];
    
    _lbDistrict.attributedText = [self attributedString:@"CAMBRIDGE" withLineSpacing:0.f withFontSpacing:1.f];
    
    _lbCity.attributedText = [self attributedString:@"LONDON" withLineSpacing:0.f withFontSpacing:1.f];
}

- (IBAction)actionVote:(UIButton *)sender {
    _isLiked = !_isLiked;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if (_isLiked) {
        [realm transactionWithBlock:^{
            _realmPhoto.likeCount += 1;
            _realmPhoto.isLiked = _isLiked;
        }];
        
        _lbLikeCount.text = [NSString stringWithFormat:@"%ld", (long)_realmPhoto.likeCount];
        
        
        NSDictionary *parameters = @{
                                     @"token": [DTSUserDefaults userToken],
                                     @"albumId": _realmPhoto.albumID,
                                     @"pictureId": _realmPhoto.photoID,
                                     };
        [DTSHTTPRequest photo_vote:parameters withCompletionBlock:^(id responseObject) {
            [DTSToastUtil toastWithText:@"已经点赞"];
        } withErrorBlock:^(id responseObject) {
            if (![responseObject isKindOfClass:[NSError class]]) {
                DTSLog(@"%@", [responseObject objectForKey:@"code"]);
                [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
            } else {
                
            }
        }];
        
    } else {
        [realm transactionWithBlock:^{
            _realmPhoto.likeCount -= 1;
            _realmPhoto.isLiked = _isLiked;
        }];
        
        _lbLikeCount.text = [NSString stringWithFormat:@"%ld", (long)_realmPhoto.likeCount];
        
        NSDictionary *parameters = @{
                                     @"token": [DTSUserDefaults userToken],
                                     @"albumId": _realmAlbum.albumID,
                                     @"pictureId": _realmPhoto.photoID,
                                     };
        [DTSHTTPRequest photo_unvote:parameters withCompletionBlock:^(id responseObject) {
            [DTSToastUtil toastWithText:@"取消点赞"];
        } withErrorBlock:^(id responseObject) {
            if (![responseObject isKindOfClass:[NSError class]]) {
                DTSLog(@"%@", [responseObject objectForKey:@"code"]);
                [DTSToastUtil toastWithText:[responseObject objectForKey:@"message"]];
            } else {
                
            }
        }];
        
    }
}

@end
