//
//  YHPromotionListCell.h
//  YHCustomer
//
//  Created by kongbo on 14-6-23.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabelStrikeThrough.h"
#import "GoodsEntity.h"

//立即购买点击的时候的代理方法
@protocol btnClickDelegate <NSObject>

@required

-(void)btnViewClickAction;

@end


typedef void(^CartBlock) (NSString * good_id,NSString * total);

@interface YHPromotionListCell : UITableViewCell {
    UIView *bg;
    UIImageView *image;
    UILabel * illustrate;
    UILabel * limit;
    UILabel * special;
    UILabel *title;
    UILabel *price;
    UILabelStrikeThrough *originalPrice;
    UIButton *cartBtn;
    UILabel *cartStatus;
    
    GoodsEntity *entity;
    
    UIView * sp_V;
}

@property (nonatomic, strong) CartBlock cartBlock;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, assign) id<btnClickDelegate>delegate;

-(void)setGoodsCellData:(GoodsEntity *)entity;
- (void)setBgColor:(NSString *)color;


@end
