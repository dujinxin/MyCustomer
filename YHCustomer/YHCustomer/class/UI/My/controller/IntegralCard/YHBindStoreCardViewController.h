//
//  YHBindStoreCardViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  绑定门店积分卡

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
//typedef  void (^RefleshBackBlock)(BOOL reflesh);
@interface YHBindStoreCardViewController : YHRootViewController<UITextFieldDelegate,keyBoardTopBarDelegate>
{
    KeyBoardTopBar *keyBoard;
}
//@property(nonatomic,copy)RefleshBackBlock refleshBolck;
@end
