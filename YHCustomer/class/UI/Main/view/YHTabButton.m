//
//  YHTabButton.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHTabButton.h"

@implementation YHTabButton

@synthesize titleView = _titleView;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self uiconfig];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleView = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleView.font = [UIFont systemFontOfSize:14];
        CGSize size = [title sizeWithFont:self.titleView.font constrainedToSize:CGSizeMake(self.size.width- 5, 30) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat x = self.size.width/2.0- size.width /2.0 -3;
        CGFloat y = self.size.height/2.0 - size.height/2.0;
        self.titleView.frame = CGRectMake(x, y, size.width, size.height);
        self.titleView.text = title;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleView.right, 14, 6, 7 )];
        self.imageView.image= image;
        
        [self addSubview:self.titleView];
        [self addSubview:self.imageView];
    }
    return self;
}
- (void)setTitleColorForTitleView:(UIColor *)color{
    self.titleView.textColor = color;
}
- (void)setImageForImageView:(UIImage *)image{
    self.imageView.image = image;
}
- (void)setTitleForTitleView:(NSString *)title{
    [self setTitleForTitleView:title withFont:nil];
}
- (void)setTitleForTitleView:(NSString *)title withFont:(UIFont *)font{
    [self setTitleForTitleView:title  withFont:font andImageForImageView:nil];
}
- (void)setTitleForTitleView:(NSString *)title withFont:(UIFont *)font andImageForImageView:(UIImage *)image{
    CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(self.size.width - 5, 30) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat x = self.size.width/2.0- size.width /2.0 -3;
    CGFloat y = self.size.height/2.0 - size.height/2.0;
    self.titleView.frame = CGRectMake(x, y, size.width, size.height);
    self.titleView.text = title;
    
    self.imageView.frame = CGRectMake(self.titleView.right, 14, 6, 7 );
    self.imageView.image = image;
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
