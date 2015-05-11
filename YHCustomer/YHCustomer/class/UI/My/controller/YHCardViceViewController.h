//
//  YHCardViceViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/12/2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "EGORefreshTableFooterOtherView.h"
#import "YHCardBag.h"
typedef  void (^ChooseViceCard)(id someThing);
@interface YHCardViceViewController : YHRootViewController<EGORefreshTableOtherDelegate , UITableViewDataSource , UITableViewDelegate>
{
    UITableView * myTableView;
}

@property(nonatomic , strong)ChooseViceCard block;
@property(nonatomic , strong) NSString * lastStr;
@property(nonatomic , strong)NSArray * seleArr;
@property(nonatomic , strong)EGORefreshTableFooterOtherView * refreshFooterOtherView;

@property(nonatomic , assign)BOOL forWard;
@property(nonatomic ,strong)YHCardVice * entityCard;
@end
