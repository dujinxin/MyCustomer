//
//  YHImageView.m
//  YHCustomer
//
//  Created by dujinxin on 14-12-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHImageView.h"

@implementation YHImageView

@synthesize show_type = _show_type;
@synthesize image_url = _image_url;
@synthesize jump_type = _jump_type;
@synthesize jump_parametric = _jump_parametric;
@synthesize title = _title;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    if ([self.target respondsToSelector:@selector(imageViewAction:)]) {
        [self.target imageViewAction:self];
    }
}
#pragma mark - key-value
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"key:%@",key);
}
@end
