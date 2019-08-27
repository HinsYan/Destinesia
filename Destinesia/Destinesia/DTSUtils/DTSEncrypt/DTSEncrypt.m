//
//  DTSEncrypt.m
//  Destinesia
//
//  Created by Chris Hu on 16/9/18.
//  Copyright © 2016年 com.icetime17. All rights reserved.
//

#import "DTSEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation DTSEncrypt

+ (NSString *)encryptViaMD5:(NSString *)stringToEncrypt {
	
	const char *cStr = [stringToEncrypt UTF8String];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
	
	NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[result appendFormat:@"%02X", digest[i]];
	}
	
	return [result lowercaseString];
}

@end
