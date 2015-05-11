//
//  YHOrderDetailViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-22.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  订单详情

#import "YHRootViewController.h"
#import "OrderEntity.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface YHOrderDetailViewController : YHRootViewController<UIWebViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
{
    UIWebView *webView;
    NSString  *url;
    MFMessageComposeViewController *_msgVC;
    BOOL        orderCancelSuccess;
    
    NSString *donation_order_id;
}

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) MyOrderEntity *orderEntity;
@property (nonatomic, strong) NSString *orderList_no;
@property (nonatomic, assign) BOOL fromReturn;

@property (nonatomic, copy )  NSString * transaction_type;
// 订单详情
- (void)setOrderListId:(MyOrderEntity *)orderEntity1;
// 配送详情
- (void)setDeliveryEntity:(MyOrderEntity *)orderEntity2;

@end
