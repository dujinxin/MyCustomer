//
//  YHCartLoginViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-18.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHCartViewController.h"

@interface YHCartLoginViewController : YHRootViewController

@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;
@property (nonatomic, strong) YHCartBlockCallBack callBack;
@end
