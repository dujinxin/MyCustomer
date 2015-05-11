//
//  YHPaySucceedViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-4-8.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  支付成功

#import "YHRootViewController.h"
#import "OrderEntity.h"

@interface YHPaySucceedViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) OrderPSModel model;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) OrderSubmitEntity *orderEntity;
@property (nonatomic, strong) NSString *order_list_id;
@end
