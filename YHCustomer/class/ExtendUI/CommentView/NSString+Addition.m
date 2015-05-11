//
//  NSString+Addition.m
//  THCustomer
//
//  Created by lichentao on 13-8-19.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "NSString+Addition.h"
#pragma mark -
#pragma mark UTF8 、GB2312  URLEncoding
@implementation NSString (Addition)
- (NSString *)MD5 {
    if(self == nil || [self length] == 0)
        return nil;
    
	const char* str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x",result[i]];
	}
	return ret;
}
-(NSString *) UNMD5 {
    
    const char *cStr = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15] ]
            
            lowercaseString];
}



- (NSString *)URLEncodeString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString *)URLDecodeString
{
    NSString*result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (CFStringRef)self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}


- (NSString *)getJsonStrWithOutHttpBySeprateStr:(NSString *)sperateStr{
    NSRange range1= [self rangeOfString:sperateStr];
    NSString *string = [self substringFromIndex:range1.location + range1.length];
    NSString *resultStr = [string stringByReplacingOccurrencesOfString:sperateStr withString:@""];
    return resultStr;
}

- (NSString *)getGoodUrlWithParmer:(NSString *)sperateStr
{
    NSRange range2= [self rangeOfString:sperateStr];
    NSString *urStr = [self substringToIndex:range2.location];
    return urStr;
}

@end
