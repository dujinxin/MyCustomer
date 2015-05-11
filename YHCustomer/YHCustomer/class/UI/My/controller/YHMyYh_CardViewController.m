//
//  YHMyYh_CardViewController.m
//  YHCustomer
//
//  Created by wangliang on 14-12-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHMyYh_CardViewController.h"
#import "YHNoneMoneyCardViewController.h"
#import "YHCardDetailsViewController.h"
#import "YHWalletDetailsViewController.h"
#import "YHCardBag.h"
@interface YHMyYh_CardViewController ()
{
    UIView *headView;
    YHCardBag_Main * entityCard;
    NSMutableArray * arr_Add;
    int pages;
    BOOL _reloadingOther;
}
@end

@implementation YHMyYh_CardViewController
@synthesize dataArray;
@synthesize refreshFooterOtherView;
@synthesize Forward;

- (void)viewDidLoad
{
    [super viewDidLoad];
    pages = 1;
    self.navigationItem.title = @"我的账户";
    [self addBackNav];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    dataArray = [NSMutableArray array];
    arr_Add = [NSMutableArray array];
    
    [self createTableView];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT -NAVBAR_HEIGHT-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    [self.view addSubview:_tableView];
//    [self.refreshHeaderView removeFromSuperview];
//    self.refreshHeaderView = nil;
////    下拉刷新....................
//    [self addRefreshTableFooterView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PAGE106];
    if (Forward)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_Info:self block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE106];
//     [[NetTrans getInstance] cancelRequestByUI:self];
    Forward = NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 154)];
    headView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    view1.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    [headView addSubview:view1];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"账户余额";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [view1 addSubview:titleLabel];
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, SCREEN_WIDTH - 30, 30)];
    
    NSString *str = entityCard.card_no;
    if (!str)
    {
        str = @"";
    }
    cardLabel.font = [UIFont systemFontOfSize:15];
    cardLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    cardLabel.text = [NSString stringWithFormat:@"卡号 ： %@",str];
    [view1 addSubview:cardLabel];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cardLabel.right, titleLabel.bottom+5,22, 22)];
    imageView.image = [UIImage imageNamed:@"my_access.png"];
    [view1 addSubview:imageView];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, cardLabel.bottom, SCREEN_WIDTH, 30)];
    float aa = [entityCard.amount floatValue];
    NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f" , aa];
    moneyLabel.font = [UIFont systemFontOfSize:15];
//    moneyLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    NSString * str_Y =  [NSString stringWithFormat:@"余额 ：%@",moneyStr];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str_Y];
    NSRange range1 = NSMakeRange(3, [str_s length]-3);
    NSRange range2 = NSMakeRange(0, 3);
    UIColor *redC = [PublicMethod colorWithHexValue1:@"#FC5860"];
    UIColor *redC1 = [PublicMethod colorWithHexValue1:@"#333333"];
    [str_s addAttribute:NSForegroundColorAttributeName value:redC1 range:range2];
    [str_s addAttribute:NSForegroundColorAttributeName value: redC range:range1];
    
    moneyLabel.attributedText = str_s;
    [view1 addSubview:moneyLabel];
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    headButton.backgroundColor = [UIColor clearColor];
    [headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:headButton];
    
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view1.bottom, SCREEN_WIDTH, 10)];
    colorLabel.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    [headView addSubview:colorLabel];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom + 10, SCREEN_WIDTH, 44)];
    view2.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    [headView addSubview:view2];
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
    totalLabel.backgroundColor = [UIColor clearColor];
     NSString * strNum;
    if ([dataArray count]>0)
    {
        strNum = [(YHCardBag_Vice *)[dataArray lastObject] total];
    }
    else
    {
        strNum = @"0";
    }
    totalLabel.text =[NSString stringWithFormat: @"共有可用永辉卡%@张" ,strNum];
    totalLabel.font = [UIFont systemFontOfSize:15];
    totalLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [view2 addSubview:totalLabel];
    
    UIButton *cardButton = [[UIButton alloc]initWithFrame:CGRectMake(totalLabel.right ,10, 100, 24)];
    [cardButton setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0f] forState:UIControlStateNormal];
    [cardButton setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
    [cardButton setTitle:@"查看无余额的卡" forState:UIControlStateNormal];
    cardButton.highlighted = YES;
    cardButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [cardButton addTarget:self action:@selector(cardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:cardButton];
    
    //    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, cardButton.bottom + 10, SCREEN_WIDTH, 1.0f)];
    //    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    //    [headView addSubview:line2];
    
    return headView;


}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 144;

}
-(void)headButtonClick:(UIButton *)button
{
    YHWalletDetailsViewController *wdv = [[YHWalletDetailsViewController alloc]init];
    wdv.entityCard = entityCard;
    wdv.forWard = YES;
    [self.navigationController pushViewController:wdv animated:YES];
}

