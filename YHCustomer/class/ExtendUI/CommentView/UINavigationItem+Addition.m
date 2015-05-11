//
//  UINavigationItem+Addition.m
//  THCustomer
//
//  Created by lichentao on 13-10-8.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "UINavigationItem+Addition.h"

@implementation UINavigationItem (Addition)
- (void)setTitle:(NSString *)title {
    self.titleView = nil;
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 30.0f)] autorelease];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0f];
	titleLabel.font = [UIFont boldSystemFontOfSize:20];
	titleLabel.backgroundColor = [UIColor clearColor];
	if (title) titleLabel.text = title;
    [titleLabel sizeToFit];
	self.titleView = titleLabel;
}

@end
