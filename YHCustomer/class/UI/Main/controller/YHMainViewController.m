//
//  YHMainViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  首页

#import "YHMainViewController.h"
#import "RefleshManager.h"
#import "GoodsEntity.h"
#import "YHMainTableViewCell.h"
#import "DmEntity.h"
#import "YHNewSearchGoodsViewController.h"
#import "YHMyOrderViewController.h"
#import "YHMyCollectViewController.h"
#import "YHCollectViewController.h"
#import "ZbarViewController.h"
#import "YHPrommotionDetailController.h"
#import "YHQuickScanOrderViewController.h"
#import "YHPromotionViewController.h"
#import "DMGoodsEntity.h"
#import "YHVipCardViewController.h"
#import "YHMyCouponViewController.h"
#import "UILabelStrikeThrough.h"
#import "CategoryEntity.h"
#import "YHGoodsDetailViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHApplyReturnGoodsViewDeliveredController.h"
#import "YHPSCityListViewController.h"
#import "YHDMGoodsWallViewController.h"
#import "YHPromotionListViewController.h"
#import "YHGoodsTabViewController.h"
#import "YHScrollView.h"
#import "ThemeEntity.h"
#import "ActivityEntity.h"
#import "VersionEntiy.h"
#import "YHShakeViewController.h"
#import "SYAppStart.h"
#import "YHSignInViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YHCardBag.h"
#import "YHCardOpenViewController.h"
#import "YHSpeedEntryViewController.h"
#import "YHMenuViewController.h"
//固定抢购
#import "YHFixedToSnapUpViewController.h"
//灵活抢购
#import "YHFlexibleToSnapUpViewController.h"

#define SpeedEntryTag     100

#define CHOOSE_CITY       150

#define kOperationTag     300


@interface YHMainViewController ()
{
    BOOL isForceUpdate;
    BOOL isFirstly;
    BOOL isFirstWillAppear;
    BOOL isShowAllCategory;
    NSTimer * launchTimer;
    CGFloat speedEntryHeight;
}
@end

@implementation YHMainViewController
@synthesize dmPromotionData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[RefleshManager sharedRefleshManager] setMainViewRefresh:YES];
        allGoodsData = [[NSMutableArray alloc] init];
        hotGoodsData = [[NSMutableArray alloc] init];
        categoryData = [[NSMutableArray alloc] init];
        dmPromotionData = [[NSMutableArray alloc] init];
        themeData = [[NSMutableArray alloc] init];
        activityData = [[NSMutableArray alloc] init];
        speedEntryData = [[NSMutableArray alloc] init];
        isForceUpdate = NO;
        isFirstly = YES;
        isShowAllCategory = NO;
        currentPage = 0;
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNavigationView];
    [self addHeadView];
    
    self._tableView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    self._tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-84-25);
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self._loadMoreFooterView removeFromSuperview];
    self._loadMoreFooterView = nil;
    

    if (![[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]) {
        [[NSUserDefaults standardUserDefaults ] setBool:NO forKey:FIRST_CHOOSE_CITY];
        [[NSUserDefaults standardUserDefaults ] synchronize];
    }
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [standard boolForKey:FIRST_CHOOSE_CITY];
    if (!isFirst)
    {
        //修改首次安装没有网络的bug
        if( [Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable){
            
        }else{
            [standard setBool:YES forKey:FIRST_CHOOSE_CITY];
            [standard synchronize];
            //先加载启动页
//            [self showIntroWithCrossDissolve];
            [self gotoCityList];
        }
    }
    else
    {
        if ([[UserAccount instance].location_CityName isEqualToString:@""] ||[UserAccount instance].location_CityName==nil || ![UserAccount instance].location_CityName)
        {
            [self gotoCityList];
        }
    }

    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
    {
          [[iToast makeText:@"没有网络连接"] show];
    }
    else
    {
        [self requestMainData];
        if ([UserAccount instance].location_CityName.length != 0 &&[UserAccount instance].region_id.length != 0) {
            [self performSelector:@selector(checkVersion) withObject:nil afterDelay:0];
        }
    }
}
- (void)checkVersion{
    //监测版本
//    [[NetTrans getInstance] API_version_check:self AgentID:@"2" Type:@"consumer"];
}
- (void)hideLaunchImage{
    [SYAppStart hide:YES];
}
- (void)hideHUD{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    //定时器多线程
     dispatch_queue_t queue = dispatch_queue_create("timer", NULL);
     dispatch_async(queue, ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];

         //使该线程保持活跃状态，保证定时器计时准确
         [[NSRunLoop currentRunLoop] run];
     });
    if (IOS_VERSION < 6)
    {
        dispatch_release(queue);
    }

    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [self setHidesBottomBarWhenPushed:NO];
    self.refreshFooterView = nil;
    [super viewWillAppear:animated];
    
    [[NetTrans getInstance] getCartGoodsNum:self];
    
    if (![cityLabel.text isEqualToString:[UserAccount instance].location_CityName]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        cityLabel.text = [UserAccount instance].location_CityName;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"storeAddress"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"storeInfo"];
        [self cleanData];
        [self requestMainData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NetTrans getInstance]API_main_launch:self];
        });
        if ([[NSUserDefaults standardUserDefaults]boolForKey:FIRST_CHOOSE_CITY] && isFirstly == YES) {
            [self performSelector:@selector(checkVersion) withObject:nil afterDelay:0];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PAGE1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (timer)
    {
        [timer invalidate];
    }
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE1];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark ------------------------- add UI
-(void)addNavigationView
{
    UIImageView * leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftView.image = [UIImage imageNamed:@"right_search"];
    
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(60, scrollview.bottom-35, SCREEN_WIDTH-120, 30)];
//    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 30)];
//    searchBar.background = [UIImage imageNamed:@"searchbar_bg"];
    searchBar.layer.borderColor = [PublicMethod colorWithHexValue:0xe70012 alpha:1.0].CGColor;
    searchBar.layer.borderWidth = 1.0f;
    searchBar.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.leftView = leftView;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    UIImageView * leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftImage.image = [UIImage imageNamed:@"cart_yonghui_logo"];
    
