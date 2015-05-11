//
//  YHReturnOrderDetailViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-5-8.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "OrderEntity.h"
#import "YHReturnOrderDetailAlreadyViewController.h"

@interface YHReturnOrderDetailViewController : YHBaseTableViewController

@property (nonatomic, strong) ReturnOrderEntity *myReturnOrderEntity;
@property (nonatomic, strong)CancelReturnOrderBlock cancelBlock;
@end


