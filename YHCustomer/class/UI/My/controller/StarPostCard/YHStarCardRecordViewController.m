//
//  YHStarCardRecordViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-4-29.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHStarCardRecordViewController.h"
#import "StarPostCardEntity.h"
@interface YHStarCardRecordViewController ()

@end

@implementation YHStarCardRecordViewController
@synthesize dataArray;
#pragma mark - 初始化
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        if (IOS_VERSION>=7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
        }
        dataArray = [[NSMutableArray alloc]init];
       
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"购卡记录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back));
    [self addTableView];
}
-(void)addTableView
{
    self._tableView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - NAVBAR_HEIGHT);
    
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self initRequest];

}
//首次请求
-(void)initRequest
{
    requestStyle = Load_InitStyle;
    countPage = 1;
    [self requestWithPage:countPage];

}
-(void)requestWithPage:(NSInteger)page
{
    //网络请求
//    [[NetTrans getInstance]API_YH_Star_Post_Card_List:self];
    [[NetTrans getInstance]API_YH_Star_Post_Card_Record_List:self page:page];

}
#pragma mark - 下拉刷新
-(void)reloadTableViewDataSource
{
    _moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    self.dataState = EGOOHasMore;
    [self requestWithPage:countPage];


}
- (void)loadMoreTableViewDataSource{
    NSLog(@"开始加载加载更多");
    _reloading = YES;
    countPage ++;
    self.dataState = EGOOHasMore;
    requestStyle = Load_MoreStyle;
    [self requestWithPage:countPage];
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return dataArray.count;
    return self.dataArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
//     BuyActiviteListEntity *entity = (BuyActiviteListEntity *)[dataArray objectAtIndex:indexPath.row];
    if (indexPath.row < dataArray.count)
    {
        StarPostCardRecordList *entity = (StarPostCardRecordList *)[self.dataArray objectAtIndex:indexPath.row];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.text = entity.ppc_goods_name;
        titleLable.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        titleLable.font = [UIFont systemFontOfSize:15.f];
        titleLable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLable];
        
        UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLable.bottom, SCREEN_WIDTH, 40)];
        timeLable.backgroundColor = [UIColor clearColor];
        timeLable.text = entity.create_time;
        timeLable.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
        timeLable.font = [UIFont systemFontOfSize:12.f];
        timeLable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:timeLable];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, timeLable.bottom - 1, SCREEN_WIDTH, 1.0f)];
        line.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0f];
        [cell.contentView addSubview:line];
        
        
    }
    
 
    return cell;

}
#pragma mark - 网络回调
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_YH_STAR_POST_CARD_RECORD_LIST)
    {
        NSMutableArray *array = (NSMutableArray *)netTransObj;
        if (requestStyle == Load_MoreStyle)
        {
            [self.dataArray addObjectsFromArray:array];
        }
        else
        {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
        
        }
        if (requestStyle == Load_MoreStyle)
        {
            //当总数为数组的总量的时候
            if (self.total == self.dataArray.count)
            {
                //已经加载完成了所有的数据
                self.dataState = EGOOOther;
            }
            else
            {
                //加载更多
                self.dataState = EGOOHasMore;
            
            }
            
        }
        else
        {
            
            if (self.dataArray.count < 10)
            {
                self.dataState = EGOOOther;
            }
            else
            {
                self.dataState = EGOOHasMore;
            
            }
        }
        
        self.total = self.dataArray.count;
        [self._tableView reloadData];
        [self finishLoadTableViewData];
        //当一页的数量小于10条的时候移除上拉
        if (self.total * 80 < SCREEN_HEIGHT - 64) {
            [self removeFooterView];
        }else{
            [self testFinishedLoadData];
        }
    }
   
    
    
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    
    
    [[iToast makeText:errMsg]show];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
