//
//  DMGoodsEntity.h
//  YHCustomer
//
//  Created by kongbo on 13-12-31.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  首页主题推荐商品实体

#import <Foundation/Foundation.h>

@interface DMGoodsEntity : NSObject
@property (nonatomic,strong)NSMutableArray * allGoods;
@property (nonatomic,strong)NSString *tag_id;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSMutableArray *goods_list;
@end

@interface DMGoodsTrans : NetTransObj
@end
