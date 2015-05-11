//
//  YHHelpUserWalletViewController.m
//  YHCustomer
//
//  Created by wangliang on 14-12-3.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHHelpUserWalletViewController.h"

@interface YHHelpUserWalletViewController ()

@end

@implementation YHHelpUserWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    self.navigationItem.title = @"钱包使用帮助";
    [self addBackNav];
    
    [self addWebView];
    [self loadRequest];
}
-(void)addBackNav
{
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavButton.frame = CGRectMake(0, 0, 30, 30);
    [leftNavButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftNavButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    
//    if (IOS_VERSION >= 7) {
//        negativeSpacer.width = -15;
//    }else{
//        negativeSpacer.width = -15;
//    }
    NSArray * arr = [NSArray arrayWithObjects:negativeSpacer , leftItem, nil];
    self.navigationItem.leftBarButtonItems = arr;
}
-(void)back:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)addWebView
{
    if (IOS_VERSION >= 7) {
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    }else{
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height
                                                             )];
    }
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    [self.view addSubview:webView];
    
}


-(void)loadRequest
{
//    将网址换一下就可以了
    url = [NSString stringWithFormat:@"%@%@" , BASE_URL , API_YHCARD_HELP];
    NSMutableURLRequest *requsetObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [requsetObj setValue:[ASIHTTPRequest defaultUserAgentString] forHTTPHeaderField:@"User-Agent"];
    
    [webView loadRequest:requsetObj];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
