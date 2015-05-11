//
//  YHFadeBackListViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-2-15.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  意见反馈列表

#import "YHFadeBackListViewController.h"
#import "FeedBackListEntity.h"
#import "YHFeedbackViewController.h"

@interface YHFadeBackListViewController ()

@end

@implementation YHFadeBackListViewController
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self._tableView.backgroundColor = [UIColor whiteColor];
    [self addRefreshTableFooterView];
    
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    
//    [self setRightBarButton:self Action:@selector(rightBtnClicked:) SetImage:@"user_feed_Btn.png" SelectImg:@"user_feed_Btn_Select.png"];
    [self setRightBarButton:self Action:@selector(rightBtnClicked:) SetImage:@"right_feedback" SelectImg:@"right_feedback"];
    
    imgBg = [PublicMethod addImageView:CGRectMake(0, 100, 320, 320) setImage:@"user_feed_Bg.png"];
    imgBg.hidden = YES;
    [self.view addSubview:imgBg];
}

- (void)rightBtnClicked:(id)sender{
    YHFeedbackViewController *feed = [[YHFeedbackViewController alloc] init];
    [self.navigationController pushViewController:feed animated:YES];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    // 初始化加载
    requestStyle = Load_InitStyle;
    countPage = 1;
    [self requestDataWithPage:countPage];
}

- (void)requestDataWithPage:(NSInteger)page{
    [[NetTrans getInstance] API_user_feed_back_list:self Page:[NSString stringWithFormat:@"%ld",(long)page]];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 110.f;
    FeedBackListEntity *entity = [dataArray objectAtIndex:indexPath.row];
    CGFloat titleFloat = [PublicMethod getLabelHeight:entity.content setLabelWidth:240 setFont:[UIFont systemFontOfSize:14]];
    CGFloat flat = 0;
    if (entity.rep_content.length > 0){
        flat = [PublicMethod getLabelHeight:entity.rep_content setLabelWidth:290 setFont:[UIFont systemFontOfSize:16]];
        flat += (titleFloat + 26 +20);
        
    }else{
        flat = titleFloat + 20;
    }
    if (flat<100) {
        return 100;
    }
    return flat;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.contentView removeAllSubviews];
    FeedBackListEntity *entity = [dataArray objectAtIndex:indexPath.row];
    
    CGFloat titleFloat = [PublicMethod getLabelHeight:entity.content setLabelWidth:240 setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *title = [PublicMethod addLabel:CGRectMake(10, 10, 240,titleFloat ) setTitle:entity.content setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:title];
    
    UILabel *time = [PublicMethod addLabel:CGRectMake(240, 20, 70, 14) setTitle:entity.add_time setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:12]];
    time.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:time];
    
    if ( entity.rep_content.length > 0) {
//        UILabel *yonghuiStore = [PublicMethod addLabel:CGRectMake(10, 50, 100, 16) setTitle:@"永辉回复:" setBackColor:[UIColor orangeColor] setFont:[UIFont systemFontOfSize:16]];
//        [cell.contentView addSubview:yonghuiStore];
        
        CGFloat flot =  [PublicMethod getLabelHeight:entity.rep_content setLabelWidth:290 setFont:[UIFont systemFontOfSize:16]];
        
        UILabel *replyContent = [PublicMethod addLabel:CGRectMake(10, titleFloat+26, 290, flot+26) setTitle:[NSString stringWithFormat:@"永辉回复:  %@",entity.rep_content] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
        [cell.contentView addSubview:replyContent];
        
        UILabel *repTime = [PublicMethod addLabel:CGRectMake(240, 60+flot+titleFloat, 70, 14) setTitle:entity.rep_add_time setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        repTime.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:repTime];
    }
    return cell;
}

#pragma mark -------------------------------------------------------------------下拉刷新方法
- (void)reloadTableViewDataSource{
    NSLog(@"开始加载");
	_moreloading = YES;
    requestStyle = Load_RefrshStyle;
    self.dataState = EGOOHasMore;
    [self requestDataWithPage:1];
}

#pragma mark -
#pragma mark -------------------------------------------------------------------加载更多
- (void)loadMoreTableViewDataSource{
    NSLog(@"开始加载加载更多");
	_reloading = YES;
    requestStyle = Load_MoreStyle;
    [self requestDataWithPage:++countPage];

}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (t_API_USER_FADELIST_API == nTag)
    {
        NSMutableArray *array  = (NSMutableArray *)netTransObj;
        
        if (requestStyle != Load_MoreStyle) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:array];
        [self._tableView reloadData];
        
        if (self.dataArray.count == 0) {
            self._tableView.hidden = YES;
            imgBg.hidden = NO;
        }
        
        if (requestStyle == Load_MoreStyle) {
            if (self.total == dataArray.count) {
                self.dataState = EGOOOther;
            }else{
                self.dataState = EGOOHasMore;
            }
        }else{
            if (dataArray.count <10) {
                self.dataState = EGOOOther;
            }else{
                self.dataState = EGOOHasMore;
            }
        }
        self.total = dataArray.count;
        [self._tableView reloadData];
        [self testFinishedLoadData];
        [self finishLoadTableViewData];
    }

}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    if (nTag == t_API_USER_FADELIST_API)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
