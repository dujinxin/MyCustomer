//
//  YHPSDeliveryArgumentViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-4-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  配送政策

#import "YHPSDeliveryArgumentViewController.h"

@interface YHPSDeliveryArgumentViewController ()

@end

@implementation YHPSDeliveryArgumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    [self addWebView];
    [self loadRequest];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------------- add UI
-(void)addWebView {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

// type = 1 配送政策
// type = 2 退货政策
- (void)setUrlType:(NSString *)type{
    if([type isEqualToString:@"1"]){
        self.navigationItem.title = @"购物指南";
    }else{
        self.navigationItem.title = @"售后保障";
    }
    url = [NSString stringWithFormat:DEVELIY_INFO,type,[UserAccount instance].session_id,[UserAccount instance].region_id];
}

#pragma mark ---------------------- 数据获取
- (void)loadRequest{
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [requestObj setValue: [ASIHTTPRequest defaultUserAgentString] forHTTPHeaderField: @"User-Agent"];
    [webView loadRequest:requestObj];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