//    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(30, 0, 30, 30);
//    [leftBtn setTitle:@"永辉微店" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//    leftBtn.titleLabel.numberOfLines = 2;
    UILabel * leftBtn = [[UILabel alloc]initWithFrame: CGRectMake(32, 0, 30, 30)];
    leftBtn.text = @"永辉微店" ;
    leftBtn.textColor = [PublicMethod colorWithHexValue:0xe70012 alpha:1.0];
    leftBtn.font = [UIFont systemFontOfSize:11];
    leftBtn.numberOfLines = 2;
    
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 62, 30);
    [left addSubview:leftImage];
    [left addSubview:leftBtn];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];

    if (IOS_VERSION >= 7) {
        negativeSpacer1.width = -10;
    }else{
        negativeSpacer1.width = -5;
    }

    NSArray * leftArray = [NSArray arrayWithObjects:negativeSpacer1,leftItem, nil];
    
    self.navigationItem.leftBarButtonItems = leftArray;
    

    UIImageView * location = [[UIImageView alloc]initWithFrame:CGRectMake(4, 16, 12, 12)];
    location.image = [UIImage imageNamed:@"city_location"];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 52, 44);
    rightBtn.tag = CHOOSE_CITY;
//    rightBtn setTitle:[UserAccount instance] forState:<#(UIControlState)#>
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cityLabel = [PublicMethod addLabel:CGRectMake(20,9.5, 32, 25) setTitle:[UserAccount instance].location_CityName setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
    cityLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [rightBtn addSubview:location];
    [rightBtn addSubview:cityLabel];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    
//    [self setRightBarButton:self Action:@selector(buttonAction:) SetImage:@"main_cityRight.png" SelectImg:@"main_cityRight_Select.png"];
    
    if (IOS_VERSION >= 7) {
        negativeSpacer2.width = -15;
    }else{
        negativeSpacer2.width = -5;
    }
    NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer2,leftBarItem, nil];
    self.navigationItem.rightBarButtonItems = barItems;
}
-(void)addNavigationView1
{
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(20, scrollview.bottom-35, SCREEN_WIDTH-40, 30)];
    searchBar.background = [UIImage imageNamed:@"searchbar_bg"];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 52, 44);
    rightBtn.tag = CHOOSE_CITY;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"main_cityRight.png"] forState:UIControlStateNormal];
    
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"main_cityRight_Select.png"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cityLabel = [PublicMethod addLabel:CGRectMake(20,9.5, 32, 25) setTitle:[UserAccount instance].location_CityName setBackColor:[UIColor whiteColor] setFont:[UIFont systemFontOfSize:12]];
    cityLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [rightBtn addSubview:cityLabel];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    
    //    [self setRightBarButton:self Action:@selector(buttonAction:) SetImage:@"main_cityRight.png" SelectImg:@"main_cityRight_Select.png"];
    
    if (IOS_VERSION >= 7)
    {
        negativeSpacer.width = -15;
    }
    else
    {
        negativeSpacer.width = -5;
    }
    NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer,leftBarItem, nil];
    self.navigationItem.rightBarButtonItems = barItems;
}

-(void)addHeadView
{
    //DM
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 531 +speedEntryHeight)];
    headView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    //old
    pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(200, 100, 120, 20)];
    //new
    pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 92.5, 20, 20)];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.layer.cornerRadius = 10;
    pageLabel.clipsToBounds = YES;
    pageLabel.font = [UIFont systemFontOfSize:12.0];
    pageLabel.adjustsFontSizeToFitWidth = YES;
    pageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122.5)];
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    
    UIImageView *defaultDM = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122.5)];
    [defaultDM setImage:[UIImage imageNamed:@"default_640X245"]];
    [scrollview addSubview:defaultDM];
    [headView addSubview:scrollview];
    //快速通道区
//    [self initSpeedEntryView];
    speedEntryHeight = 0;
    //热销商品区
    hotGoodsView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollview.bottom +speedEntryHeight +10, SCREEN_WIDTH, 143)];
    hotGoodsView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    //运营活动区
    eventView = [[UIView alloc]initWithFrame:CGRectMake(0, hotGoodsView.bottom+10, SCREEN_WIDTH, 144)];
    eventView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    //商品分类区
    [self._tableView setTableHeaderView:headView];
}
//新手提示
-(void)addTipsView
{
    NSString *first_launch = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_launch"];
    if (![first_launch isEqualToString:@"not_first_launch"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"not_first_launch" forKey:@"first_launch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        tipsBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        tipsBg.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.2];
        if (self.isVisible)
        {
            [[YHAppDelegate appDelegate].window addSubview:tipsBg];
        }
        CGFloat h = SCREEN_WIDTH /2;
        UIImageView *clickView = [[UIImageView alloc]initWithFrame:CGRectMake(h -30, 40, h, 125)];
        clickView.userInteractionEnabled = YES;
        [clickView setImage:[UIImage imageNamed:@"click_bu_code"]];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipAction:)];
        [clickView addGestureRecognizer:tapGesture];
        [tipsBg addSubview:clickView];
        /*
        if ([hotGoodsData count]>3)
        {
            UIImageView *scrollView = [[UIImageView alloc]initWithFrame:CGRectMake(140, clickView.bottom+50, 163, 87)];
            scrollView.userInteractionEnabled = YES;
            [scrollView setImage:[UIImage imageNamed:@"scroll_tips"]];
            UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipAction:)];
            [scrollView addGestureRecognizer:tapGesture1];
            [tipsBg addSubview:scrollView];
        }
         */
    }
}
- (void)initSpeedEntryView:(NSArray *)array{

    if (array.count %4 ==0) {
        speedEntryHeight =  array.count /4 * 64;
    }else{
        speedEntryHeight =  (array.count /4 +1)* 64;
    }
    UIView * speedEntrySuperView = [[UIView alloc]initWithFrame:CGRectMake(0, scrollview.bottom, SCREEN_WIDTH, speedEntryHeight)];
    speedEntrySuperView.backgroundColor = [UIColor clearColor];
    speedEntrySuperView.tag = 9090;
    [headView addSubview:speedEntrySuperView];
    
    for (int i = 0; i < array.count ; i ++)
    {
        NSDictionary * dict = [array objectAtIndex:i];
        UIButton *dmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dmBtn.tag = SpeedEntryTag + [[dict objectForKey:@"id"] integerValue];
        dmBtn.frame = CGRectMake(SCREEN_WIDTH /4 * (i%4), scrollview.bottom + 64 *(i/4), SCREEN_WIDTH /4, 64);
        [dmBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [dmBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [dmBtn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        [dmBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [dmBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(25, 8, 30, 30)];
//        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d",i +1]];
        [image setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]]];
//        image.userInteractionEnabled = YES;
        [dmBtn addSubview:image];
        UILabel * xline = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, 80, 1)];
        xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        [dmBtn addSubview:xline];
        UILabel * yline = [[UILabel alloc]initWithFrame:CGRectMake(79, 0, 1, 64)];
        yline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        [dmBtn addSubview:yline];
        
        [dmBtn setBackgroundImage:[UIImage imageNamed:@"icon_pressed.png"] forState:UIControlStateHighlighted];
        [dmBtn setBackgroundImage:[UIImage imageNamed:@"icon_normal.png"] forState:UIControlStateNormal];
        [dmBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:dmBtn];
    }
    
}
- (UIView *)moreView{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bgView.backgroundColor =[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    bgView.tag = 8080;
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH -20, 40);
    [moreBtn setTitle:@"更多推荐" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    moreBtn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    [moreBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn];
    
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 20, 20)];
    arrow.image = [UIImage imageNamed:@"more_arrow"];
    arrow.userInteractionEnabled = YES;
    [moreBtn addSubview:arrow];
    
    return bgView;

}
#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (isShowAllCategory) {
        return [categoryData count];
