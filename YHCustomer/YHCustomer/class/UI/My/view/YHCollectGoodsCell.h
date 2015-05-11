//
//  YHCollectGoodsCell.h
//  YHCustomer
//
//  Created by kongbo on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsEntity.h"
#import "PromotionEntity.h"
@class UILabelStrike;

typedef void(^CartBlock) ();
typedef void (^RefreshCollectVC) ();


@interface YHCollectGoodsCell : UITableViewCell
@property(nonatomic,strong)UIImageView *_logoImage;
@property(nonatomic,strong)UIImageView *_dmImage;
@property(nonatomic,strong)UILabel *_dmCity;
@property(nonatomic,strong)UILabel *_goodInfo;
@property(nonatomic,strong)UILabel *_price;
@property(nonatomic,strong)UILabelStrike *_originalPrice;
@property(nonatomic,strong)UILabel *_goodsCity;
@property(nonatomic,strong)UIButton *cart;
@property(nonatomic,strong)GoodsEntity *entity;
@property(nonatomic,strong)UILabel  *labelCartStatus;

@property (nonatomic,strong) UILabel * _limit;
@property (nonatomic,strong) UILabel * _special;

@property (nonatomic,strong) UILabel * _illustrate;

@property (nonatomic, strong) CartBlock cartBlock;
@property (nonatomic, strong) RefreshCollectVC collectBlock;

-(void)setGoodsCellData:(GoodsEntity *)entity;
-(void)setDmCellData:(DmEntity *)entity;
@end
