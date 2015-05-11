//
//  YHCouponDetailViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-6-10.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  优惠券详情

#import "YHRootViewController.h"

@interface YHCouponDetailViewController : YHRootViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    NSString  *url;
}

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *couponId;
- (void)setCouponDetailId:(NSString *)couponId;
@end
