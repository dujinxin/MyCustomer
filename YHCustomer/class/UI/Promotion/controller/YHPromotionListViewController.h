//
//  YHPromotionListViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  首页dm跳转的促销商品列表页面

#import "YHBaseTableViewController.h"
#import "DmEntity.h"
#import "YHCartView.h"


@interface YHPromotionListViewController : YHBaseTableViewController <CartViewDelegate,YHAlertViewDelegate>{
    YHCartView *cartView;
    NSMutableArray *goodsData;
}
@property (nonatomic,retain) DmEntity *dmEntity;
@property (nonatomic, assign) BOOL fromMyCollect;
@end
