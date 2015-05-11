//
//  YHOldResViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-3-26.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
@interface YHOldResViewController : YHRootViewController<UITextFieldDelegate,keyBoardTopBarDelegate>{
    
    //注册新增积分卡
    UITextField  *_integralCardField;
    
    UITextField  *_mobileField;
    UITextField  *_idField;
    UITextField  *_passWordField;
    UITextField  *_recommenNumField;
    UITextField  *_verCodeField;
    UIButton     *instructionBtn;
    UIButton     *verCodeBtn;
    UIButton     *registerBtn;
    UIScrollView       *infoView;
    
    KeyBoardTopBar *keyBoard;
}
@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;

@end
