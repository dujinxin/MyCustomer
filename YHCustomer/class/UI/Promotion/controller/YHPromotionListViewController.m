//
//  YHPromotionListViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHPromotionListViewController.h"
#import "GoodsEntity.h"
#import "UILabelStrikeThrough.h"
#import "YHPromotionListCell.h"
#import "YHGoodsDetailViewController.h"
#import "YHCartViewController.h"
#import "CommentShareView.h"
#import "YHCommentViewController.h"
#import "YHNewOrderViewController.h"

@interface YHPromotionListViewController ()
{
    NSString * _goods_id;
    NSString * _total;
}
@end

@implementation YHPromotionListViewController
@synthesize fromMyCollect;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       countPage = 1;
        goodsData = [NSMutableArray array];
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
    
     self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
   
    self.navigationItem.title = self.dmEntity.title;
    
    self._tableView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    self._tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    self._tableView.separatorColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [self addRefreshTableFooterView];
    
    [self setHeadView];
    [self addFootView];
    [self addCartView];
    
    [[PSNetTrans getInstance]buy_getGoodsList:self type:@"dm" page_type:nil bu_id:@"0" bu_brand_id:nil bu_category_id:nil bu_goods_id:nil dm_id:self.dmEntity.dm_id page:[NSString stringWithFormat:@"%ld",(long)countPage] limit:@"10" order:@"default" tag_id:nil ApiTag:t_API_PS_DM_LIST key:nil is_stock:@"0"];
    
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
    //    UIImage * image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:promotionShareEntity.qr_code_src]]];
    if ([defautls objectForKey:@"codeImage"]) {
        NSLog(@"codeImage:%@",[defautls objectForKey:@"codeImage"]);
        
    }

}


// 收藏
- (void)collectAction:(id)sender{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    [MTA trackCustomKeyValueEvent :EVENT_ID1 props:nil];
    [[NetTrans getInstance] buy_collectPromotion:self Type:@"dm" DM_id:self.dmEntity.dm_id];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
    [[YHAppDelegate appDelegate] hideTabBar:YES];
    if (cartView) {
        [cartView changeCartNum];
    }
    
    if (fromMyCollect == YES)
    {
        [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collected" SelectImg:nil];
    }else{
        
        if ([[UserAccount instance] isLogin])
        {
            
            [[NetTrans getInstance] buy_collectStatus:self Type:@"dm" DM_id:self.dmEntity.dm_id];
        }else{
            [self setRightBarButton:self Action:@selector(collectAction:) SetImage:@"right_collecting" SelectImg:nil];
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [[YHAppDelegate appDelegate] hideTabBar:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------------  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsEntity *entity = (GoodsEntity *)[goodsData objectAtIndex:indexPath.row];
    CGSize size ;
    size = [entity.goods_name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(210, 40) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 20 && (entity.goods_introduction && entity.goods_introduction.length != 0) && (entity.is_or_not_salse.integerValue == 1 || entity.limit_the_purchase_type.integerValue != 0))
        return 130;
    else
        return 110;
}

#pragma mark ------------------------    UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    YHPromotionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[YHPromotionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBgColor:self.dmEntity.background_color];
        
        __unsafe_unretained YHPromotionListViewController *vc = self;
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

    GoodsEntity *entity = (GoodsEntity *)[goodsData objectAtIndex:indexPath.row];
    [cell setGoodsCellData:entity];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [goodsData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsEntity *entity ;
    //= [[GoodsEntity alloc]init];
    entity = [goodsData objectAtIndex:indexPath.row];
    
    
    YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    detaiVC.url = url;
    [detaiVC setMainGoodsUrl:url goodsID:entity.goods_id];
    [self.navigationController pushViewController:detaiVC animated:YES];
}

#pragma mark ------------------  UI  
-(void)setHeadView {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90+32)];
    bg.backgroundColor = [PublicMethod colorWithHexValue1:self.dmEntity.background_color];
    bg.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    bg.layer.borderWidth = 0.5;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    [image setImageWithURL:[NSURL URLWithString:self.dmEntity.image_url] placeholderImage:[UIImage imageNamed:@"default_640X180"]];
    [bg addSubview:image];
    
    CGFloat height = 0;
    if (self.dmEntity._description && ![self.dmEntity._description isEqualToString:@""]) {
        UILabel *title = [PublicMethod addLabel:CGRectMake(10, 122, SCREEN_WIDTH -20, 32) setTitle:self.dmEntity._description setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
        if (self.dmEntity.background_color.length != 0) {
            title.backgroundColor = [PublicMethod colorWithHexValue1:self.dmEntity.background_color];
        }else{
            title.backgroundColor = [UIColor clearColor];
        }
        
        title.textAlignment = NSTextAlignmentLeft;
        CGSize size = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(title.frame.size.width, 999) lineBreakMode:NSLineBreakByWordWrapping];
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, size.height);
        [bg addSubview:title];
        height = title.frame.size.height;
    }
    bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 122 +height);

    [self._tableView setTableHeaderView:bg];
}