//    }else{
//        if (categoryData.count >3) {
//            return 4;
//        }else{
//            return [categoryData count];
//        }
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    YHMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[YHMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.mainVC = self;
    }
    
    CategoryEntity *entity =(CategoryEntity *)[categoryData objectAtIndex:indexPath.row];
    cell.rowNum = [entity.show_type integerValue];
    [cell setCellView:entity];
    
    return cell;
}
- (UITableViewCell *)tableView1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    YHMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[YHMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.mainVC = self;
    }
    
    if (isShowAllCategory) {
        CategoryEntity *entity =(CategoryEntity *)[categoryData objectAtIndex:indexPath.row];
        cell.rowNum = [entity.show_type integerValue];
        [cell setCellView:entity];
    }else{
        if (categoryData.count <= 3) {
            CategoryEntity *entity =(CategoryEntity *)[categoryData objectAtIndex:indexPath.row];
            cell.rowNum = [entity.show_type integerValue];
            [cell setCellView:entity];
        }else{
            if (indexPath.row < 3) {
                CategoryEntity *entity =(CategoryEntity *)[categoryData objectAtIndex:indexPath.row];
                cell.rowNum = [entity.show_type integerValue];
                [cell setCellView:entity];
            }else if(indexPath.row ==3){
                UIView * bgView = [cell.contentView viewWithTag:8080];
                if (bgView) {
                    [bgView removeFromSuperview];
                    [cell.contentView addSubview:bgView];
                }else{
                    [cell.contentView addSubview:[self moreView]];
                }
            }
        }
    }
    return cell;
}

#pragma mark -------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (isShowAllCategory == NO) {
//        if (indexPath.row == 3) {
//            isShowAllCategory = YES;
//            
//            [self._tableView reloadData];
//        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (isShowAllCategory) {
        return 308/2;
//    }else{
//        if (categoryData.count > 3) {
//            if (indexPath.row <3) {
//                return 308/2;
//            }else{
//                return 50;
//            }
//        }else{
//            return 308/2;
//        }
//    }
    
}
- (void)moreBtnClick:(UIButton *)btn {
    isShowAllCategory = YES;
    [btn setHidden:YES];
    [btn.superview setHidden:YES];
    [btn removeAllSubviews];
    [btn.superview removeFromSuperview];
    [btn removeFromSuperview];
    [self._tableView reloadData];
    

}
#pragma mark ---------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource
{
     requestStyle = Load_RefrshStyle;
    _moreloading = YES;
    countPage = 1;
   
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
    {
         [[iToast makeText:@"没有网络连接"] show];
    }
    else
    {
        if ([[UserAccount instance].location_CityName isEqualToString:@""] ||[UserAccount instance].location_CityName==nil || ![UserAccount instance].location_CityName)
        {
            [self gotoCityList];
        }
        else
        {
            [self requestMainData];
        }
    }
    
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)reloadMoreTableViewDataSource
{
	_moreloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    NSLog(@"getMore start requestInterface.");
}

#pragma mark -------------------------按钮事件处理
-(void)buttonAction:(UIButton *)button {

    switch (button.tag) {
        case CHOOSE_CITY:{// 城市列表
            isFirstly = NO;
            [self gotoCityList];
        }
            break;
        case 101:// 签到
        {
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHSignInViewController *collectVC = [[YHSignInViewController alloc] init];
            if ([[YHAppDelegate appDelegate] checkLogin])
            {
                [self.navigationController pushViewController:collectVC animated:YES];
                [MTA trackCustomKeyValueEvent:EVENT_ID100 props:nil];
            }
        }
            break;
        case 102:// 摇一摇
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID45 props:nil];
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHShakeViewController * svc = [[YHShakeViewController alloc]init ];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 103://DM
        {
            
            [MTA trackCustomKeyValueEvent:EVENT_ID16 props:nil];
            
            if (dmPromotionData.count > 0) {
                DmEntity *entity = (DmEntity *)[dmPromotionData objectAtIndex:0];
                if ([entity.home_show_id isEqualToString:@"0"]) {
                    [[iToast makeText:@"未设置DM"] show];
                    return;
                }

               [[PSNetTrans getInstance]get_DM_Info:self DMId:entity.home_show_id];
                
            }
        }
            break;
        case 104:// 扫描
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID20 props:nil];
            if (IOS_VERSION >= 7) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相机功能未开启，请去(设置>隐私>相机)开启一下吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }else if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusAuthorized){
                    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                    ZbarViewController *zbar = [[ZbarViewController alloc] init];
                    if ([[UserAccount instance] isLogin]){
                        zbar.saoType = Sao_Pay;
                        [self.navigationController pushViewController:zbar animated:YES];
                    }else{
                        zbar.saoType = Sao_Goods;
                        [self.navigationController pushViewController:zbar animated:YES];
                    }
                }
            }else{
                [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                ZbarViewController *zbar = [[ZbarViewController alloc] init];
                if ([[UserAccount instance] isLogin]){
                    zbar.saoType = Sao_Pay;
                    [self.navigationController pushViewController:zbar animated:YES];
                }else{
                    zbar.saoType = Sao_Goods;
                    [self.navigationController pushViewController:zbar animated:YES];
                }
            }
            
            
        }
            break;
        case 105:// 积分卡
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID17 props:nil];
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHVipCardViewController *vipVC = [[YHVipCardViewController alloc] init];
            vipVC.isForword = YES;
            [self.navigationController pushViewController:vipVC animated:YES];

        }
            break;
        case 106://我的收藏
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID18 props:nil];
            
            NSDictionary* kvs=[NSDictionary dictionaryWithObject:@"collect" forKey:@"Key"];
            [MTA trackCustomKeyValueEvent:@"click" props:kvs];
            
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHMyCollectViewController *collectVC = [[YHMyCollectViewController alloc] init];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
            break;
        case 107:// 永辉钱包
        {
          
            if ([[YHAppDelegate appDelegate] checkLogin])
            {
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [MTA trackCustomKeyValueEvent:EVENT_ID102 props:nil];
                YHCardOpenViewController * openView = [[YHCardOpenViewController alloc] init];
                openView.forWard = YES;
                [self.navigationController pushViewController:openView animated:YES];
            }
        }
            break;
        case 109:// 更多
        {
            
            YHSpeedEntryViewController * svc = [[YHSpeedEntryViewController alloc]init ];
            svc.DmArray = [[NSMutableArray alloc]initWithArray:dmPromotionData];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 108:// 优惠券
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID19 props:nil];
            
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHMyCouponViewController *couponVC = [[YHMyCouponViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case 110:// 菜谱
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID50 props:nil];
            YHMenuViewController *fiv = [[YHMenuViewController alloc]init];
            [self.navigationController pushViewController:fiv animated:NO];

        }
            break;
        default:
            break;
    }
}


