//
//  YHAboutViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-19.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHAboutViewController : YHRootViewController <UIWebViewDelegate>{
    UIWebView *webView;
    NSString  *url;
}

@property (nonatomic, strong) NSString *_appLink;

@end
