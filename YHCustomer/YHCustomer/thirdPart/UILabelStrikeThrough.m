//
//  UILabelStrikeThrough.m
//  YHCustomer
//
//  Created by kongbo on 14-3-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "UILabelStrikeThrough.h"

@implementation UILabelStrikeThrough
@synthesize isWithStrikeThrough;
- (void)drawRect:(CGRect)rect
{
    if (isWithStrikeThrough)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGFloat black[4] = {0.5f, 0.5f, 0.5f, 1.0f};
        CGContextSetStrokeColor(c, black);
        CGContextSetLineWidth(c, 1);
        CGContextBeginPath(c);
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
        CGContextMoveToPoint(c, self.bounds.origin.x+3, halfWayUp );
        CGContextAddLineToPoint(c, self.bounds.origin.x + self.bounds.size.width, halfWayUp);
        CGContextStrokePath(c);
    }
    
    [super drawRect:rect];
}

@end
