//
//  THBaseTableViewController.m
//  THCustomer
//
//  Created by lichentao on 13-8-15.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "YHBaseTableViewController.h"

@interface YHBaseTableViewController ()

@end


@implementation YHBaseTableViewController
@synthesize _styple;
@synthesize _tableView;
@synthesize _loadMoreFooterView;
@synthesize refreshHeaderView;
@synthesize refreshFooterView;
@synthesize isHasMore = _isHasMore;
@synthesize total = _total;
@synthesize dataState = _dataState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        countPage = 1;
        _isHasMore = YES;
        _total = 0;
        _dataState = EGOONone;
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
//    [self addRefreshTableFooterView];
//    [self addGetMoreFootView];
//    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
}

- (UIView *)tableViewHeaderView{
    return [PublicMethod addBackView:CGRectMake(0, 0, 320, 10) setBackColor:LIGHT_GRAY_COLOR];
}

/* 添加下拉view */
- (void)addRefreshTableHeaderView
{
    if (refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
        view.delegate = self;
        [_tableView addSubview:view];
        self.refreshHeaderView = view;
        [refreshHeaderView refreshLastUpdatedDate];
    }
}
- (void)addRefreshTableFooterView
{
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
}
/*加载更多view*/
//- (void)addGetMoreFootView{
//    if (_loadMoreFooterView == nil) {
//		WBLoadMoreTableFootView *view = [[WBLoadMoreTableFootView alloc] initWithFrame:CGRectMake(0.0f, self._tableView.frame.size.height, self._tableView.frame.size.width, self._tableView.bounds.size.height)];
//		view.delegate = self;
//		[self._tableView addSubview:view];
//		self._loadMoreFooterView = view;
//	}
//}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - 
#pragma mark UIScrollViewDelegate Methods---------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (refreshHeaderView)
    {
        [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (refreshFooterView)
    {
        [refreshFooterView egoLoadMoreScrollViewDidScroll:scrollView];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
//    {
//        [[iToast makeText:@"没有网络连接"] show];
//        refreshFooterView.loadingState = EGOOLoadFail;
//    }
//    else{
        if (refreshHeaderView)
        {
            [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        if (refreshFooterView)
        {
            [refreshFooterView egoLoadMoreScrollViewDidEndDragging:scrollView];
        }
//    }

}

#pragma mark -------------------------------------------------------------------下拉刷新方法
- (void)reloadTableViewDataSource{
    NSLog(@"开始刷新");
	_moreloading = YES;
}
- (void)doneLoadingTableViewData{
	NSLog(@"下拉刷新加载结束");
	//  model should call this when its done loading
	_moreloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _moreloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)vie{
    return [NSDate date];
}

#pragma mark -
#pragma mark ------------------------------------------------加载更多
//- (void)reloadMoreTableViewDataSource{
//    NSLog(@"开始加载加载更多");
//	_moreloading = YES;
//}

//- (void)doneLoadingMoreTableViewData{
//    
//    _moreloading = NO;
//
//    [_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self._tableView];
//    NSLog(@"加载更多加载结束");
//
//}

#pragma  -mark
#pragma mark  -----------------------------------------------LoadMoreTableFooterDelegate Methods
//- (void)loadMoreTableFooterDidTriggerRefresh:(WBLoadMoreTableFootView *)view {
//	[self reloadMoreTableViewDataSource];
////	[self performSelector:@selector(doneLoadingMoreTableViewData) withObject:nil afterDelay:2];
//}
//
//- (BOOL)loadMoreTableFooterDataSourceIsLoading:(WBLoadMoreTableFootView *)view {
//	return _moreloading;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------  网络请求结束调用，结束动画
-(void)finishLoadTableViewData
{
    if (requestStyle == Load_RefrshStyle)
    {
        [self doneLoadingTableViewData];
//        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
    }
//    else if (requestStyle == Load_MoreStyle)
//    {
//        [self testFinishedLoadData];
//        
//    }
}
-(void)testFinishedLoadData
{
    [self finishReloadingData];
//    [self performSelector:@selector(setFooterView) withObject:nil afterDelay:.3];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
//    if (refreshHeaderView) {
//        [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
//    }
    
    if (refreshFooterView) {
        [refreshFooterView egoLoadMoreScrollViewDataSourceDidFinishedLoading:_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    if (refreshFooterView && [refreshFooterView superview])
    {
        // reset position
        refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              _tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         _tableView.frame.size.width, self.view.bounds.size.height)];
        refreshFooterView.delegate = self;
        [_tableView addSubview:refreshFooterView];
    }
    
    if (refreshFooterView)
    {
        [refreshFooterView refreshLastUpdatedDate];
    }
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
    {
//        [[iToast makeText:@"没有网络连接"] show];
        refreshFooterView.loadingState = EGOOLoadFail;
    }
    switch (_dataState) {
        case EGOOHasMore:
            refreshFooterView.loadingState = EGOOHasMore;
            break;
        case EGOOLoadFail:
            refreshFooterView.loadingState = EGOOLoadFail;
            break;
        case EGOONone:
            refreshFooterView.loadingState = EGOONone;
            break;
        case EGOOOther:
            refreshFooterView.loadingState = EGOOOther;
            break;
        default:
            break;
    }
}


-(void)removeFooterView
{
    if (refreshFooterView && [refreshFooterView superview])
    {
        [refreshFooterView removeFromSuperview];
    }
    refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
//- (void)refreshTableViewDataSource
//{
//    NSLog(@"开始刷新");
//    _reloading = YES;
//}
- (void)loadMoreTableViewDataSource{
    NSLog(@"开始加载");
    _reloading = YES;
}

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
//    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
//        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:1.5];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
    NSLog(@"刷新完成");
    [self testFinishedLoadData];
    
}
//加载调用的方法
-(void)getNextPageView
{
//    [_tableView reloadData];
    [self removeFooterView];
    [self testFinishedLoadData];
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoLoadMoreTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    
    if (aRefreshPos == EGORefreshFooter) {
        [self performSelector:@selector(loadMoreTableViewDataSource) withObject:nil afterDelay:0];
//        [self loadMoreTableViewDataSource];
    }
    [self beginToReloadData:aRefreshPos];
    
}

- (BOOL)egoLoadMoreTableDataSourceIsLoading:(UIView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

@end
