//
//  YHGoodsTabViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-8-12.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHGoodsTabViewController.h"
#import "YHPromotionListCell.h"
#import "YHGoodsDetailViewController.h"
#import "YHCartViewController.h"
#import "YHNewSearchGoodsViewController.h"
#import "YHNewOrderViewController.h"

@interface YHGoodsTabViewController ()
{
    NSString * _goods_id;
    NSString * _total;
}
@end

@implementation YHGoodsTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        goodsData = [NSMutableArray array];
        enoughGoodsData = [NSMutableArray array];
        enoughGoods = NO;
        
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    
    NSString *type = (NSString *)[params objectForKey:@"type"];
    if ([type isEqualToString:@"home_dm"])
    {//tabBar 促销
        
    }
    else
    {
        [self addNavigationBackButton];
    }
    [self addNavRightButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MTA trackPageViewBegin:PAGE8];
    
    self._tableView.frame = CGRectMake(0, 35, 320, ScreenSize.height - NAVBAR_HEIGHT  - 35);
    self._tableView.backgroundColor = LIGHT_GRAY_COLOR;
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addRefreshTableFooterView];
    
    NSString *type = (NSString *)[params objectForKey:@"type"];
    if ([type isEqualToString:@"home_dm"])
    {//tabBar 促销
        self._tableView.frame = CGRectMake(0, 35, 320, ScreenSize.height - NAVBAR_HEIGHT - 35-44);
    }
    else
    {
        //        [self addCartView];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [self addCartView];
    
    [self initShadowView];
    [self initMoreView];
    [self initCategoryView];
    [self addTopTabView];
    
    
    [[PSNetTrans getInstance] buy_getGoodsList:self
                                          type:[params objectForKey:@"type"]
                                     page_type:nil
                                         bu_id:[params objectForKey:@"bu_id"]
                                   bu_brand_id:[params objectForKey:@"bu_brand_id"]
                                bu_category_id:bu_category_id_default
                                   bu_goods_id:[params objectForKey:@"bu_goods_id"]
                                         dm_id:[params objectForKey:@"dm_id"]
                                          page:[NSString stringWithFormat:@"%ld",(long)countPage]
                                         limit:@"10"
                                         order:[params objectForKey:@"order"]
                                        tag_id:[params objectForKey:@"tag_id"]
                                        ApiTag:t_API_PS_GOODS_LIST
                                           key:[params objectForKey:@"key"]
                                      is_stock:[params objectForKey:@"is_stock"]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
    NSString *type = (NSString *)[params objectForKey:@"type"];
    if ([type isEqualToString:@"home_dm"])
    {//tabBar 促销
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
        self.dataState = EGOOHasMore;
    } else {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
        self.dataState = EGOOHasMore;
    }
    NSString *jump_type = (NSString *)[params objectForKey:@"jump_type"];
    if (![jump_type isEqualToString:@"1"]) {
        if ([type isEqualToString:@"home_dm"]){
            [categoryView request_type:@"dm_home_goods" bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
        }else if([type isEqualToString:@"tag"]){
            [categoryView request_type:@"home_tag_goods" bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
        }else{
            [categoryView request_type:[params objectForKey:@"type"] bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
        }
    }else{
//        [categoryView request_type:[params objectForKey:@"type"] bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
    }
    if (cartView)
    {
        [cartView changeCartNum];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE8];
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

#pragma mark ------------------------- add UI
-(void)addNavigationBackButton
{
    self.navigationItem.leftBarButtonItems= BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
}

-(void)addNavRightButton
{
    // 设置导航条右侧按钮
    [self setRightBarButton:self Action:@selector(searchAction:) SetImage:@"right_search" SelectImg:@"right_search"];
//    [self setRightBarButton:self Action:@selector(searchAction:) SetImage:@"category_Search" SelectImg:@"category_Search_Select"];
}

- (void)addTopTabView
{
    NSString *jump_type = (NSString *)[params objectForKey:@"jump_type"];
    
    tab1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [tab1 setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
    [tab1 setTitle:@"全部商品" forState:UIControlStateNormal];
    tab1.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    tab1.contentEdgeInsets = UIEdgeInsetsMake(2,3, 0, 0);
    [tab1 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [tab1 addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    tab2 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab2.tag = 0;
    [tab2 setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
    [tab2 setTitle:@"默认排序" forState:UIControlStateNormal];
    tab2.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    tab2.contentEdgeInsets = UIEdgeInsetsMake(2,3, 0, 0);
    [tab2 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [tab2 addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    tab3 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab3.tag = 0;
    [tab3 setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
    [tab3 setTitle:@"只看有货" forState:UIControlStateNormal];
    tab3.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    tab3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    tab3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tab3.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    tab3.contentEdgeInsets = UIEdgeInsetsMake(2,-20, 0, 0);
    [tab3 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [tab3 addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([jump_type isEqualToString:@"1"])
    {//品类,2个
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(159, 10, 1, 15)];
        line1.backgroundColor = [PublicMethod colorWithHexValue:0xb7b7b7 alpha:1.0];
        [tab2 addSubview:line1];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(139, 14, 6, 7)];
        arrow.tag = 2;
        [arrow setImage:[UIImage imageNamed:@"arrow_"]];
        [tab2 addSubview:arrow];
        
        tab2.frame = CGRectMake(0, 0, 160, 35);
        tab3.frame = CGRectMake(160, 0, 160, 35);
        [self.view addSubview:tab2];
        [self.view addSubview:tab3];
        
        tabs = [NSArray array];
        tabs = @[tab2,tab3];
    } else {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(105.66, 10, 1, 15)];
        line1.backgroundColor = [PublicMethod colorWithHexValue:0xb7b7b7 alpha:1.0];
        [tab1 addSubview:line1];
        UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(95, 14, 6, 7)];
        arrow1.tag = 1;
        [arrow1 setImage:[UIImage imageNamed:@"arrow_"]];
        [tab1 addSubview:arrow1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(105.66, 10, 1, 15)];
        line2.backgroundColor = [PublicMethod colorWithHexValue:0xb7b7b7 alpha:1.0];
        [tab2 addSubview:line2];
        UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(95, 14, 6, 7)];
        arrow2.tag = 2;
        [arrow2 setImage:[UIImage imageNamed:@"arrow_"]];
        [tab2 addSubview:arrow2];
        
        tab1.frame = CGRectMake(0, 0, 106.66, 35);
        tab2.frame = CGRectMake(tab1.right, 0, 106.66, 35);
        tab3.frame = CGRectMake(tab2.right, 0, 106.66, 35);
        [self.view addSubview:tab1];
        [self.view addSubview:tab2];
        [self.view addSubview:tab3];
        
        tabs = [NSArray array];
        tabs = @[tab1,tab2,tab3];
    }
    
    selectView = [[UIImageView alloc] initWithFrame:CGRectMake(tab3.width-34, 5.5, 24, 24)];
    [selectView setImage:[UIImage imageNamed:@"check"]];
    if ([tabs count] == 3)
    {
        tab3.contentEdgeInsets = UIEdgeInsetsMake(2,tab3.width/10, 0, 0);
    }
    else
    {
        tab3.contentEdgeInsets = UIEdgeInsetsMake(2,tab3.width/4-10, 0, 0);
        selectView.frame = CGRectMake(tab3.width-54, 5.5, 24, 24);
    }
    
    [tab3 addSubview:selectView];
    
    UIView *line_sep = [[UIView alloc]initWithFrame:CGRectMake(0, tab3.bottom-1, 320, 1)];
    line_sep.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [self.view addSubview:line_sep];
}

- (void)changeTabColor:(UIButton *)btn
{
    if (btn != tab3)
    {
        for (UIButton *button in tabs)
        {
            if (button == btn)
            {
                [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
            }
        }
    }
    
    if (enoughGoods) {
        [tab3 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    } else {
        [tab3 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    }
}

-(void)addCartView
{
    cartView = [[YHCartView alloc] initWithFrame:CGRectMake(260, SCREEN_HEIGHT-44-124, 54, 54)];
    cartView.delegate = self;
    NSString *type = (NSString *)[params objectForKey:@"type"];
    if (![type isEqualToString:@"home_dm"])
    {//tabBar 促销
        [self.view addSubview:cartView];
    }
}

- (void)initMoreView
{
    moreView = [[UIView alloc]initWithFrame:CGRectMake(0, -7*45+35, 320, 7*45)];
    moreView.backgroundColor = [UIColor redColor];
    moreView.tag = 0;
    
    moreTab1 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab1.backgroundColor = [UIColor whiteColor];
    moreTab1.frame = CGRectMake(0, 0, 320, 45);
    [moreTab1 setTitle:@"默认排序" forState:UIControlStateNormal];
    moreTab1.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    moreTab1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab1.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab1 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab1 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab1.bottom, 320, 1)];
    line1.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    
    moreTab2 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab2.backgroundColor = [UIColor whiteColor];
    moreTab2.frame = CGRectMake(0, moreTab1.bottom, 320, 45);
    [moreTab2 setTitle:@"价格从高到低" forState:UIControlStateNormal];
    moreTab2.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    moreTab2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab2.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab2 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab2 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab2.bottom, 320, 1)];
    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    
    
    moreTab3 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab3.backgroundColor = [UIColor whiteColor];
    moreTab3.frame = CGRectMake(0, moreTab2.bottom, 320, 45);
    [moreTab3 setTitle:@"价格从低到高" forState:UIControlStateNormal];
    moreTab3.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    moreTab3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab3.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab3 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab3 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab3.bottom, 320, 1)];
    line3.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    
    moreTab4 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab4.backgroundColor = [UIColor whiteColor];
    moreTab4.frame = CGRectMake(0, moreTab3.bottom, 320, 45);
    [moreTab4 setTitle:@"销量从高到低" forState:UIControlStateNormal];
    moreTab4.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    moreTab4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab4.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab4 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab4 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab4.bottom, 320, 1)];
    line4.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    //    moreTab5 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    moreTab5.backgroundColor = [UIColor whiteColor];
    //    moreTab5.frame = CGRectMake(0, moreTab4.bottom, 320, 35);
    //    [moreTab5 setTitle:@"销量从低到高" forState:UIControlStateNormal];
    //    moreTab5.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    //    moreTab5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    moreTab5.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    //    [moreTab5 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //    [moreTab5 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab5.bottom, 320, 1)];
    //    line5.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    moreTab6 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab6.backgroundColor = [UIColor whiteColor];
    moreTab6.frame = CGRectMake(0, moreTab4.bottom, 320, 45);
    [moreTab6 setTitle:@"折扣从高到低" forState:UIControlStateNormal];
    moreTab6.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    moreTab6.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab6.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab6 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab6 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab6.bottom, 320, 1)];
    line6.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    //    moreTab7 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    moreTab7.backgroundColor = [UIColor whiteColor];
    //    moreTab7.frame = CGRectMake(0, moreTab6.bottom, 320, 35);
    //    [moreTab7 setTitle:@"折扣从低到高" forState:UIControlStateNormal];
    //    moreTab7.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    //    moreTab7.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    moreTab7.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    //    [moreTab7 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    //    [moreTab7 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab6.bottom, 320, 1)];
    //    line7.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    moreTab8 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab8.backgroundColor = [UIColor whiteColor];
    moreTab8.frame = CGRectMake(0, moreTab6.bottom, 320, 45);
    [moreTab8 setTitle:@"最新上架的商品" forState:UIControlStateNormal];
    moreTab8.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    moreTab8.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab8.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab8 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab8 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line8 = [[UIView alloc]initWithFrame:CGRectMake(0, moreTab8.bottom, 320, 1)];
    line8.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    moreTab9 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreTab9.backgroundColor = [UIColor whiteColor];
    moreTab9.frame = CGRectMake(0, moreTab8.bottom, 320, 45);
    [moreTab9 setTitle:@"商品名称排序" forState:UIControlStateNormal];
    moreTab9.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    moreTab9.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreTab9.contentEdgeInsets = UIEdgeInsetsMake(3,10, 0, 0);
    [moreTab9 setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    [moreTab9 addTarget:self action:@selector(moreTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [moreView addSubview:moreTab1];
    [moreView addSubview:moreTab2];
    [moreView addSubview:moreTab3];
    [moreView addSubview:moreTab4];
    //    [moreView addSubview:moreTab5];
    [moreView addSubview:moreTab6];
    //    [moreView addSubview:moreTab7];
    [moreView addSubview:moreTab8];
    [moreView addSubview:moreTab9];
    
    [moreView addSubview:line1];
    [moreView addSubview:line2];
    [moreView addSubview:line3];
    [moreView addSubview:line4];
    //    [moreView addSubview:line5];
    [moreView addSubview:line6];
    //    [moreView addSubview:line7];
    [moreView addSubview:line8];
    
    checkView = [[UIImageView alloc] initWithFrame:CGRectMake(320-34, 10.5, 24, 24)];
    [checkView setImage:[UIImage imageNamed:@"tab_sel"]];
    [moreTab1 addSubview:checkView];
    
    [self.view addSubview:moreView];
}

- (void)moreViewIn
{
    moreView.tag = 0;
    if (moreView.frame.origin.y == 35)
    {
        [shadow setHidden:YES];
        moreView.frame = CGRectMake(0, 35, 320, 7*45);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        moreView.frame = CGRectMake(0, -7*45+35, 320, 7*45);
        [UIView commitAnimations];
    }
}

- (void)moreViewOut {
    moreView.tag = 1;
    if (moreView.frame.origin.y == -7*45+35)
    {
        [shadow setHidden:NO];
        moreView.frame = CGRectMake(0, -7*45+35, 320, 7*45);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        moreView.frame = CGRectMake(0, 35, 320, 7*45);
        [UIView commitAnimations];
    }
}

-(void)initCategoryView
{
    __unsafe_unretained YHGoodsTabViewController *vc = self;
    categoryView = [[CategoryView alloc]initWithFrame:CGRectMake(0, -(SCREEN_HEIGHT-44-35), SCREEN_WIDTH, 0)];
    NSString *type = (NSString *)[params objectForKey:@"type"];
    if ([type isEqualToString:@"home_dm"]) {//tabBar 促销
        categoryView.isPromotion = YES;
    } else {
        categoryView.isPromotion = NO;
    }
    categoryView.tapBlock = ^(){
        [vc categoryViewIn];
    };
    categoryView.block = ^(NSString * is_parent_category,NSString *bu_category_id,NSString *title)
    {
        UIImageView *arrow2 = (UIImageView *)[vc->tab2 viewWithTag:2];
        [arrow2 setImage:[UIImage imageNamed:@"arrow_"]];
        UIImageView *arrow1 = (UIImageView *)[vc->tab1 viewWithTag:1];
        [arrow1 setImage:[UIImage imageNamed:@"arrow_selected"]];
        
        [vc->tab1 setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
        
        [vc categoryViewIn];
        
        vc->countPage = 1;
        vc->requestStyle = Load_RefrshStyle;
        
        if (title)
        {
            [vc->tab1 setTitle:title forState:UIControlStateNormal];
        }
        
        if (bu_category_id)
        {
            [vc->params setObject:bu_category_id forKey:@"bu_category_id"];
        }else{
            [vc->params setObject:@"" forKey:@"bu_category_id"];
        }
        
        vc->category_type = is_parent_category;//1,2
        
//        vc->isHasMore = YES;
        vc->dataState = EGOOHasMore;
        [vc requestData];
        
    };
    
//    [categoryView request_type:[params objectForKey:@"type"] bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
    
    [self.view addSubview:categoryView];
}

- (void)categoryViewIn
{
    categoryView.isOut = NO;
    
    if (categoryView.frame.origin.y == 35) {
        
        [shadow setHidden:YES];
        
        categoryView.frame = CGRectMake(0, 35, 320, categoryView.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        categoryView.frame = CGRectMake(0, -(SCREEN_HEIGHT-44-35), 320, categoryView.height);
        [UIView commitAnimations];
        
    }
}

- (void)categoryViewOut {
    categoryView.isOut = YES;
    
    //    if ([tab1.titleLabel.text isEqualToString:@"全部商品"]) {
    //        [categoryView deleteFirstEntity];
    //    } else {
    //        [categoryView addFirstEntity];
    //    }
    
    [categoryView refresh];
    
    if (categoryView.frame.origin.y == -(SCREEN_HEIGHT-44-35))
    {
        
        [shadow setHidden:NO];
        categoryView.frame = CGRectMake(0, -(SCREEN_HEIGHT-44-35), 320, categoryView.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDelegate:self];
        categoryView.frame = CGRectMake(0, 35, 320, categoryView.height);
        [UIView commitAnimations];
        
    }
}

- (void)initShadowView
{
    shadow = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 320, self._tableView.height)];
    shadow.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.5];
    shadow.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowAction)];
    
    [shadow addGestureRecognizer:tap];
    [self.view addSubview:shadow];
    [shadow setHidden:YES];
}

-(void)setTopTabSelectedColor:(UIButton *)button
{
    for (UIButton *btn in tabs)
    {
        if (btn == button)
        {
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xdddcdc alpha:1.0]];
        }
        else
        {
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
        }
    }
}


