//
//  YHFixedToSnapUpViewController.h
//  YHCustomer
//
//  Created by wangliang on 15-1-7.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  固定抢购

#import "YHRootViewController.h"
#import "TORSegmentControl.h"
#import "EGORefreshTableFooterOtherView.h"
#import "YHCartView.h"
typedef void(^CartBlock) ();

@interface YHFixedToSnapUpViewController : YHRootViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableOtherDelegate,UIAlertViewDelegate,CartViewDelegate>
{

    UITableView *_tableView;
    NSMutableArray *infoArray;
    TORSegmentControl *segMent;
    //添加购物车
    YHCartView *cartView;
    
}

@property(nonatomic , strong) EGORefreshTableFooterOtherView * refreshFooterOtherView;
@property (nonatomic, strong) CartBlock cartBlock;
@property(nonatomic,strong)NSMutableArray *goodListArray;
@property(nonatomic , assign)BOOL Forward;

@end