- (void)gotoCityList
{
    YHPSCityListViewController *cityList = [[YHPSCityListViewController alloc] init];
    cityList.cityId =  self.locationCityId;
//    cityList.cityBlock = ^(NSString *cityName)
//    {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self performSelector:@selector(hideHUD) withObject:self afterDelay:1];
//        cityLabel.text = cityName;
//        [self cleanData];
//        [self requestMainData];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [[NetTrans getInstance]API_main_launch:self];
//            });
//        if ([[NSUserDefaults standardUserDefaults]boolForKey:FIRST_CHOOSE_CITY] && isFirstly == YES) {
//            [self performSelector:@selector(checkVersion) withObject:nil afterDelay:0];
//        }
//    };
    [self.navigationController pushViewController:cityList animated:YES];
}
#pragma mark --------------------------Request 
-(void)requestMainData
{
#pragma mark  ----------------   分段执行3个并行网络请求,对试图UI进行分步加载
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * udid;
    if ([defaults valueForKey:@"udid"]){
        if ([[defaults stringForKey:@"udid"]length] != 0) {
            udid = [defaults stringForKey:@"udid"];
        }else{
            udid = @"";
        }
    }else{
        udid = @"";
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//        并行请求1
         [[NetTrans getInstance] API_dm_main_top:self DMId:@"0"];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        //        并行请求2
        [[NetTrans getInstance] API_speed_entry:self type:@"1"];
    });
    
     dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        //        并行请求1
         [[NetTrans getInstance] API_main_hotGoods:self udid:udid];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        //        并行请求2
        [[NetTrans getInstance] API_main_activity:self];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程1
        [[NetTrans getInstance] API_main_category:self];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程2
        [[NetTrans getInstance] API_main_theme:self];
    });
}


#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    NSLog(@"nTag == %d" , nTag);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(t_API_MAIN_HOTGOODS == nTag)
    {
        [self setData:netTransObj Tag:nTag];
    } else if (t_API_SPEED_ENTRY == nTag){
        [self setData:netTransObj Tag:nTag];
    } else if (t_API_DM_MAIN_TOP == nTag) {
        [self setData:netTransObj Tag:nTag];
    } else if (t_API_MAIN_ACTIVITY == nTag) {
        [self setData:netTransObj Tag:nTag];
    } else if (t_API_MAIN_CATEGORY == nTag) {
        [self setData:netTransObj Tag:nTag];
    } else if (t_API_MAIN_THEME == nTag) {
        [self setData:netTransObj Tag:nTag];
    } else if (t_API_PS_DM_INFO == nTag) {
        [self setData:netTransObj Tag:nTag];
    }
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
//    if (t_API_VERSION == nTag) {
//        VersionEntiy *version = (VersionEntiy *)netTransObj;
//        NSString *verNum = version._version;
//        if ([version.force_update integerValue] == 1&&verNum.integerValue > K_VERSION_CODE) { //强制更新bool
//            
//        }else{
//            if (verNum.integerValue > K_VERSION_CODE) {
//                //前往appstore下载
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"永辉微店有新版啦！" message:[NSString stringWithFormat:@"\n%@",version.version_caption] delegate:self cancelButtonTitle:@"一会再说" otherButtonTitles:@"马上更新",nil];
//                    alert.tag = 1001,
//                    [alert show];
//                });
//            }
//        }
//    }
    if (nTag == t_API_MAIN_LAUNCH) {
        NSMutableArray * array = (NSMutableArray *)netTransObj;
        if (array.count != 0) {

            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * dict = [array lastObject];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"photo"]]];
            CGFloat show_time = [[dict objectForKey:@"show_time"]floatValue];
            [defaults setObject:data forKey:@"imageData"];
            [defaults setFloat:show_time forKey:@"show_time"];
            [defaults synchronize];
        }else{
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"imageData"];
            [defaults removeObjectForKey:@"show_time"];
            [defaults synchronize];
        }
        
    }
//    else if (t_API_YH_CARD_ISOPEN == nTag)
//    {
//        
////        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        YHCardBag* entity = (YHCardBag *)netTransObj;
//        if ([entity.type isEqualToString:@"0"])
//        {
//            YHCardOpenViewController * openView = [[YHCardOpenViewController alloc] init];
//            openView.entityCard = entity;
//            [self.navigationController pushViewController:openView animated:YES];
//        }
//        else if ([entity.type isEqualToString:@"1"])
//        {
//            YHCardCloseViewController * closeView = [[YHCardCloseViewController alloc] init];
//            [self.navigationController pushViewController:closeView animated:YES];
//        }
//          [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
//    }
    [self finishLoadTableViewData];
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self finishLoadTableViewData];
    if (nTag != t_API_CART_TOTAL_API)
    {
         [[iToast makeText:errMsg] show];
    }
}

#pragma mark --------------------   set data 

