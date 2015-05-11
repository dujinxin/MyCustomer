//
//  YHCardDetailsViewController.m
//  YHCustomer
//
//  Created by wangliang on 14-12-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHCardDetailsViewController.h"
#import "YHTransactionRecordsViewController.h"
#import "YHHelpUserWalletViewController.h"

@interface YHCardDetailsViewController ()
{
//    UIView *headView;
    int pages;
    BOOL _reloadingOther;
    NSMutableArray * arr_Add;
}
@end

@implementation YHCardDetailsViewController
@synthesize dataArray;
@synthesize entityCard;
@synthesize refreshFooterOtherView;
@synthesize forWard;


- (void)viewDidLoad {
    pages = 1;
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    arr_Add = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    self.navigationItem.title = @"永辉卡详情";
    [self addBackNav];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (forWard)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
        [[NetTrans getInstance] API_YH_Card_Trans_List:self CardNo:entityCard.card_no Pages:str_num block:^(NSString *someThing) {
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
//     [[NetTrans getInstance] cancelRequestByUI:self];
    forWard = NO;
}

-(void)addBackNav
{
self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
}
-(void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
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
    _tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    if ([dataArray count] > 0)
    {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
        UIView * view_T = [self getViewC];
        view_T.centerY =_tableView.frame.size.height/2;
        [self.view addSubview:view_T];
    }
}

-(UIView *)getViewC
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    view.backgroundColor = [UIColor clearColor];
//    UIImageView * im_V = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, 0, 90, 90)];
//    im_V.image = [UIImage imageNamed:@"icon_表情微笑.png"];
//    [view addSubview:im_V];
//    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(im_V.frame)+10, SCREEN_WIDTH, 20)];
//    lab.text = @"亲，没有钱包账户信息哦！";
//    lab.font = [UIFont systemFontOfSize:13];
//    lab.textColor = [PublicMethod colorWithHexValue1:@"#666666"];
//    lab.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:lab];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    headView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 27)];
    NSString *str = entityCard.card_no;
    cardLabel.text = [NSString stringWithFormat:@"卡号： %@",str];
    
    cardLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    cardLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:cardLabel];
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, cardLabel.bottom , SCREEN_WIDTH, 27)];
//    moneyLabel.textColor = [PublicMethod colorWithHexValue:0xFC5860 alpha:1.0f];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    CGFloat aa = [[entityCard card_amount] floatValue];
    NSString *str2 =[NSString stringWithFormat:@"￥%.2f" , aa];
