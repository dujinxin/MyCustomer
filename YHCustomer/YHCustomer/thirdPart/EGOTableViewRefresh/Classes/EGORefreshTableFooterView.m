//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableFooterView.h"

@interface EGORefreshTableFooterView (Private)
- (void)setState:(EGOLoadMoreState)aState;
@end

@implementation EGORefreshTableFooterView

@synthesize delegate=_delegate;
@synthesize isHasMore = _isHasMore;
@synthesize loadingState = _loadingState;


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {

		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 40.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        _lastUpdatedLabel.hidden = YES;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 10.0f, 140.f, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
        label.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
		label.textAlignment = UITextAlignmentLeft;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
//		CALayer *layer = [CALayer layer];
//		layer.frame = CGRectMake(25.0f, 20.0f, 30.0f, 55.0f);
//		layer.contentsGravity = kCAGravityResizeAspect;
//		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
		
//		[[self layer] addSublayer:layer];
//		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(120.0f, 10.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
//		[self setState:EGOOLoadMoreNormal];
        _state = EGOOLoadMoreNormal;
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoLoadMoreTableDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOLoadMoreState)aState
{
	switch (aState) {
		case EGOOLoadMorePulling:
//			_statusLabel.text = NSLocalizedString(@"Release to load more...", @"Release to load more");
//            if (_isHasMore) {
                _statusLabel.text = @"松开加载";
                [_activityView startAnimating];
                _statusLabel.frame =CGRectMake(150.0f, 10.0f, 140.f, 20.0f);
//            }else{
//                _statusLabel.text = @"亲，更多商品上架在即哟~";
//                _statusLabel.frame =CGRectMake(80.0f, 20.0f, 180.f, 20.0f);
//                [_activityView stopAnimating];
//            }
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
////			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//            _arrowImage.transform = CATransform3DIdentity;
//			[CATransaction commit];
			
			break;
		case EGOOLoadMoreNormal:
			
			if (_state == EGOOLoadMorePulling) {
//				[CATransaction begin];
//				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//				_arrowImage.transform = CATransform3DIdentity;
//				[CATransaction commit];
			}
			
//			_statusLabel.text = NSLocalizedString(@"Pull up to load more...", @"Pull up to load more");
//            if (_isHasMore) {
                _statusLabel.text = @"上拉加载";
                [_activityView startAnimating];
                _statusLabel.frame =CGRectMake(150.0f, 10.0f, 140.f, 20.0f);
//            }else{
//                _statusLabel.text = @"亲，更多商品上架在即哟~";
//                _statusLabel.frame =CGRectMake(80.0f, 20.0f, 180.f, 20.0f);
//                [_activityView stopAnimating];
//            }
//			[_activityView stopAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = NO;
//			//_arrowImage.transform = CATransform3DIdentity;
//            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
//			
//			[self refreshLastUpdatedDate];
			
			break;
		case EGOOLoadMoreLoading:
			
//			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            switch (_loadingState) {
                case EGOOHasMore:
                {
                    _statusLabel.text = @"正在加载";
                    [_activityView startAnimating];
                    _statusLabel.frame =CGRectMake(150.0f, 10.0f, 140.f, 20.0f);
                }
                    break;
                case EGOOLoadFail:
                {
                    _statusLabel.text = @"加载失败";
                    [_activityView stopAnimating];
                    _statusLabel.frame =CGRectMake(150.0f, 10.0f, 140.f, 20.0f);
                }
                    break;
                case EGOONone:
                {
                    _statusLabel.text = @"亲，更多商品上架在即哟~";
                    _statusLabel.frame =CGRectMake(80.0f, 10.0f, 180.f, 20.0f);
                    [_activityView stopAnimating];
                }
                    break;
                case EGOOOther:
                {
                    _statusLabel.text = @"全部加载完毕";
                    _statusLabel.frame =CGRectMake(130.0f, 10.0f, 180.f, 20.0f);
                    [_activityView stopAnimating];
                }
                    break;
                    
                default:
                    break;
            }
//            if (_isHasMore) {
//                _statusLabel.text = @"正在加载";
//                [_activityView startAnimating];
//                _statusLabel.frame =CGRectMake(150.0f, 20.0f, 140.f, 20.0f);
//            }else{
//                _statusLabel.text = @"亲，更多商品上架在即哟~";
//                _statusLabel.frame =CGRectMake(80.0f, 20.0f, 180.f, 20.0f);
//                [_activityView stopAnimating];
//            }
//			[_activityView startAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = YES;
//			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == EGOOLoadMoreLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 40);
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoLoadMoreTableDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && 
            (scrollView.contentOffset.y+scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT && 
            scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOLoadMoreNormal];
		} else if (_state == EGOOLoadMoreNormal &&
                   scrollView.contentOffset.y+(scrollView.frame.size.height) >= scrollView.contentSize.height+REFRESH_REGION_HEIGHT && !_loading) {
			[self setState:EGOOLoadMorePulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	//自动加载
	}else if (! scrollView.isDragging){
        BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoLoadMoreTableDataSourceIsLoading:self];
		}
		if (_state == EGOOPullRefreshPulling &&scrollView.contentOffset.y+scrollView.frame.size.height < scrollView.contentSize.height &&
            scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOLoadMoreNormal];
		} else if (_state == EGOOLoadMoreNormal &&scrollView.contentOffset.y+(scrollView.frame.size.height) >= scrollView.contentSize.height && !_loading) {
            if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDidTriggerRefresh:)]) {
                [_delegate egoLoadMoreTableDidTriggerRefresh:EGORefreshFooter];
            }
			[self setState:EGOOLoadMoreLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
            [UIView commitAnimations];
            
		}
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
	
}

- (void)egoLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDataSourceIsLoading:)]) {
		_loading = [_delegate egoLoadMoreTableDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y+(scrollView.frame.size.height) >= scrollView.contentSize.height+REFRESH_REGION_HEIGHT  && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDidTriggerRefresh:)]) {
			[_delegate egoLoadMoreTableDidTriggerRefresh:EGORefreshFooter];
		}
		
		[self setState:EGOOLoadMoreLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT, 0.0f);
		[UIView commitAnimations];
		
    }
//    else if(scrollView.contentOffset.y+(scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT && scrollView.contentOffset.y+(scrollView.frame.size.height) >= scrollView.contentSize.height  && !_loading){
//        if ([_delegate respondsToSelector:@selector(egoLoadMoreTableDidTriggerRefresh:)]) {
//            [_delegate egoLoadMoreTableDidTriggerRefresh:EGORefreshFooter];
//        }
//    }
    
	
}

- (void)egoLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
//	[self setState:EGOOLoadMoreNormal];
    _state = EGOOLoadMoreNormal;

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
