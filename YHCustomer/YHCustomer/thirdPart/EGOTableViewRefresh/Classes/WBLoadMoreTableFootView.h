//
//  WBLoadMoreTableFootView.h
//  mystore_employees
//
//  Created by wangbob on 13-2-4.
//  Copyright (c) 2013年 ChangShengTianDi std. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

typedef enum{
	LoadMorePulling = 0,
	LoadMoreNormal,
	LoadMoreLoading,
} LoadMoreState;

@protocol WBLoadMoreTableFooterDelegate;
@interface WBLoadMoreTableFootView : UIView {
	id _delegate;
	LoadMoreState    _state;
	UILabel          *_statusLabel;
	UIActivityIndicatorView *_activityView;
//    BOOL _isHasMore;
}

@property(nonatomic,assign) id <WBLoadMoreTableFooterDelegate> delegate;
//@property(nonatomic,assign) BOOL isHasMore;
- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol WBLoadMoreTableFooterDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(WBLoadMoreTableFootView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(WBLoadMoreTableFootView *)view;
@end