//    moneyLabel.text = [NSString stringWithFormat:@"余额：%@",str2];
    NSString * str_Y =  [NSString stringWithFormat:@"余额：%@",str2];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str_Y];
    NSRange range1 = NSMakeRange(3, [str_s length]-3);
    NSRange range2 = NSMakeRange(0, 3);
    UIColor *redC = [PublicMethod colorWithHexValue1:@"#FC5860"];
    UIColor *redC1 = [PublicMethod colorWithHexValue1:@"#333333"];
    [str_s addAttribute:NSForegroundColorAttributeName value:redC1 range:range2];
    [str_s addAttribute:NSForegroundColorAttributeName value: redC range:range1];
    moneyLabel.attributedText = str_s;
    [headView addSubview:moneyLabel];
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, moneyLabel.bottom, SCREEN_WIDTH, 27)];
    NSString *str1;
    if ([entityCard.total_state_str isEqualToString:@""])
    {
//        if ([entityCard.total_state isEqualToString:@"I"])
//        {
//            str1 = @"未激活";
//        }
//        else if ([entityCard.total_state isEqualToString:@"A"])
//        {
//            str1 = @"正常";
//        }
//        else if ([entityCard.total_state isEqualToString:@"F"])
//        {
//            str1 = @"冻结";
//        }
        str1 = @"";
    }
    else
    {
        str1 = entityCard.total_state_str;
    }
    stateLabel.text = [NSString stringWithFormat:@"状态： %@",str1];
    stateLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    stateLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:stateLabel];
    
    UILabel *ValidityTime = [[UILabel alloc]initWithFrame:CGRectMake(10, stateLabel.bottom  , SCREEN_WIDTH , 27)];
    ValidityTime.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    ValidityTime.font = [UIFont systemFontOfSize:15];
    
    NSString *str3 = entityCard.validity_date;
    ValidityTime.text = [NSString stringWithFormat:@"有效期：至%@",str3];
    [headView addSubview:ValidityTime];
    
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ValidityTime.bottom, SCREEN_WIDTH, 10)];
    bgLabel.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    [headView addSubview:bgLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, bgLabel.bottom, SCREEN_WIDTH, 30)];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSString * str_num;
    if ([dataArray count] == 0)
    {
        str_num = @"0";
    }
    else
    {
        str_num = [(YHCardTransList*)[dataArray lastObject] total];
    }
    titleLabel.text = [NSString stringWithFormat:@"共有交易记录%@条" , str_num];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:titleLabel];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCardTransList * entity = [dataArray objectAtIndex:indexPath.row];
    NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    UIView * backV = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 59)];
    backV.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [cell addSubview:backV];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    UIView *startLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1.0f)];
    startLine.backgroundColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f];
    [cell addSubview:startLine];
    
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 100, 30)];
    NSString *str = entity.transaction_store;
    storeLabel.text = [NSString stringWithFormat:@"%@",str];
    storeLabel.font = [UIFont systemFontOfSize:15];
    storeLabel.backgroundColor = [UIColor clearColor];
    storeLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [cell addSubview:storeLabel];
    
    UILabel *stlyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(storeLabel.frame) , 0, SCREEN_WIDTH-CGRectGetMaxX(storeLabel.frame)-10, 30)];
    NSString *str1 = entity.transaction_type;
    stlyLabel.text = [NSString stringWithFormat:@"%@",str1];
    stlyLabel.font = [UIFont systemFontOfSize:15];
    stlyLabel.textAlignment = NSTextAlignmentRight;
    stlyLabel.backgroundColor = [UIColor clearColor];
    stlyLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [cell addSubview:stlyLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(storeLabel.frame) , 120, 30)];
    CGFloat aa = [entity.transaction_amount floatValue];
    moneyLabel.backgroundColor = [UIColor clearColor];
    NSString *str2;
    if ([entity.balance_of_payments isEqualToString:@"1"])
    {
        moneyLabel.textColor = [PublicMethod colorWithHexValue1:@"#007EFF"];
        str2 = [NSString stringWithFormat:@"+￥%.2f" , aa];
    }
    else if ([entity.balance_of_payments isEqualToString:@"2"])
    {
        moneyLabel.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
        str2 = [NSString stringWithFormat:@"-￥%.2f" , aa];
    }
    if (!str2 || str2==nil || [str2 isEqualToString:@""])
    {
        str2 = @"";
    }
    moneyLabel.text = str2;
    moneyLabel.font = [UIFont systemFontOfSize:18];
//    moneyLabel.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
    [cell addSubview:moneyLabel];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(175, CGRectGetMaxY(storeLabel.frame),SCREEN_WIDTH - 150, 30)];
    NSString *str3 = entity.transaction_time;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.text = [NSString stringWithFormat:@"%@",str3];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [cell addSubview:timeLabel];
    
    
    //    UIView *endLine = [[UIView alloc]initWithFrame:CGRectMake(0,timeLabel.bottom, SCREEN_WIDTH, 1.0f)];
    //    endLine.backgroundColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f];
    //    [cell.contentView addSubview:endLine];
    
    
    return cell;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_TRANS_LIST == nTag)
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
        else  if (pages == 1)
        {
            [dataArray addObjectsFromArray:arr_Add];
            [self createTableView];
        }
        //            [self addRefreshTableFooterView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        [_tableView reloadData];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_YH_CARD_TRANS_LIST)
    {
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
        if (pages > 1)
        {
            pages--;
        }
    }
    
}
-(void)getMoreData
{
    //    [self removeFooterView];
    pages ++;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
    [[NetTrans getInstance] API_YH_Card_Trans_List:self CardNo:entityCard.card_no Pages:str_num block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
    [self testFinishedLoadData];
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
    NSString *  str_num = [(YHCardTransList*)[dataArray lastObject] total];
    if ([str_num intValue] == [dataArray count])
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
-(void)testFinishedLoadData{
    
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

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (refreshFooterOtherView) {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidScroll:_tableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (refreshFooterOtherView)
    {
        NSLog(@"%f" , scrollView.contentOffset.y);
        if (scrollView.contentOffset.y > 0)
        {
            [refreshFooterOtherView egoRefreshOtherScrollViewDidEndDragging:_tableView];
        }
        
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
