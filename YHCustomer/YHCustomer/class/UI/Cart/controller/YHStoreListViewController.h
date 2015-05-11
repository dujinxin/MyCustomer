//
//  YHStoreListViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  超市列表（门店列表）

#import "YHRootViewController.h"
#import "BuListEntity.h"
typedef void (^YHChooseStoreBlock)(BuListEntity *buEntity);

@interface YHStoreListViewController : YHBaseTableViewController

@property (nonatomic, strong) NSMutableArray *storeArray;
@property (nonatomic, strong) YHChooseStoreBlock storeBlock;
@property (nonatomic, strong) BuListEntity *store;
@property (nonatomic, strong) NSString      *buname;
@end
