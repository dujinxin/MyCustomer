//
//  YHWalletDetailsViewController.h
//  YHCustomer
//
//  Created by wangliang on 14-12-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHCardBag.h"
#import "EGORefreshTableFooterOtherView.h"

@interface YHWalletDetailsViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableOtherDelegate>
{

    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic , strong)EGORefreshTableFooterOtherView * refreshFooterOtherView;
@property(nonatomic , strong)YHCardBag_Main * entityCard;
@property(nonatomic , assign)BOOL forWard;
@end
