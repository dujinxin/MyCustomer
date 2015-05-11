//
//  GoodsView.m
//  YHCustomer
//
//  Created by lichentao on 14-4-30.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "GoodsView.h"
#import "GoodsEntity.h"
@implementation GoodsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 设置商品数组
- (void)setGoodsArray:(NSMutableArray *)goodsArray{
    [self removeAllSubviews];
    UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 15, 15, 18)];
    accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
    /* cell中 商品列表 */
    if(goodsArray.count == 1) {
        GoodsEntity *goodsEnty = [goodsArray objectAtIndex:0];
        UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 38, 38)];
        [goodsImageView setImageWithURL:[NSURL URLWithString:goodsEnty.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
        goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
        goodsImageView.layer.borderWidth = .1f;
        [self addSubview:goodsImageView];
        
        UILabel *goodsInfo = [PublicMethod addLabel:CGRectMake(60, 1, 200, 30) setTitle:goodsEnty.goods_name setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:goodsInfo];
        goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
        goodsImageView.layer.borderWidth = 1.0f;
        
        [self addSubview:accessImg];
        
    }else if(goodsArray.count <=3 && goodsArray.count > 1){
        for (int i = 0; i <goodsArray.count; i ++) {
            GoodsEntity *goodsEnty = [goodsArray objectAtIndex:i];
            UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10 + i*45, 5, 38, 38)];
            [goodsImageView setImageWithURL:[NSURL URLWithString:goodsEnty.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
            goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
            goodsImageView.layer.borderWidth = 1.0f;
            [self addSubview:goodsImageView];
        }
        [self addSubview:accessImg];
        
    }
    else if(goodsArray.count > 3){
        for (int i = 0; i < 3; i ++) {
            GoodsEntity *goodsEnty = [goodsArray objectAtIndex:i];
            UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10 + i*45, 5, 38, 38)];
            [goodsImageView setImageWithURL:[NSURL URLWithString:goodsEnty.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
            goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
            goodsImageView.layer.borderWidth = 1.0f;
            [self addSubview:goodsImageView];
        }
        UILabel *pointLabel = [PublicMethod addLabel:CGRectMake(150, 10, 100, 18) setTitle:@"..." setBackColor:[UIColor grayColor] setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:pointLabel];
        [self addSubview:accessImg];
    }
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
