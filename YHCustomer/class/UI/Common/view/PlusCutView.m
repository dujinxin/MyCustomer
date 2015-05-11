//
//  PlusCutView.m
//  YHCustomer
//
//  Created by lichentao on 14-5-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "PlusCutView.h"

@implementation PlusCutView
@synthesize numLabel;
@synthesize plusBlock,cutBlock;
@synthesize goodsEntity1;



- (id)initWithFrame:(CGRect)frame GoodsEntity:(GoodsEntity *)goodsEntity Type:(ReturnOrCart)type setPlusBlock:(PlusButtonBlock)plusBlock1 CutButtonBlock:(CutButtonBlock)cutBlock1 ChangeNumBlock:(ChangeNumBlock)changeBlock1
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.plusBlock = plusBlock1;
        self.cutBlock = cutBlock1;
        self.changeBlock = changeBlock1;
        self.goodsEntity1 = goodsEntity;
        self.myType = type;
        if (type == return_Type) {
            maxNum = [goodsEntity.goodNum intValue];
        }else{
            maxNum = 999;
        }
        
        UITapGestureRecognizer *registerReconnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNumButtonClick:)];
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 24, 24)];
        numLabel.text = [NSString stringWithFormat:@"%@",goodsEntity.goodNum];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.userInteractionEnabled = YES;
        numLabel.layer.borderWidth = 1.0;
        numLabel.layer.borderColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0].CGColor;
        numLabel.font = [UIFont systemFontOfSize:12];
        [numLabel addGestureRecognizer:registerReconnizer];
        
        plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.backgroundColor = [UIColor clearColor];
        plusButton.frame = CGRectMake(69, 0, 24, 24);
        plusButton.tag = 1001;
        plusButton.userInteractionEnabled = YES;
        [plusButton setBackgroundImage:[UIImage imageNamed:@"ps_plus.png"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"ps_plus_Select.png"] forState:UIControlStateHighlighted];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"ps_plus_Select.png"] forState:UIControlStateSelected];
        [plusButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cutButton.frame = CGRectMake(0, 0, 24, 24);
        cutButton.backgroundColor = [UIColor clearColor];
        cutButton.tag = 1002;
        cutButton.userInteractionEnabled = YES;
        [cutButton setBackgroundImage:[UIImage imageNamed:@"ps_cut.png"] forState:UIControlStateNormal];
        [cutButton setBackgroundImage:[UIImage imageNamed:@"ps_cut_Select.png"] forState:UIControlStateHighlighted];
        [cutButton setBackgroundImage:[UIImage imageNamed:@"ps_cut_Select.png"] forState:UIControlStateSelected];
        [cutButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:numLabel];
        [self addSubview:cutButton];
        [self addSubview:plusButton];
    }
    return self;
}

- (void)changeNumButtonClick:(id)sender{
    self.changeBlock();
}

- (void)buttonClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1001) {// PLUS
        if ([numLabel.text intValue] == maxNum) {
            [plusButton setBackgroundImage:[UIImage imageNamed:@"ps_plus_Select.png"] forState:UIControlStateNormal];
            return;
        }
        [plusButton setBackgroundImage:[UIImage imageNamed:@"ps_plus.png"] forState:UIControlStateNormal];
        if ([numLabel.text intValue] > 1) {
            [cutButton setBackgroundImage:[UIImage imageNamed:@"ps_cut.png"] forState:UIControlStateNormal];
        }
        
        if (self.myType == cart_Type) {
            plusBool = YES;
            NSLog(@"%@,%@",goodsEntity1.bu_goods_id,goodsEntity1.goods_name);
            [[NetTrans getInstance] changeGoods:self Bu_Goods_Id:goodsEntity1.bu_goods_id Type:@"0"];
            return;
        }
        
        numLabel.text = [NSString stringWithFormat:@"%d",[numLabel.text intValue]+1];
        plusBlock(numLabel.text);
    }else{                // cut
        if ([numLabel.text intValue] == 1) {
            [cutButton setBackgroundImage:[UIImage imageNamed:@"ps_cut_Select.png"] forState:UIControlStateNormal];
            return;
        }
        [cutButton setBackgroundImage:[UIImage imageNamed:@"ps_cut.png"] forState:UIControlStateNormal];
        if (self.myType == cart_Type) {
            plusBool = NO;
            [[NetTrans getInstance] changeGoods:self Bu_Goods_Id:goodsEntity1.bu_goods_id Type:@"1"];
            return;
        }
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)[numLabel.text integerValue]-1];
        cutBlock(numLabel.text);
    }
}


#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_UPDATETOTAL_API) {
        if (plusBool == YES) {
            numLabel.text = [NSString stringWithFormat:@"%ld",(long)[numLabel.text integerValue] + 1];
        }else{
            numLabel.text = [NSString stringWithFormat:@"%ld",(long)[numLabel.text integerValue]-1];
        }
        cutBlock(numLabel.text);
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if (nTag == t_API_UPDATETOTAL_API)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
    }
    [self showNotice:errMsg];
    return;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
