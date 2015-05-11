//
//  YHPromotionViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  促销

#import "YHRootViewController.h"

@interface YHPromotionViewController : YHRootViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    NSString  *url;
    NSString  *promotionType;
    
    BOOL isRefresh;
}

@property (nonatomic, strong)  UIWebView *webView;
@property (nonatomic, assign)  BOOL isRefresh;

- (void)setParamerWihtType:(NSString *)type Id:(NSString *)subId tag:(NSInteger)tag;
@end
