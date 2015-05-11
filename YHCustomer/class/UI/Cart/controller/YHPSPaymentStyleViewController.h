//
//  YHPSPaymentStyleViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-3-26.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"

typedef  void (^ChoosePayMethod)(NSString * style,id object,  NSInteger number);

@interface YHPSPaymentStyleViewController : YHBaseTableViewController

@property (nonatomic, strong) ChoosePayMethod chooseBlock;
@property (nonatomic, strong) NSDictionary *paymentDic;
@property (nonatomic, copy) NSString *paystyle;
@property (nonatomic, copy) NSString * payMethod;
@property (nonatomic, assign)NSInteger couponNumber;
@property (nonatomic, assign)BOOL fromNewOrder;

@property (nonatomic, assign)BOOL fromConfirmOrder;
@property (nonatomic, copy) NSString * order_list_no;
@property (nonatomic, assign)PSModel model;
@property (nonatomic, copy) NSString * lm_id;

@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * total;
@end
