//
//  YHDMGoodsWallViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  促销－关联商品－cell（2个商品）

#import "YHBaseTableViewController.h"
#import "DmEntity.h"
#import "YHCartView.h"

@interface YHDMGoodsWallViewController : YHBaseTableViewController<CartViewDelegate>

@property (nonatomic, strong) DmEntity *dm_Entity;
@property (nonatomic, assign) BOOL fromMyCollect;
@end
