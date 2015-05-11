//
//  YHPoliceViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-24.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  条款和隐私政策说明界面

#import "YHPoliceViewController.h"

@interface YHPoliceViewController ()

@end

@implementation YHPoliceViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"帮助";
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
//    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addWebView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PublicMethod addNavBackground:self.view title:@"条款和隐私政策说明"];
    
    [PublicMethod addBackButtonWithTarget:self action:@selector(back:)];
    [self loadRequest];
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
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
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, originY+NAVBAR_HEIGHT, ScreenSize.width, ScreenSize.height - NAVBAR_HEIGHT)];
        
    }else{
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, ScreenSize.width, ScreenSize.height - NAVBAR_HEIGHT)];
        
    }
    //    _webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

#pragma mark ---------------------- 数据获取
- (void)loadRequest{
    url = [NSString stringWithFormat:@"http://app.yonghui.cn:8081/v1/page/agreement"];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [requestObj setValue: [ASIHTTPRequest defaultUserAgentString] forHTTPHeaderField: @"User-Agent"];
    [webView loadRequest:requestObj];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
