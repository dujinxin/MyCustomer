//
//  GuideView.m
//  myappone
//
//  Created by liu yao on 13-1-9.
//  Copyright (c) 2013年 ChangShengTianDi std. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView
@synthesize endBtn = _endBtn;
-(void)dealloc
{
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = YES;
        _mainScrollView.contentSize = CGSizeMake(frame.size.width * 6, SCREEN_HEIGHT);
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.scrollEnabled = YES;
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(60, SCREEN_HEIGHT - 30 , 200, 30)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = 6;
        for (int i = 0; i < 6; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            if (iPhone5) {
                UIImage * img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_0%d_5",i+1] ofType:@"jpg"]];
                [image setImage:img];
                
            }else{
                [image setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_0%d",i+1] ofType:@"jpg"]]];
            }

            [_mainScrollView addSubview:image];
            [image release];
            if (i == 5) {
                self.endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (iPhone5){
                    [_endBtn setFrame:CGRectMake(320*i + 100, frame.size.height -140, SCREEN_WIDTH -200, 40)];
                }else{
                    [_endBtn setFrame:CGRectMake(320*i + 100, frame.size.height -110, SCREEN_WIDTH -200, 40)];
                }
                
                [_endBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                _endBtn.backgroundColor = [UIColor clearColor];
//                _endBtn.backgroundColor = [UIColor redColor];
                [_mainScrollView addSubview:_endBtn];
                [self addSubview:_mainScrollView];
                [_mainScrollView release];
            }
        }

    }
    return self;
}
-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(frame.size.width * imageArray.count, SCREEN_HEIGHT);
        _mainScrollView.delegate = self;
        _mainScrollView.scrollEnabled = YES;
        [self addSubview:_mainScrollView];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(60, 440 , 200, 30)];
        _pageControl.backgroundColor = [UIColor grayColor];
        _pageControl.numberOfPages = 6;
        [_pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
//            if (iPhone5) {
//                [image setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"welcome%d-568h@2x",i+1] ofType:@"png"]]];
//            }else{
//                [image setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"welcome%d",i+1] ofType:@"png"]]];
//            }
            [image setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_0%d",i+1] ofType:@"jpg"]]];
            [_mainScrollView addSubview:image];
            [image release];
            if (i == 5) {
                self.endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_endBtn setFrame:CGRectMake(320*i, 0, 320, frame.size.height-20)];
                [_endBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_mainScrollView addSubview:_endBtn];
                [self addSubview:_endBtn];
                [_mainScrollView release];
            }
        }
        
    }
    return self;
}
- (void)btnClick:(UIButton *)btn
{
    if ([(id)self.delegate respondsToSelector:@selector(guideViewDidFinish)]) {
        [self.delegate guideViewDidFinish];
    }
    [self hideWithFadeOutDuration:0.3];
}
- (void)valueChange:(UIPageControl *)page{
    [_mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page.currentPage, SCREEN_HEIGHT)];
}
- (void)hideWithFadeOutDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:nil];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/320;
    
//    if (_pageControl.currentPage == 4) {
//        if ([(id)self.delegate respondsToSelector:@selector(guideViewDidFinish)]) {
//            [self.delegate guideViewDidFinish];
//        }
//    }else{
//        _mainScrollView.contentOffset = CGPointMake(320 * _pageControl.currentPage, 0);
//    }
    if (_mainScrollView.contentOffset.x/320.0 < 0.5 ) {
        _pageControl.currentPage = 0;
    }else if (_mainScrollView.contentOffset.x/320.0 >= 0.5 && _mainScrollView.contentOffset.x/320.0 < 1.5) {
        _pageControl.currentPage = 1;
    }else if (_mainScrollView.contentOffset.x/320.0 >= 1.5 && _mainScrollView.contentOffset.x/320.0 < 2.5) {
        _pageControl.currentPage = 2;
    }else if (_mainScrollView.contentOffset.x/320.0 >= 2.5 && _mainScrollView.contentOffset.x/320.0 < 3.5) {
        _pageControl.currentPage = 3;
    }else if (_mainScrollView.contentOffset.x/320.0 >= 3.5 && _mainScrollView.contentOffset.x/320.0 < 4) {
        _pageControl.currentPage = 4;
    }else if (_mainScrollView.contentOffset.x/320.0 >= 4.5 && _mainScrollView.contentOffset.x/320.0 < 5) {
        _pageControl.currentPage = 5;
    }else if (_mainScrollView.contentOffset.x/320.0 > 5) {
        if ([(id)self.delegate respondsToSelector:@selector(guideViewDidFinish)]) {
            [self.delegate guideViewDidFinish];
        }
        [self hideWithFadeOutDuration:0.3];
    }
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
