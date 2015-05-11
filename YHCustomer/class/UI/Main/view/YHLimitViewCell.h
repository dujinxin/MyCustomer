//
//  YHLimitViewCell.h
//  YHCustomer
//
//  Created by dujinxin on 15-1-5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UILabelStrikeThrough.h"
#import "GoodsEntity.h"

typedef void(^CartBlock) ();

@interface YHLimitViewCell : UITableViewCell{
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
    
    UILabel *remainder;
    UIProgressView * progress;
    UIView * progressBg;
    UIView * progressTr;
    
    GoodsEntity *entity;
}
@property (nonatomic, strong) CartBlock cartBlock;
@property (nonatomic, strong) UILabel * title;
-(void)setGoodsCellData:(GoodsEntity *)entity;
- (void)setBgColor:(NSString *)color;
@end
