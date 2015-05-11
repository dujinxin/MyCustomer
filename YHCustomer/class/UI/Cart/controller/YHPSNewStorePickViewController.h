//
//  YHPSNewStorePickViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-10-10.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "BuListEntity.h"

typedef void(^PickStoreBlock)(NSString *bu_id,NSString *bu_name,NSString * bu_code,NSString *address);

@interface YHPSNewStorePickViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *popMenu;
}

@property (nonatomic, strong)BuListEntity   *listEntity;
@property (nonatomic, strong)NSMutableArray *popArray;
@property (nonatomic, strong)NSDictionary   *storeDic;
@property (nonatomic, strong)PickStoreBlock  psStoreBlock;

@property (nonatomic, copy) NSString * bu_code;
@property (nonatomic, copy) NSString * bu_name;
@property (nonatomic, copy) NSString * bu_id;
@property (nonatomic, copy) NSString * bu_address;


@end
