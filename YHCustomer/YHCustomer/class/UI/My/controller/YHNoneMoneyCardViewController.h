//
//  YHNoneMoneyCardViewController.h
//  YHCustomer
//
//  Created by wangliang on 14-12-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "EGORefreshTableFooterOtherView.h"

@interface YHNoneMoneyCardViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableOtherDelegate>
{

    UITableView *_tableView;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic , strong) EGORefreshTableFooterOtherView * refreshFooterOtherView;
@property(nonatomic , assign)BOOL forWard;
@end
