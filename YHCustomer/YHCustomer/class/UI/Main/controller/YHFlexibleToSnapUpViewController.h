//
//  YHFlexibleToSnapUpViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-1-7.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  灵活抢购

#import "YHBaseTableViewController.h"
#import "EGORefreshTableFooterOtherView.h"
#import "FixedToSnapUpEntity.h"
#import "YHCartView.h"
typedef void(^CartBlock) ();
@interface YHFlexibleToSnapUpViewController : YHRootViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableOtherDelegate,UIAlertViewDelegate,CartViewDelegate>
{
    
    UITableView *_tableView;
    //添加购物车
    YHCartView *cartView;
    
}
@property(nonatomic , strong) EGORefreshTableFooterOtherView * refreshFooterOtherView;
@property (nonatomic, strong) CartBlock cartBlock;

@property(nonatomic,strong)NSMutableArray *goodListArray;
@property(nonatomic,strong)NSMutableArray *infoArray;
@property(nonatomic,strong)NSString* activity_id;
@property(nonatomic,strong)FixedToSnapUpEntity *fixedToSnapUpEntity;
@property(nonatomic , assign)BOOL Forward;
@end
