//
//  YHReturnOrderDetailAlreadyViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-5-6.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "OrderEntity.h"

typedef void(^CancelReturnOrderBlock)();
typedef void(^SubmitDeliverySuccessBlock)();

@interface YHReturnOrderDetailAlreadyViewController : YHBaseTableViewController
@property (nonatomic, strong) ReturnOrderEntity *myReturnOrderEntity;
@property (nonatomic, strong)CancelReturnOrderBlock cancelBlock;
@property (nonatomic, strong)SubmitDeliverySuccessBlock deliveryBlock;
@end
