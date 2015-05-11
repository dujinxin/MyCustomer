//
//  YHForgetPwdViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-12.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  忘记密码界面

#import "YHRootViewController.h"

@interface YHForgetPwdViewController : YHRootViewController<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *mobileField;
@property (nonatomic, strong) UITextField *verField;
@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;
@end
