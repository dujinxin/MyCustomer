//
//  YHDMGoodsWallCell.h
//  YHCustomer
//
//  Created by lichentao on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsWallView.h"

typedef void(^DMGoodsBlock)(GoodsEntity *entity);
typedef void(^DMGoodsAddCartBlock)(GoodsEntity *cartEntity);

@interface YHDMGoodsWallCell : UITableViewCell


@property (nonatomic, strong) DMGoodsBlock dmGoodsViewBlock;
@property (nonatomic, strong) DMGoodsAddCartBlock addCartBlock;

- (void)setCellWithGoodsEntity:(NSMutableArray *)inputGoodsArray DMGoodsBlock:(DMGoodsBlock)dmGoodsBlock1 DMGoodsAddCartBlock:(DMGoodsAddCartBlock)dmGoodsAddCartBlock1;

@end
