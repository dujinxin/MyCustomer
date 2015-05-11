//
//  GoodsWallView.m
//  YHCustomer
//
//  Created by lichentao on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "GoodsWallView.h"

#define GOODS_IMAGE_TAG 101
#define GOODS_NAME_TAG 102
#define GOODS_DISTANTPRICE_TAG 103
#define GOODS_PRICE_TAG 104
#define GOODS_CART_BTN_TAG 105
#define GOODS_OUT_BRANCH_TAG 106

#define GOODS_IMG_WIDTH 140
#define GOODS_IMG_HEIGHT 140

@implementation GoodsWallView
@synthesize myGoodsEntity;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsViewTaped:)]];
        
        UIImageView *goodsImg = [PublicMethod addImageView:CGRectMake(10, 10, GOODS_IMG_WIDTH, GOODS_IMG_HEIGHT) setImage:nil];
        goodsImg.tag = GOODS_IMAGE_TAG;
        [self addSubview:goodsImg];
        
        UILabel *goodsName = [PublicMethod addLabel:CGRectMake(10, 160, 140, 40) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:15]];
        goodsName.tag = GOODS_NAME_TAG;
        [self addSubview:goodsName];
        
        UILabel *discountPrice = [PublicMethod addLabel:CGRectMake(10, 200, 140, 20) setTitle:nil setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f ] setFont:[UIFont systemFontOfSize:20]];
        discountPrice.tag = GOODS_DISTANTPRICE_TAG;
        [self addSubview:discountPrice];
        
        
        UILabelStrikeThrough *price = [[UILabelStrikeThrough alloc] initWithFrame:CGRectMake(10, 225, 80, 20)];
        price.isWithStrikeThrough = YES;
        price.font = [UIFont systemFontOfSize:12];
        price.textColor = [PublicMethod colorWithHexValue:0x999999 alpha:1.0f];
        price.tag = GOODS_PRICE_TAG;
        [self addSubview:price];
        
        UIButton *cartBtn = [PublicMethod addButton:CGRectMake(120, 205, 30, 30) title:nil backGround:@"cart_btn.png" setTag:GOODS_CART_BTN_TAG setId:self selector:@selector(cartBtnClicked:) setFont:nil setTextColor:nil];
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn_Select.png"] forState:UIControlStateHighlighted];
        cartBtn.tag =GOODS_CART_BTN_TAG;
        [self addSubview:cartBtn];
        
        
        //缺货状态
        UILabel  *cartStatus = [PublicMethod addLabel:CGRectMake(110, 205, 50, 30) setTitle:@"补货中" setBackColor:[UIColor orangeColor] setFont:[UIFont systemFontOfSize:14]];
        cartStatus.tag = GOODS_OUT_BRANCH_TAG;
        [self addSubview:cartStatus];
    }
    return self;
}


- (void)setGoodsEntityWithBlock:(GoodsEntity *)goodsEntity GoodsViewBlock:(GoodsViewBlock)goodsViewBlock1 GoodsCartAddBlock:(GoodsCartAddBlock) cartAddBlock1
{
    self.goodsBlock = goodsViewBlock1;
    self.addCartBlock =cartAddBlock1;
    self.myGoodsEntity = goodsEntity;
    
    UIImageView *goodsImg = (UIImageView *)[self viewWithTag:GOODS_IMAGE_TAG];
    UILabel *goodsName = (UILabel *)[self viewWithTag:GOODS_NAME_TAG];
    UILabel *discountPrice = (UILabel *)[self viewWithTag:GOODS_DISTANTPRICE_TAG];
    UILabelStrikeThrough *price = (UILabelStrikeThrough *)[self viewWithTag:GOODS_PRICE_TAG];
    price.hidden = YES;
    UILabel *cartStatus = (UILabel *)[self viewWithTag:GOODS_OUT_BRANCH_TAG];
    UIButton *cartBtn = (UIButton *)[self viewWithTag:GOODS_CART_BTN_TAG];
    
    [goodsImg setImageWithURL:[NSURL URLWithString:goodsEntity.goods_image] placeholderImage:[UIImage imageNamed:@"dm_default.png"]];
    goodsName.text = goodsEntity.goods_name;
    discountPrice.text = [NSString stringWithFormat:@"￥%@",goodsEntity.discount_price];

    price.text = [NSString stringWithFormat:@"￥%@",goodsEntity.price];
    CGSize size = [price.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(80, 20) lineBreakMode:NSLineBreakByCharWrapping];
    price.frame = CGRectMake(10, 225, size.width, size.height);
    
    if ([goodsEntity.out_of_stock intValue] == 1) {
        [cartBtn setHidden:YES];
        [cartStatus setHidden:NO];
    }else{
        [cartBtn setHidden:NO];
        [cartStatus setHidden:YES];
    }
    //0加入购物车，1立即购买
    if (goodsEntity.transaction_type.integerValue == 0) {
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
    }else{
        [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn_shopping"] forState:UIControlStateNormal];
    }
    
    // 现价 <= 原价 将原价加删除线
    if ([goodsEntity.discount_price floatValue] <[goodsEntity.price floatValue]) {
        price.hidden = NO;
//        price.isWithStrikeThrough = YES;
//        [price setNeedsDisplay];
    }
    
    //调整位置
    discountPrice.size = [discountPrice.text sizeWithFont:discountPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
}

// 购物车btn 触发
- (void)cartBtnClicked:(UIButton *)btn{
    if (_addCartBlock) {
        _addCartBlock(myGoodsEntity);
    }
}

// 点击整个商品view
- (void)goodsViewTaped:(id)sender{
    if (_goodsBlock) {
        _goodsBlock(myGoodsEntity);
    }
}

@end
