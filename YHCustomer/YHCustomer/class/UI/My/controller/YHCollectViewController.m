//
//  YHCollectViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-1-20.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHCollectViewController.h"
#import "GoodsEntity.h"
#import "YHCollectGoodsCell.h"
#import "PromotionEntity.h"
#import "DmEntity.h"
#import "YHPrommotionDetailController.h"
#import "YHGoodsDetailViewController.h"
#import "YHPromotionListViewController.h"
#import "YHPromotionListViewController.h"
#import "YHDMGoodsWallViewController.h"
#import "YHTabButton.h"
#import "YHNewOrderViewController.h"

@interface YHCollectViewController ()
{
    UIView * tabBgView;
    UIView * xline;
    
    NSString * _goods_id;
    NSString * _total;
}
@end

@implementation YHCollectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"我的收藏";
        collectType = GoodsType;
        dmDataArray = [[NSMutableArray alloc] init];
        goodsDataArray = [[NSMutableArray alloc] init];
        
        countPage = 1;
        self.view.backgroundColor = LIGHT_GRAY_COLOR;
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    [self addNavigationBackButton];
//    [self addCollectBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTabView];
    self._tableView.frame = CGRectMake(0, 38, SCREEN_WIDTH, ScreenSize.height - NAVBAR_HEIGHT  - 38);
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self._tableView.backgroundColor = LIGHT_GRAY_COLOR;
    [self addRefreshTableFooterView];
    
    resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    resultImage.image = [UIImage imageNamed:@"collect_default"];
    [self.view addSubview: resultImage];
    resultImage.hidden = YES;
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -38)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xft.duoduofish.com/collectionList"]]];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.bounces = NO;
    [webView setHidden:YES];
    [self.view addSubview:webView];
    
    [self addCartView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE12];
    [self requestWithType:collectType];
    
    if (cartView) {
        [cartView changeCartNum];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE12];
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
-(void)addNavigationBackButton
{
    self.navigationItem.leftBarButtonItems= BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
}

