//
//  YHLoginViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-12.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  登录

#import "YHRootViewController.h"
typedef void (^THLoginViewBackBlock)();// 没有登录，直接关闭返回
typedef void (^THLoginSuccessBlock)(UserAccount *account);

@interface YHLoginViewController : YHRootViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField               *nameField;
@property (nonatomic, strong) UITextField               *pwdField;
@property (nonatomic, strong) NSString                  *_UserName;
@property (nonatomic, strong) NSString                  *_PassWord;
@property (nonatomic, strong) UITableView               *loginTableView;
@property (nonatomic, copy) THLoginSuccessBlock         loginSuccessBlock;
@property (nonatomic, copy) THLoginViewBackBlock        loginBackBlock;

@property (nonatomic , assign) LogOutType  logOutType;
@end
