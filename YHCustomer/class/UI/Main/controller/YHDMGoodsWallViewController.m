//
//  YHDMGoodsWallViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  促销－关联商品－cell（2个商品关联）

#import "YHDMGoodsWallViewController.h"
#import "YHDMGoodsWallCell.h"
#import "GoodsEntity.h"
#import "CommentShareView.h"
#import "YHCartViewController.h"
#import "YHGoodsDetailViewController.h"
#import "YHCommentViewController.h"
#import "YHNewOrderViewController.h"

@interface YHDMGoodsWallViewController(){
    NSString * _goods_id;
    NSString * _total;
}

@end
@implementation YHDMGoodsWallViewController{
    YHCartView *cartView;
    NSMutableArray *goodsList;
    NSMutableArray *formatDataArray;
}
@synthesize dm_Entity;
@synthesize fromMyCollect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        goodsList = [[NSMutableArray alloc] init];
        formatDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [super viewWillAppear:animated];
    if (cartView) {
        [cartView changeCartNum];
    }
    
    if (fromMyCollect == YES) {
        [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:nil];
    }else{
        if ([[UserAccount instance] isLogin]) {
            [[NetTrans getInstance] buy_collectStatus:self Type:@"dm" DM_id:self.dm_Entity.dm_id];
        }else{
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collected" SelectImg:nil];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    self.view.backgroundColor =  [PublicMethod colorWithHexValue1:dm_Entity.background_color];
    self.navigationItem.title = self.dm_Entity.title;
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"", @selector(back:));
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];

    [self setTableView];
    [self addCartView];
    [self addTableViewFoot];
    [self initRequest];
}


// 收藏
- (void)collectAction:(id)sender{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    [MTA trackCustomKeyValueEvent :EVENT_ID1 props:nil];
    [[NetTrans getInstance] buy_collectPromotion:self Type:@"dm" DM_id:dm_Entity.dm_id];
}

- (void)setTableView{
    self._tableView.backgroundColor = [UIColor clearColor];
    self._tableView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height- NAVBAR_HEIGHT - 49);
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self._tableView.tableHeaderView = [self addTableViewHeaderView];
    [self addRefreshTableFooterView];
}

- (void)addCartView{
    cartView = [[YHCartView alloc] initWithFrame:CGRectMake(230, SCREEN_HEIGHT-44-124 -40, 54, 54)];
    cartView.delegate =  self;
    [self.view addSubview:cartView];
}

#pragma -mark
#pragma -CartViewDelegate
- (void)cartViewClickAction{
    if ([[YHAppDelegate appDelegate] checkLogin]) {
        YHCartViewController *cart = [[YHCartViewController alloc] init];
        cart.isFromOther = YES;
        [self.navigationController pushViewController:cart animated:YES];
    }
}

- (void)addTableViewFoot{
//    CommentShareView *commentShare = [[CommentShareView alloc] initCommentShareView:CGRectMake(0, ScreenSize.height - NAVBAR_HEIGHT - 49, ScreenSize.width, 49) Dm_ID:dm_Entity.dm_id CommentButtonBlock:^(NSString *dm_id){
//       // 跳转到评论（dm）
//        YHCommentViewController *commentVC = [[YHCommentViewController alloc]init];
//        [commentVC setCommentListDataAndType:dm_id Type:PROMOTION_COMMENT_LIST IsBought:YES];
//        [self.navigationController pushViewController:commentVC animated:YES];
//
//    }];
    CommentShareView *commentShare = [[CommentShareView alloc]initCommentShareView:CGRectMake(0, ScreenSize.height - NAVBAR_HEIGHT - 49, ScreenSize.width, 49) viewController:self Dm_ID:dm_Entity.dm_id CommentButtonBlock:^(NSString *dm_id){
        [MTA trackCustomKeyValueEvent :EVENT_ID3 props:nil];
        YHCommentViewController *commentVC = [[YHCommentViewController alloc]init];
        [commentVC setCommentListDataAndType:dm_id Type:PROMOTION_COMMENT_LIST IsBought:YES];
        [self.navigationController pushViewController:commentVC animated:YES];
    }];
    [self.view addSubview:commentShare];
}

- (void)initRequest{
    countPage = 1;
    requestStyle = Load_InitStyle;
    self.dataState = EGOOHasMore;
    [self requestWithPage:countPage];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestWithPage:(NSInteger)coutPage1{
    [[PSNetTrans getInstance] buy_getGoodsList:self type:@"dm" page_type:nil bu_id:dm_Entity.bu_id bu_brand_id:nil bu_category_id:nil bu_goods_id:nil dm_id:dm_Entity.dm_id page:[NSString stringWithFormat:@"%ld",(long)coutPage1] limit:@"5" order:@"default" tag_id:nil  ApiTag:t_API_BUY_PLATFORM_GOODS_LIST key:nil is_stock:@"0"];
}

- (UIView *)addTableViewHeaderView{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    bg.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    [image setImageWithURL:[NSURL URLWithString:self.dm_Entity.image_url] placeholderImage:[UIImage imageNamed:@"dm_default"]];
    [bg addSubview:image];
    
    CGFloat height = 0;
    if (self.dm_Entity._description && ![self.dm_Entity._description isEqualToString:@""]) {
        UILabel *title = [PublicMethod addLabel:CGRectMake(10, 122, SCREEN_WIDTH-20 , 32) setTitle:self.dm_Entity._description setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        CGSize size = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width, 999) lineBreakMode:NSLineBreakByWordWrapping];
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, size.height);
        [bg addSubview:title];
        height = title.frame.size.height;
    }
    bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 122 +height);
    return bg;
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return formatDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    YHDMGoodsWallCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[YHDMGoodsWallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setCellWithGoodsEntity:[formatDataArray objectAtIndex:indexPath.row] DMGoodsBlock:^(GoodsEntity *entity){
        [self goodsViewTapClicked:entity];
    } DMGoodsAddCartBlock:^(GoodsEntity *entity){
        [self addCartButtonClicked:entity];
    }];
    return cell;
}

