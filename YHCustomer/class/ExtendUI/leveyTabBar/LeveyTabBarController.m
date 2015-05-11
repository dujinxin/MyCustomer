//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
//#define LEVEYTABBARHEIGHT 63.0f
#define LEVEYTABBARHEIGHT 49.0f
#define LeveyTabbarHeight 49.0f

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
    UIViewController *vc = self.parentViewController;
    while (vc) {
        if ([vc isKindOfClass:[LeveyTabBarController class]]) {
            return (LeveyTabBarController *)vc;
        } else if (vc.parentViewController && vc.parentViewController != vc) {
            vc = vc.parentViewController;
        } else {
            vc = nil;
        }
    }
    return nil;
}

@end

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation LeveyTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
{
	self = [super init];
	if (self != nil)
	{
        float originY = 0.0f;
        if (IOS_VERSION >= 7)
        {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//            originY = 20;
        }
        
		_viewControllers = [[NSMutableArray arrayWithArray:vcs] retain];
		
		_containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _containerView.backgroundColor = [UIColor clearColor];
        
		_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, 320.0f, _containerView.frame.size.height - kTabBarHeight)];
		_transitionView.backgroundColor =  [UIColor whiteColor];

		
		_tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, originY + _containerView.frame.size.height - LEVEYTABBARHEIGHT, SCREEN_WIDTH, LEVEYTABBARHEIGHT) buttonImages:arr];
        _tabBar.backgroundColor = [UIColor clearColor];
		_tabBar.delegate = self;
        NSLog(@"_containerView.frame:%@",NSStringFromCGRect(_containerView.frame));
        NSLog(@"_tabBar.frame:%@",NSStringFromCGRect(_tabBar.frame));
        NSLog(@"_transitionView.frame:%@",NSStringFromCGRect(_transitionView.frame));
	}
	return self;
}

- (void)loadView 
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
    self.selectedIndex = 0;
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	
	_tabBar = nil;
	_viewControllers = nil;
}

- (void)dealloc 
{
    _tabBar.delegate = nil;
	[_tabBar release];
    [_containerView release];
    [_transitionView release];
	[_viewControllers release];
    [super dealloc];
}

#pragma mark - instant methods
- (LeveyTabBar *)tabBar
{
	return _tabBar;
}

- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}

- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
	}
	else
	{
		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
	}
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
{
    _tabBarHidden = yesOrNO;
	if (yesOrNO == YES) {
		if (self.tabBar.frame.origin.y  == self.view.frame.size.height) {
			return;
		}
	} else {
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - LEVEYTABBARHEIGHT) {
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
    }

    
    float tabBarOriginY = tabBarOriginY = yesOrNO ? self.view.frame.size.height : self.view.frame.size.height - LEVEYTABBARHEIGHT;
    self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, tabBarOriginY, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    
    
    float transitionViewOriginY = tabBarOriginY = yesOrNO ? self.view.frame.size.height : self.view.frame.size.height - kTabBarHeight;
    _transitionView.frame = CGRectMake(_transitionView.frame.origin.x, _transitionView.frame.origin.y, _transitionView.frame.size.width, transitionViewOriginY);
    
    if (animated == YES)
	{
		[UIView commitAnimations];
	}
    
    
    
    
    
    
//    if (yesOrNO == YES)
//	{
//		if (self.tabBar.frame.origin.y + 12 == self.view.frame.size.height)
//		{
//			return;
//		}
//	}
//	else
//	{
//		if (self.tabBar.frame.origin.y + 12 == self.view.frame.size.height - kTabBarHeight)
//		{
//			return;
//		}
//	}
//	
//    NSLog(@"self.tabBar.frame is %f",self.tabBar.frame.origin.y);
//    NSLog(@"self.view.frame.size.heigh %f",self.view.frame.size.height - 48);
//    
//	if (animated == YES)
//	{
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.3f];
//        
//        if (yesOrNO == YES)
//        {
//            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//        }
//        else
//        {
//            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//        }
//        
//        
//		[UIView commitAnimations];
//	}
//	else
//	{
//		if (yesOrNO == YES)
//		{
//			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//		}
//		else
//		{
//			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//		}
//	}
}

- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}

- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    // If target index is equal to current index.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    
    _selectedIndex = index;
    if (_selectedIndex != 4) {
        [_transitionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
        targetViewController.view.frame = _transitionView.bounds;
        [self addChildViewController:targetViewController];
        [_transitionView addSubview:targetViewController.view];
    }
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
    }
}

#pragma mark -
#pragma mark tabBar delegates
- (BOOL)tabBar:(LeveyTabBar *)tabBar shouldSelectIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        return [_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]];
        NSLog(@"index = %ld",(long)index);
    }
    return YES;
}

- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self displayViewAtIndex:index];
}
@end