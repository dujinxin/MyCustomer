//
//  YHResetPwdViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  重设密码界面

#import "YHRootViewController.h"

@interface YHResetPwdViewController : YHRootViewController <UITextFieldDelegate>{
    UITextField *_passwordField;
    UIButton    *_commitBtn;
}
@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;
@end
