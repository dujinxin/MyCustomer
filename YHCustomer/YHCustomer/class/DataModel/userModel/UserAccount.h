//
//  UserAccount.h
//  THCustomer
//
//  Created by lichentao on 13-8-12.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject  <NSCoding>
@property (nonatomic, strong) NSString *user_icon;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *login_user_name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *true_name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *session_id;
@property (nonatomic, strong) NSString *region_id;
@property (nonatomic, strong) NSString *location_CityName;
@property (nonatomic, copy) NSString *login_type;     // 0:普通登陆 1:第三方 2:天虹登陆

@property (nonatomic, assign)BOOL  isSinaAuthorize;
@property (nonatomic, assign)BOOL  isTencentAuthorize;
+ (UserAccount *)instance;
- (void)restoreAccount:(NSDictionary *)accountInfo;
- (void)updateAccount:(NSDictionary *)accountInfo;
- (void)saveAccount;
- (void)logout;
- (BOOL)isLogin;
-(void)logoutPassive;
@end



@interface CityInfo : NSObject

+ (CityInfo *)instance ;
- (NSString *)getCityCode:(NSString *)locationCity;

@end