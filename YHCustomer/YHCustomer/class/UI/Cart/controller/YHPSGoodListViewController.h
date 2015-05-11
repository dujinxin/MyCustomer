//
//  YHPSGoodListViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-4-8.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"

@interface YHPSGoodListViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *goodsWight;
@property (nonatomic, strong) NSString *logistics_amount;
@property (nonatomic, copy)   NSString *goods_num;

@property (nonatomic, copy)   NSString * goods_id;
@property (nonatomic, copy)   NSString * total;
@end
