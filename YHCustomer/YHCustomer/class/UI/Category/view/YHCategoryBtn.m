//
//  YHCategoryBtn.m
//  YHCustomer
//
//  Created by dujinxin on 14-10-10.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHCategoryBtn.h"

@implementation YHCategoryBtn

@synthesize icon = _icon;
@synthesize arrow = _arrow;
@synthesize name = _name;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiconfig];
    }
    return self;
}
- (void)uiconfig{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 65, 65)];
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(0, self.icon.bottom +5, self.frame.size.width, 20)];
    self.arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6.0 -10, self.bottom -10, 20, 10)];
    
    self.name.textAlignment = NSTextAlignmentCenter;
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    
    [self addSubview:self.icon];
    [self addSubview:self.name];
    [self addSubview:self.arrow];
    
}
- (void)setSelectedImage:(UIImage *)image{
    [self.arrow setImage:image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
