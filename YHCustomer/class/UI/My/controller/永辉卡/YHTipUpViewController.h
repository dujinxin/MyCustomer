//
//  YHTipUpViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/11/18.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "UPPayPlugin.h"
#import "YHCardBag.h"
@interface YHTipUpViewController : YHRootViewController<UPPayPluginDelegate , UIAlertViewDelegate , UITextFieldDelegate , YHAlertViewDelegate , UIActionSheetDelegate>


@property(nonatomic , strong)NSString * card_no;
@property(nonatomic , strong)NSString * tap;
@property(nonatomic , strong)YHCardBag * entityBag;
@property(nonatomic , assign)BOOL forWard;

@end
