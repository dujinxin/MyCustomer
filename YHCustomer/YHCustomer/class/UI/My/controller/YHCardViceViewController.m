//
//  YHCardViceViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/12/2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//
#define CARDID @"ViceCardId"
#import "YHCardViceViewController.h"
#import "YHCardBag.h"

@interface YHCardViceViewController ()
{
    UILabel *priceInfo;
    NSMutableArray * dataArr;//显示数据
    NSMutableArray * arr_Add;
    int pages;
    BOOL _reloadingOther;
}
@end

@implementation YHCardViceViewController
@synthesize block;
@synthesize lastStr;
@synthesize seleArr;
@synthesize refreshFooterOtherView;
@synthesize forWard;
@synthesize entityCard;
- (void)viewDidLoad {
    pages = 1;
    dataArr = [NSMutableArray array];
    arr_Add = [NSMutableArray array];
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [super viewDidLoad];
//    [self updata];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"选择永辉卡";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (forWard)
    {
        NSString * str_N = [NSString stringWithFormat:@"%d" , pages];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_List_Share:self pages:str_N block:^(NSString *someThing) {
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

-(void)upNav
{
    NSString * str_num;
    if ([dataArr count] == 0)
    {
        str_num = @"0";
    }
    else
    {
        str_num = [(YHCardVice *)[dataArr lastObject] total];

    }
    NSString * str = [NSString stringWithFormat:@"选择永辉卡（共%@张）" , str_num];
    NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = NSMakeRange(5, [str length]-5);
    NSRange range2 = NSMakeRange(0, 5);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------------------------------------------------addUI
-(void)addUI
{
    if (myTableView)
    {
        [myTableView removeFromSuperview];
        myTableView = nil;
    }

    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TURE_VIEW_HIGTH)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    [self.view addSubview:myTableView];
    
    if ([dataArr count] > 0)
    {
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
  else
  {
     myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     myTableView.scrollEnabled = NO;
      
      myTableView.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
      UIView * view_T = [self getViewC];
      view_T.centerY =TURE_VIEW_HIGTH/2;
      [self.view addSubview:view_T];
      
  }
   
//    [self.view addSubview:[self drawFootView]];
}

-(UIView *)getViewC
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView * im_V = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, 0, 90, 90)];
    im_V.image = [UIImage imageNamed:@"icon_表情微笑.png"];
    [view addSubview:im_V];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(im_V.frame)+10, SCREEN_WIDTH, 20)];
    lab.text = @"您好，没有可选择的永辉卡，快点去购买吧！";
    lab.font = [UIFont systemFontOfSize:13];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [PublicMethod colorWithHexValue1:@"#666666"];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}

/*footView*/
-(UIView *)drawFootView
{
   UIView* footView =[[UIView alloc] initWithFrame:CGRectMake(0, TURE_VIEW_HIGTH-50, SCREEN_WIDTH, 50)];
    footView.backgroundColor =[PublicMethod colorWithHexValue:0x434343 alpha:1];
    
    UILabel * priceInfo_1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 11, 150, 24)];
    priceInfo_1.backgroundColor=[UIColor clearColor];
    priceInfo_1.textColor =[UIColor whiteColor];
    priceInfo_1.text =@"已选择可转账金额";
    priceInfo_1.font =[UIFont boldSystemFontOfSize:15.0];
//    self.totalAmount = priceInfo;
    [footView addSubview:priceInfo_1];
    
    priceInfo = [[UILabel alloc] initWithFrame:CGRectMake(140, 11, 70, 24)];
    priceInfo.textColor =[UIColor redColor];
    priceInfo.text = lastStr;
    priceInfo.font =[UIFont boldSystemFontOfSize:15.0];
    [footView addSubview:priceInfo];
    //提交
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame =CGRectMake(220, 0, 100, 50);
    //    sendButton.backgroundColor = [PublicMethod colorWithHexValue:0xFC7F4A alpha:1];
    sendButton.backgroundColor= RGBCOLOR(255, 126, 0);
    [sendButton setTitle:@"确定" forState:UIControlStateNormal];
    sendButton.titleLabel.font =[UIFont systemFontOfSize:17.0];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sendButton];
    return footView;
}

