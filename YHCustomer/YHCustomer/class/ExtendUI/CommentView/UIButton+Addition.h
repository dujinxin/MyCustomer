//
//  UIButton+Addition.h
//  THCustomer
//
//  Created by lichentao on 13-8-13.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <UIKit/UIKit.h>

// set / get runtime

@interface UIButton (Addition)

+ (UIButton *)backButtonWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (UIButton *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (UIButton *)rightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (UIButton *) rightButtonWithTitleAndImg:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