-(void)setData:(id)data Tag:(int)tag{
    if (data != nil)
    {
        [[RefleshManager sharedRefleshManager] setMainViewRefresh:NO];
        if (tag == t_API_MAIN_HOTGOODS)
        {//热销商品
            newGoods = (DMGoodsEntity *)data;
            //展示商品标题
            [allGoodsData removeAllObjects];
            [hotGoodsData removeAllObjects];
            [allGoodsData addObjectsFromArray:newGoods.allGoods];
            
            [hotGoodsView removeAllSubviews];
            [hotGoodsView removeFromSuperview];
            [eventView removeFromSuperview];
            
            CGFloat height = 0;
            for (int i = 0 ; i < allGoodsData.count; i ++ ) {
                DMGoodsEntity * subGoods = [allGoodsData objectAtIndex:i];
                
                YHScrollView * yhScrollView = [[YHScrollView alloc]initWithFrame:CGRectMake(0, 0 + i* 174, SCREEN_WIDTH, 164)];
                [yhScrollView.titleBtn setTitle:subGoods.name forState:UIControlStateNormal];
                [yhScrollView.titleBtn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
                yhScrollView.tag = 1000 *(i+1);
                
                height += yhScrollView.bottom;
                [hotGoodsView addSubview:yhScrollView];
                
                if (i == 0) {
                    [hotGoodsData addObjectsFromArray:subGoods.goods_list];
                }
                
                if ([subGoods.goods_list count]>3) {
                    yhScrollView.scrollView.contentOffset = CGPointMake(106/2, 0);
                }
                yhScrollView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*([subGoods.goods_list count]/3)+([subGoods.goods_list count]%3)*106.6, 134);
                
                
                for (int j = 0; j<[subGoods.goods_list count]; j++)
                {
                    GoodsEntity *entity = (GoodsEntity *)[subGoods.goods_list objectAtIndex:j];
                    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(j*(106+1), 0, 106, 134)];
                    bgView.backgroundColor = [UIColor whiteColor];
                    [yhScrollView.scrollView addSubview:bgView];
                    if (j!=([subGoods.goods_list count]-1)) {
                        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(bgView.right, 0, 1, 134)];
                        line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                        [yhScrollView.scrollView addSubview:line];
                    }
                    
                    UIImageView  *image = [[UIImageView alloc]initWithFrame:CGRectMake(13, 5, 80, 80)];
                    image.tag = yhScrollView.tag + j;
                    image.userInteractionEnabled = YES;
                    image.backgroundColor = [UIColor blueColor];
                    [image setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"goods_default"]];
                    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotGoodsAction:)];
                    [image addGestureRecognizer:gestureRecognizer];
                    [bgView addSubview:image];
                    
                    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(5, image.bottom, 106-2*5, 32)];
                    text.backgroundColor = [UIColor clearColor];
                    text.numberOfLines = 0;// 不可少Label属性之一
                    text.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
                    text.font = [UIFont systemFontOfSize:12.0];
                    text.textAlignment = NSTextAlignmentCenter;
                    text.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
                    text.text = entity.goods_name;
                    [bgView addSubview:text];
                    
                    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(0, text.bottom, 58, 17)];
                    price.backgroundColor = [UIColor clearColor];
                    price.font = [UIFont systemFontOfSize:12.0];
                    price.textAlignment = NSTextAlignmentCenter;
                    price.adjustsFontSizeToFitWidth = YES;
                    price.textColor = [PublicMethod colorWithHexValue:0xfb5963 alpha:1.0];
                    price.text = [NSString stringWithFormat:@"￥%@",entity.discount_price];
                    [bgView addSubview:price];
                    
                    if ([entity.price floatValue]>[entity.discount_price floatValue]) {
                        UILabelStrikeThrough *dis_price = [[UILabelStrikeThrough alloc]initWithFrame:CGRectMake(price.right, text.bottom, 58, 17)];
                        dis_price.isWithStrikeThrough = YES;
                        dis_price.backgroundColor = [UIColor clearColor];
                        dis_price.font = [UIFont systemFontOfSize:10.0];
                        dis_price.textAlignment = NSTextAlignmentCenter;
                        dis_price.adjustsFontSizeToFitWidth = YES;
                        dis_price.textColor = [PublicMethod colorWithHexValue:0x999999 alpha:1.0];
                        dis_price.text = [NSString stringWithFormat:@"￥%@",entity.price];
                        [bgView addSubview:dis_price];
                    }
                    
                }
//                //
//                if ([subGoods.goods_list count]>0 && i == 0) {
//                    [self addTipsView];
//                }
                
            }
            if ([allGoodsData count] == 0) {
                if ([activityData count] == 0) {
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324-10-170.5-10 +speedEntryHeight);
                }
                else {
//                    eventView.frame = CGRectMake(0, 196.5, SCREEN_WIDTH, 170.5);
                    eventView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, activityData.count * 180);
                    [headView addSubview:eventView];
//                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 531-143-10+64);
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324 +speedEntryHeight -180 + activityData.count * 180 -10);
                }
            }
            else {
                if ([activityData count] == 0) {
                    hotGoodsView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, 174 * allGoodsData.count -10);
                    [headView addSubview:hotGoodsView];
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324-170.5-10 + 174 * allGoodsData.count -10 +speedEntryHeight);
                }
                else {
                    hotGoodsView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, 174 * allGoodsData.count - 10);
                    [headView addSubview:hotGoodsView];
//                    eventView.frame = CGRectMake(0, hotGoodsView.bottom+10, SCREEN_WIDTH, 170.5);
                    eventView.frame = CGRectMake(0, hotGoodsView.bottom+10, SCREEN_WIDTH, activityData.count * 180);
                    [headView addSubview:eventView];
//                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 388 + 174* allGoodsData.count - 10 +64);
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324 + 174* allGoodsData.count +speedEntryHeight -180 + activityData.count * 180 -10);
                }
            }
            [self._tableView setTableHeaderView:headView];
            
            [self._tableView reloadData];
        }
        else if (tag == t_API_DM_MAIN_TOP)
        {//顶部DM
            NSMutableArray *dataArray = (NSMutableArray *)data;
            [self.dmPromotionData removeAllObjects];
            [self.dmPromotionData addObjectsFromArray:dataArray];
            [scrollview removeAllSubviews];
            scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*[dataArray count] ,122.5);
            for (int i=0; i<[dataArray count]; i++)
            {
                DmEntity *entity = [dataArray objectAtIndex:i];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 122.5)];
                image.userInteractionEnabled = YES;
                image.tag = i;
                [image setImageWithURL:[NSURL URLWithString:entity.dm_image] placeholderImage:[UIImage imageNamed:@"default_640X245"]];
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dmAction:)];
                [image addGestureRecognizer:gestureRecognizer];
                [scrollview addSubview:image];
            }
            totalPages = dataArray.count;
            [self setPageLabelText:currentPage +1];
            [headView addSubview:pageLabel];
