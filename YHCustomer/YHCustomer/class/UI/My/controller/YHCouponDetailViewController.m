//
//  YHCouponDetailViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-6-10.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  优惠券详情

#import "YHCouponDetailViewController.h"

@interface YHCouponDetailViewController ()

@end

@implementation YHCouponDetailViewController
@synthesize url;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"优惠券详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"", @selector(back:));
    [self addWebView];
    [self loadRequest];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCouponDetailId:(NSString *)couponId{
    url = [NSString stringWithFormat:COUPON_DETAIL_URL,couponId,[UserAccount instance].session_id,[UserAccount instance].region_id];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
