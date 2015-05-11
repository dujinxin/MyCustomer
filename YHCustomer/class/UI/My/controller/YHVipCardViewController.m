//
//  YHVipCardViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-17.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHVipCardViewController.h"
#import "YHBindVipCardViewController.h"
#import "YHBindStoreCardViewController.h"
#import "RefleshManager.h"
@interface YHVipCardViewController ()<UIWebViewDelegate>
{
    BOOL isTure;
}
@end

@implementation YHVipCardViewController
@synthesize entity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"我的积分卡";
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addNavRightButton];
    [self addWebView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
//    YHBindStoreCardViewController *bsv = [[YHBindStoreCardViewController alloc]init];
//    
//    bsv.refleshBolck = ^(BOOL isre)
//    {
//         isTure = isre;
//        
//    };
//    NSLog(@"%@",isTure);
    if (self.isForword == YES||[[RefleshManager sharedRefleshManager] getBindCardRefresh])
    {
      [self loadRequest];
    }
    
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE13];
//    [self loadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE13];

    self.isForword = NO
    ;
//    self.view = nil;
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
-(void)addNavRightButton {
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 52, 44)];
//    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(15, 0, 52, 44);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_bind_vip_card_btn"] forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_bind_vip_card_btn_selected"] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:self action:@selector(rightButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:rightBtn];
//    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
            //去掉导航上的完善资料按钮
    //[self setRightBarButton:self Action:@selector(rightButtonClickEvent:) SetImage:@"nav_bind_vip_card_btn.png" SelectImg:@"nav_bind_vip_card_btn_selected.png"];
   [self setRightBarButton:self Action:@selector(bindCard:) SetImage:nil SelectImg:nil title:@"绑卡"];
    

}
-(void)bindCard:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance]API_YH_My_Card_Binding_Status:self];
    
//    YHBindStoreCardViewController *bsv = [[YHBindStoreCardViewController alloc]init];
//    [self.navigationController pushViewController:bsv animated:YES];


}
-(void)addWebView {
    if (IOS_VERSION >= 7) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height+20)];
        
    }else{
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
        
    }
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_webView];
}
#pragma mark - UIWebDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"加载完成");
    [[RefleshManager sharedRefleshManager]setBindCardRefresh:NO];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showNotice:@"加载失败"];
}
#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
//    [[YHAppDelegate appDelegate] hideTabBar:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)rightButtonClickEvent:(id)sender
//{
//    YHBindVipCardViewController *bindVC = [[YHBindVipCardViewController alloc] init];
//    [self.navigationController pushViewController:bindVC animated:YES];
//}

#pragma mark ---------------------- 数据获取
- (void)loadRequest{
    _url = [NSString stringWithFormat:VIP_CARD_DETAIL_URL,[UserAccount instance].user_id,[UserAccount instance].session_id];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [requestObj setValue: [ASIHTTPRequest defaultUserAgentString] forHTTPHeaderField: @"User-Agent"];
    [_webView loadRequest:requestObj];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if (t_API_YH_MY_CARD_BINDING_STATUS == nTag)
    {
        
//        self._userInfoEntity = (UserInfoEntity*)entity;
        
        entity = (CardBindStatusEntity *)netTransObj;
        NSString *type = [NSString stringWithFormat:@"%@",entity.bind_status];
        if ([type isEqualToString:@"0"])
        {
            YHBindStoreCardViewController *bsv = [[YHBindStoreCardViewController alloc]init];
//            bsv.refleshBolck = ^(BOOL isre){
//            };
            [self.navigationController pushViewController:bsv animated:YES];
        }
        else if([type isEqualToString:@"1"])
        {
            [self showAlert:@"已绑定积分卡，不可重复绑定"];
            //[[iToast makeText:@"已绑定积分卡，不可重复绑定"]show];
        
        }
        
       
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [[iToast makeText:errMsg]show];
}

@end