//            pageCtr.numberOfPages = [dataArray count];
//            [headView addSubview:pageCtr];
            if ([self.dmPromotionData count] == 0) {
                [scrollview removeAllSubviews];
            }
            [self._tableView reloadData];
        }
        else if (tag == t_API_SPEED_ENTRY)
        {
            [speedEntryData removeAllObjects];
            [speedEntryData addObjectsFromArray:(NSMutableArray *)data];
            UIView * view = [headView viewWithTag:9090];
            [view removeAllSubviews];
            [view removeFromSuperview];
            [self initSpeedEntryView:speedEntryData];
            
            if ([allGoodsData count] == 0) {
                if ([activityData count] == 0) {
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324-10-170.5-10 +speedEntryHeight);
                }else {
                    eventView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, activityData.count * 180);
                    [headView addSubview:eventView];
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324 +speedEntryHeight -180 + activityData.count * 180 -10);
                }
            }
            else {
                if ([activityData count] == 0) {
                    hotGoodsView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, 174 * allGoodsData.count -10);
                    [headView addSubview:hotGoodsView];
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324-170.5-10 + 174 * allGoodsData.count -10 +speedEntryHeight);
                }else {
                    hotGoodsView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, 174 * allGoodsData.count - 10);
                    [headView addSubview:hotGoodsView];
                    eventView.frame = CGRectMake(0, hotGoodsView.bottom+10, SCREEN_WIDTH, activityData.count * 180);
                    [headView addSubview:eventView];
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324 + 174* allGoodsData.count +speedEntryHeight -180 + activityData.count * 180 -10);
                }
            }
            [self._tableView setTableHeaderView:headView];
            [self._tableView reloadData];
        }
        else if (tag == t_API_MAIN_CATEGORY)
        {//分类区
            [categoryData removeAllObjects];
            [categoryData addObjectsFromArray:(NSMutableArray *)data];

            if (categoryData.count >3) {
                isShowAllCategory = NO;
            }else{
                isShowAllCategory = YES;
            }
            [self._tableView reloadData];
        }
        else if (tag == t_API_MAIN_THEME)
        {//底部主题区
            [themeData removeAllObjects];
            [themeData addObjectsFromArray:(NSArray *)(data)];
            if ([themeData count]>0){
                UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145 * themeData.count + 10 *(themeData.count -1))];
                footView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                    for (int i=0; i<[themeData count]; i++)
                    {
                        YHThemeView * themeView = [[YHThemeView alloc ]initWithFrame:CGRectMake(0, 155 * i, SCREEN_WIDTH, 145)];
                        themeView.delegate = self;
                        themeView.backgroundColor = [UIColor whiteColor];
                        [footView addSubview:themeView];
                        NSMutableArray * array = [themeData objectAtIndex:i];
                        for (NSDictionary * d in array) {
                            NSString * show_type = [d objectForKey:@"show_type"];
                            switch (show_type.integerValue) {
                                case 1:
                                {
                                    [themeView.leftTopImageView setValuesForKeysWithDictionary:d];
                                    [themeView.leftTopImageView setImageWithURL:[NSURL URLWithString:themeView.leftTopImageView.image_url] placeholderImage:[UIImage imageNamed:@"default_290X115"]];
                                }
                                    break;
                                case 2:
                                {
                                    [themeView.leftBottomImageView setValuesForKeysWithDictionary:d];
                                    [themeView.leftBottomImageView setImageWithURL:[NSURL URLWithString:themeView.leftBottomImageView.image_url] placeholderImage:[UIImage imageNamed:@"default_290X115"]];
                                }
                                    break;
                                case 3:
                                {
                                    [themeView.rightTopImageView setValuesForKeysWithDictionary:d];
                                    [themeView.rightTopImageView setImageWithURL:[NSURL URLWithString:themeView.rightTopImageView.image_url] placeholderImage:[UIImage imageNamed:@"default_290X115"]];
                                }
                                    break;
                                case 4:
                                {
                                    [themeView.rightBottomImageView setValuesForKeysWithDictionary:d];
                                    [themeView.rightBottomImageView setImageWithURL:[NSURL URLWithString:themeView.rightBottomImageView.image_url] placeholderImage:[UIImage imageNamed:@"default_290X115"]];
                                }
                                    break;

                            default:
                                break;
                            }
                        }
                    }
                
                [self._tableView setTableFooterView:footView];
            }
            else {
                [self._tableView setTableFooterView:nil];
            }
            
        }
        else if (tag == t_API_MAIN_ACTIVITY)
        {//运营区

            [activityData removeAllObjects];
            [activityData addObjectsFromArray:data];
            
            [hotGoodsView removeFromSuperview];
            [eventView removeAllSubviews];
            [eventView removeFromSuperview];
            
            CGFloat eventViewHeight = 0;
            for (int i = 0;  i < activityData.count; i ++)
            {
                ActivityEntity * entity = [[ActivityEntity alloc]init];
                entity = [activityData objectAtIndex:i];
                kOperationType type = entity.show_mode.intValue -1;

                YHOperationView * operation = [[YHOperationView alloc]initWithFrame:CGRectMake(0, i *180, SCREEN_WIDTH, 170) type:type];
                operation.tag = kOperationTag + i;
                operation.delegate = self;
                operation.backgroundColor = [UIColor whiteColor];
                operation.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                [eventView addSubview:operation];
                eventViewHeight += 180;
                for (NSDictionary *dict in entity.activity_info) {
                    switch ([[dict objectForKey:@"show_type"]integerValue]) {
                        case 1:
                        case 4:
                        case 7:
                        {
                            [operation.bigLeftImageView setValuesForKeysWithDictionary:dict];
                            [operation.bigLeftImageView setImageWithURL:[NSURL URLWithString:operation.bigLeftImageView.image_url] placeholderImage:[UIImage imageNamed:@"default_640X245"]];

                        }
                            break;
                        case 2:
                        case 8:
                        {
                            [operation.mediumTopImageView setValuesForKeysWithDictionary:dict];
                            [operation.mediumTopImageView setImageWithURL:[NSURL URLWithString:operation.mediumTopImageView.image_url] placeholderImage:[UIImage imageNamed:@"default_290X115"]];
                        }
                            break;
                        case 3:
                        {
                            [operation.mediumBottomImageView setValuesForKeysWithDictionary:dict];
                            [operation.mediumBottomImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"default_290X115"]];
                        }
                            break;
                        case 5:
                        {
                            [operation.bigRightImageView setValuesForKeysWithDictionary:dict];
                            [operation.bigRightImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"default_640X245"]];
                        }
                            break;
                        case 6:
                        {
                            [operation.superImageView setValuesForKeysWithDictionary:dict];
                            [operation.superImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"default_640X245"]];
//                            operation.superImageView.target = self;
                        }
                            break;
                        case 9:
                        {
                            [operation.smallLeftImageView setValuesForKeysWithDictionary:dict];
                            [operation.smallLeftImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"goods_default"]];
                        }
                            break;
                        case 10:
                        {
                            [operation.smallRightImageView setValuesForKeysWithDictionary:dict];
                            [operation.smallRightImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"goods_default"]];
                        }
                            break;
                        
                    default:
                        break;
                    }
                }
                
            }
            
            
            if ([activityData count] == 0) {
                if ([allGoodsData count]==0) {
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324-10-170.5-10 +speedEntryHeight);
                } else {
                    hotGoodsView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, 174 * allGoodsData.count - 10);
                    [headView addSubview:hotGoodsView];
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324-170.5-10 + 174* allGoodsData.count -10 +speedEntryHeight);
                }
                
                [self._tableView setTableHeaderView:headView];
            }
            else
            {
                if ([allGoodsData count]==0) {
//                    eventView.frame = CGRectMake(0, 196.5, SCREEN_WIDTH, 170.5);
                    eventView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, eventViewHeight);
                    [headView addSubview:eventView];
//                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 531-143-10+64);
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324 +speedEntryHeight -180 +eventViewHeight -10);
                } else {
                    hotGoodsView.frame = CGRectMake(0, 122.5 +speedEntryHeight +10, SCREEN_WIDTH, 174 * allGoodsData.count -10);
                    [headView addSubview:hotGoodsView];
//                    eventView.frame = CGRectMake(0, hotGoodsView.bottom+10, SCREEN_WIDTH, 170.5);
                    eventView.frame = CGRectMake(0, hotGoodsView.bottom+10, SCREEN_WIDTH, eventViewHeight );
                    [headView addSubview:eventView];
//                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 388 + 174 * allGoodsData.count - 10 +64);
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 324 + 174 * allGoodsData.count +speedEntryHeight -180 + eventViewHeight -10);
                }
                
                [self._tableView setTableHeaderView:headView];
            }
            
            [self._tableView reloadData];
        }
        else if (t_API_PS_DM_INFO == tag)
        {
            
            NSMutableArray *dataArray = (NSMutableArray *)data;
            DmEntity *entity = [dataArray objectAtIndex:0];
            
            [self dmJumpLogic:entity];
            
        }
        
    }
}
#pragma mark - YHImageViewDelegate  -- 主题区
-(void)yhThemeViewAction:(YHImageView *)imageView{
    
    [MTA trackCustomKeyValueEvent:EVENT_ID26 props:nil];
    [self jumpWithType:imageView.jump_type jump_parametric:imageView.jump_parametric title:imageView.title];
}
#pragma mark - YHOperationDelegate  -- 运营活动区
-(void)yhImageViewAction:(YHImageView *)imageView{
    
    [MTA trackCustomKeyValueEvent:EVENT_ID24 props:nil];
    [self jumpWithType:imageView.jump_type jump_parametric:imageView.jump_parametric title:imageView.title];
}
#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    // 提示更新
//    if (alertView.tag == 1001) {
//        if (buttonIndex == 1) {
//            NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
//            [[UIApplication sharedApplication] openURL:iTunesURL];
//        }
//    }
//
//}

