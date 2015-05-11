//
//  YHVipCardViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-17.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "CardBindStatusEntity.h"

@interface YHVipCardViewController : YHRootViewController {
    UIWebView       *_webView;
    NSString        *_url;
}
@property(nonatomic,strong)CardBindStatusEntity *entity;
@property(nonatomic,assign)BOOL isForword;

@end
