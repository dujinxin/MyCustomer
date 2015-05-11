//
//  NSString+Addition.h
//  THCustomer
//
//  Created by lichentao on 13-8-19.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#include <ctype.h>

@interface NSString (Addition)
// md5编码
-(NSString *)UNMD5;
// md5
- (NSString *)MD5;
// URL编码
- (NSString *)URLEncodeString;
// URL 解码
- (NSString *)URLDecodeString;
// 截取相同字符串之间内容
- (NSString *)getJsonStrWithOutHttpBySeprateStr:(NSString *)sperateStr;
// 获取字符串中的url去除 param部分
- (NSString *)getGoodUrlWithParmer:(NSString *)sperateStr;
@end