-(void)cardButtonClick:(UIButton *)button
{
    YHNoneMoneyCardViewController *NCard = [[YHNoneMoneyCardViewController alloc]init];
    NCard.forWard = YES;
    [self.navigationController pushViewController:NCard animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   // return [dataArray count];
    return [dataArray count];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * cell_str = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YHCardBag_Vice * entity_Temp = [dataArray objectAtIndex:indexPath.row];
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
    
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right, 10, SCREEN_WIDTH - imageView.right - 20, 30)];
    cardLabel.backgroundColor = [UIColor clearColor];
    cardLabel.text = entity_Temp.card_no;
    cardLabel.textAlignment = NSTextAlignmentRight;
    cardLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    cardLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:cardLabel];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH/2, 20)];
    titleLabel.text = @"缤纷购物 精彩生活";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0xfffffe alpha:1.0f];
    [view_1 addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, cardLabel.bottom - 15, SCREEN_WIDTH-titleLabel.right-30, 40)];
    moneyLabel.textColor = [PublicMethod colorWithHexValue:0xfff6b9 alpha:1.0f];
    moneyLabel.font = [UIFont systemFontOfSize:20];
    moneyLabel.backgroundColor = [UIColor clearColor];
    CGFloat aa = [entity_Temp.card_amount floatValue];
    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f" , aa];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [view_1 addSubview:moneyLabel];
    
    UIView *view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, view_1.bottom, view.width, 30)];
    view_2.backgroundColor = [PublicMethod colorWithHexValue:0xfff6b9 alpha:1.0f];
    [view addSubview:view_2];
    
    UILabel *englishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
    englishLabel.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
    englishLabel.font = [UIFont systemFontOfSize:12];
    englishLabel.backgroundColor = [UIColor clearColor];
    englishLabel.text = @"Enjoy shopping Wonderful life";
    [view_2 addSubview:englishLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(englishLabel.right, 10, SCREEN_WIDTH-englishLabel.right-30, 18)];
    timeLabel.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
    timeLabel.text = entity_Temp.validity_date;
    timeLabel.backgroundColor = [UIColor clearColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:9];
    [view_2 addSubview:timeLabel];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCardBag_Vice * entityV = [dataArray objectAtIndex:indexPath.row];
    YHCardDetailsViewController *cdv = [[YHCardDetailsViewController alloc]init];
    cdv.entityCard = entityV;
    cdv.forWard = YES;
    [self.navigationController pushViewController:cdv animated:YES];
    
}

/*刷新接口请求*/
//- (void)reloadTableViewDataSource{
//        _moreloading = YES;
//        countPage = 1;
//        requestStyle = Load_RefrshStyle;
//    //    [self requestWithType:subType];
//    [self showAlert:@"下拉刷新"];
//    NSLog(@"refresh start requestInterface.");
//}

/*加载更多接口请求*/
//- (void)reloadMoreTableViewDataSource{
//        _moreloading = YES;
//        countPage ++;
//        requestStyle = Load_MoreStyle;
//    //   [self requestWithType:subType];
//    [self showAlert:@"上拉加载"];
//    NSLog(@"getMore start requestInterface.");
//}
-(void)addBackNav
{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
}
-(void)back:(id)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------------------- ---------------------- 网络请求回掉
-(void)addUI
{
    
    if ([dataArray count] == 0)
    {
        _tableView.scrollEnabled = NO;
    }
    else
    {
        _tableView.scrollEnabled = YES;
    }
    //    [self._tableView setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"]];
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_INFO == nTag)
    {
        entityCard = (YHCardBag_Main *)netTransObj;
        NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_List:self pages:str_num Type:@"1" block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
    else if (t_API_YH_CARD_LIST_VICE == nTag)
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
            [self addUI];
        }
        //            [self addRefreshTableFooterView];
        [self performSelector:@selector(testFinishedLoadDataOther) withObject:nil afterDelay:0.0f];
        [_tableView reloadData];
    }

}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_INFO == nTag)
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
    }
    else if (nTag == t_API_YH_CARD_LIST_VICE)
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
    
    NSString * strNum = [(YHCardBag_Vice *)[dataArray lastObject] total];
    if ([strNum intValue] == [dataArray count])
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
    NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_YH_Card_List:self pages:str_num Type:@"1" block:^(NSString *someThing) {
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
