//
//  YHImageView.h
//  YHCustomer
//
//  Created by dujinxin on 14-12-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHImageView;
@protocol YHImageViewDelegate <NSObject>

- (void)imageViewAction:(YHImageView *)imageView;

@end
@interface YHImageView : UIImageView

@property (nonatomic,assign)id<YHImageViewDelegate> target;
@property (nonatomic,assign)SEL action;

//运营活动区/主题区
@property(nonatomic,copy)NSString *show_type;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *jump_type;
@property(nonatomic,copy)NSString *jump_parametric;
@property(nonatomic,copy)NSString *title;



@end
