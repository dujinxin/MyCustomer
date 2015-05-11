//
//  YHModifyContactViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-21.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
@interface YHModifyContactViewController : YHRootViewController<UITextFieldDelegate,keyBoardTopBarDelegate>
{
    UIScrollView *myScrollView;
    UITextField *verCodeField;
    UILabel *titleLabel;
    UIButton *verCodeBtn;
    int  numTitle;
    NSTimer *time;
    BOOL isSucee;
    KeyBoardTopBar *keyBoard;
}
@property (nonatomic,strong)NSString * mobile;
@end
