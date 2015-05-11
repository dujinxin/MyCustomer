//
//  TORSegmentControl.m
//  Torch
//
//  Created by 薛靖博 on 14/11/28.
//  Copyright (c) 2014年 wangtiansoft. All rights reserved.
//
#define SELEVIEWBACK [UIColor colorWithWhite:1 alpha:1]
#define VIEWBACK [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1]

#import "TORSegmentControl.h"

@interface TORSegmentControl ()
@property (nonatomic, strong) NSMutableArray *lbTitles;
@property (nonatomic, assign) BOOL verticle;
@property (nonatomic ,strong) NSMutableArray * viewTitles;
@end

@implementation TORSegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    return self;
}

- (instancetype)initWithItems:(NSMutableArray *)items vertical:(BOOL)verticle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedTintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        self.selectedTintColor_P = [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
        
        self.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        self.tintColor_P = [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
        
        self.tintSize = 15.f;
        self.tintSize_P = 12.f;
        
        self.lbTitles = items;
        self.verticle = verticle;
    
    }
    return self;
}

- (instancetype)initWithItems:(NSMutableArray *)items {
    self = [self initWithItems:items vertical:NO];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    NSInteger count = self.lbTitles.count;
    CGFloat width_L = size.width/count;
    if (!_verticle)
    {
        for (int i=0; i<count; i++)
        {
//            UIView * view_L = [[UIView alloc] initWithFrame:CGRectMake(width_L*i, 0, width_L, size.height)];
            UIView * view_L = (UIView *)self.viewTitles[i];
            CGRect frame = CGRectMake(width_L*i, 0, width_L, size.height);
            [view_L setFrame:frame];
            NSArray * arr = [self.lbTitles objectAtIndex:i];
            for (int j = 0 ; j < arr.count; j++)
            {
                if (j == 0 )
                {
                    UILabel * lab = [arr objectAtIndex:j];
                    CGRect rect  = CGRectMake(0, 5, width_L, 20);
                    [lab setFrame:rect];
                }
                else
                {
                    UILabel * lab = [arr objectAtIndex:j];
                    CGRect rect  = CGRectMake(0, 28, width_L, 12);
//                    lab.backgroundColor = [UIColor greenColor];
                    [lab setFrame:rect];
                }
            }
//            UILabel *lb = (UILabel *)self.lbTitles[i];
//            CGRect frame = CGRectMake(size.width / count * i, 0, size.width / count, size.height);
//            [lb setFrame:frame];
        }
    }
    else
    {
        for (int i=0; i<count; i++)
        {
            UILabel *lb = (UILabel *)self.lbTitles[i];
            CGRect frame = CGRectMake(0, size.height / count * i, size.width, size.height / count);
            lb.frame = frame;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (int i=0; i<_viewTitles.count ; i++)
    {
        UIView * view_T = _viewTitles[i];
//        UISegmentedControl
//        CGRect textRect1 = view_T.frame;
        if (i < _viewTitles.count-1)
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(view_T.frame.size.width-1, 0, 1, view_T.frame.size.height)];
            view.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1];
            [view_T addSubview:view];
        }
        /*
        UILabel *titleLabel = _lbTitles[i];
        CGRect textRect = titleLabel.frame;
        if (_haveLine)
        {
            CGContextRef contextRef = UIGraphicsGetCurrentContext();
            CGFloat descender = titleLabel.font.descender;
            
            if(i == _selectedSegmentIndex)
            {
                CGContextSetStrokeColorWithColor(contextRef, _selectedTintColor.CGColor);
                CGContextSetLineWidth(contextRef, 1.5);
            }
            else
            {
                CGContextSetStrokeColorWithColor(contextRef, _tintColor.CGColor);
                CGContextSetLineWidth(contextRef, 0.5);
            }
            
            CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
            CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
            
            CGContextClosePath(contextRef);
            CGContextDrawPath(contextRef, kCGPathStroke);
        }
         */
    }
}
-(void)upTitles:(NSMutableArray *)lbT
{
    for (int i = 0; i < lbT.count; i++)
    {
        NSArray * arr = [lbT objectAtIndex:i];
        for (int j = 0 ; j < arr.count; j ++)
        {
            UILabel * lab =  self.lbTitles[i][j];
            lab.text = arr[j];
        }
    }
}
#pragma mark - set
- (void)setLbTitles:(NSMutableArray *)lbTitles
{
    _lbTitles = [[NSMutableArray alloc] init];
    _viewTitles = [[NSMutableArray alloc] init];
    for (int i=0; i<lbTitles.count; i++)
    {
        NSMutableArray * arr_T = [[NSMutableArray alloc] init];
        UIView * view_T = [[UIView alloc] init];
        view_T.tag = i;
        view_T.backgroundColor = [UIColor clearColor];
        [self addSubview:view_T];
        
        NSMutableArray * arr = (NSMutableArray *)lbTitles[i];
        for (int j = 0 ; j < arr.count ; j++)
        {
            if (j == 0)
            {
                UILabel *lb = [[UILabel alloc] init];
                lb.text = arr[j];
                lb.tag = j;
                lb.font = [UIFont systemFontOfSize:self.tintSize];
                lb.backgroundColor = [UIColor clearColor];
                [lb setTextAlignment:NSTextAlignmentCenter];
                lb.textColor = self.tintColor;
                [view_T addSubview:lb];
                [arr_T addObject:lb];
            }
            else
            {
                UILabel *lb = [[UILabel alloc] init];
                lb.text = arr[j];
                lb.tag = j;
                lb.font = [UIFont systemFontOfSize:self.tintSize_P];
                lb.backgroundColor = [UIColor clearColor];
                [lb setTextAlignment:NSTextAlignmentCenter];
                lb.textColor = self.tintColor_P;
                [view_T addSubview:lb];
                [arr_T addObject:lb];
            }
        }
        [_lbTitles addObject:arr_T];
        [_viewTitles addObject:view_T];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    [self setNeedsDisplay];
    
    for (UIView * view in self.viewTitles)
    {
        if (view.tag == selectedSegmentIndex)
        {
            NSArray * arr = [self.lbTitles objectAtIndex:view.tag];
            for (int i = 0 ; i < arr.count ; i ++)
            {
                if (i == 0 )
                {
                    UILabel * lab_1 = (UILabel *)arr[i];
                    lab_1.textColor = self.selectedTintColor;
                }
                else
                {
                    UILabel * lab_1 = (UILabel *)arr[i];
                    lab_1.textColor = self.selectedTintColor_P;
                }
            }
            view.backgroundColor = SELEVIEWBACK;
        }
        else
        {
            NSArray * arr = [self.lbTitles objectAtIndex:view.tag];
            for (int i = 0 ; i < arr.count ; i ++)
            {
                if (i == 0 )
                {
                    UILabel * lab_1 = (UILabel *)arr[i];
                    lab_1.textColor = self.tintColor;
                }
                else
                {
                    UILabel * lab_1 = (UILabel *)arr[i];
                    lab_1.textColor = self.tintColor_P;
                }
            }
            view.backgroundColor = VIEWBACK;
        }
    }
    
//    for (UILabel *lb in self.lbTitles)
//    {
//        if (lb.tag == selectedSegmentIndex)
//        {
//            lb.textColor = self.selectedTintColor;
//        }
//        else
//        {
//            lb.textColor = self.tintColor;
//        }
//    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    for (int i=0; i<self.lbTitles.count; i++)
    {
        UILabel *lb = [self.lbTitles[i] objectAtIndex:0];
        
        if (i != _selectedSegmentIndex)
        {
            [lb setTextColor:_tintColor];
        }
    }
}

-(void)setTintColor_P:(UIColor *)tintColor_P
{
    _tintColor_P = tintColor_P;
    
    for (int i=0; i<self.lbTitles.count; i++)
    {
        UILabel *lb = [self.lbTitles[i] objectAtIndex:1];
        if (i != _selectedSegmentIndex)
        {
            [lb setTextColor:_tintColor_P];
        }
    }
}

- (void)setSelectedTintColor:(UIColor *)selectedTintColor
{
    _selectedTintColor = selectedTintColor;
    UILabel *lb = [self.lbTitles[_selectedSegmentIndex] objectAtIndex:0];
    [lb setTextColor:_selectedTintColor];
    UILabel *lb_P = [self.lbTitles[_selectedSegmentIndex] objectAtIndex:1];
    [lb_P setTextColor:_selectedTintColor_P];
}

- (void)setTintSize:(CGFloat)tintSize
{
    _tintSize = tintSize;
    for (int i=0; i<self.lbTitles.count; i++) {
        UILabel *lb = [self.lbTitles[i] objectAtIndex:0];
        [lb setFont:[UIFont systemFontOfSize:_tintSize]];
        
        UILabel *lb_P = [self.lbTitles[i] objectAtIndex:1];
        [lb_P setFont:[UIFont systemFontOfSize:_tintSize_P]];
    }
}

#pragma mark - UIControl
/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (UIView *view in self.viewTitles)
    {
        CGRect frame = view.frame;
        
        if (CGRectContainsPoint(frame, point))
        {
            [self setSelectedSegmentIndex:view.tag];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            return;
        }
    }
    return;

}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    [self beginTrackingWithTouch:touch withEvent:event];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    [self continueTrackingWithTouch:touch withEvent:event];
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint point = [touch locationInView:self];
    
    for (UIView *view in self.viewTitles)
    {
        CGRect frame = view.frame;
        
        if (CGRectContainsPoint(frame, point))
        {
            [self setSelectedSegmentIndex:view.tag];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            return YES;
        }
    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
}

@end
