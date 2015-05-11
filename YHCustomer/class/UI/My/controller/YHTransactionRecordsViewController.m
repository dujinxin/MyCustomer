//
//  YHTransactionRecordsViewController.m
//  YHCustomer
//
//  Created by wangliang on 14-12-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHTransactionRecordsViewController.h"
#import "YHCardBag.h"


@interface YHTransactionRecordsViewController ()
{

    UIView *headView;
    int pages;
    NSMutableArray * dataArray;
    NSMutableArray * arr_Add;
    BOOL _reloadingOther;
}
@end

@implementation YHTransactionRecordsViewController
@synthesize refreshFooterOtherView;
@synthesize forWard;

- (void)viewDidLoad {
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    pages = 1;
    dataArray = [NSMutableArray array];
    arr_Add = [NSMutableArray array];
    [super viewDidLoad];
    self.navigationItem.title = @"转赠信息";
    [self addBackNav];
  
}
-(void)createUI
{
    NSString * str = [NSString stringWithFormat:@"转赠信息（共0张）"];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(4, [str length]-4);
    NSRange range2 = NSMakeRange(0, 4);
    UIFont *font1 = [UIFont systemFontOfSize:12];
    UIFont *font2 = [UIFont boldSystemFontOfSize:20];
    [str_s addAttribute:NSFontAttributeName value:font1 range:range1];
    [str_s addAttribute:NSFontAttributeName value:font2 range:range2];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    
    lab.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
    lab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lab;
    lab.attributedText = str_s;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-90)/2, (SCREEN_HEIGHT - 220)/2, 90, 90)];
    imageView.image = [UIImage imageNamed:@"icon_表情微笑.png"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom + 20, SCREEN_WIDTH , 30)];
    label.text = @"您好，亲友们都在期待着您的转赠，赶快转赠一张吧!";
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [PublicMethod colorWithHexValue:0xaaaaaa alpha:1.0f];
    [view addSubview:label];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PAGE107];
    if (forWard)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString * str = [NSString stringWithFormat:@"%d" , pages];
        [[NetTrans getInstance] API_YH_Card_History_List:self Pages:str block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE107];
//     [[NetTrans getInstance] cancelRequestByUI:self];
    forWard = NO;
}
-(void)createTableView
{
//    NSString *cardStr = @"10"
    if (_tableView)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT -NAVBAR_HEIGHT-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
}

-(void)upNav
{
    NSString * str_Num ;
    if ([dataArray count] > 0)
    {
       str_Num = [(YHCardHistoryList*)[dataArray lastObject] total];
    }
    else
    {
        str_Num = @"0";
    }
    NSString * str = [NSString stringWithFormat:@"转赠信息（共%@张）",str_Num];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(4, [str length]-4);
    NSRange range2 = NSMakeRange(0, 4);
    UIFont *font1 = [UIFont systemFontOfSize:12];
    UIFont *font2 = [UIFont boldSystemFontOfSize:20];
    [str_s addAttribute:NSFontAttributeName value:font1 range:range1];
    [str_s addAttribute:NSFontAttributeName value:font2 range:range2];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
    lab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lab;
    lab.attributedText = str_s;
}