- (void)addCollectBtn{
    dmBtn = [PublicMethod addButton:CGRectMake(161, 0, 160, 35) title:@"活动收藏" backGround:@"unselected_indicator_front.png" setTag:1000 setId:self selector:@selector(buttonClickTag:) setFont:[UIFont systemFontOfSize:12] setTextColor:[UIColor lightGrayColor]];
    
    goodsBtn = [PublicMethod addButton:CGRectMake(0, 0, 160, 35) title:@"商品收藏" backGround:@"selected_indicator_front.png" setTag:1001 setId:self selector:@selector(buttonClickTag:) setFont:[UIFont systemFontOfSize:12] setTextColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0]];
    [self.view addSubview:dmBtn];
    [self.view addSubview:goodsBtn];
}
- (void)addTabView{
    tabBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    [self.view addSubview:tabBgView];
    
    //红色横线
    xline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.f - 40, 36, 80, 2)];
    xline.backgroundColor = [UIColor redColor];
    
    
    NSArray * titleArray = [NSArray arrayWithObjects:@"商品收藏",@"活动收藏",@"菜谱收藏",nil];
    
    for (int i = 0 ; i < 3 ; i ++ ) {
        
        YHTabButton * btn = [[YHTabButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/3.f)* i, 0, SCREEN_WIDTH/3.f , 38) title:[titleArray objectAtIndex:i] image:[UIImage imageNamed:@"arrow_selected"]];
        [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [btn.titleView setHidden:YES];
        [btn.imageView setHidden:YES];
        btn.tag = 100 + i;
        btn.titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
        //竖线
        if (i < 2) {
            UIView *yline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0f -1, 10, 1, 18)];
            yline.backgroundColor = [PublicMethod colorWithHexValue:0xb7b7b7 alpha:1.0];
            [btn addSubview:yline];
        }
        if (i == 0) {
            [btn addSubview:xline];
        }
        [tabBgView addSubview:btn];
    }
    
    UIView *line_sep = [[UIView alloc]initWithFrame:CGRectMake(0,37, 320, 1)];
    line_sep.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [tabBgView addSubview:line_sep];
}
-(void)addCartView {
    cartView = [[YHCartView alloc] initWithFrame:CGRectMake(260, SCREEN_HEIGHT-44-124, 54, 54)];
    cartView.delegate =  self;
    [self.view addSubview:cartView];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tabAction:(UIButton *)button{
    
    YHTabButton * btn = (YHTabButton *)button;
    [xline removeFromSuperview];
    [btn addSubview:xline];
    switch (btn.tag) {
        case 100:{
            
            collectType = GoodsType;
            [dmBtn setBackgroundImage:[UIImage imageNamed:@"unselected_indicator_front.png"] forState:UIControlStateNormal];
            [dmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [goodsBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
            [goodsBtn setBackgroundImage:[UIImage imageNamed:@"selected_indicator_front.png"] forState:UIControlStateNormal];
            [webView setHidden:YES];
            [cartView setHidden:NO];
            
        }
            break;
        case 101:{
            collectType = DmType;
            [dmBtn setBackgroundImage:[UIImage imageNamed:@"selected_indicator_front.png"] forState:UIControlStateNormal];
            [dmBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
            [goodsBtn setBackgroundImage:[UIImage imageNamed:@"unselected_indicator_front.png"] forState:UIControlStateNormal];
            [goodsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [webView setHidden:YES];
            [cartView setHidden:YES];
        }
            break;
        case 102:{
            [webView setHidden:NO];
            [cartView setHidden:YES];
        }
            break;
        default:
            break;
    }
    [self requestWithType:collectType];
}
- (void)buttonClickTag:(id)sender{
    requestStyle = Load_RefrshStyle;
    [dmDataArray removeAllObjects];
    [goodsDataArray removeAllObjects];
    
//    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self._tableView reloadData];
    countPage = 1;
    UIButton *btn = (UIButton *)sender;
    if (btn == dmBtn) {
        collectType = DmType;
        [dmBtn setBackgroundImage:[UIImage imageNamed:@"selected_indicator_front.png"] forState:UIControlStateNormal];
        [dmBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [goodsBtn setBackgroundImage:[UIImage imageNamed:@"unselected_indicator_front.png"] forState:UIControlStateNormal];
        [goodsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [cartView setHidden:YES];
    }else{
        collectType = GoodsType;
        [dmBtn setBackgroundImage:[UIImage imageNamed:@"unselected_indicator_front.png"] forState:UIControlStateNormal];
        [dmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [goodsBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [goodsBtn setBackgroundImage:[UIImage imageNamed:@"selected_indicator_front.png"] forState:UIControlStateNormal];
        
        [cartView setHidden:NO];
    }
    [self requestWithType:collectType];
}

#pragma mark ----------------  request data
- (void)requestWithType:(CollectType) type{
    if (type == DmType) {
        [[NetTrans getInstance] getPromotionCollectList:self page:countPage limit:10 region_id:[UserAccount instance].region_id];
    }else if(type == GoodsType){
        [[NetTrans getInstance] getGoodsCollectList:self page:countPage limit:10 region_id:[UserAccount instance].region_id type:@"user_collect"];
    }else{
        
    }
}

#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (collectType == DmType) {
        return [dmDataArray count];
    } else {
        return [goodsDataArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    YHCollectGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil)
    {
        cell = [[YHCollectGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (collectType == DmType) {
        
        DmEntity *entity = [[DmEntity alloc]init];
        entity = [dmDataArray objectAtIndex:indexPath.row];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDmCellData:entity];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        
        GoodsEntity *entity = [[GoodsEntity alloc]init];
        entity = [goodsDataArray objectAtIndex:indexPath.row];
        
        
        [cell setGoodsCellData:entity];
        
        __unsafe_unretained YHCollectViewController *vc = self;
        cell.cartBlock = ^(NSString * goods_id,NSString * total){
            if (goods_id && total) {
                vc->_goods_id = goods_id;
                vc->_total = total;
                [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:goods_id total:total];
            }else{
                [vc->cartView changeCartNum];
            }
        };
        
        cell.collectBlock = ^(){
            countPage = 1;
            [goodsDataArray removeAllObjects];
            [dmDataArray removeAllObjects];
            [vc._tableView reloadData];
            [vc requestWithType:collectType];
            [[NetTrans getInstance] getCartGoodsNum:vc];
        };
        
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return cell;
}

#pragma mark -------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (collectType == DmType) {
        
        DmEntity *entity1 = [[DmEntity alloc]init];
        entity1 = [dmDataArray objectAtIndex:indexPath.row];
        
        
        if (![entity1.region_id isEqualToString:[UserAccount instance].region_id]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您目前在%@站，要操作%@收藏的活动，请点击'切换城市'，将为您切换到%@站!",[UserAccount instance].location_CityName,entity1.region_name,entity1.region_name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"切换城市", nil];
            alert.tag = 1000;
            
            [alert show];
            
            region_id = entity1.region_id;
            region_name = entity1.region_name;
            return;
        }
        
        [self dmJumpLogic:entity1];
        
    } else {
        
        GoodsEntity *entity = [[GoodsEntity alloc]init];
        entity = [goodsDataArray objectAtIndex:indexPath.row];
        
        if (![entity.region_id isEqualToString:[UserAccount instance].region_id]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您目前在%@站，要操作%@收藏的活动，请点击'切换城市'，将为您切换到%@站!",[UserAccount instance].location_CityName,entity.region_name,entity.region_name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"切换城市", nil];
            alert.tag = 1000;
            
            [alert show];
            
            region_id = entity.region_id;
            region_name = entity.region_name;
            return;
        }
        
        YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
        NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
        detaiVC.url = url;
        [detaiVC setMainGoodsUrl:url goodsID:entity.goods_id];
        [self.navigationController pushViewController:detaiVC animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (collectType == DmType) {
        return 122.5+20;
    } else {
        GoodsEntity *entity;
        entity = (GoodsEntity *)[goodsDataArray objectAtIndex:indexPath.row];
        CGSize size ;
        size = [entity.goods_name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(215, 40) lineBreakMode:NSLineBreakByWordWrapping];
        if (size.height > 20) {
            return 130;
        }else{
            return 110;
        }
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectType == DmType) {
        
        DmEntity *entity = [[DmEntity alloc]init];
        entity = [dmDataArray objectAtIndex:indexPath.row];
        
        NSString *dmID = entity.dm_id;;
        [[NetTrans getInstance] buy_collectPromotion:self Type:@"dm" DM_id:dmID];
    } else {
        
        GoodsEntity *entity = [[GoodsEntity alloc]init];
        entity = [goodsDataArray objectAtIndex:indexPath.row];
        
        [[NetTrans getInstance] buy_collectPromotion:self Type:@"goods" DM_id:entity.goods_id];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
            listVC.fromMyCollect = YES;
            [self.navigationController pushViewController:listVC animated:YES];
            
        } else {//1为瀑布流模式
            
            YHDMGoodsWallViewController *goodWall = [[YHDMGoodsWallViewController alloc] init];
            goodWall.dm_Entity = entity;
            goodWall.fromMyCollect = YES;
            
            [self.navigationController pushViewController:goodWall animated:YES];
            
        }
        
    }
    
}


#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
    
    _moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    self.dataState = EGOOHasMore;
    
    [self requestWithType:collectType];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    [self requestWithType:collectType];
    
    NSLog(@"getMore start requestInterface.");
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    
    if(t_API_PROMOTION_COLLECT_LIST == nTag)
    {
        
        NSMutableArray *data = (NSMutableArray *)netTransObj;
        [self setData:nTag withData:data];
    }else if (t_API_GOODS_COLLECT_LIST == nTag) {
        
        GoodsListEntity *goods = (GoodsListEntity *)netTransObj;
        [self setData:nTag withData:goods.goodsArray];
    }else if (t_API_BUY_PLATFORM_PROMOTION_COLLECT == nTag) {
        countPage = 1;
        requestStyle = Load_RefrshStyle;
        [self requestWithType:collectType];
    } else if (t_API_BUY_PLATFORM_GOODS_COLLECT == nTag) {
        countPage = 1;
        requestStyle = Load_RefrshStyle;
        [self requestWithType:collectType];
    }else if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
        YHNewOrderViewController *orderCart = [[YHNewOrderViewController alloc] init];
        orderCart.transaction_type = @"1";
        orderCart.goods_id = _goods_id;
        orderCart.total = _total;
        orderCart.immdiateBuy = YES;
        orderCart.entity = (OrderSubmitEntity *)netTransObj;
        [self.navigationController pushViewController:orderCart animated:YES];
    }
    //    [self finishLoadTableViewData];
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
    [dmDataArray removeAllObjects];
    [goodsDataArray removeAllObjects];
    [self._tableView reloadData];
    
    if ([status isEqualToString:WEB_STATUS_3])
    {
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
    }
}

-(void)setData:(int)tag withData:(NSMutableArray *)data{
    if (data != nil) {
        if (tag == t_API_PROMOTION_COLLECT_LIST) {
            if (requestStyle != Load_MoreStyle) {
                [dmDataArray removeAllObjects];
                if ([data count] == 0) {
                    [resultImage setHidden:NO];
                    [self._tableView setHidden:YES];
                    return;
                }
                [resultImage setHidden:YES];
                [self._tableView setHidden:NO];
                self.total = data.count;
                if (self.total <10) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }
            [dmDataArray addObjectsFromArray:data];
            if (requestStyle == Load_MoreStyle) {
                if (self.total == dmDataArray.count) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }else{
                if (dmDataArray.count <10) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }
            self.total = dmDataArray.count;
        } else {
            if (requestStyle != Load_MoreStyle) {
                [goodsDataArray removeAllObjects];
                if ([data count] == 0) {
                    [resultImage setHidden:NO];
                    [self._tableView setHidden:YES];
                    return;
                }
                [resultImage setHidden:YES];
                [self._tableView setHidden:NO];
                self.total = data.count;
                if (self.total <10) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }
            [goodsDataArray addObjectsFromArray:data];
            if (requestStyle == Load_MoreStyle) {
                if (self.total == goodsDataArray.count) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }else{
                if (goodsDataArray.count <10) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }
            self.total = goodsDataArray.count;
            
            
        }
        [self._tableView reloadData];
        //        [self testFinishedLoadData];
        [self finishLoadTableViewData];
    }
    if (collectType == DmType) {
        if (self.total * (122.5+20) < SCREEN_HEIGHT - 64-50-35) {
            [self removeFooterView];
        }else{
            [self testFinishedLoadData];
        }
    } else {
        if (self.total * 110 < SCREEN_HEIGHT - 64-50-35) {
            [self removeFooterView];
        }else{
            [self testFinishedLoadData];
        }
    }
}

#pragma mark ------------  CartViewDelegate
-(void)cartViewClickAction {
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    YHCartViewController *cart = [[YHCartViewController alloc] init];
    cart.isFromOther = YES;
    [self.navigationController pushViewController:cart animated:YES];
}

#pragma mark ----------------------------------------------------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000 && buttonIndex == 1) {
        
        [UserAccount instance].region_id = region_id;
        [UserAccount instance].location_CityName = region_name;
        [[UserAccount instance] saveAccount];
        
        
        countPage = 1;
        [goodsDataArray removeAllObjects];
        [dmDataArray removeAllObjects];
        [self._tableView reloadData];
        [self requestWithType:collectType];
        [[NetTrans getInstance] getCartGoodsNum:self];
        
    }
}

@end
