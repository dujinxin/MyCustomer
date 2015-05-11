//
//  YHMarketViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/12/5.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHAlertView.h"
#import "YHCardBag.h"


@interface YHMarketViewController : YHRootViewController<YHAlertViewDelegate , UIAlertViewDelegate>


@property(nonatomic , strong)YHCardBag * entityCard;
@property(nonatomic , assign)BOOL forWard;
@property(nonatomic , assign)BOOL isReflsh;


@end
