    //
//  WBLoadMoreTableFootView.m
//  mystore_employees
//
//  Created by wangbob on 13-2-4.
//  Copyright (c) 2013年 ChangShengTianDi std. All rights reserved.
//

#import "WBLoadMoreTableFootView.h"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface WBLoadMoreTableFootView (Private)
- (void)setState:(LoadMoreState)aState;
@end

@implementation WBLoadMoreTableFootView
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        [label release];
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(150.0f, 20.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        [view release];
        self.hidden = YES;
        
        [self setState:LoadMoreNormal];
    }
    
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{
    switch (aState) {
        case LoadMorePulling:
            _statusLabel.text = NSLocalizedString(@"Release to load more...", @"Release to load more");
            break;
        case LoadMoreNormal:
            //			_statusLabel.text = NSLocalizedString(@"加载更多...", @"Load More");
            _statusLabel.text = NSLocalizedString(@"", @"Load More");
            _statusLabel.hidden = NO;
            [_activityView stopAnimating];
            break;
        case LoadMoreLoading:
            _statusLabel.hidden = YES;
            [_activityView startAnimating];
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y <= 0) {
        return;
    }
    
    if (_state == LoadMoreLoading) {
        //scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
        }
        
        if (_state == LoadMoreNormal && scrollView.contentOffset.y < (scrollView.contentSize.height) && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && !_loading) {
            self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
            self.hidden = NO;
        }
        
        if (scrollView.contentInset.bottom != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= 0) {
        return;
    }
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) && !_loading) {
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
            [_delegate loadMoreTableFooterDidTriggerRefresh:self];
        }
        
        [self setState:LoadMoreLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [UIView commitAnimations];
    }
    //    NSLog(@"contentInset:%f",scrollView.contentInset.bottom);
    
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    //    NSLog(@"contentInset:%f",scrollView.contentInset.bottom);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    [self setState:LoadMoreNormal];
    
    self.hidden = YES;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    [super dealloc];
}


@end