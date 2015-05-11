//
//  YHSearchOrderViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-1-18.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//   pda快速扫描－搜索

#import "YHRootViewController.h"

@interface YHSearchOrderViewController : YHRootViewController<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *padNumField;
@property(nonatomic , assign)SaoType saoType;

@end
