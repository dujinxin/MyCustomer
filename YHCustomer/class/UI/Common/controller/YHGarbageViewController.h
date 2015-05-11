//
//  YHGarbageViewController.h
//  YHCustomer
//
//  Created by dujinxin on 15-5-8.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "WBLoadMoreTableFootView.h"


@interface YHGarbageViewController : YHRootViewController<EGORefreshTableHeaderDelegate,WBLoadMoreTableFooterDelegate,UITableViewDelegate,UITableViewDataSource>
{            
    BOOL                        _moreloading;          // 下拉刷新||加载更多 bool控制
    WallLoadStyle               requestStyle;          // 请求类型(首次,下拉刷新，加载更多)
    int                         countPage;             // 页码
}
@property (nonatomic, assign) UITableViewStyle               _styple;
@property (nonatomic, strong) UITableView                    *_tableView;
@property (nonatomic, strong) EGORefreshTableHeaderView      *refreshHeaderView;
@property (nonatomic, strong) WBLoadMoreTableFootView        *_loadMoreFooterView;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)addRefreshTableHeaderView;
/*加载更多*/
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


-(void)finishLoadTableViewData;
/*headerView*/
- (UIView *)tableViewHeaderView;
@end
