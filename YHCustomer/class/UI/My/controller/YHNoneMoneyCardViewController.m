//
//  YHNoneMoneyCardViewController.m
//  YHCustomer
//
//  Created by wangliang on 14-12-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHNoneMoneyCardViewController.h"
#import "YHCardDetailsViewController.h"
#import "YHCardBag.h"
@interface YHNoneMoneyCardViewController ()
{
    int pages;
    UIView *headView;
    NSMutableArray * arr_Add;
    BOOL _reloadingOther;
    
}
@end

@implementation YHNoneMoneyCardViewController
@synthesize dataArray;
@synthesize refreshFooterOtherView;
@synthesize forWard;

- (void)viewDidLoad {
    pages = 1;
    [super viewDidLoad];
    self.navigationItem.title = @"无余额永辉卡";
    [self addBackNav];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    dataArray = [[NSMutableArray alloc]init];
    arr_Add = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}
-(void)addBackNav
{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (forWard)
    {
        NSString * str_Num = [NSString stringWithFormat:@"%d" , pages];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_List:self pages:str_Num Type:@"2" block:^(NSString *someThing) {
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

-(void)back:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createUI
{
    NSString * str = [NSString stringWithFormat:@"无余额永辉卡（共0张）"];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(6, [str length]-6);
    NSRange range2 = NSMakeRange(0, 6);
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
    label.text = @"您好，您目前还没有无余额永辉卡!";
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f];
    [view addSubview:label];
}
-(void)createTableView
{
//    int count = 10;
    if (_tableView)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT -NAVBAR_HEIGHT-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)upNav
{
    NSString * str_num = [(YHCardBag_Vice *)[dataArray lastObject] total];
    if (!str_num)
    {
        str_num = @"0";
    }
    if ([str_num intValue] > 10)
    {
        [self performSelector:@selector(testFinishedLoadDataOther) withObject:nil afterDelay:0.0f];
    }
  
    NSString * str = [NSString stringWithFormat:@"无余额永辉卡（共%@张）" , str_num];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(6, [str length]-6);
    NSRange range2 = NSMakeRange(0, 6);
    UIFont *font1 = [UIFont systemFontOfSize:12];
    UIFont *font2 = [UIFont boldSystemFontOfSize:20];
    [str_s addAttribute:NSFontAttributeName value:font1 range:range1];
    [str_s addAttribute:NSFontAttributeName value:font2 range:range2];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    
    lab.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lab;
    lab.attributedText = str_s;
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
    YHCardBag_Vice * entity = [dataArray objectAtIndex:indexPath.row];
    NSString static *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 90)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6;
    //剪切图片
    view.clipsToBounds = YES;
    [cell.contentView addSubview:view];
    
    UIView *view_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.width, 60)];
    view_1.backgroundColor = [PublicMethod colorWithHexValue:0xaaaaaa alpha:1.0f];
    [view addSubview:view_1];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 71, 19)];
    //    imageView.image = [UIImage imageNamed:@"goods_default@2x"];
    [imageView setImage:[UIImage imageNamed:@"icon_永辉钱包_永辉超市log加文字.png"]];
    [view_1 addSubview:imageView];
    
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right, 10, SCREEN_WIDTH - imageView.right - 20, 30)];
    cardLabel.text = entity.card_no;
    cardLabel.textAlignment = NSTextAlignmentRight;
    cardLabel.backgroundColor = [UIColor clearColor];
    cardLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    cardLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:cardLabel];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH/2, 20)];
    titleLabel.text = @"缤纷购物 精彩生活";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0xfffffe alpha:1.0f];
    [view_1 addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 35, SCREEN_WIDTH/2-40, 20)];
    moneyLabel.textColor = [PublicMethod colorWithHexValue:0xdcdcdc alpha:1.0f];
    moneyLabel.font = [UIFont systemFontOfSize:25];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.backgroundColor = [UIColor clearColor];
    CGFloat aa = [entity.card_amount floatValue];
    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f" , aa];
    [view_1 addSubview:moneyLabel];
    
    UIView *view_2 = [[UIView alloc]initWithFrame:CGRectMake(0, view_1.bottom, view.width, 30)];
    view_2.backgroundColor = [PublicMethod colorWithHexValue:0xdcdcdc alpha:1.0f];
    [view addSubview:view_2];
    
    UILabel *englishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 20)];
    englishLabel.textColor = [PublicMethod colorWithHexValue:0xaaaaaa alpha:1.0f];
    englishLabel.font = [UIFont systemFontOfSize:12];
    englishLabel.backgroundColor = [UIColor clearColor];
    englishLabel.text = @"Enjoy shopping Wonderful life";
    [view_2 addSubview:englishLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(englishLabel.right, 10, SCREEN_WIDTH-englishLabel.right-30, 18)];
    timeLabel.textColor = [PublicMethod colorWithHexValue:0xaaaaaa alpha:1.0f];
    timeLabel.text = entity.validity_date;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.backgroundColor = [UIColor clearColor];

    timeLabel.font = [UIFont systemFontOfSize:9];
    [view_2 addSubview:timeLabel];



    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YHCardDetailsViewController *cdv = [[YHCardDetailsViewController alloc]init];
//    [self.navigationController pushViewController:cdv animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------------------网络请求回掉

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   if (t_API_YH_CARD_LIST_VICE == nTag)
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
        if (pages == 1)
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
//        [self performSelector:@selector(testFinishedLoadDataOther) withObject:nil afterDelay:0.0f];
        [_tableView reloadData];
    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  if (nTag == t_API_YH_CARD_LIST_VICE)
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
    
    NSString * str_num = [(YHCardBag_Vice *)[dataArray lastObject] total];
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
    [[NetTrans getInstance] API_YH_Card_List:self pages:str_num Type:@"2" block:^(NSString *someThing) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
