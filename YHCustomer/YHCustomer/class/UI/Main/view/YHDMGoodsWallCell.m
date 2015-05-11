//
//  YHDMGoodsWallCell.m
//  YHCustomer
//
//  Created by lichentao on 14-6-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHDMGoodsWallCell.h"
#import "GoodsWallView.h"

@implementation YHDMGoodsWallCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *lineSeperate = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 0.4) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f]];
        [self addSubview:lineSeperate];
        
        UIView *verticalLine = [PublicMethod addBackView:CGRectMake(160, 0, 0.4, 250) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f]];
        [self addSubview:verticalLine];
        
        UIView *lineSeperate1 = [PublicMethod addBackView:CGRectMake(0, 249, ScreenSize.width, 0.4) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f]];
        [self addSubview:lineSeperate1];

    }
    return self;
}

- (void)setCellWithGoodsEntity:(NSMutableArray *)inputGoodsArray DMGoodsBlock:(DMGoodsBlock)dmGoodsBlock1 DMGoodsAddCartBlock:(DMGoodsAddCartBlock)dmGoodsAddCartBlock1{
    [self.contentView removeAllSubviews];
    self.dmGoodsViewBlock = dmGoodsBlock1;
    self.addCartBlock = dmGoodsAddCartBlock1;
    // onecell - two - goods
    if (inputGoodsArray.count == 2) {
        for (int i = 0; i < inputGoodsArray.count; i ++) {
            GoodsEntity *entity = [inputGoodsArray objectAtIndex:i];
            GoodsWallView *goodsView1 = [[GoodsWallView alloc] initWithFrame:CGRectMake(i * 160, 0, 160, 250)];
            [goodsView1 setGoodsEntityWithBlock:entity GoodsViewBlock:^(GoodsEntity *myGoodsEntity){
                _dmGoodsViewBlock(entity);
            } GoodsCartAddBlock:^(GoodsEntity *myGoodsEntity){
                _addCartBlock(entity);
            }];
            [self.contentView addSubview:goodsView1];
        }
        

    }else{
        // oneCell - one - goods
        GoodsEntity *entity = [inputGoodsArray objectAtIndex:0];
        GoodsWallView *goodsView = [[GoodsWallView alloc] initWithFrame:CGRectMake(0, 0, 160, 250)];
        [goodsView setGoodsEntityWithBlock:entity GoodsViewBlock:^(GoodsEntity *myGoodsEntity){
            _dmGoodsViewBlock(entity);
        } GoodsCartAddBlock:^(GoodsEntity *myGoodsEntity){
            _addCartBlock(entity);
        }];
        [self.contentView addSubview:goodsView];
    }
}

@end
