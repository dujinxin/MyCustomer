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

#import "EGORefreshTableFooterOtherView.h"

@interface EGORefreshTableFooterOtherView (Private)
- (void)setState:(EGOPullRefreshOtherState)aState;
@end

@implementation EGORefreshTableFooterOtherView

@synthesize delegate=_delegate;


- (id)initWithOtherFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame]))
    {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, 20.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:EGOOPullRefreshOtherNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithOtherFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

#define aMinute 60
#define anHour 3600
#define aDay 86400

- (void)refreshLastOtherUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceLastOtherUpdated:)]) {
		//得到当前时间
      
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
		NSDate *date = [_delegate egoRefreshTableDataSourceLastOtherUpdated:self];
        /*
        //获取上次加载的时间
        NSString * str_L = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
        NSDate * data_L = [dateFormatter dateFromString:str_L];
        
        NSTimeInterval timeSinceLastUpdate = [data_L timeIntervalSinceNow];
        NSInteger timeToDisplay = 0;
//        timeSinceLastUpdate *= -1;
        if(timeSinceLastUpdate < anHour) {
            timeToDisplay = (NSInteger) (timeSinceLastUpdate / aMinute);
            
            if(timeToDisplay ==  1) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"更新于 %ld 分钟之前",@"PullTableViewLan",@"Last uppdate in minutes singular"),(long)timeToDisplay];
            } else {
                
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"更新于 %ld 分钟之前",@"PullTableViewLan",@"Last uppdate in minutes plural"), (long)timeToDisplay];
                
            }
            
        } else if (timeSinceLastUpdate < aDay) {
            timeToDisplay = (NSInteger) (timeSinceLastUpdate / anHour);
            if(timeToDisplay == 1) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"更新于 %ld 小时之前",@"PullTableViewLan",@"Last uppdate in hours singular"), (long)timeToDisplay];
            } else {
              
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"更新于 %ld 小时之前",@"PullTableViewLan",@"Last uppdate in hours plural"), (long)timeToDisplay];
                
            }
            
        } else {
            timeToDisplay = (NSInteger) (timeSinceLastUpdate / aDay);
            if(timeToDisplay == 1) {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"更新于 %ld 天之前",@"PullTableViewLan",@"Last uppdate in days singular"), (long)timeToDisplay];
            } else {
                _lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"更新于 %ld 天之前",@"PullTableViewLan",@"Last uppdate in days plural"), (long)timeToDisplay];
            }
            
        }

		*/
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"刷新时间: %@", [dateFormatter stringFromDate:date]];
//       NSString * str_Date =  [dateFormatter stringFromDate:date];
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshOtherState)aState{
	
	switch (aState) {
		case EGOOPullRefreshOtherPulling:
			
			_statusLabel.text = NSLocalizedString(@"松开加载", @"松开加载");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            _arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshOtherNormal:
			
			if (_state == EGOOPullRefreshOtherPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉加载.", @"上拉加载");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			//_arrowImage.transform = CATransform3DIdentity;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			[self refreshLastOtherUpdatedDate];
			
			break;
		case EGOOPullRefreshOtherLoading:
			
			_statusLabel.text = NSLocalizedString(@"正在加载", @"正在加载");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshOtherScrollViewDidScroll:(UITableView *)scrollView {	
	
	if (_state == EGOOPullRefreshOtherLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MAX(offset, 60);
        if (scrollView.contentSize.height > scrollView.frame.size.height)
        {
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT_OTHER, 0.0f);
        }
		else
        {
//            if (scrollView.contentSize.height )
//            {
//                <#statements#>
//            }
            CGFloat heG = scrollView.frame.size.height - scrollView.contentSize.height+REFRESH_REGION_HEIGHT_OTHER;
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, heG, 0.0f);
        }
	}
    else if (scrollView.isDragging)
    {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsOtherLoading:)]) {
			_loading = [_delegate egoRefreshTableDataSourceIsOtherLoading:self];
		}
		
		if (_state == EGOOPullRefreshOtherPulling &&
            (scrollView.contentOffset.y+scrollView.frame.size.height) < scrollView.contentSize.height+REFRESH_REGION_HEIGHT_OTHER &&
            scrollView.contentOffset.y > 0.0f && !_loading)
        {
			[self setState:EGOOPullRefreshOtherNormal];
		}
        else if (_state == EGOOPullRefreshOtherNormal &&
                   scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT_OTHER && !_loading)
        {
			[self setState:EGOOPullRefreshOtherPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshOtherScrollViewDidEndDragging:(UITableView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsOtherLoading:)]) {
		_loading = [_delegate egoRefreshTableDataSourceIsOtherLoading:self];
	}
	
	if (scrollView.contentOffset.y+(scrollView.frame.size.height) > scrollView.contentSize.height+REFRESH_REGION_HEIGHT_OTHER  && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerOtherRefresh:)]) {
			[_delegate egoRefreshTableDidTriggerOtherRefresh:EGORefreshFooter];
		}
		
		[self setState:EGOOPullRefreshOtherLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_REGION_HEIGHT_OTHER, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshOtherScrollViewDataSourceDidFinishedLoading:(UITableView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshOtherNormal];

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
