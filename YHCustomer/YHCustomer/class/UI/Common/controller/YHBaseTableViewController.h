//
//  THBaseTableViewController.h
//  THCustomer
//
//  Created by lichentao on 13-8-15.
//  Copyright (c) 2013年 efuture. All rights reserved.
//  下拉刷新和加载更多tableview

#import "YHRootViewController.h"
#import "WBLoadMoreTableFootView.h"

@interface YHBaseTableViewController : YHRootViewController<EGORefreshTableHeaderDelegate,
//WBLoadMoreTableFooterDelegate,
EGOLoadMoreTableDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL                        _hasMore;              // 是否还有更多数据
    BOOL                        _moreloading;          // 下拉刷新||加载更多 bool控制
    WallLoadStyle               requestStyle;          // 请求类型(首次,下拉刷新，加载更多)
    NSInteger                    countPage;             // 页码
    BOOL                        _reloading;
    BOOL                        isHasMore;
    EGOLoadingState             dataState;
    
}
@property (nonatomic, assign) UITableViewStyle                _styple;
@property (nonatomic, strong) UITableView                    *_tableView;
@property (nonatomic, strong) EGORefreshTableHeaderView      *refreshHeaderView;
@property (nonatomic, strong) WBLoadMoreTableFootView        *_loadMoreFooterView;
@property (nonatomic, strong) EGORefreshTableFooterView      *refreshFooterView;
@property (nonatomic, assign) BOOL isHasMore;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) EGOLoadingState dataState;

- (id)initWithStyle:(UITableViewStyle)style;
- (void)addRefreshTableHeaderView;
- (void)addRefreshTableFooterView;

/*加载更多*/
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
/*加载完成*/
-(void)testFinishedLoadData;
-(void)finishLoadTableViewData;
/*headerView*/
- (UIView *)tableViewHeaderView;
- (void)removeFooterView;

@end
