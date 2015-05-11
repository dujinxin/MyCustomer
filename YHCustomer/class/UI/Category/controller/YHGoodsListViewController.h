//
//  YHGoodsListViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-13.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  商品列表-native

#import "YHRootViewController.h"
#import "GoodsEntity.h"
#import "CateBrandEntity.h"

@interface YHGoodsListViewController : YHBaseTableViewController

@property (nonatomic, strong) GoodsListEntity *goodsListEntity;
@property (nonatomic, strong) NSMutableArray *goodsList;
@property (nonatomic, strong) CateBrandEntity *cateGory;
@end
