//
//  YHPromotionViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  促销商品列表

#import "YHPromotionViewController.h"
#import "YHCartViewController.h"
#import "YHGoodsDetailViewController.h"

@interface YHPromotionViewController ()

@end

@implementation YHPromotionViewController
@synthesize webView;
@synthesize isRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            [self setParamerWihtType:@"3" Id:nil tag:NSIntegerMax];//促销初始化
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshUpdateFocus:) name:MY_PROMOTION_REFRESH_FOCUS object:nil];
    }
    return self;
}


/*强制刷新 tab 切换 */
- (void)refreshUpdateFocus:(id)sender{
    [self loadRequest];
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
     [MTA trackPageViewBegin:PAGE8];
    [self loadRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NetTrans getInstance] getCartGoodsNum:self];
    if ([promotionType isEqualToString:@"3"])
    {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
        self.navigationItem.title = @"促销商品";
        if (![url isEqualToString:[NSString stringWithFormat:GOODS_LIST_WITH_TYPE,@"3",@"",
                                   [UserAccount instance].session_id,[UserAccount instance].region_id]]) {//首次安装应用，本VC初始化时还无region_id，更新后需要重新生成URL
            
            url = [NSString stringWithFormat:GOODS_LIST_WITH_TYPE,@"3",@"",[UserAccount instance].session_id,[UserAccount instance].region_id];
            
            [self loadRequest];
        }
        url = [NSString stringWithFormat:GOODS_LIST_WITH_TYPE,@"3",@"",[UserAccount instance].session_id,[UserAccount instance].region_id];
        if ([[UserAccount instance] isLogin])
        {
            if (isRefresh == NO)
            {
                self.isRefresh = YES;
                [self loadRequest];
            }
        }
        else
        {
            self.isRefresh = NO;
        }
    }
    else
    {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE8];
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
-(void)addWebView {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height + (68 - kTabBarHeight))];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

#pragma mark ---------------------- 数据获取
- (void)loadRequest{
    //清除UIWebView的缓存
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:requestObj];
}

#pragma mark-
#pragma mark -UIWebViewDelegate

#pragma mark --------------------------webView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSString *decode =[requestString URLDecodeString];
    if([decode rangeOfString:@"#myrainbowparams#"].length > 0){
        NSString *finalStr = [decode getJsonStrWithOutHttpBySeprateStr:@"#myrainbowparams#"];
        NSString *urlStr = [decode getGoodUrlWithParmer:@"#myrainbowparams#"];
        NSDictionary *paramDic = [finalStr objectFromJSONString];
        BOOL isSkip = [self webRequestStringAnalytics:paramDic URL:urlStr];
        return isSkip;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}


#pragma mark --------------------------webview字符解析
-(BOOL)webRequestStringAnalytics:(NSDictionary*)dicParam URL:(NSString*)url1
{
    // 只做跳转
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"004"])
    {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
        YHGoodsDetailViewController *goodsDetail = [[YHGoodsDetailViewController alloc] init];
        goodsDetail.navigationItem.title = [[dicParam objectForKey:@"params"] objectForKey:@"title"];
        [goodsDetail setBu_GoodsUrl:url1 Paramer:dicParam
         ];
        [self.navigationController pushViewController:goodsDetail animated:YES];
        return NO;
    }
    // 进入购物车
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"001"])
    {
        YHCartViewController *cart = [[YHCartViewController alloc] init];
        cart.isFromOther = YES;
        [self.navigationController pushViewController:cart animated:YES];
    }
    // 进入商品评论列表
    else if([[dicParam objectForKey:@"actionid"]isEqualToString:@"002"])
    {
        
    }
    // 登陆页面
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"003"])
    {
        [[YHAppDelegate appDelegate]  checkLogin];
    }

    // 查看购物车商品数量
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"005"])
    {
        if ([[YHAppDelegate appDelegate]  checkLogin]) {
            [self showNotice:@"已成功加入购物车"];
            [MTA trackCustomKeyValueEvent :EVENT_ID5 props:nil];
            NSString *totalNum = [NSString stringWithFormat:@"%@",[[dicParam objectForKey:@"params"] objectForKey:@"total"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:totalNum forKey:@"cartNum"];
            [[YHAppDelegate appDelegate] changeCartNum:totalNum];
        }

    }
    // 达到购买上线
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"006"])
    {
        NSString *showAlertMsg = [[dicParam objectForKey:@"params"] objectForKey:@"marked_words"];
        if ([showAlertMsg isEqualToString:@"not_login" ]) {
            [[YHAppDelegate appDelegate]  checkLogin];
        }else{
            [self showNotice:[[dicParam objectForKey:@"params"] objectForKey:@"marked_words"]];
        }
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

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark -------------------------调用函数
//参数：热销商品列表（type=1）
//主题促销商品列表（type=2）
//促销商品列表（type=3）
//品牌商品列表（type=4&bu_brand_id=品牌ID）
//品类商品列表（type=5&bu_category_id=品类ID）
//关键字商品列表(type=6&keyword=关键字)

- (void)setParamerWihtType:(NSString *)type Id:(NSString *)subId tag:(NSInteger)tag{
    promotionType = type;
    
    if ([type isEqualToString:@"1"]) {
        url = [NSString stringWithFormat:GOODS_LIST_WITH_TYPE,type,@"",[UserAccount instance].session_id,[UserAccount instance].region_id];

        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    } else if ([type isEqualToString:@"3"]){
        url = [NSString stringWithFormat:GOODS_LIST_WITH_TYPE,type,@"",[UserAccount instance].session_id,[UserAccount instance].region_id];

    } else if ([type isEqualToString:@"4"]){
        url = [NSString stringWithFormat:BAND_GOODS_LIST_WITH_TYPE,type,subId,[UserAccount instance].session_id,[UserAccount instance].region_id];

        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    } else if ([type isEqualToString:@"5"]){
        url = [NSString stringWithFormat:CATEGORY_GOODS_LIST_WITH_TYPE,type,subId,[UserAccount instance].session_id,[UserAccount instance].region_id];
 
        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    } else if ([type isEqualToString:@"7"]){
        url = [NSString stringWithFormat:GOODS_LIST_WITH_TYPE,type,[NSString stringWithFormat:@"%ld",(long)tag],[UserAccount instance].session_id,[UserAccount instance].region_id];

        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    }
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == t_API_CART_TOTAL_API)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
    }
}
@end