#pragma mark      --------------------------------------------------tableView delegate and dataS

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCardVice * entity = [dataArr objectAtIndex:indexPath.row];
    NSString * cellStr = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
    }
    cell.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 90)];
    back.layer.cornerRadius = 8;
    back.clipsToBounds = YES;
    back.layer.masksToBounds = YES;
    [cell addSubview:back];
    
    UIImageView * view_img_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 60)];
    view_img_1.backgroundColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    //        view_img_1.layer.cornerRadius =8;
    [back addSubview:view_img_1];
    
    UIImageView * view_img_2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 71,19 )];
    view_img_2.backgroundColor = [UIColor clearColor];
    view_img_2.image = [UIImage imageNamed:@"icon_永辉钱包_永辉超市log加文字.png"];
    [back addSubview:view_img_2];
    
    //        UIImageView * ima_view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
    //        ima_view.image = [UIImage imageNamed:@"二维码.png"];
    //        [cell.contentView addSubview:ima_view];
    
    
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view_img_2.frame), 10, SCREEN_WIDTH-111, 20)];
    lab_1.backgroundColor = [UIColor clearColor];
    lab_1.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    lab_1.text = entity.card_no;
    lab_1.textAlignment = NSTextAlignmentRight;
    lab_1.font = [UIFont systemFontOfSize:15];
    [back addSubview:lab_1];
    
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH/2, 20)];
    lab_2.text = @"缤纷购物，精彩生活";
    lab_2.backgroundColor = [UIColor clearColor];
    lab_2.font = [UIFont systemFontOfSize:15];
    lab_2.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [back addSubview:lab_2];
    
    UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 35, SCREEN_WIDTH/2-30, 25)];
    CGFloat aa = [entity.card_amount floatValue];
    lab_3.text = [NSString stringWithFormat:@"￥%.2f" , aa];
    lab_3.textAlignment = NSTextAlignmentRight;
    lab_3.font = [UIFont systemFontOfSize:20];
    lab_3.backgroundColor = [UIColor clearColor];
    lab_3.textColor = [PublicMethod colorWithHexValue1:@"#FFF6B9"];
    [back addSubview:lab_3];
    
    
    UIImageView * im_B = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view_img_1.frame), SCREEN_WIDTH-20, 30)];
    im_B.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFF6B9"];
    //        im_B.layer.cornerRadius = 8;
    [back addSubview:im_B];
    
    UILabel * lab_E = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view_img_1.frame)+5, SCREEN_WIDTH-40, 14)];
    lab_E.text = @"Enjoy shopping Wonderful life";
    lab_E.font = [UIFont systemFontOfSize:12];
    lab_E.backgroundColor = [UIColor clearColor];
    lab_E.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    [back addSubview:lab_E];
    
    UILabel * lab_T = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_E.frame)-4, SCREEN_WIDTH-40, 10)];
    lab_T.text = entity.validity_date;
    lab_T.font = [UIFont systemFontOfSize:9];
    lab_T.backgroundColor = [UIColor clearColor];
    lab_T.textAlignment = NSTextAlignmentRight;
    lab_T.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    [back addSubview:lab_T];

    
    UIView * view_S = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20 , 90)];
    view_S.tag = 100;
    view_S.layer.cornerRadius = 8;
    [cell addSubview:view_S];
    
    UIImageView * im_v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    im_v.tag = 101;
    [cell addSubview:im_v];
    [im_v setCenter:view_S.center];
    
    if ([entityCard.card_no isEqualToString:entity.card_no])
    {
        view_S.backgroundColor = [UIColor blackColor];
        view_S.alpha = 0.5;
        im_v.image = [UIImage imageNamed:@"agreeArg"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YHCardVice * entity = [dataArr objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //agreeArg
//    UIView * view_U = [self getCum:CGRectMake(10, 10, SCREEN_WIDTH-20 , 90)];
//    [cell addSubview:view_U];
    
    entityCard = entity;
    [self.navigationController popViewControllerAnimated:YES];
    block(entity);
    [tableView reloadData];
}


-(UIView *)getCum:(CGRect)rect
{
    UIView * view_1 = [[UIView alloc] initWithFrame:rect];
    view_1.layer.cornerRadius = 8;
    view_1.backgroundColor = [UIColor blackColor];
    view_1.alpha = 0.5;
    UIImageView * im_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"agreeArg"]];
    [view_1 addSubview:im_1];
    im_1.center = view_1.center;
    return view_1;
}
#pragma mark    ------------------------------------------------   按钮事件
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------------------------       上拉加载，下啦刷新