#pragma mark ------------  public
-(void)setRequstParams:(NSMutableDictionary *)param
{
    
    bu_category_id_default = [param objectForKey:@"bu_category_id"];
    params = [NSMutableDictionary dictionary];
    params = param;
    [params setValue:@"0" forKey:@"is_stock"];
    
    if ([[params objectForKey:@"type"] isEqualToString:@"home_dm"])
    {//tabbar促销
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityAction) name:@"changeCity" object:nil];
    }else{
        
    }
}

#pragma mark ------------------------  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsEntity *entity;
//    if (enoughGoods) {
//        entity = (GoodsEntity *)[enoughGoodsData objectAtIndex:indexPath.row];
//    } else {
        entity = (GoodsEntity *)[goodsData objectAtIndex:indexPath.row];
//    }
    CGSize size ;
    size = [entity.goods_name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(210, 40) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 20 && (entity.goods_introduction && entity.goods_introduction.length != 0) && (entity.is_or_not_salse.integerValue == 1 || entity.limit_the_purchase_type.integerValue != 0))
        return 130;
    else
        return 110;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self._tableView numberOfRowsInSection:indexPath.section]-1) {
//        [self loadMoreTableViewDataSource];
    }
}

#pragma mark ------------------------    UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    YHPromotionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[YHPromotionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __unsafe_unretained YHGoodsTabViewController *vc = self;
        cell.cartBlock = ^(NSString * goods_id,NSString * total){
            if (goods_id && total) {
                vc->_goods_id = goods_id;
                vc->_total = total;
                [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:goods_id total:total];
            }else{
                [vc->cartView changeCartNum];
            }
        };
    }