-(void)addBackNav
{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
}
-(void)back:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     return [dataArray count];
//    return 10;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCardHistoryList * entity = [dataArray objectAtIndex:indexPath.row];
    static NSString * cell_str = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0f];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 90)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6;
    //剪切图片
    
    view.clipsToBounds = YES;
    [cell.contentView addSubview:view];
    
    UIView *view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.width, 60)];
    view_1.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
    [view addSubview:view_1];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 71, 19)];
    //    imageView.image = [UIImage imageNamed:@"goods_default@2x"];
    [imageView setImage:[UIImage imageNamed:@"icon_永辉钱包_永辉超市log加文字.png"]];
    [view_1 addSubview:imageView];
    
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right, 10, SCREEN_WIDTH - imageView.right - 30, 20)];
    cardLabel.text = entity.card_no;
    cardLabel.textAlignment = NSTextAlignmentRight;
    cardLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    cardLabel.font = [UIFont systemFontOfSize:15];
    cardLabel.backgroundColor = [UIColor clearColor];
    [view_1 addSubview:cardLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH/2-10, 20)];
    titleLabel.text = @"缤纷购物 精彩生活";
    titleLabel.font = [UIFont systemFontOfSize:15];
     titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0xfffffe alpha:1.0f];
    [view_1 addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 35, SCREEN_WIDTH/2-30, 20)];
    moneyLabel.textColor = [PublicMethod colorWithHexValue:0xfff6b9 alpha:1.0f];
    moneyLabel.font = [UIFont systemFontOfSize:20];
    CGFloat aa = [entity.total_amount floatValue];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    NSString * str_s = [NSString stringWithFormat:@"￥%.2f", aa];
    moneyLabel.text = str_s;
     moneyLabel.backgroundColor = [UIColor clearColor];
    [view_1 addSubview:moneyLabel];
    
    UIView *view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, view_1.bottom, view.width, 30)];
    view_2.backgroundColor = [PublicMethod colorWithHexValue:0xff84b2 alpha:1.0f];
    [view addSubview:view_2];
    //转赠对象
    UILabel *objectLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 180, 30)];
    objectLabel.textColor = [PublicMethod colorWithHexValue:0xfffffe alpha:1.0f];
    objectLabel.font = [UIFont systemFontOfSize:15];
    NSString *phoneStr = entity.examples_of_object;
    objectLabel.backgroundColor = [UIColor clearColor];
    objectLabel.text = [NSString stringWithFormat:@"转赠对象：%@",phoneStr];
    [view_2 addSubview:objectLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(objectLabel.right, 10, SCREEN_WIDTH-objectLabel.right-30, 18)];
    timeLabel.textColor = [PublicMethod colorWithHexValue:0xfffffe alpha:1.0f];
    timeLabel.text = entity.validity_date;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:9];
    [view_2 addSubview:timeLabel];
    
    return cell;
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_HISTORY_LIST == nTag)
    {
        arr_Add = (NSMutableArray *)netTransObj;
        if (pages > 1)
        {
            if ([arr_Add count] == 0)
            {
                [[iToast makeText:@"已加载全部数据"] show];
                pages--;
            }
            else
            {
                [dataArray addObjectsFromArray:arr_Add];
            }
        }
        else
        {
             [dataArray addObjectsFromArray:arr_Add];
            if ([dataArray count] == 0)
            {
                [self createUI];
            }
            else
            {
                 [self createTableView];
            }
        }
        [self upNav];
        //            [self addRefreshTableFooterView];
        [self performSelector:@selector(testFinishedLoadDataOther) withObject:nil afterDelay:0.0f];
        [_tableView reloadData];
    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_HISTORY_LIST == nTag)
    {
        if (pages>1)
        {
            pages--;
        }
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else if([status isEqualToString:WEB_STATUS_0])
        {
            [[iToast makeText:errMsg] show];
        }
    }
}
-(void)setFooterView
{
    //    UIEdgeInsets test = self._tableView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    NSLog(@"self._tableView.contentSize.height = %f" ,_tableView.contentSize.height );
    NSLog(@"self._tableView.frame.size.height = %f" , _tableView.frame.size.height);
    NSLog(@"height = %f" , height);
    //    height = self._tableView.contentSize.height;
    if (refreshFooterOtherView && [refreshFooterOtherView superview]) {
        // reset position
        refreshFooterOtherView.frame = CGRectMake(0.0f,
                                                  height,
                                                  _tableView.frame.size.width,
                                                  self.view.bounds.size.height);
    }else {
        // create the footerView
        refreshFooterOtherView = [[EGORefreshTableFooterOtherView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             _tableView.frame.size.width, self.view.bounds.size.height)];
        refreshFooterOtherView.delegate = self;
        [_tableView addSubview:refreshFooterOtherView];
    }
    
    if (refreshFooterOtherView) {
        [refreshFooterOtherView refreshLastOtherUpdatedDate];
    }
    NSString *   str_Num = [(YHCardHistoryList*)[dataArray lastObject] total];
    if ([str_Num intValue] == [dataArray count])
    {
        if (refreshFooterOtherView)
        {
            [refreshFooterOtherView removeFromSuperview];
            [[refreshFooterOtherView superview] removeFromSuperview];
            refreshFooterOtherView = nil;
        }
    }

}
#pragma mark ------------------------------- 上拉加载
-(void)testFinishedLoadDataOther{
    
    [self finishReloadingData];
    [self setFooterView];
}

- (void)finishReloadingData
{
    _reloadingOther = NO;
    if (refreshFooterOtherView)
    {
        [refreshFooterOtherView egoRefreshOtherScrollViewDataSourceDidFinishedLoading:_tableView];
        //        [refreshFooterOtherView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}
/*加载更多接口请求*/
-(void)getMoreData
{
    //    [self removeFooterView];
    pages ++;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * str = [NSString stringWithFormat:@"%d" , pages];
    [[NetTrans getInstance] API_YH_Card_History_List:self Pages:str block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
    [self testFinishedLoadDataOther];
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (refreshFooterOtherView)
    {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidScroll:_tableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (refreshFooterOtherView) {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidEndDragging:_tableView];
    }
}

#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerOtherRefresh:(EGORefreshPos)aRefreshPos{
    
    [self beginToReloadData:aRefreshPos];
    
}
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloadingOther = YES;
    if(aRefreshPos == EGORefreshOtherFooter){
        // pull up to load more data
        [self performSelector:@selector(getMoreData) withObject:nil afterDelay:1.0];
    }
    // overide, the actual loading data operation is done in the subclass
}

- (BOOL)egoRefreshTableDataSourceIsOtherLoading:(UIView *)view{
    
    return _reloadingOther; // should return if data source model is reloading
    
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastOtherUpdated:(UIView *)view{
    
    return [NSDate date]; // should return date data source was last changed
    
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
