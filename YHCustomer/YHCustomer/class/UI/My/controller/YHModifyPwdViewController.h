//
//  YHModifyPwdViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-17.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHModifyPwdViewController : YHRootViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIButton   *_resetBtn;
}

@property(retain,nonatomic)NSString *_oldPassword;
@property(retain,nonatomic)NSString *_nowPassword;
@property(retain,nonatomic)NSString *_comfirmPassWord;

@end