#pragma mark ----------------------------------------------- 对选择的永辉卡的id进行字符串的添加与删除
-(NSString *)GetTureStr:(NSString *)num
{
    NSString * strTemp;
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSString * str_last = [standard stringForKey:CARDID];
    if (!str_last || [str_last isEqualToString:@""] || str_last == nil)
    {
        str_last = [[NSString alloc] init];
        NSString * str = [NSString stringWithFormat:@"%@" , num];
        [str_last stringByAppendingString:str];
    }
    else
    {
        NSMutableArray * arr = (NSMutableArray *)[str_last componentsSeparatedByString:@","];
        if ([arr containsObject:num])
        {
            [arr removeObject:num];
        }
        else
        {
            [arr addObject:num];
        }
        NSInteger count = [arr count];
        if (count == 1)
        {
            strTemp = [arr lastObject];
        }
        else
        {
            for (int i = 0 ; i < count ; i ++)
            {
                if (i == 0 )
                {
                    strTemp = [arr objectAtIndex:i];
                }
                else
                {
                    NSString * str_ee = [arr objectAtIndex:i];
                    NSString * str_ss = [NSString stringWithFormat:@",%@" , str_ee];
                    [strTemp stringByAppendingString:str_ss];
                }
            }
        }
    }
    return strTemp;
}

-(NSMutableArray *)GetTureStr
{
    NSMutableArray * arr_temp;
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSString * str_last = [standard stringForKey:CARDID];
    arr_temp = (NSMutableArray *)[str_last componentsSeparatedByString:@","];
    return arr_temp;
}

-(NSString *)tureStr:(NSMutableArray *)arr
{
    NSString * strTemp;
    NSInteger count = [arr count];
    if (count == 1)
    {
        strTemp = [arr lastObject];
    }
    else
    {
        for (int i = 0 ; i < count ; i ++)
        {
            if (i == 0 )
            {
                strTemp = [arr objectAtIndex:i];
            }
            else
            {
                NSString * str_ee = [arr objectAtIndex:i];
                NSString * str_ss = [NSString stringWithFormat:@",%@" , str_ee];
                [strTemp stringByAppendingString:str_ss];
            }
        }
    }
    return strTemp;
}


#pragma mark ------------------- ---------------------- 网络请求回掉

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_SHARE == nTag)
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
                [dataArr addObjectsFromArray:arr_Add];
            }
        }
       else  if (pages == 1)
        {
             [dataArr addObjectsFromArray:arr_Add];
            [self addUI];
        }
        [self upNav];
        //            [self addRefreshTableFooterView];
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
        [myTableView reloadData];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_SHARE == nTag)
    {
        if (pages>2)
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
-(void)getMoreData
{
    //    [self removeFooterView];
    pages ++;
    NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_YH_Card_List_Share:self pages:str_num block:^(NSString *someThing) {
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
    CGFloat height = MAX(myTableView.contentSize.height, myTableView.frame.size.height);
    NSLog(@"self._tableView.contentSize.height = %f" ,myTableView.contentSize.height );
    NSLog(@"self._tableView.frame.size.height = %f" , myTableView.frame.size.height);
    NSLog(@"height = %f" , height);
    //    height = self._tableView.contentSize.height;
    if (refreshFooterOtherView && [refreshFooterOtherView superview]) {
        // reset position
        refreshFooterOtherView.frame = CGRectMake(0.0f,
                                                  height,
                                                  myTableView.frame.size.width,
                                                  self.view.bounds.size.height);
    }else {
        // create the footerView
        refreshFooterOtherView = [[EGORefreshTableFooterOtherView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             myTableView.frame.size.width, self.view.bounds.size.height)];
        refreshFooterOtherView.delegate = self;
        [myTableView addSubview:refreshFooterOtherView];
    }
    
    if (refreshFooterOtherView) {
        [refreshFooterOtherView refreshLastOtherUpdatedDate];
    }
    
    NSString * str_num = [(YHCardVice *)[dataArr lastObject] total];;
    if ([str_num intValue] == [dataArr count])
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
        [refreshFooterOtherView egoRefreshOtherScrollViewDataSourceDidFinishedLoading:myTableView];
        //        [refreshFooterOtherView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (refreshFooterOtherView) {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidScroll:myTableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (refreshFooterOtherView) {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidEndDragging:myTableView];
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
