//
//  OneOrderInfoView.h
//  THCustomer
//
//  Created by 任 清阳 on 13-9-12.
//  Copyright (c) 2013年 efuture. All rights reserved.
//  提交订单中得单个商品view

#import <UIKit/UIKit.h>
#import "GoodsEntity.h"

@interface OneOrderInfoView : UIView
{
    UIButton *allSelectBtn;
    BOOL     isSelect;
}
@property (nonatomic, strong)GoodsEntity     *myEntity;
@property (nonatomic, assign)id             controller;

- (void)setOrderInfoGoodEntity:(GoodsEntity *)entity :(id)controller1 SetOrderType:(int)type;
- (void)setOrderCartInfoGoodEntity:(GoodsEntity *)entity;

// 设置退货商品
- (void)setReturnInfoGoodEntity:(GoodsEntity *)entity;

@end
