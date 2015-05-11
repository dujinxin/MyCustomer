//
//  YHOrderViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-14.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  提交订单

#import "YHRootViewController.h"
#import "OrderEntity.h"
#import "BuListEntity.h"

@interface YHOrderViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate> {
    UITableView *tableview;
    PSModel model;
    UIPickerView *pick;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIButton *invoiceBtn;
    UITextField *invoiceField;
    UITextField *markField;
    UIButton *yesBtn;
    UIButton *noBtn;
    
    NSString *_bu_id;
    NSString *_bu_name;
    NSString *_bu_address;
    NSString *_time;
    NSString *_time_id;
    NSString *_coupon_id;
    NSString *_coupon_name;
    NSString *_remark;
    NSString *_pay_method;
    NSString *_pay_name;
    
    NSString *_lm_id;
    NSString *_lm_name;
    NSString *_lm_time_id;
    NSString *_lm_time_name;
    NSString *_is_tel;
    NSString *_receipt_type;
    NSString *_receipt_title;
    NSString *_order_address_id;
    NSString *_name;
    NSString *_tel;
    NSString *_logistics_area_name;
    NSString *_logistics_address;
    
    
    UILabel *priceInfo;
    
    BOOL needInvoice;
    BOOL invoiceIsCompany;
    NSString *invoiceText;
    NSString *remarkText;
    
    
    NSMutableArray *DeliveryStyleArray;
    
    NSMutableArray *ymdArray;
    NSString *defaultPickTime;
    
    NSString *today;
    NSString *tomorrow;
    NSString *dateString;
}
@property (nonatomic, strong) GoodList          *goodsEntity;
@property (nonatomic, strong) OrderSubmitEntity *entity;
@property (nonatomic, strong) UILabel           *totalLabel;
@property (nonatomic, strong) NSDictionary      *myCouponDic;
@property (nonatomic, strong) NSMutableArray    *arrAddress;

@end
