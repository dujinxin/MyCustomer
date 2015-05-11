//
//  YHChangePassViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/11/18.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"
#import "YHCardBag.h"

@interface YHChangePassViewController : YHRootViewController<UITextFieldDelegate , keyBoardTopBarDelegate>
{
    KeyBoardTopBar *keyBoard;
}

@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)YHCardBag * entityCard;
@end
