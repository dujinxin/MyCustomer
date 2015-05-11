//
//  YHQuickScanOrderViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-23.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  快速扫瞄－订单详情

#import "YHRootViewController.h"
#import "OrderEntity.h"
#import "UPPayPlugin.h"
#import "YHAlertView.h"
typedef void(^quickBlockCallback)(id obj);

@interface YHQuickScanOrderViewController : YHRootViewController<UIActionSheetDelegate,UPPayPluginDelegate,YHAlertViewDelegate> {
    UILabel *orderNum;
    UILabel *buName ;
    UILabel *address;
    UILabel *tel;
    UILabel *payDeltail;
    UILabel *priceDetail;
    UILabel *couponDetail;
    UILabel *couponInfo;
    NSDictionary *myCouponDic;
    
    NSString *couponName;
    
}

@property (nonatomic, strong) OrderSubmitEntity *submitOrder;
@property (nonatomic, strong) NSMutableArray *couponList;
@property (nonatomic, strong) NSDictionary *myCouponDic;
@property (nonatomic, copy) NSString * order_list_no;
@property (nonatomic, assign )BOOL isFromMyOrder;
@property (nonatomic, assign )BOOL isFromOrderDetail;
@property (nonatomic, copy) quickBlockCallback block;


@end
