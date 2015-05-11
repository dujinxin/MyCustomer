//
//  UIBarButtonItem+Addition.m
//  THCustomer
//
//  Created by lichentao on 13-8-13.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"

@implementation UIBarButtonItem (Addition)
+ (NSMutableArray *)backBarButtonItemWithTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	return [UIBarButtonItem backBarButtonItemWithTitle:@"返回" target:target action:action forControlEvents:controlEvents];
}


+ (NSMutableArray *)backBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	UIButton        *backView = [UIButton backButtonWithTitle:title target:target action:action forControlEvents:controlEvents];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    UIBarButtonItem *backBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:backView] autorelease];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
//    if (IOS_VERSION >= 7) {
//        negativeSpacer.width = -15;
//    }else{
//        negativeSpacer.width = -5;
//    }
    NSMutableArray *buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,backBarButtonItem, nil];
    [negativeSpacer release];
	return buttonArray;
}


+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	UIButton  *rightButton        =[UIButton rightButtonWithTitle:title target:target action:action forControlEvents:controlEvents];
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:rightButton] autorelease];
	return rightBarButtonItem;
}

+ (UIBarButtonItem *)rightBarButtonItemWithImage:(NSString *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton        *rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(10,6,70,30);
    [rightButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [rightButton addTarget:target action:action forControlEvents:controlEvents];
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:rightButton] autorelease];
	return rightBarButtonItem;
}
@end
