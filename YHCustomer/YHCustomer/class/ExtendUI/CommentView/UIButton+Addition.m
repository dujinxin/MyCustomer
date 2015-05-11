//
//  UIButton+Addition.m
//  THCustomer
//
//  Created by lichentao on 13-8-13.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)

+ (UIButton *)backButtonWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	return [UIButton backButtonWithTitle:@"返回" target:target action:action forControlEvents:controlEvents];
}

+ (UIButton *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIFont   *titleFont  = [UIFont systemFontOfSize:14];
//	CGSize    titleSize  = [title sizeWithFont:titleFont];
	backButton.frame           = CGRectMake(0.f, 0.0f, 30.f, 30.0f);
	backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
	backButton.titleLabel.font = titleFont;
	backButton.titleLabel.shadowColor = [UIColor blackColor];
	backButton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);

//	[backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//	[backButton setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back_Select.png"] forState:UIControlStateSelected];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back_Select.png"] forState:UIControlStateHighlighted];
	[backButton addTarget:target action:action forControlEvents:controlEvents];
    
	return backButton;
}


+ (UIButton *)rightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIFont   *titleFont   = [UIFont boldSystemFontOfSize:15];
	CGSize    titleSize   = [title sizeWithFont:titleFont];
	rightButton.frame           = CGRectMake(0.0f, 0.0f, titleSize.width + 16, 30.0f);
    
    [rightButton setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
    
	rightButton.titleLabel.font = titleFont;
	rightButton.titleLabel.shadowColor = [UIColor blackColor];
	rightButton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
	[rightButton setTitle:title forState:UIControlStateNormal];
//	[rightButton setBackgroundImage:[UIImage imageNamed:@"cart_Confirm.png"] forState:UIControlStateNormal];
	[rightButton addTarget:target action:action forControlEvents:controlEvents];
	return rightButton;
}

@end
