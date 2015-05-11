//
//  YHCartView.m
//  YHCustomer
//
//  Created by kongbo on 14-6-24.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHCartView.h"

@implementation YHCartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]init];
        [ges addTarget:self action:@selector(clickAction)];
        [self addGestureRecognizer:ges];
        
        [self initView];
    }
    return self;
}

-(void)initView {
    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [image setImage:[UIImage imageNamed:@"btn购物车003"]];
    [self addSubview:image];
    
    corner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [corner setImage:[UIImage imageNamed:@"cartview_2"]];
//    [corner setImage:[UIImage imageNamed:@"cart_Icon"]];
    [corner setHidden:YES];
    [self addSubview:corner];
    
    numLabel = [PublicMethod addLabel:CGRectMake(24, 8, 28, 14) setTitle:@"" setBackColor:[UIColor whiteColor] setFont:[UIFont systemFontOfSize:16.0]];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.numberOfLines = 1;
    numLabel.backgroundColor = [UIColor clearColor];

    [self changeCartNum];

    [corner addSubview:numLabel];
}

-(void)changeCartNum {

    NSString *totalNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"cartNum"];
    if (![totalNum isEqualToString:@"0"] && totalNum) {
        [corner setHidden:NO];
        if ([totalNum intValue]>99){
            numLabel.text = @"99+";
        }
        else
        {
            numLabel.text = totalNum;
        }
    } else {
        [corner setHidden:YES];
        numLabel.text = @"";
    }
    
    [[NetTrans getInstance] getCartGoodsNum:self];

}

#pragma mark -------------  click
-(void)clickAction {
    if (self.delegate) {
        [self.delegate cartViewClickAction];
    }
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == t_API_CART_TOTAL_API)
    {
    }
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
        
        
        if (![totalNum isEqualToString:@"0"]) {
            [corner setHidden:NO];
            if ([totalNum intValue]>99) {
                numLabel.text = @"99+";
            } else {
                numLabel.text = totalNum;
            }
        } else {
            [corner setHidden:YES];
            numLabel.text = @"";
        }
    }
}

@end
