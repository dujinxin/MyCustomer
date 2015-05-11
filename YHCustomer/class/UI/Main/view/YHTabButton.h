//
//  YHTabButton.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHTabButton : UIButton
{
    UILabel * titleView;
    UIImageView * imageView;
}
@property (nonatomic,strong)UILabel * titleView;
@property (nonatomic,strong)UIImageView * imageView;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image;
- (void)setImageForImageView:(UIImage *)image;
- (void)setTitleColorForTitleView:(UIColor *)color;
- (void)setTitleForTitleView:(NSString *)title;
//- (void)setTitleForTitleView:(NSString *)title font:(UIFont *)font;
- (void)setTitleForTitleView:(NSString *)title withFont:(UIFont *)font andImageForImageView:(UIImage *)image;
@end

