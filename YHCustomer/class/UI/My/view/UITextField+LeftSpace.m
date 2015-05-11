//
//  UITextField+LeftSpace.m
//  YHCustomer
//
//  Created by kongbo on 14-5-13.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "UITextField+LeftSpace.h"

@implementation UITextField (LeftSpace)
-(void)setLeftSpace:(float)padding {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, self.height)]; //左端缩进padding像素
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
