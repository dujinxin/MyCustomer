//
//  YHNewSetPwdViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  重置密码

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
@interface YHNewSetPwdViewController : YHRootViewController<UITextFieldDelegate,keyBoardTopBarDelegate>
{
    KeyBoardTopBar *keyBoard;
}
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *type;
@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;
@end
