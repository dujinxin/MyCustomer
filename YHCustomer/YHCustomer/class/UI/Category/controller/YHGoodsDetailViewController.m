//
//  YHGoodsDetailViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  商品详情页面

#import "YHGoodsDetailViewController.h"
#import "YHCartViewController.h"
#import "GoodsStatusEntity.h"
#import "YHCommentViewController.h"
#import "GoodShareEntity.h"
#import "YHNewOrderViewController.h"
@interface YHGoodsDetailViewController ()
{

    GoodShareEntity *goodShareEntity;
    NSString * _goods_id;
    NSString * _total;

}
@end

@implementation YHGoodsDetailViewController
@synthesize url;
@synthesize bu_goods_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
        isBuy = @"0";
        isLogin = [[UserAccount instance] isLogin];
        isOutOfStocks = YES;
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    [self addWebView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MTA trackPageViewBegin:PAGE5];
    self.navigationItem.title = @"商品详情";
    
//    [self addRightNav];
    
    
    [self loadRequest];

}
-(void)addRightNav
{
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn1 setImage:[UIImage imageNamed:@"right_collecting"] forState:UIControlStateNormal];
//    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"category_Collect.png"] forState:UIControlStateNormal];
//    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"category_Collect_Select.png" ] forState:UIControlStateHighlighted];
    [rightBtn1 addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(52, 0, 30, 30);
    [rightBtn2 setImage:[UIImage imageNamed:@"right_share"] forState:UIControlStateNormal];
//    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
//    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"icon_share.png" ] forState:UIControlStateHighlighted];
    [rightBtn2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn2];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
//    if (IOS_VERSION >= 7) {
//        negativeSpacer.width = -15;
//    }else{
//        negativeSpacer.width = -5;
//    }
    NSMutableArray *buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,rightBarItem,negativeSpacer,rightBarItem1,nil];
    self.navigationItem.rightBarButtonItems = buttonArray;

}
-(void)addCollectRight
{
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn1 setImage:[UIImage imageNamed:@"right_collected"] forState:UIControlStateNormal];
//    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"category_Collect_Cancel.png"] forState:UIControlStateNormal];
//    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"category_CancelCollect_Select.png" ] forState:UIControlStateHighlighted];
    [rightBtn1 addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(52, 0, 30, 30);
    [rightBtn2 setImage:[UIImage imageNamed:@"right_share"] forState:UIControlStateNormal];
//    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    //    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"icon_share.png" ] forState:UIControlStateHighlighted];
    [rightBtn2 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn2];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
//    if (IOS_VERSION >= 7) {
//        negativeSpacer.width = -15;
//    }else{
//        negativeSpacer.width = -5;
//    }
    NSMutableArray *buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,rightBarItem,negativeSpacer,rightBarItem1,nil];
    self.navigationItem.rightBarButtonItems = buttonArray;





}
-(void)shareAction:(id)sender{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    NSLog(@"%@",self.bu_goods_id);
    [[NetTrans getInstance]goods_share:self bu_goods_id:self.bu_goods_id];




}
- (void)collectAction:(id)sender{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    [[NetTrans getInstance] buy_collectPromotion:self Type:@"goods" DM_id:self.bu_goods_id];
    [MTA trackCustomKeyValueEvent:EVENT_ID4 props:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [[NetTrans getInstance] API_goods_status_func:self GoodsID:self.bu_goods_id];
    [[NetTrans getInstance] API_goods_isOutOfStock:self GoodsID:self.bu_goods_id];
    
    if ([[UserAccount instance] isLogin]) {

        if (!isLogin)
        {//之前未登录，“加入购物车”登录后，刷新详情购物车等状态
            isLogin = YES;
            self.url = [NSString stringWithFormat:GOODS_DETAIL,self.bu_goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            [self addWebView];
            [self loadRequest];
        }
  
        [[NetTrans getInstance] buy_collectStatus:self Type:@"goods" DM_id:self.bu_goods_id];
    }else{
        //1
//        [self addRightNav];
    }
    
//    [self loadRequest];
//    [webView reload];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE5];
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
-(void)addWebView
{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, SCREEN_HEIGHT)];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

#pragma mark ---------------------- 数据获取
- (void)loadRequest
{
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:requestObj];
}

#pragma mark-
#pragma mark -UIWebViewDelegate

#pragma mark --------------------------webView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"type:%ld",(long)navigationType);
    NSString *requestString = [[request URL] absoluteString];
    NSString *decode =[requestString URLDecodeString];
    if([decode rangeOfString:@"#myrainbowparams#"].length > 0)
    {
        NSString *finalStr = [decode getJsonStrWithOutHttpBySeprateStr:@"#myrainbowparams#"];
        NSString *urlStr = [decode getGoodUrlWithParmer:@"#myrainbowparams#"];
        NSDictionary *paramDic = [finalStr objectFromJSONString];
        BOOL isSkip = [self webRequestStringAnalytics:paramDic URL:urlStr];
        return isSkip;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

#pragma mark --------------------------webview字符解析
-(BOOL)webRequestStringAnalytics:(NSDictionary*)dicParam URL:(NSString*)url1
{
    NSLog(@"actionid:%@",[dicParam objectForKey:@"actionid"]);
    // 是否缺货
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"012"]) {
//        isOutOfStocks = NO;
//        [self addRightNav];
//        self.navigationItem.rightBarButtonItems = nil;
//        return YES;
        NSLog(@"actionid:%@",[dicParam objectForKey:@"actionid"]);
    }
    // 关于商品详细
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"000"]) {
        self.navigationItem.title = @"商品详细信息";
        [self setRightBarButton:self Action:nil SetImage:nil SelectImg:nil];

        return YES;
    }
    // 进入购物车
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"001"])
    {
        
        if (self.fromCart) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            YHCartViewController *cart = [[YHCartViewController alloc] init];
            cart.callBack = ^(){
                [webView reload];
            };
            cart.isFromOther = YES;
            [self.navigationController pushViewController:cart animated:YES];
        }

    }
    //立即购
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"013"] && [[dicParam objectForKey:@"clientaction"] integerValue] == 1) {
        if ([dicParam objectForKey:@"params"]) {
            _goods_id = [[dicParam objectForKey:@"params"] objectForKey:@"bu_goods_id"];
            _total = [[dicParam objectForKey:@"params"] objectForKey:@"total"];
        }
        [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:_goods_id total:_total];
    }
    // 进入商品评论列表
    else if([[dicParam objectForKey:@"actionid"]isEqualToString:@"002"])
    {
        if ([[YHAppDelegate appDelegate]  checkLogin]) {
            NSDictionary *params = [dicParam objectForKey:@"params"];
            NSString *good_id = [params objectForKey:@"bu_goods_id"];
            YHCommentViewController *commentVC = [[YHCommentViewController alloc]init];
            [commentVC setCommentListDataAndType:good_id Type:GOODS_COMMENT_LIST IsBought:[isBuy boolValue]];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
    }
    // 登陆页面
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"003"])
    {
        [[YHAppDelegate appDelegate]  checkLogin];
    }
    // 商品首页
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"004"])
    {
        self.url = [NSString stringWithFormat:@"%@bu_goods_id=%@&session_id=%@&region_id=%@&bu_code=%@",url1,[[dicParam objectForKey:@"params"] objectForKey:@"bu_goods_id"],[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
        [self loadRequest];
    }
    // 获取数量
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"005"])
    {
        if ([[YHAppDelegate appDelegate]  checkLogin]) {
            [self showNotice:@"已成功加入购物车"];
            [MTA trackCustomKeyValueEvent :EVENT_ID5 props:nil];
            NSString *totalNum = [NSString stringWithFormat:@"%@",[[dicParam objectForKey:@"params"] objectForKey:@"total"]];
            [[NSUserDefaults standardUserDefaults] setObject:totalNum forKey:@"cartNum"];
            [[YHAppDelegate appDelegate] changeCartNum:totalNum];
            
            if (self.refresh) {
                self.refresh();
            }
        }
//        else {
//            [[iToast makeText:@"请登录"] show];
//        }

    }
    // 达到购买上线
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"006"]) {
//        [self showNotice:[[dicParam objectForKey:@"params"] objectForKey:@"marked_words"]];
        iToast *toast = [iToast makeText:[[dicParam objectForKey:@"params"] objectForKey:@"marked_words"]];
        [toast setDuration:5000];
        [toast show];
    }
    // 确认加入购物车／*本地调用api*/
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"007"])
    {
        
    }
    // 门店首页
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"008"])
    {
        
    }
    return NO;
}

