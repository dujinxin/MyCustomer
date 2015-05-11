//
//  YHShakeActivityDetailViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-11-23.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHShakeActivityDetailViewController.h"
#import <AdSupport/AdSupport.h>
@interface YHShakeActivityDetailViewController ()
{
    UIImageView * activityImage;
}
@end

@implementation YHShakeActivityDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self.navigationItem.title = @"活动详情";
    
    CGFloat y = 0;
    if (self.description_image.length != 0){
        activityImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
        [activityImage setImageWithURL:[NSURL URLWithString:self.description_image]placeholderImage:[UIImage imageNamed:@"default_640X245"]];
        y = activityImage.height;
    }
    
    UIWebView * web = [[UIWebView alloc ]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
    NSString * urlString = [NSString stringWithFormat:@"%@v2/page/shake_info?shake_id=%@&session_id=%@&region_id=%@",BASE_URL,self.activity_id,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    web.delegate = self;
    web.scrollView.delegate = self;
    [web loadRequest:request];
    [self.view addSubview:web];

    for (UIView * view in web.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            for (UIView * v in view.subviews) {
                if (![v isKindOfClass:[UIImageView class]]) {
                    if (self.description_image.length != 0){
                        [web.scrollView addSubview:activityImage];
                        v.frame = CGRectMake(0, activityImage.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - y -64);
                    }else{
                        v.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  -64);
                    }
                    
                }
            }
        }
    }
    NSLog(@"%@",urlString);
    NSLog(@"web.superview:%@",web.superview);
    NSLog(@"web.subViews:%@",web.subviews);
    NSLog(@"web.scrollView:%@",web.scrollView.subviews);
    

    
//    UILabel * l = [[UILabel alloc]initWithFrame:CGRectMake(10, activityImage.bottom, SCREEN_WIDTH -20, SCREEN_HEIGHT -125 -64)];
//    l.text = self._description;
//    l.numberOfLines = 0;
//    l.textAlignment = NSTextAlignmentJustified;
//    //设置行间距
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:l.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:7];//调整行间距
//    
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [l.text length])];
//    l.attributedText = attributedString;
//    [l sizeToFit];
//    l.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
//    [self.view addSubview:l];
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGRect frame = activityImage.frame;
//    CGFloat y = -scrollView.contentOffset.y;
//    activityImage.frame = CGRectMake(frame.origin.x,y, frame.size.width, frame.size.height);
//    scrollView.frame = CGRectMake(frame.origin.x, y + 125, frame.size.width, SCREEN_HEIGHT -64-125);
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
