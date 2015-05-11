//
//  YHAboutViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-19.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHAboutViewController.h"
#import "VersionEntiy.h"
@interface YHAboutViewController ()

@end

@implementation YHAboutViewController
@synthesize _appLink;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"关于产品";
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addWebView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    
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
    if (IOS_VERSION >= 7) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height+20)];
    }else{
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    }
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

#pragma mark ---------------------- 数据获取
- (void)loadRequest{
    url = [NSString stringWithFormat:ABOUT_URL,VERSION,[UserAccount instance].session_id];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [requestObj setValue: [ASIHTTPRequest defaultUserAgentString] forHTTPHeaderField: @"User-Agent"];
    [webView loadRequest:requestObj];
}

#pragma mark --------------------------webview delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"%@",requestString);
    NSString *decode =[requestString URLDecodeString];
    if ([decode rangeOfString:@"#myrainbowparams#"].location == NSNotFound) {
        return YES;
    }
    else
    {
        NSString *finalStr = [decode getJsonStrWithOutHttpBySeprateStr:@"#myrainbowparams#"];
        if (finalStr != nil) {
            NSDictionary *paramDic = [finalStr objectFromJSONString];
            NSString *actionid = [paramDic objectForKey:@"actionid"];
            if ([actionid isEqualToString:@"007"]) {
                //打开评价界面
                NSString *str = [NSString stringWithFormat:
                                 @"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                return NO;
            }
            if ([actionid isEqualToString:@"008"]) {
//                //监测版本
//                [[NetTrans getInstance] API_version_check:self AgentID:@"2" Type:@"consumer"];
            }
            if ([actionid isEqualToString:@"014"]) {
                NSDictionary* dicpara = [paramDic objectForKey:@"params"];
                NSString* strLat = [dicpara objectForKey:@"ios"];
                //    NSLog(strLat);
                NSURL *iTunesURL = [NSURL URLWithString:strLat];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                return NO;
                
            }
        }
    }
    
    return YES;
}



//#pragma mark - connectionDelegate
//-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
//{
//    if (t_API_VERSION == nTag) {
//        VersionEntiy *version = (VersionEntiy *)netTransObj;
//        NSString *verNum = version._version;
//        self._appLink = version._url;
//        if (verNum.integerValue > K_VERSION_CODE) {
//            //前往appstore下载
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"永辉微店有新版啦！" message:[NSString stringWithFormat:@"\n%@",version.version_caption] delegate:self cancelButtonTitle:@"一会再说" otherButtonTitles:@"马上更新", nil];
//            alert.tag = 1001;
//            [alert show];
//        }
//    }
//
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1 && alertView.tag == 1001) {
//        NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
//        [[UIApplication sharedApplication] openURL:iTunesURL];
//    }
//}
#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
