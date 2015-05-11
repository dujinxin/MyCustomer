//
//  YHMenuDetailViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-1-16.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHMenuDetailViewController.h"

@interface YHMenuDetailViewController ()<UIWebViewDelegate>

@end

@implementation YHMenuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar];
    
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -20)];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    web.delegate = self;
    web.scrollView.bounces = NO;
    web.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:web];
    NSLog(@"self.view.frame:%@", NSStringFromCGRect(self.view.frame));
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addNavigationBar{
    self.navigationItem.title = [self.param objectForKey:@"title"];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(52, 0, 30, 30);
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
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
    if (IOS_VERSION >= 7) {
        negativeSpacer.width = -15;
    }else{
        negativeSpacer.width = -5;
    }
    NSMutableArray *buttonArray= [NSMutableArray arrayWithObjects:rightBarItem1,negativeSpacer,nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)shareAction:(id)sender{
    
    NSLog(@"self.param:%@",self.param);
    NSLog(@"sss:%@",[NSString stringWithFormat:@"http://xft.duoduofish.com%@",[self.param objectForKey:@"image_url"]]);
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        return;
    }
    [PublicMethod showCustomShareListViewWithWxContent:[self.param objectForKey:@"description"] sinaWeiboContent:[self.param objectForKey:@"description_sina"] flat:2 title:[self.param objectForKey:@"title"] imageUrl:[self.param objectForKey:@"image_url"] url:[self.param objectForKey:@"page_url"] description:[self.param objectForKey:@"description"] qrCodeSrc:[self.param objectForKey:@"qr_code_src"] block:^(id obj) {
        NSLog(@"sss:%@",[self.param objectForKey:@"image_url"]);
    } VController:self AlertViewController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
}
#pragma mark - WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"type:%ld",(long)navigationType);
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
    //分享
    if ([[param objectForKey:@"actionid"] isEqualToString:@"101"]) {
        [PublicMethod showCustomShareListViewWithWxContent:[param objectForKey:@"description"] sinaWeiboContent:[param objectForKey:@"description_sina"] flat:2 title:[param objectForKey:@"title"] imageUrl:[NSString stringWithFormat:@"http://xft.duoduofish.com%@",[param objectForKey:@"image_url"]] url:[param objectForKey:@"page_url"] description:[param objectForKey:@"description"] qrCodeSrc:[param objectForKey:@"qr_code_src"] block:^(id obj) {
            NSLog(@"sss:%@",[NSString stringWithFormat:@"http://xft.duoduofish.com%@",[param objectForKey:@"image_url"]]);
        } VController:self AlertViewController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
        return YES;
    }
    //收藏
    if ([[param objectForKey:@"actionid"] isEqualToString:@"103"]) {
        if ([[YHAppDelegate appDelegate]  checkLogin]){
            return YES;
        }
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
