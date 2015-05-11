//
//  ShareCustomViewController.h
//  YHCustomer
//
//  Created by wangliang on 14-11-28.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCustomViewController : UIViewController<UITextViewDelegate>
@property(nonatomic,strong)UITextView *shareTextView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSString *_description;
@property (nonatomic, strong)NSString * page_url;
@property (nonatomic, strong)NSString * imageUrl;
@property (nonatomic, strong)NSString * download_url;
@property (nonatomic, strong)NSString * sina_content;
@end
