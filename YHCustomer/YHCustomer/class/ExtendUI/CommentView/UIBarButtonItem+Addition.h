//
//  UIBarButtonItem+Addition.h
//  THCustomer
//
//  Created by lichentao on 13-8-13.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Addition)

//+ (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
//+ (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (UIBarButtonItem *)rightBarButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (NSMutableArray *)backBarButtonItemWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (NSMutableArray *)backBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