#pragma mark ----------------------- UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (scrollView == scrollview) {
        int size  = self.view.frame.size.width;
        int page = scrollView.contentOffset.x/size;
//        pageCtr.currentPage = page;
        currentPage = page;
        [self setPageLabelText:currentPage +1];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark ------------   private
-(void)autoChangePage
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (pageCtr.currentPage < (pageCtr.numberOfPages-1)) {
//            pageCtr.currentPage += 1;
//            [scrollview setContentOffset:CGPointMake(pageCtr.currentPage*SCREEN_WIDTH, 0) animated:YES];
//        } else {
//            pageCtr.currentPage =0;
//            [scrollview setContentOffset:CGPointMake(pageCtr.currentPage*SCREEN_WIDTH, 0) animated:NO];
//        }
//    });
    dispatch_async(dispatch_get_main_queue(), ^{
        if (currentPage < (totalPages -1)) {
            currentPage += 1;
            [scrollview setContentOffset:CGPointMake(currentPage*SCREEN_WIDTH, 0) animated:YES];
        } else {
            currentPage = 0;
            [scrollview setContentOffset:CGPointMake(currentPage*SCREEN_WIDTH, 0) animated:NO];
        }
        [self setPageLabelText:currentPage +1];
    });
}
- (void)setPageLabelText:(NSInteger)page{
    pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)page,(long)totalPages];
    //设置特殊颜色
    NSInteger length = [NSString stringWithFormat:@"%ld", (long)page].length;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:pageLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0 ] range:NSMakeRange(0,length)];
    pageLabel.attributedText = attributedString;
}
#pragma mark --------------   UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [MTA trackCustomKeyValueEvent:EVENT_ID21 props:nil];
    YHNewSearchGoodsViewController *searchVC = [[YHNewSearchGoodsViewController alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"bu_id"];
    [params setValue:@"default" forKey:@"order"];
    [params setValue:@"search" forKey:@"type"];
    [searchVC setRequstParams:params];
    //    searchVC.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController pushViewController:searchVC animated:NO];
    return NO;
}

#pragma mark ================  action  ===================

#pragma mark -----------// 促销详情
- (void)dmAction:(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID15 props:nil];
    
    NSDictionary* kvs=[NSDictionary dictionaryWithObject:@"dm" forKey:@"Key"];
    [MTA trackCustomKeyValueEvent:@"clickEvent" props:kvs];
    
    UITapGestureRecognizer *ges=(UITapGestureRecognizer *)sender;
    NSInteger tag = ges.view.tag;
    DmEntity *entity = [self.dmPromotionData objectAtIndex:tag];
    
    [self dmJumpLogic:entity];

}


#pragma mark -----------//热销商品标题
-(void)titleAction:(id)sender {
    [MTA trackCustomKeyValueEvent:EVENT_ID23 props:nil];
    
    YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
    
    UIButton * btn = (UIButton *)sender;
    YHScrollView * yhScrollView = (YHScrollView *) btn.superview;
    DMGoodsEntity * entity =[allGoodsData objectAtIndex:yhScrollView.tag/1000-1];
    vc.navigationItem.title = entity.name;
    
//    vc.navigationItem.title = goods.name;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"tag" forKey:@"type"];
    [dic setValue:@"0" forKey:@"bu_id"];
    [dic setValue:entity.tag_id forKey:@"tag_id"];
    [dic setValue:@"default" forKey:@"order"];
    [dic setValue:@"3" forKey:@"jump_type"];
    [vc setRequstParams:dic];
    [self.navigationController pushViewController:vc animated:YES];
    
//    YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//    proVC.navigationItem.title = goods.name;
//    [proVC setParamerWihtType:@"7" Id:nil tag:[goods.tag_id integerValue]];
//    [self.navigationController pushViewController:proVC animated:YES];
}

