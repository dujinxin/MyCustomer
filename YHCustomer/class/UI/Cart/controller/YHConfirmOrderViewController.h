//
//  YHConfirmOrderViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-14.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  确认订单页面

#import "YHRootViewController.h"
#import "OrderEntity.h"
#import "UPPayPlugin.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "YHAlertView.h"
typedef void(^confirmBlockCallback)(id obj);

@interface YHConfirmOrderViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate,UPPayPluginDelegate,UIActionSheetDelegate , YHAlertViewDelegate>{
    UILabel *deliverTime;
}

@property (nonatomic, assign) OrderPSModel model;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) OrderSubmitEntity *orderEntity;
@property (nonatomic, strong) NSString *coupon_id;
@property (nonatomic, copy) NSString * total_amount;

@property (nonatomic, assign)BOOL isFromMyOrder;
@property (nonatomic, assign)BOOL isFromOrderDetail;
@property (nonatomic, copy) NSString * order_list_id;
@property (nonatomic, copy) NSString * order_list_no;
@property (nonatomic, copy) NSString * order_type;
@property (nonatomic, copy) confirmBlockCallback block;

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * total;
@property (nonatomic, copy) NSString * transaction_type;

@end
