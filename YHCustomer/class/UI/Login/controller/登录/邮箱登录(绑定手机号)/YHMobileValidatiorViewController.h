//
//  YHMobileValidatiorViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-12.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
#import "YHAlertView.h"
//typedef void (^THLoginSuccessBlock)(UserAccount *account);
@interface YHMobileValidatiorViewController : YHRootViewController<UITextFieldDelegate,keyBoardTopBarDelegate,YHAlertViewDelegate>
{
    KeyBoardTopBar *keyBoard;

}
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *passWord;
@property (nonatomic, copy) THLoginSuccessBlock       loginSuccessBlock;

@end
