//
//  YHScrollView.m
//  YHCustomer
//
//  Created by dujinxin on 14-8-27.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHScrollView.h"

@implementation YHScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29)];
        [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"main_hot_bg"] forState:UIControlStateNormal];
        [self.titleBtn setBackgroundImage:[UIImage imageNamed:@"main_hot_bg_selected"] forState:UIControlStateHighlighted];
        
        self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.titleBtn setTitleColor:[PublicMethod colorWithHexValue:0xfb5963 alpha:1.0] forState:UIControlStateNormal];
        self.titleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleBtn];
        
        //分割线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleBtn.bottom, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        [self addSubview:line];
        
        //滚动展示视图
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.titleBtn.bottom+0.5 , SCREEN_WIDTH, 134)];

        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.pagingEnabled = NO;
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];

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
