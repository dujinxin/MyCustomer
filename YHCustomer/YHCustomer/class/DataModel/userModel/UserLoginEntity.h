//
//  UserLoginEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginEntity : NSObject

@property (nonatomic, copy) NSString *_user_id;
@property (nonatomic, copy)  NSString *_login_user_name;
@property (nonatomic, copy) NSString *_mobile;
@property (nonatomic, copy) NSString *_email;
@property (nonatomic, copy) NSString *_user_name;
@property (nonatomic, copy) NSString *_true_name;
@property (nonatomic, copy) NSString *_gender;
@property (nonatomic, copy) NSString *_intro;
@property (nonatomic, copy) NSString *_session_id;
@property (nonatomic, copy) NSString *login_status;     // 0:普通登陆 1:第三方 2:天虹登陆
@end
//第三方登录
@interface UserThirdLoginEntity : NSObject


@end

@interface UserTrans : NetTransObj

@end
