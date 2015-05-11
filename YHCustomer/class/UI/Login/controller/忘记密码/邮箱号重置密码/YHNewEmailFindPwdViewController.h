//
//  YHNewEmailFindPwdViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  通过邮箱 找回密码

#import "YHRootViewController.h"

@interface YHNewEmailFindPwdViewController : YHRootViewController
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *type;
@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;
@end
