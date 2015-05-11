//
//  YHPSDeliveryArgumentViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-4-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHPSDeliveryArgumentViewController : YHRootViewController{
    UIWebView *webView;
    NSString  *url;
}

- (void)setUrlType:(NSString *)type;
@end
