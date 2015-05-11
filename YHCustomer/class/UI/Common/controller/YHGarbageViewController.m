//
//  YHGarbageViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-5-8.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHGarbageViewController.h"

@interface YHGarbageViewController ()

@end


@implementation YHGarbageViewController
@synthesize _styple;
@synthesize _tableView;
@synthesize _loadMoreFooterView;
@synthesize refreshHeaderView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        //        页码
        countPage = 1;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _styple = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,ScreenSize.height-NAVBAR_HEIGHT) style:_styple];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.backgroundView = nil;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self._tableView = tableView;
    
    [self addRefreshTableHeaderView];
    [self addGetMoreFootView];
}

- (UIView *)tableViewHeaderView{
    return [PublicMethod addBackView:CGRectMake(0, 0, 320, 10) setBackColor:LIGHT_GRAY_COLOR];
}

/* 添加下拉view */
- (void)addRefreshTableHeaderView{
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
        view.delegate = self;
        [_tableView addSubview:view];
        self.refreshHeaderView = view;
        [refreshHeaderView refreshLastUpdatedDate];
    }
}

/*加载更多view*/
- (void)addGetMoreFootView{
    if (_loadMoreFooterView == nil) {
        WBLoadMoreTableFootView *view = [[WBLoadMoreTableFootView alloc] initWithFrame:CGRectMake(0.0f, self._tableView.contentSize.height, self._tableView.frame.size.width, self._tableView.bounds.size.height)];
        view.delegate = self;
        [self._tableView addSubview:view];
        self._loadMoreFooterView = view;
    }
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods---------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (refreshHeaderView) {
        [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (_loadMoreFooterView) {
        [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (refreshHeaderView) {
        [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (_loadMoreFooterView) {
        [_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
    }
    
}

#pragma mark -------------------------------------------------------------------下拉刷新方法
- (void)reloadTableViewDataSource{
    NSLog(@"开始加载");
    _moreloading = YES;
}
- (void)doneLoadingTableViewData{
    NSLog(@"上拉刷新加载结束");
    //  model should call this when its done loading
    _moreloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    //    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _moreloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)vie{
    return [NSDate date];
}

#pragma mark -
#pragma mark ------------------------------------------------加载更多
- (void)reloadMoreTableViewDataSource{
    NSLog(@"开始加载加载更多");
    _moreloading = YES;
}

- (void)doneLoadingMoreTableViewData{
    _moreloading = NO;
    [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self._tableView];
    NSLog(@"加载更多加载结束");
}

#pragma  -mark
#pragma mark  -----------------------------------------------LoadMoreTableFooterDelegate Methods
- (void)loadMoreTableFooterDidTriggerRefresh:(WBLoadMoreTableFootView *)view {
    [self reloadMoreTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingMoreTableViewData) withObject:nil afterDelay:0.5];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(WBLoadMoreTableFootView *)view {
    return _moreloading;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------  网络请求结束调用，结束动画
-(void)finishLoadTableViewData {
    if (requestStyle == Load_RefrshStyle) {
        [self doneLoadingTableViewData];
    } else if (requestStyle == Load_MoreStyle) {
        [self doneLoadingMoreTableViewData];
    }
}
@end