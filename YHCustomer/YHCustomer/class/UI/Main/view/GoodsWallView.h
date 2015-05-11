//
//  GoodsWallView.h
//  YHCustomer
//
//  Created by lichentao on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsEntity.h"

typedef void(^GoodsViewBlock)(GoodsEntity *goodsEntity);       // 点击整个商品
typedef void(^GoodsCartAddBlock)(GoodsEntity *goodsEntity);    // 点击加入购物车

@interface GoodsWallView : UIView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) GoodsViewBlock    goodsBlock;
@property (nonatomic, strong) GoodsCartAddBlock addCartBlock;
@property (nonatomic, strong) GoodsEntity       *myGoodsEntity;


- (void)setGoodsEntityWithBlock:(GoodsEntity *)goodsEntity GoodsViewBlock:(GoodsViewBlock)goodsViewBlock1 GoodsCartAddBlock:(GoodsCartAddBlock) cartAddBlock1;

@end
