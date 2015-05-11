//
//  YHOperationView.m
//  YHCustomer
//
//  Created by dujinxin on 14-12-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHOperationView.h"

@implementation YHOperationView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame type:(kOperationType)operationType{
    self = [super initWithFrame:frame];
    if (self) {
        switch (operationType) {
            case kOperationOne:
            {
                [self addSubview:self.superImageView];
            }
                break;
            case kOperationTwo:
            {
                [self addSubview:self.bigLeftImageView];
                [self addSubview:self.bigRightImageView];
            }
                break;
            case kOperationThree:
            {
                [self addSubview:self.bigLeftImageView];
                [self addSubview:self.mediumTopImageView];
                [self addSubview:self.mediumBottomImageView];
            }
                break;
            case kOperationFour:
            {
                [self addSubview:self.bigLeftImageView];
                [self addSubview:self.mediumTopImageView];
                [self addSubview:self.smallLeftImageView];
                [self addSubview:self.smallRightImageView];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}
#pragma mark - YHImageViewDelegate
- (void)imageViewAction:(YHImageView *)imageView{
    if ([self.delegate respondsToSelector:@selector(yhImageViewAction:)]) {
        [self.delegate yhImageViewAction:imageView];
    }
}
#pragma mark - SubViewInit
-(UIImageView *)superImageView{
    if (!_superImageView) {
        _superImageView = [[YHImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 170)];
        _superImageView.backgroundColor = [UIColor redColor];
        _superImageView.target = self;
    }
    return _superImageView;
}
-(UIImageView *)bigLeftImageView{
    if (!_bigLeftImageView) {
        _bigLeftImageView = [[YHImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width /2 -0.5, 170)];
        _bigLeftImageView.backgroundColor = [UIColor redColor];
        _bigLeftImageView.target = self;
    }
    return _bigLeftImageView;
}
-(UIImageView *)bigRightImageView{
    if (!_bigRightImageView) {
        _bigRightImageView = [[YHImageView alloc]initWithFrame:CGRectMake(self.frame.size.width /2 +0.5, 0, self.frame.size.width /2 -0.5, 170)];
        _bigRightImageView.backgroundColor = [UIColor redColor];
        _bigRightImageView.target = self;
    }
    return _bigRightImageView;
}
-(UIImageView *)mediumTopImageView{
    if (!_mediumTopImageView) {
        _mediumTopImageView = [[YHImageView alloc]initWithFrame:CGRectMake(self.frame.size.width /2 +0.5, 0, self.frame.size.width /2 -0.5 , 84.5)];
        _mediumTopImageView.backgroundColor = [UIColor redColor];
        _mediumTopImageView.target = self;
    }
    return _mediumTopImageView;
}
-(UIImageView *)mediumBottomImageView{
    if (!_mediumBottomImageView) {
        _mediumBottomImageView = [[YHImageView alloc]initWithFrame:CGRectMake(self.frame.size.width /2 +0.5, _mediumTopImageView.bottom + 1, self.frame.size.width /2 -0.5, 84.5)];
        _mediumBottomImageView.backgroundColor = [UIColor redColor];
        _mediumBottomImageView.target = self;
    }
    return _mediumBottomImageView;
}
-(UIImageView *)smallLeftImageView{
    if (!_smallLeftImageView) {
        _smallLeftImageView = [[YHImageView alloc]initWithFrame:CGRectMake(self.frame.size.width /2 +0.5, _mediumTopImageView.bottom + 1, 79.5, 84.5)];
        _smallLeftImageView.backgroundColor = [UIColor redColor];
        _smallLeftImageView.target = self;
    }
    return _smallLeftImageView;
}
-(UIImageView *)smallRightImageView{
    if (!_smallRightImageView) {
        _smallRightImageView = [[YHImageView alloc]initWithFrame:CGRectMake(_smallLeftImageView.right+0.5, _mediumTopImageView.bottom + 1, 79.5, 84.5)];
        _smallRightImageView.backgroundColor = [UIColor redColor];
        _smallRightImageView.target = self;
    }
    return _smallRightImageView;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"<%@: %p,%@ %@>",[self class],self,self.delegate,self.subviews];
}
-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p,%@ %@>",[self class],self,self.delegate,self.subviews];
}
@end