//    cell.backgroundColor = [UIColor blueColor];
    GoodsEntity *entity;
//    if (enoughGoods) {
//        entity = (GoodsEntity *)[enoughGoodsData objectAtIndex:indexPath.row];
//    } else {
        entity = (GoodsEntity *)[goodsData objectAtIndex:indexPath.row];
//    }
    [cell setGoodsCellData:entity];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (enoughGoods) {
//        return [enoughGoodsData count];
//    } else {
        return [goodsData count];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsEntity *entity;
//    if (enoughGoods)
//    {
//        entity = [enoughGoodsData objectAtIndex:indexPath.row];
//    }
//    else
//    {
        entity = [goodsData objectAtIndex:indexPath.row];
//    }
    
    YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    detaiVC.url = url;//entity.goods_id
    [detaiVC setMainGoodsUrl:url goodsID:entity.goods_id];
    [self.navigationController pushViewController:detaiVC animated:YES];
}

#pragma mark ----------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
    _moreloading = YES;
    countPage = 1;
    self.dataState = EGOOHasMore;
    requestStyle = Load_RefrshStyle;
    
    [self requestData];
    
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    
    [self requestData];
    
    NSLog(@"getMore start requestInterface.");
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topTabAction:(UIButton *)btn
{
    [self setTopTabSelectedColor:btn];
    if (btn == tab1)
    {
        [self moreViewIn];
        if ([categoryView.categoryData count]>0)
        {
            if (categoryView.isOut)
            {
                [self categoryViewIn];
                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
            }
            else
            {
                [self categoryViewOut];
            }
        }
        else
        {
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];

        }
        
    }
    else if (btn == tab2)
    {
        
        [self categoryViewIn];
        
        if (moreView.tag%2 == 0) {
            [self moreViewOut];
        } else {
            [self moreViewIn];
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
        }
        
        //刷新筛选菜单
        //        [categoryView request_type:[params objectForKey:@"type"] bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
        
    }
    else if (btn == tab3)
    {
        [self categoryViewIn];
        [self moreViewIn];
        
        tab3.tag += 1;
        if (tab3.tag%2 == 1) {//有货
            
            enoughGoods = YES;
            [selectView setImage:[UIImage imageNamed:@"check_selected"]];
            [params setValue:@"1" forKey:@"is_stock"];
            
        } else {
            
            enoughGoods = NO;
            [selectView setImage:[UIImage imageNamed:@"check"]];
            [params setValue:@"0" forKey:@"is_stock"];
            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
            
        }
        
        requestStyle = Load_RefrshStyle;
        countPage = 1;
        [self requestData];
        
        [self._tableView reloadData];
        
    }
    if (btn != tab2)
    {
        [self changeTabColor:btn];
    }
    
    
}

