//
//  YHActionSheet.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-6.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHActionSheet.h"

#define NavBarHeight                    40
#define ViewHeight                      480


//@interface YHActionSheet(){
//@private
//    float customViewHeight;
//}
//@end


@implementation YHActionSheet

@synthesize customView = _customView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(id)initWithViewHeight:(float)height{
    self = [super init];
    if (self) {
        customViewHeight = height;
        self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewHeight - customViewHeight, 320, customViewHeight)];
//        self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewHeight - customViewHeight, 320, customViewHeight)];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.superview addSubview:self.customView];
    
}
- (void)done{
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.delegate actionSheet:self clickedButtonAtIndex:0];
}
@end
