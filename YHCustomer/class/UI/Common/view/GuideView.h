//
//  GuideView.h
//  myappone
//
//  Created by liu yao on 13-1-9.
//  Copyright (c) 2013年 ChangShengTianDi std. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideViewDelegate <NSObject>

- (void)guideViewDidFinish;

@end
@interface GuideView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_mainScrollView;
    UIPageControl * _pageControl;
}
@property (nonatomic, strong) UIButton  * endBtn;
@property (nonatomic, strong) UIScrollView * mainScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) id<GuideViewDelegate> delegate;
@end
