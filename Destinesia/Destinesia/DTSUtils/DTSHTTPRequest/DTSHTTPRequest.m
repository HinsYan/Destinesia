//
//  DTSHTTPRequest.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/21.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSHTTPRequest.h"


static NSString *const kDTSRestAPI_basicUrl         = @"http://www.bing.com";

static NSString *const kDTSRestAPI_album_delete     = @"/album/delete/";
static NSString *const kDTSRestAPI_album_view       = @"/album/view/";
static NSString *const kDTSRestAPI_album_save       = @"/album/save/";

static NSString *const kDTSRestAPI_album_listbyloc  = @"/album/listbyloc/";
static NSString *const kDTSRestAPI_album_list       = @"/album/list/";
static NSString *const kDTSRestAPI_album_detail     = @"/album/detail/";
static NSString *const kDTSRestAPI_album_piclist    = @"/album/piclist/";

static NSString *const kDTSRestAPI_photo_unvote     = @"/picture/unvote/";
static NSString *const kDTSRestAPI_photo_vote       = @"/picture/vote/";

static NSString *const kDTSRestAPI_user_register    = @"/user/regist/";
static NSString *const kDTSRestAPI_user_login       = @"/user/login/";
static NSString *const kDTSRestAPI_user_reset       = @"/user/reset/";
static NSString *const kDTSRestAPI_user_recommend   = @"/user/recommend/";


@implementation DTSHTTPRequest

#pragma mark - Album

+ (void)album_delete:(NSDictionary *)parameters
 withCompletionBlock:(CompletionBlock)completionBlock
      withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_album_delete
                withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)album_view:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
    withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_album_view
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)album_save:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST_JSON_Content:kDTSRestAPI_album_save
                              withParameters:parameters
                         withCompletionBlock:completionBlock
                              withErrorBlock:errorBlock];
}

+ (void)album_listbyloc:(NSDictionary *)parameters
    withCompletionBlock:(CompletionBlock)completionBlock
         withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_album_listbyloc
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];

}

+ (void)album_list:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_album_list
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)album_detail:(NSDictionary *)parameters
 withCompletionBlock:(CompletionBlock)completionBlock
      withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_album_detail
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)album_photo:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
     withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager GET:kDTSRestAPI_album_piclist
                withParameters:parameters
           withCompletionBlock:completionBlock
                withErrorBlock:errorBlock];
}

#pragma mark - Picture

+ (void)photo_vote:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_photo_vote
                withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)photo_unvote:(NSDictionary *)parameters
 withCompletionBlock:(CompletionBlock)completionBlock
      withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_photo_unvote
                withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

#pragma mark - User

+ (void)user_register:(NSDictionary *)parameters
  withCompletionBlock:(CompletionBlock)completionBlock
       withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_user_register
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)user_login:(NSDictionary *)parameters
withCompletionBlock:(CompletionBlock)completionBlock
withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_user_login
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)user_resetPasswd:(NSDictionary *)parameters
     withCompletionBlock:(CompletionBlock)completionBlock
          withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_user_reset
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

+ (void)user_recommend:(NSDictionary *)parameters
   withCompletionBlock:(CompletionBlock)completionBlock
        withErrorBlock:(ErrorBlock)errorBlock
{
    [DTSHTTPRequestManager POST:kDTSRestAPI_user_recommend
                 withParameters:parameters
            withCompletionBlock:completionBlock
                 withErrorBlock:errorBlock];
}

@end