// 点击cell中商品
- (void)goodsViewTapClicked:(GoodsEntity *)entity{
    YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    detaiVC.url = url;
    [detaiVC setMainGoodsUrl:url goodsID:entity.goods_id];
    [self.navigationController pushViewController:detaiVC animated:YES];
}

// 点击cell中商品 中购物车按钮
- (void)addCartButtonClicked:(GoodsEntity *)entity{
    if ([[YHAppDelegate appDelegate] checkLogin]) {
        //加入购物车
        if (entity.transaction_type.integerValue == 0){
            [[NetTrans getInstance] addCart:self GoodsID:entity.goods_id Total:@"1"];
        }//立即购买
        else{
            _goods_id = entity.goods_id;
            _total = @"1";
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:entity.goods_id total:@"1"];
        }

    }
}

// 下拉刷新
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    self.dataState = EGOOHasMore;
    [self requestWithPage:countPage];
}

//  加载更多
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    [self requestWithPage:countPage];
}

- (void)convertDataArrayToFormat:(NSMutableArray *)inputDataArray{
    for (int i = 0; i < inputDataArray.count; i = i + 2) {
        NSMutableArray *arrayOneCell = [NSMutableArray array];
        NSLog(@"i = %d",i);
        GoodsEntity *oneGoods = [inputDataArray objectAtIndex:i];
        if (i == inputDataArray.count - 1) {
            [arrayOneCell addObject:oneGoods];
        }else{
            GoodsEntity *oneGoods1 = [inputDataArray objectAtIndex:i+1];
            [arrayOneCell addObject:oneGoods];
            [arrayOneCell addObject:oneGoods1];
        }
        [formatDataArray addObject:arrayOneCell];
    }
    
    [self._tableView reloadData];
//    [self testFinishedLoadData];
    [self finishLoadTableViewData];
    if (self.total < 3) {
        [self removeFooterView];
    }else{
        [self testFinishedLoadData];
    }
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_BUY_PLATFORM_GOODS_LIST == nTag)
    {
        GoodsListEntity *goodListEntity = (GoodsListEntity *)netTransObj;
        [formatDataArray removeAllObjects];

        if (requestStyle != Load_MoreStyle) {
            [goodsList removeAllObjects];
            [goodsList addObjectsFromArray: goodListEntity.goodsArray];
        }else{
            [goodsList addObjectsFromArray: goodListEntity.goodsArray];
        }
        
        if (requestStyle == Load_MoreStyle) {
            if (self.total == goodsList.count) {
                self.dataState = EGOONone;
            }else{
                self.dataState = EGOOHasMore;
            }
        }else{
            
        }
        self.total = goodsList.count;
        [self convertDataArrayToFormat:goodsList];
    }
    if (t_API_ADDCART_GOODS == nTag) {
        [[iToast makeText:@"添加到购物车成功"]show];
        [cartView changeCartNum];
    }
 
    if (nTag == t_API_BUY_PLATFORM_PROMOTION_COLLECT) {
        NSNumber *collectStatus = (NSNumber *)netTransObj;
        if ([collectStatus integerValue] == 1) {
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collected" SelectImg:nil];
            [self showNotice:@"收藏成功!"];
        }
        if ([collectStatus integerValue] == 0) {
            [self showNotice:@"取消收藏成功!"];
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:nil];
        }
    }
    
    if (nTag == t_API_BUY_PLATFORM_DM_COLLECT_STATUS) {
        NSNumber *collectStatus = (NSNumber *)netTransObj;
        if ([collectStatus integerValue] == 1) {
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collected" SelectImg:nil];
        }
        if ([collectStatus integerValue] == 0) {
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:nil];
        }
    }
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
        YHNewOrderViewController *orderCart = [[YHNewOrderViewController alloc] init];
        orderCart.transaction_type = @"1";
        orderCart.goods_id = _goods_id;
        orderCart.total = _total;
        orderCart.immdiateBuy = YES;
        orderCart.entity = (OrderSubmitEntity *)netTransObj;
        [self.navigationController pushViewController:orderCart animated:YES];
    }
    [self finishLoadTableViewData];
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [self finishLoadTableViewData];
    if (nTag == t_API_ADDCART_GOODS)
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
    else if (nTag == t_API_BUY_PLATFORM_PROMOTION_COLLECT)
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
    else if (nTag == t_API_BUY_PLATFORM_DM_COLLECT_STATUS)
    {
        
    }
    [[iToast makeText:errMsg]show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
