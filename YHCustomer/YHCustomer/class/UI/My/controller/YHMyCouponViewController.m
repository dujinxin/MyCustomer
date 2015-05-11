//
//  YHMyCouponViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHMyCouponViewController.h"
#import "YHCouponDetailViewController.h"

@interface YHMyCouponViewController (){
    UIImage     *buttonBackgroundImage;
    UIImage     *buttonSelectImage;
}

@end

@implementation YHMyCouponViewController
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"我的优惠券";
        [self.view setBackgroundColor:LIGHT_GRAY_COLOR];
        dataArray = [[NSMutableArray alloc] init];
        requestCouponType = Coupon_List;
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewEnd:PAGE14];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE14];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    buttonBackgroundImage = [UIImage imageNamed:@"unselected_indicator_front.png"];
    buttonSelectImage = [UIImage imageNamed:@"selected_indicator_front.png"];

    [self.view addSubview:[self addHeaderView]];
    self._tableView.frame = CGRectMake(0, 38, ScreenSize.width, ScreenSize.height-38 - NAVBAR_HEIGHT);
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initRequest];
}

// 首次请求
- (void)initRequest{
    requestStyle = Load_InitStyle;
    countPage = 1;
    [self requestWithPage:requestCouponType AndPage:countPage];
}

- (void)reloadTableViewDataSource{
    NSLog(@"下拉刷新");
    _moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    self.dataState = EGOOHasMore;
    [self requestWithPage:requestCouponType AndPage:countPage];
}
- (void)loadMoreTableViewDataSource{
    NSLog(@"开始加载加载更多");
    _reloading = YES;
    countPage ++;
    self.dataState = EGOOHasMore;
    requestStyle = Load_MoreStyle;
    [self requestWithPage:requestCouponType AndPage:countPage];
}
- (void)requestWithPage:(int)type AndPage:(NSInteger)page{
    [[PSNetTrans getInstance] API_MyCouponList:self Type:type Page:[NSString stringWithFormat:@"%ld",(long)page]];
}

#pragma mark -
#pragma mark ------------------------------add UI
- (UIView *)addHeaderView{
    UIView *headerview = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 38) setBackColor:LIGHT_GRAY_COLOR];
    float width = (ScreenSize.width)/2;

    UIView *lineGray = [PublicMethod addBackView:CGRectMake(0, 37, ScreenSize.width, 1) setBackColor:[UIColor lightGrayColor]];
    lineGray.alpha = .1f;
    [headerview addSubview:lineGray];
    
    // 可用优惠券
    couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    couponBtn.frame = CGRectMake(0, 0, width, 37);
    [couponBtn setBackgroundImage: buttonSelectImage forState:UIControlStateNormal];
    [couponBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateHighlighted];
    couponBtn.tag = 1001;
    [couponBtn addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [couponBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [couponBtn setTitle:@"可用优惠券" forState:UIControlStateNormal];
    couponBtn.titleLabel.font =[UIFont systemFontOfSize:15.0];
    
    // 历史优惠券
    historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(width, 0, width+2, 37);
    [historyBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [historyBtn setBackgroundImage:buttonSelectImage forState:UIControlStateHighlighted];
    historyBtn.tag = 1002;
    [historyBtn addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setTitle:@"历史优惠券" forState:UIControlStateNormal];
    historyBtn.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [historyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [headerview addSubview:couponBtn];
    [headerview addSubview:historyBtn];
    return headerview;
}

- (void)buttonClickWithSytle:(UIButton *)btn{
    [dataArray removeAllObjects];
    [couponBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [historyBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [couponBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (btn.tag == 1001) {
        [couponBtn setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
        [couponBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        requestCouponType = Coupon_List;

    }else{
        [historyBtn setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
        [historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        requestCouponType = Coupon_LIST_History;
    }
    [self initRequest];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    YHCouponDetailViewController *detailCoupon = [[YHCouponDetailViewController alloc] init];
    [detailCoupon setCouponDetailId:[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:detailCoupon animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    if (indexPath.row < dataArray.count) {
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 290, 90)];
        bgImg.image = [UIImage imageNamed:@"cart_yonghui_CoupoonBg.png"];
        [cell.contentView addSubview:bgImg];
        
        UIImageView *bgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(9, 14, 67, 67)];
        bgLogo.image = [UIImage imageNamed:@"cart_yonghui_logo.png"];
        [bgImg addSubview:bgLogo];
        
        UILabel *titleName = [PublicMethod addLabel:CGRectMake(85, 8, 200, 40) setTitle:[dic objectForKey:@"title"] setBackColor:[PublicMethod colorWithHexValue:0xcc0000 alpha:1.0f] setFont:[UIFont systemFontOfSize:23]];
        titleName.numberOfLines =0;
        [bgImg addSubview:titleName];
        
        UILabel *description = [PublicMethod addLabel:CGRectMake(85, 44, 190,20) setTitle:[NSString stringWithFormat:@"有效日期: %@-%@",[dic objectForKey:@"start_time"],[dic objectForKey:@"end_time"]] setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:10]];
        [bgImg addSubview:description];
        
        UILabel *regionName = [PublicMethod addLabel:CGRectMake(85, 61, 190, 20) setTitle:[NSString stringWithFormat:@"使用范围 : %@",[dic objectForKey:@"region_name"]] setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:10]];
        [bgImg addSubview:regionName];
        
        UIView *cellSeperateLine = [PublicMethod addBackView:CGRectMake(0, 120-10, ScreenSize.width, 10) setBackColor:LIGHT_GRAY_COLOR];
        cellSeperateLine.alpha = .5f;
        [cell.contentView addSubview:cellSeperateLine];

    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [self finishLoadTableViewData];
    if (nTag == t_API_PS_REGION_COUPON_LIST)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
    }
     [[iToast makeText:errMsg]show];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_PS_REGION_COUPON_LIST) {
        NSMutableArray *array = (NSMutableArray *)netTransObj;
        if (requestStyle == Load_MoreStyle) {
            [self.dataArray addObjectsFromArray:array];
        }else{
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
        }
        
        if (requestStyle == Load_MoreStyle) {
            if (self.total == self.dataArray.count) {
                self.dataState = EGOOOther;
            }else{
                self.dataState = EGOOHasMore;
            }
        }else{
            if (self.dataArray .count <10) {
                self.dataState = EGOOOther;
            }else{
                self.dataState = EGOOHasMore;
            }
        }
        self.total = self.dataArray.count;
        
        [self._tableView reloadData];
        [self finishLoadTableViewData];
        //移除上拉
        if (self.total * 120 < SCREEN_HEIGHT - 64-38) {
            [self removeFooterView];
        }else{
            [self testFinishedLoadData];
        }
        
        
    }
    

}
@end
