//
//  YHMenuViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-1-16.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHMenuViewController.h"
#import "YHMenuDetailViewController.h"
#import "YHMenuListViewController.h"

@interface YHMenuViewController ()<UIWebViewDelegate>

@end

@implementation YHMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MTA trackPageViewBegin:PAGE20];
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -20)];
//    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xft.duoduofish.com/"]]];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.1.41.230/"]]];
    web.delegate = self;
    web.scrollView.bounces = NO;
    web.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:web];
    NSLog(@"self.view.frame:%@", NSStringFromCGRect(self.view.frame));
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE20];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"requestString:%@",requestString);
    NSString *decode =[requestString URLDecodeString];
    if([decode rangeOfString:@"#myrainbowparams#"].length > 0)
    {
        NSString *finalStr = [decode getJsonStrWithOutHttpBySeprateStr:@"#myrainbowparams#"];
        NSString *urlStr = [decode getGoodUrlWithParmer:@"#myrainbowparams#"];
        NSDictionary *paramDic = [finalStr objectFromJSONString];
        NSLog(@"paramDic:%@",paramDic);
        BOOL isSkip = [self webRequestStringAnalytics:paramDic URL:urlStr];
        return isSkip;
    }
    return YES;
}
- (BOOL)webRequestStringAnalytics:(NSDictionary *)param URL:(NSString *)url{
    //详情
    if ([[param objectForKey:@"actionid"] isEqualToString:@"101"]) {
        YHMenuDetailViewController * menuDetail = [[YHMenuDetailViewController alloc]init ];
        menuDetail.navigationItem.title = [param objectForKey:@"title"];
        menuDetail.webUrl = [NSString stringWithFormat:@"%@",url];
        menuDetail.param = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"params"]];
        [self.navigationController pushViewController:menuDetail animated:NO];
    }
    //列表
    if ([[param objectForKey:@"actionid"] isEqualToString:@"100"]) {
        YHMenuListViewController * menuList = [[YHMenuListViewController alloc]init ];
        menuList.navigationItem.title = [param objectForKey:@"title"];
        menuList.webUrl = [NSString stringWithFormat:@"%@",url];
        menuList.param = [NSMutableDictionary dictionaryWithDictionary:[param objectForKey:@"params"]];
        [self.navigationController pushViewController:menuList animated:NO];
    }
    //返回
    if ([[param objectForKey:@"actionid"] isEqualToString:@"102"]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    // 登陆页面
    if ([[param objectForKey:@"actionid"] isEqualToString:@"003"])
    {
        [[YHAppDelegate appDelegate]  checkLogin];
    }
    return NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showNotice:@"加载失败"];
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
