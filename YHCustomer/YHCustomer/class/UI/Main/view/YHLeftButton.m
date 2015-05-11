//
//  YHLeftButton.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHLeftButton.h"

@implementation YHLeftButton

@synthesize categoryName = _categoryName;
@synthesize selectName = _selectName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [PublicMethod colorWithHexValue:0x3d3d3d alpha:1.0];
        
        self.categoryName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 39)];
        self.categoryName.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        self.categoryName.backgroundColor = [PublicMethod colorWithHexValue:0x3d3d3d alpha:1.0];
        self.categoryName.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.categoryName];
        
        self.selectName = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 140, 39)];
        self.selectName.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        self.selectName.backgroundColor = [PublicMethod colorWithHexValue:0x3d3d3d alpha:1.0];
        self.selectName.font = [UIFont systemFontOfSize:15.f];
        self.selectName.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.selectName];
        
        UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(320 -65, 10, 20, 20)];
        arrow.image = [UIImage imageNamed:@"icon_arrow"];
        [self addSubview:arrow];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40 -0.5, 320 -40, 0.5)];
        line.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:line];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
