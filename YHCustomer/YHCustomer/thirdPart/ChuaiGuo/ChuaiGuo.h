//
//  ChuaiGuo.h
//  ChuaiGuo
//
//  Created by chuaiguo on 13-8-12.
//  Copyright (c) 2013年 www.chuaiguo.com  All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHUAIGUO_TEST_VERSION @"1.01"

#undef CHLog

#if __cplusplus
extern "C" {
#endif
    void CHLog(NSString *format, ...) __attribute__((format(__NSString__, 1, 2)));
#if __cplusplus
}
#endif

@interface ChuaiGuo : NSObject

/* 应用程序启动需注册apptoken
 * 必须调用才能启用远程日志和远程崩溃报告
 */
+ (void)Begin:(NSString *) apptoken ;

/* 设置参数
 * 参数名称key见最后
 */
+ (void)SetOption:(NSDictionary *) dict ;

@end

/* 此处为参数名称key可选项
 * 值为布尔值，包装方式示例 [NSNumber numberWithBool:NO]
 */
FOUNDATION_EXPORT NSString *const CHOptionLogToConsole;    // 默认 @YES.
FOUNDATION_EXPORT NSString *const CHOptionLogToRemote;     // 默认 @YES.
