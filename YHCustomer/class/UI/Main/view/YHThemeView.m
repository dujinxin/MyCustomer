//
//  YHThemeView.m
//  YHCustomer
//
//  Created by dujinxin on 14-12-29.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHThemeView.h"

@implementation YHThemeView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.leftTopImageView];
        [self addSubview:self.leftBottomImageView];
        [self addSubview:self.rightTopImageView];
        [self addSubview:self.rightBottomImageView];

    }
    return self;
}
#pragma mark - YHImageViewDelegate
- (void)imageViewAction:(YHImageView *)imageView{
    if ([self.delegate respondsToSelector:@selector(yhThemeViewAction:)]) {
        [self.delegate yhThemeViewAction:imageView];
    }
}

#pragma mark - SubViewInit
-(UIImageView *)leftTopImageView{
    if (!_leftTopImageView) {
        _leftTopImageView = [[YHImageView alloc]initWithFrame:CGRectMake(10, 10, 145, 57.5)];
        _leftTopImageView.backgroundColor = [UIColor redColor];
        _leftTopImageView.target = self;
    }
    return _leftTopImageView;
}
-(UIImageView *)leftBottomImageView{
    if (!_leftBottomImageView) {
        _leftBottomImageView = [[YHImageView alloc]initWithFrame:CGRectMake(10, 77.5, 145, 57.5)];
        _leftBottomImageView.backgroundColor = [UIColor redColor];
        _leftBottomImageView.target = self;
    }
    return _leftBottomImageView;
}
-(UIImageView *)rightTopImageView{
    if (!_rightTopImageView) {
        _rightTopImageView = [[YHImageView alloc]initWithFrame:CGRectMake(165, 10, 145, 57.5)];
        _rightTopImageView.backgroundColor = [UIColor redColor];
        _rightTopImageView.target = self;
    }
    return _rightTopImageView;
}
-(UIImageView *)rightBottomImageView{
    if (!_rightBottomImageView) {
        _rightBottomImageView = [[YHImageView alloc]initWithFrame:CGRectMake(165, 77.5, 145, 57.5)];
        _rightBottomImageView.backgroundColor = [UIColor redColor];
        _rightBottomImageView.target = self;
    }
    return _rightBottomImageView;
}

@end
