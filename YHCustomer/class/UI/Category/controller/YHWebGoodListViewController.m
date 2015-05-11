//
//  YHWebGoodListViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  商品列表

#import "YHWebGoodListViewController.h"
#import "YHCartViewController.H"
#import "YHGoodsDetailViewController.h"
@interface YHWebGoodListViewController ()


@end

@implementation YHWebGoodListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
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
    [MTA trackPageViewBegin:PAGE3];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadRequest];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE3];
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
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

#pragma mark ---------------------- 数据获取
- (void)loadRequest{
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

#pragma mark --------------------------webview字符解析
-(BOOL)webRequestStringAnalytics:(NSDictionary*)dicParam URL:(NSString*)url1
{
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
    // 专柜首页
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"004"])
    {
        YHGoodsDetailViewController *goodsDetail = [[YHGoodsDetailViewController alloc] init];
        goodsDetail.navigationItem.title = [[dicParam objectForKey:@"params"] objectForKey:@"title"];
        [goodsDetail setBu_GoodsUrl:url1 Paramer:dicParam];
        [self.navigationController pushViewController:goodsDetail animated:YES];
        return NO;
    }
    // 查看购物车商品数量
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"005"])
    {
        [self showNotice:@"已成功加入购物车"];
        [MTA trackCustomKeyValueEvent :EVENT_ID5 props:nil];
        NSString *totalNum = [NSString stringWithFormat:@"%@",[[dicParam objectForKey:@"params"] objectForKey:@"total"]];
        [[NSUserDefaults standardUserDefaults] setObject:totalNum forKey:@"cartNum"];
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];

    }
    // 达到购买上线
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"006"]) {
        [self showNotice:[[dicParam objectForKey:@"params"] objectForKey:@"marked_words"]];
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

- (void)setParamerWihtType:(NSString *)type Id:(NSString *)subId{
    switch ([type intValue]) {
        case 4:
        {
            url = [NSString stringWithFormat:GOODS_LIST,type,@"bu_brand_id",subId,[UserAccount instance].session_id,[UserAccount instance].region_id];
        }
            break;
        case 5:
        {
            url = [NSString stringWithFormat:GOODS_LIST,type,@"bu_category_id",subId,[UserAccount instance].session_id,[UserAccount instance].region_id];

        }
            break;
        case 6:
        {
            self.navigationItem.title = subId;
            url = [NSString stringWithFormat:GOODS_LIST,type,@"keyword",[subId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[UserAccount instance].session_id,[UserAccount instance].region_id];

        }
            break;
            
        default:
            break;
    }
    
}


@end