// 设置商品详情bu_goods_id
- (void)setBu_GoodsUrl:(NSString *)goodsDetailUrl Paramer:(NSDictionary *)dic{
    self.bu_goods_id =[[dic objectForKey:@"params"] objectForKey:@"bu_goods_id"];
    
    self.url = [NSString stringWithFormat:@"%@bu_goods_id=%@&session_id=%@&region_id=%@&bu_code=%@",goodsDetailUrl,self.bu_goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
}

//首页商品
-(void)setMainGoodsUrl:(NSString *)goodsUrl goodsID:(NSString *)goodID{
    self.bu_goods_id = goodID;
    self.url = goodsUrl;
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    if ([webView canGoBack]) {
        self.navigationItem.title = @"商品详情";
        [self addRightNav];
        [webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag == t_API_BUY_PLATFORM_GOODS_COLLECT)
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
    else if (nTag == t_API_BUY_PLATFORM_GOODS_COLLECT_STATUS)
    {
        
        if ([status isEqualToString:WEB_STATUS_3])
        {
            //            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            //            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            //            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            //            [[UserAccount instance] logoutPassive];
            //            [delegate LoginPassive];
            return;
        }
        
    }
    else if (nTag == t_API_BUY_PLATFORM_GOODS_STARUS)
    {
        
        if ([status isEqualToString:WEB_STATUS_3])
        {
            //            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            //            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            //            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            //            [[UserAccount instance] logoutPassive];
            //            [delegate LoginPassive];
            return;
        }
    }
    [[iToast makeText:errMsg]show];
}
-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    UIImage * image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:goodShareEntity.qr_code_src]]];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    

}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
        [[iToast makeText:message ]show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"您的照片功能未开启，请去(设置>隐私>照片)开启一下吧！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    NSNumber *collectStatus = (NSNumber *)netTransObj;
    if (nTag == t_API_BUY_PLATFORM_GOODS_COLLECT) {
        if ([collectStatus integerValue] == 1) {
            [self showNotice:@"收藏成功!"];
            [self addCollectRight];
        }
        if ([collectStatus integerValue] == 0) {
            [self showNotice:@"取消收藏成功!"];
            [self addRightNav];
        }
    } else if (t_API_BUY_PLATFORM_GOODS_STARUS == nTag) {
        GoodsStatusEntity *entity = (GoodsStatusEntity*)netTransObj;
        isBuy = entity.buy_status;
    }
    if (nTag == t_API_BUY_PLATFORM_GOODS_STOCK) {
        GoodsStockEntity * entity = (GoodsStockEntity *)netTransObj;
        if (entity.is_show.integerValue == 1) {
            isOutOfStocks = NO;
            [self addRightNav];
        }else{
            isOutOfStocks = YES;
        }
    }
    if (nTag == t_API_BUY_PLATFORM_GOODS_COLLECT_STATUS) {
        if (isOutOfStocks == NO) {
            if ([collectStatus integerValue] == 1) {
                [self addCollectRight];
                
            }
            if ([collectStatus integerValue] == 0) {
                [self addRightNav];
            }
        }
        
    }
    if (t_API_GOODS_SHARE == nTag) {
        [MTA trackCustomKeyValueEvent :EVENT_ID2 props:nil];
        goodShareEntity = (GoodShareEntity *)netTransObj;
        NSInteger flat = 1;

        [PublicMethod showCustomShareListViewWithWxContent:goodShareEntity.wx_content sinaWeiboContent:goodShareEntity.sina_content flat:flat title:goodShareEntity.title imageUrl:goodShareEntity.photo url:goodShareEntity.page_url description:goodShareEntity.description qrCodeSrc:goodShareEntity.qr_code_src block:^(id obj) {
            
        } VController:self AlertViewController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
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
    
}


@end
