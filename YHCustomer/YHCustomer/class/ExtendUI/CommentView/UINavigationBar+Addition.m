//
//  UINavigationBar+Addition.m
//  THCustomer
//
//  Created by lichentao on 13-8-7.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "UINavigationBar+Addition.h"

@implementation UINavigationBar (Addition)
- (void)drawRect:(CGRect)rect {
    if ([[UIDevice currentDevice].systemVersion compare:@"5.0"]<0) {
        UIImage *backgroundImage = [UIImage imageNamed:@"nav_Bg.png"];
        CGRect rect1 = CGRectMake(0, 0, 320, 44);
        [backgroundImage drawInRect:rect1];
    }else{
//        [self setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIImage imageNamed:@"nav_Bg.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];

    }
}

@end
