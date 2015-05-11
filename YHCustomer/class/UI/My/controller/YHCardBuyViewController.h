//
//  YHCardBuyViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/12/3.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHCardBag.h"
#import "YHAlertView.h"
#import "UPPayPlugin.h"

@interface YHCardBuyViewController : YHRootViewController<UIActionSheetDelegate , YHAlertViewDelegate,UPPayPluginDelegate , UIAlertViewDelegate>


@property(nonatomic , strong)YHCardBag * entityCard;
@property(nonatomic , assign)BOOL forWard;
@end
