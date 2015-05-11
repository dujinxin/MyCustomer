//
//  YHModifyPhoneContactViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-21.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
@interface YHModifyPhoneContactViewController : YHRootViewController<UITextFieldDelegate,keyBoardTopBarDelegate>
{
    KeyBoardTopBar *keyBoard;

}

@end