- (void)searchAction:(id)sender
{
    YHNewSearchGoodsViewController *searchVC = [[YHNewSearchGoodsViewController alloc]init];
    NSMutableDictionary *params_other = [NSMutableDictionary dictionary];//blw 14-10-17   params -> params_other
    [params_other setValue:@"0" forKey:@"bu_id"];
    [params_other setValue:@"default" forKey:@"order"];
    [params_other setValue:@"search" forKey:@"type"];
    [searchVC setRequstParams:params_other];
    //    searchVC.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController pushViewController:searchVC animated:NO];
    
}

- (void)moreTabAction:(UIButton *)btn
{
    [checkView removeFromSuperview];
    requestStyle = Load_RefrshStyle;
    countPage = 1;
    [self moreViewIn];
    
    [self changeTabColor:tab2];
    UIImageView *arrow2 = (UIImageView *)[tab2 viewWithTag:2];
    [arrow2 setImage:[UIImage imageNamed:@"arrow_selected"]];
    UIImageView *arrow1 = (UIImageView *)[tab1 viewWithTag:1];
    [arrow1 setImage:[UIImage imageNamed:@"arrow_"]];
    
    [tab2 setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
    
    if (btn == moreTab1) {//默认排序
        [moreTab1 addSubview:checkView];
        [tab2 setTitle:@"默认排序" forState:UIControlStateNormal];
        tab2.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [params setValue:@"default" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab2) {//价格从高到低
        [moreTab2 addSubview:checkView];
        [tab2 setTitle:@"价格降序" forState:UIControlStateNormal];
        
        [params setValue:@"price:1" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab3) {//价格从低到高
        [moreTab3 addSubview:checkView];
        [tab2 setTitle:@"价格升序" forState:UIControlStateNormal];
        
        [params setValue:@"price:0" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab4) {//销量从高到低
        [moreTab4 addSubview:checkView];
        [tab2 setTitle:@"销量降序" forState:UIControlStateNormal];
        
        [params setValue:@"sales:1" forKey:@"order"];
        [self requestData];
        
    }  else if (btn == moreTab5) {//销量从低到高
        [moreTab5 addSubview:checkView];
        [tab2 setTitle:@"销量升序" forState:UIControlStateNormal];
        
        [params setValue:@"sales:0" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab6) {//折扣从高到低
        [moreTab6 addSubview:checkView];
        [tab2 setTitle:@"折扣降序" forState:UIControlStateNormal];
        
        [params setValue:@"discount:1" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab7) {//折扣从低到高
        [moreTab7 addSubview:checkView];
        [tab2 setTitle:@"折扣升序" forState:UIControlStateNormal];
        
        [params setValue:@"discount:0" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab8) {//最近上架的商品
        [moreTab8 addSubview:checkView];
        [tab2 setTitle:@"最新上架" forState:UIControlStateNormal];
        
        [params setValue:@"onsell_time" forKey:@"order"];
        [self requestData];
        
    } else if (btn == moreTab9) {//品牌名称排序
        [moreTab9 addSubview:checkView];
        [tab2 setTitle:@"品名排序" forState:UIControlStateNormal];
        
        [params setValue:@"name" forKey:@"order"];
        [self requestData];
    }
}

-(void)shadowAction
{
    [self moreViewIn];
    
    //blw 14-10-17
    [self changeTabColor];
    
}

//blw 14-10-17
- (void)changeTabColor
{
    for (UIButton *button in tabs)
    {
        [button setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
    }
}

#pragma mark ------------  CartViewDelegate
-(void)cartViewClickAction
{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO)
    {
        return;
    }
    YHCartViewController *cart = [[YHCartViewController alloc] init];
    cart.isFromOther = YES;
    [self.navigationController pushViewController:cart animated:YES];
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_PS_GOODS_LIST == nTag)
    {
        
        GoodsListEntity *entity = (GoodsListEntity *)netTransObj;
        if (requestStyle == Load_InitStyle || requestStyle == Load_RefrshStyle) {
            self.total = 0;
            [goodsData removeAllObjects];
//            [enoughGoodsData removeAllObjects];
        }

        [goodsData addObjectsFromArray:entity.goodsArray];
        
//        [enoughGoodsData addObjectsFromArray:entity.goodsArray];
//        for (GoodsEntity *goods in entity.goodsArray) {
//            NSString *goodStr = [NSString stringWithFormat:@"%@",goods.out_of_stock];
//            if (![goodStr isEqualToString:@"1"]) {//有货
//                [enoughGoodsData addObject:goods];
//            }
//        }
        if (requestStyle == Load_MoreStyle) {
            if (self.total == goodsData.count) {
                self.dataState = EGOONone;
            }else{
                self.dataState = EGOOHasMore;
            }
        }else{
            if (goodsData.count <10) {
                self.dataState = EGOONone;
            }else{
                self.dataState = EGOOHasMore;
            }
            [self._tableView setContentOffset:CGPointZero];
        }
//        if ( enoughGoods == YES) {//有货
            self.total = goodsData.count;
//        }else{
//            self.total = enoughGoodsData.count;
//        }
        
        [self._tableView reloadData];
        [self finishLoadTableViewData];
        NSString *type = (NSString *)[params objectForKey:@"type"];
        if ([type isEqualToString:@"home_dm"]){
            if (self.total * 110 < SCREEN_HEIGHT - 64-50-35) {
                [self removeFooterView];
            }else{
                [self testFinishedLoadData];
            }
        }else{
            if (goodsData.count * 110 < SCREEN_HEIGHT - 64 -35) {
                [self removeFooterView];
            }else{
                [self testFinishedLoadData];
            }
        }
        
    }else if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
        YHNewOrderViewController *orderCart = [[YHNewOrderViewController alloc] init];
        orderCart.transaction_type = @"1";
        orderCart.goods_id = _goods_id;
        orderCart.total = _total;
        orderCart.immdiateBuy = YES;
        orderCart.entity = (OrderSubmitEntity *)netTransObj;
        [self.navigationController pushViewController:orderCart animated:YES];
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self finishLoadTableViewData];
    self.dataState = EGOOLoadFail;
    [self testFinishedLoadData];
    if (nTag == t_API_PS_GOODS_LIST)
    {
         [[iToast makeText:errMsg]show];
    }
}

#pragma mark ----------- changeCityAction
-(void)changeCityAction {
    
    [self categoryViewIn];
    [self moreViewIn];
    
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    [goodsData removeAllObjects];
//    [enoughGoodsData removeAllObjects];
    [self._tableView reloadData];
    
    //tab1
    [tab1 setTitle:@"全部商品" forState:UIControlStateNormal];
    [params setValue:nil forKey:@"bu_category_id"];//筛选菜单返回了这个参数
    category_type = nil;//筛选菜单返回了这个参数
    
    //tab2
    [checkView removeFromSuperview];
    [moreTab1 addSubview:checkView];
    [tab2 setTitle:@"默认排序" forState:UIControlStateNormal];
    [params setValue:@"default" forKey:@"order"];
    
    //tab3
    enoughGoods = NO;
    [selectView setImage:[UIImage imageNamed:@"check"]];
    [params setValue:@"0" forKey:@"is_stock"];
    
    
    [[PSNetTrans getInstance] buy_getGoodsList:self
                                          type:[params objectForKey:@"type"]
                                     page_type:category_type
                                         bu_id:[params objectForKey:@"bu_id"]
                                   bu_brand_id:[params objectForKey:@"bu_brand_id"]
                                bu_category_id:[params objectForKey:@"bu_category_id"]
                                   bu_goods_id:[params objectForKey:@"bu_goods_id"]
                                         dm_id:[params objectForKey:@"dm_id"]
                                          page:[NSString stringWithFormat:@"%ld",(long)countPage]
                                         limit:@"10"
                                         order:[params objectForKey:@"order"]
                                        tag_id:[params objectForKey:@"tag_id"]
                                        ApiTag:t_API_PS_GOODS_LIST
                                           key:[params objectForKey:@"key"]
                                      is_stock:[params objectForKey:@"is_stock"]];
    
    //刷新筛选菜单
    [categoryView request_type:@"dm_home_goods" bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
}

#pragma mark ----------------------
-(void)requestData {
    [[PSNetTrans getInstance] buy_getGoodsList:self
                                          type:[params objectForKey:@"type"]
                                     page_type:category_type
                                         bu_id:[params objectForKey:@"bu_id"]
                                   bu_brand_id:[params objectForKey:@"bu_brand_id"]
                                bu_category_id:[params objectForKey:@"bu_category_id"]
                                   bu_goods_id:[params objectForKey:@"bu_goods_id"]
                                         dm_id:[params objectForKey:@"dm_id"]
                                          page:[NSString stringWithFormat:@"%ld",(long)countPage]
                                         limit:@"10"
                                         order:[params objectForKey:@"order"]
                                        tag_id:[params objectForKey:@"tag_id"]
                                        ApiTag:t_API_PS_GOODS_LIST
                                           key:[params objectForKey:@"key"]
                                      is_stock:[params objectForKey:@"is_stock"]];
    
//        [[PSNetTrans getInstance] buy_getCategoryGoodsList:self
//                                                 page_type:[params objectForKey:@"type"]
//                                                      type:category_type
//                                               bu_brand_id:[params objectForKey:@"bu_brand_id"]
//                                            bu_category_id:[params objectForKey:@"bu_category_id"]
//                                                       key:[params objectForKey:@"key"]
//                                                    tag_id:[params objectForKey:@"tag_id"]
//                                                      page:[NSString stringWithFormat:@"%ld",(long)countPage]
//                                                     limit:@"10"
//                                                     order:[params objectForKey:@"order"] is_stock:[params objectForKey:@"is_stock"]];
        
    if (requestStyle != Load_MoreStyle) {
        NSString *jump_type = (NSString *)[params objectForKey:@"jump_type"];
        if(![jump_type isEqualToString:@"1"]){
            //首次进入促销页无网络，连接网络后刷新也要调用这个方法，保证分类中有数据
            if ([[params objectForKey:@"type"]isEqualToString:@"home_dm"]) {
                [categoryView request_type:@"dm_home_goods" bu_brand_id:[params objectForKey:@"bu_brand_id"] tag_id:[params objectForKey:@"tag_id"] key:[params objectForKey:@"key"]];
            }
        }
    }
}

@end
