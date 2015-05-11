//
//  YHNewForgetPwdViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  修改忘记密码界面

#import "YHRootViewController.h"

@interface YHNewForgetPwdViewController : YHRootViewController<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *_userName;
@property(nonatomic ,copy)THLoginSuccessBlock loginSuccessBlock;

@end
