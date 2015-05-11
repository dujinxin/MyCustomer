//
//  YHShakeActivityDetailViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-11-23.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHShakeActivityDetailViewController : YHRootViewController<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,copy)NSString * _description;
@property (nonatomic, copy)NSString * activity_id;
@property (nonatomic, copy)NSString * description_image;
@end