#pragma mark -----------//热销商品
-(void)hotGoodsAction :(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID22 props:nil];
    
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    UITapGestureRecognizer *ges=(UITapGestureRecognizer *)sender;
//    int tag = ges.view.tag;
//    GoodsEntity *entity = [hotGoodsData objectAtIndex:tag];
    NSInteger i = ges.view.tag /1000;
    NSInteger j = ges.view.tag %1000;
    DMGoodsEntity * dmEntity = [allGoodsData objectAtIndex:i-1];
    GoodsEntity * entity = [dmEntity.goods_list objectAtIndex:j];
    
    YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
//   ......................
    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    [detailVC setMainGoodsUrl:url goodsID:entity.goods_id];
    [self.navigationController pushViewController:detailVC animated:YES];
}


//#pragma mark -----------//底部主题
//-(void)footViewAction:(id)sender {
//    [MTA trackCustomKeyValueEvent:EVENT_ID26 props:nil];
//    
//    UITapGestureRecognizer *ges=(UITapGestureRecognizer *)sender;
//    int tag = (int)ges.view.tag;
//    ActivityEntity *entity =[themeData objectAtIndex:tag];
//
//    [self jumpWithType:entity.jump_type jump_parametric:entity.jump_parametric title:entity.title];
//
//}
//
//
//#pragma mark -----------//活动区（三个图片）
//-(void)activityAction:(id)sender {
//    
//    [MTA trackCustomKeyValueEvent:EVENT_ID24 props:nil];
//    UITapGestureRecognizer *ges=(UITapGestureRecognizer *)sender;
//    int tag = ges.view.tag;
//    ActivityEntity *entity = [[ActivityEntity alloc]init];
//    for ( ActivityEntity *activityEntity in activityData) {
//        if ([activityEntity.show_type intValue] == tag) {
//            entity = activityEntity;
//            break;
//        }
//    }
//}

#pragma mark - 运营活动区/主题区---跳转
- (void)jumpWithType:(NSString *)jump_type jump_parametric:(NSString *)jump_parametric title:(NSString *)title{
    if (![jump_type isEqualToString:@"6"]) {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    }
    switch ([jump_type integerValue]) {
        case 1://品类
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = title;
            NSArray *params = [jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"category" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_category_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 2://品牌
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = title;
            NSArray *params = [jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"brand" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_brand_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3://主题标签
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = title;
            NSArray *params = [jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"tag" forKey:@"type"];
            [dic setValue:@"0" forKey:@"bu_id"];
            [dic setValue:[params objectAtIndex:0] forKey:@"tag_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 4://搜索
        {
            
            YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
            srvc.view.backgroundColor = [UIColor clearColor];
            srvc.navigationItem.title = jump_parametric;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:jump_parametric forKey:@"key"];
            [params setValue:@"0" forKey:@"bu_id"];
            [params setValue:@"default" forKey:@"order"];
            [params setValue:@"search" forKey:@"type"];
            [params setValue:jump_type forKey:@"jump_type"];
            [srvc setRequstParams:params];
            [self.navigationController pushViewController:srvc animated:YES];

        }
            break;
        case 5://商品详情
        {
            YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
            NSString *url = [NSString stringWithFormat:GOODS_DETAIL,jump_parametric,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            [detailVC setMainGoodsUrl:url goodsID:jump_parametric];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 6://dm商品列表或瀑布流
        {
            NSArray *params = [jump_parametric componentsSeparatedByString:@":"];
            /*商品瀑布流API申请*/
            [[PSNetTrans getInstance]get_DM_Info:self DMId:[params objectAtIndex:0]];
        }
            break;
        case 7://固定抢购
        {
            YHFixedToSnapUpViewController *vc = [[YHFixedToSnapUpViewController alloc] init];
            vc.Forward = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8://灵活抢购
        {
            YHFlexibleToSnapUpViewController *vc = [[YHFlexibleToSnapUpViewController alloc] init];
            vc.Forward = YES;
            NSArray *params = [jump_parametric componentsSeparatedByString:@":"];
            vc.activity_id = [params objectAtIndex:0];
            NSLog(@"%@",[params objectAtIndex:0]);
            NSLog(@"%@",vc.activity_id);
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -----------//首次运行提示
-(void)tipAction:(id)sender
{
    UIGestureRecognizer *ges = (UIGestureRecognizer *)sender;
    [ges.view removeFromSuperview];
    if ([tipsBg.subviews count] == 0)
    {
        [tipsBg removeFromSuperview];
    }
}

#pragma mark ================  action  ===================

#pragma mark------------  clean data and refresh ui
//选择城市后调用
-(void)cleanData
{
    currentPage = 0;
    
    [dmPromotionData removeAllObjects];//促销大图数组
    [hotGoodsData removeAllObjects];//热销商品
    [allGoodsData removeAllObjects];
    [activityData removeAllObjects];//运营区
    [categoryData removeAllObjects];//分类商品
    [themeData removeAllObjects];//主题
    [speedEntryData removeAllObjects];//快速通道区
    [self._tableView setTableHeaderView:nil];
    [self._tableView setTableFooterView:nil];
    [self addHeadView];
    
    [self._tableView reloadData];
}

#pragma mark ----------------  改版促销跳转逻辑
-(void)dmJumpLogic:(DmEntity *)entity {
    
    if ([entity.connect_goods isEqualToString:@"0"]) {//0为不关联商品促销
        
        YHPrommotionDetailController *promotionDetail = [[YHPrommotionDetailController alloc] init];
        [promotionDetail setDMId:entity.dm_id];
        [self.navigationController pushViewController:promotionDetail animated:YES];
        
    } else if ([entity.connect_goods isEqualToString:@"1"] || [entity.connect_goods isEqualToString:@"2"]) {//1为关联商品促销  2是促销关联的标签商品
        
        if ([entity.page_type isEqualToString:@"0"]) {//0为列表模式
            
            YHPromotionListViewController *listVC = [[YHPromotionListViewController alloc]init];
            listVC.dmEntity = entity;
            [self.navigationController pushViewController:listVC animated:YES];
            
        } else {//1为瀑布流模式
            
            YHDMGoodsWallViewController *goodWall = [[YHDMGoodsWallViewController alloc] init];
            goodWall.dm_Entity = entity;
            [self.navigationController pushViewController:goodWall animated:YES];
            
        }
    }
    
}
#pragma mark - GuideView
- (void)introDidFinish {
    NSLog(@"Intro callback");
    if ([[UserAccount instance].location_CityName isEqualToString:@""] ||[UserAccount instance].location_CityName==nil || ![UserAccount instance].location_CityName)
    {
        self.navigationController.navigationBarHidden = NO;
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
        //        self.navigationController.navigationBar.alpha = 1;
        
        [self gotoCityList];
    }
    
}
@end
