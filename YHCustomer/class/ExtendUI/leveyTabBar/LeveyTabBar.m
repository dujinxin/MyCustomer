//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import "LeveyTabBar.h"

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;
@synthesize animatedView = _animatedView;
@synthesize numButton;
- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
//		[self addSubview:_backgroundView];
		self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor greenColor];
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		UIButton *btn;
//		CGFloat width = 320.0f / [imageArray count];
        CGFloat width = 64;
            // 添加购物车数量图标

		for (int i = 0; i < [imageArray count]; i++)
		{
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            if (i !=4) {
//                btn.showsTouchWhenHighlighted = YES;
//            }
			btn.tag = i;
//			btn.frame = CGRectMake(256, 0, 64, 63);
            btn.frame = CGRectMake(256, 0, 64, 49);
            [btn setBackgroundImage: [[imageArray objectAtIndex:i] objectForKey:@"Normal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Selected"] forState:UIControlStateSelected];

			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i != 4) {
//                btn.frame = CGRectMake(width * i, 15, width, 48);
                btn.frame = CGRectMake(width * i, 0, width, 49);
            }
            NSString *strCartNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartNum"];
            if (i == 4)
            {
                numButton = [UIButton buttonWithType:UIButtonTypeCustom];
                numButton.frame = CGRectMake(42, 0, 21, 21);
                [numButton setBackgroundImage:[UIImage imageNamed:@"cart_Icon.png"] forState:UIControlStateNormal];
                [numButton setTitle:[NSString stringWithFormat:@"%@",strCartNum] forState:UIControlStateNormal];
                numButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
                [btn addSubview:numButton];
            }
            if (![UserAccount instance].isLogin || [strCartNum isEqualToString:@"0"] || nil == strCartNum) {
                numButton.hidden = YES;
            }
            [btn setBackgroundColor:[UIColor clearColor]];
			[self.buttons addObject:btn];
			[self addSubview:btn];
		}
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)setAnimatedView:(UIImageView *)animatedView
{
    [_animatedView release];
    [animatedView retain];
    _animatedView = animatedView;
    [self addSubview:animatedView];
}

- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    int index = (int )btn.tag;    
    if ([_delegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)])
    {
        if (![_delegate tabBar:self shouldSelectIndex:index])
        {
            return;
        }
    }
    [self selectTabAtIndex:index];
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
    NSLog(@"%ld",(long)index);
	btn.selected = YES;
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
        NSLog(@"%ld",(long)btn.tag);
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _animatedView.frame = CGRectMake(btn.frame.origin.x, _animatedView.frame.origin.y, _animatedView.frame.size.width, _animatedView.frame.size.height);
    }];
    
//    NSLog(@"Select index: %d",btn.tag);
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width = 320.0f / [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = 320.0f / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Selected"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (void)dealloc
{
    [_backgroundView release];
    [_buttons release];
    [_animatedView release];
    [super dealloc];
}

@end