-(void)addCartView {
    cartView = [[YHCartView alloc] initWithFrame:CGRectMake(260, SCREEN_HEIGHT-44-124 -40, 54, 54)];
    cartView.delegate =  self;
    [self.view addSubview:cartView];
}

-(void)addFootView {
//    CommentShareView *commentShare = [[CommentShareView alloc] initCommentShareView:CGRectMake(0, ScreenSize.height - NAVBAR_HEIGHT - 49, ScreenSize.width, 49) Dm_ID:self.dmEntity.dm_id CommentButtonBlock:^(NSString *dm_id){
//        // 跳转到评论（dm）
//        YHCommentViewController *commentVC = [[YHCommentViewController alloc]init];
//        [commentVC setCommentListDataAndType:dm_id Type:PROMOTION_COMMENT_LIST IsBought:YES];
//        [self.navigationController pushViewController:commentVC animated:YES];
//        
//    }];
//    [self.view addSubview:commentShare];
    CommentShareView * commentShare = [[CommentShareView alloc] initCommentShareView:CGRectMake(0, ScreenSize.height - NAVBAR_HEIGHT - 49, ScreenSize.width, 49) viewController:self Dm_ID:self.dmEntity.dm_id CommentButtonBlock:^(NSString *dm_id) {
        YHCommentViewController *commentVC = [[YHCommentViewController alloc]init];
        [commentVC setCommentListDataAndType:dm_id Type:PROMOTION_COMMENT_LIST IsBought:YES];
        [self.navigationController pushViewController:commentVC animated:YES];
    }];
    [self.view addSubview:commentShare];
}
//-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    //
//    //    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
//    //    NSData * data =[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.qr_code_src]];
//    //    [defautls setObject:data forKey:@"codeImage"];
//    //    [defautls synchronize];
//    if (buttonIndex == 0) {
////        UIImage * image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.qr_code_src]]];
////        //    将图片写入相册
////        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
//       NSLog(@"baocun");
//    }
//    
//}

#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    countPage = 1;
    self.dataState = EGOOHasMore;
    requestStyle = Load_RefrshStyle;
 
    [[PSNetTrans getInstance]buy_getGoodsList:self type:@"dm" page_type:nil bu_id:@"0" bu_brand_id:nil bu_category_id:nil bu_goods_id:nil dm_id:self.dmEntity.dm_id page:[NSString stringWithFormat:@"%ld",(long)countPage] limit:@"10" order:@"default" tag_id:nil ApiTag:t_API_PS_DM_LIST key:nil is_stock:@"0"];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
	_reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    
    [[PSNetTrans getInstance]buy_getGoodsList:self type:@"dm" page_type:nil bu_id:@"0" bu_brand_id:nil bu_category_id:nil bu_goods_id:nil dm_id:self.dmEntity.dm_id page:[NSString stringWithFormat:@"%ld",(long)countPage] limit:@"10" order:@"default" tag_id:nil ApiTag:t_API_PS_DM_LIST key:nil is_stock:@"0"];
    NSLog(@"getMore start requestInterface.");
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(t_API_PS_DM_LIST == nTag)
    {
        GoodsListEntity *entity = (GoodsListEntity *)netTransObj;
        if (requestStyle == Load_RefrshStyle) {
            [goodsData removeAllObjects];
            self.total = 0;
        }
        [goodsData addObjectsFromArray:entity.goodsArray];
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
        }
        self.total = goodsData.count;
        [self._tableView reloadData];
        [self testFinishedLoadData];
        [self finishLoadTableViewData];
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
    }else if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
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
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self finishLoadTableViewData];
    [[iToast makeText:errMsg]show];
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


@end
