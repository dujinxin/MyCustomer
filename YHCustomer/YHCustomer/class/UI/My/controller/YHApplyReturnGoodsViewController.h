//
//  YHApplyReturnGoodsViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-4-30.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  未提货状态，申请退货界面

#import "YHRootViewController.h"
#import "OrderEntity.h"
#import "MyPickerView.h"

typedef void(^SubmitSucessBlock)();

@interface YHApplyReturnGoodsViewController : YHRootViewController<UITextFieldDelegate> {
    UIScrollView *scrollView;
    UIView *bg2;//退货原因
    UIView *bg3;//退货账号
    
    NSString *payMethod;
    UIButton *btn;
    UIButton *submitBtn;
    UITextField *returnReason;
    
    MyOrderEntity *orderEntity;
    
    MyPickerView *pickView;
    NSMutableArray *reasonArray;
    
    UITextField *name;
    UITextField *accout;
    NSString *reason_code;
    NSString *reason_name;
    NSString *returns_name;
    NSString *returns_account;
}
@property (nonatomic,strong)NSString *model;
@property (nonatomic, strong)SubmitSucessBlock submitBlock;
-(void)setData:(MyOrderEntity *)entity;
@end
