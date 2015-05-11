//
//  YHWebGoodListViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  商品列表

#import "YHRootViewController.h"

@interface YHWebGoodListViewController : YHRootViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    NSString  *url;
}

- (void)setParamerWihtType:(NSString *)type Id:(NSString *)subId;
@end
