//
//  PlusCutView.h
//  YHCustomer
//
//  Created by lichentao on 14-5-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  plus (+) cut (-)

#import <UIKit/UIKit.h>
#import "GoodsEntity.h"

typedef enum{
    return_Type,        // 退货商品列表
    cart_Type,          // 购物车
}ReturnOrCart;

typedef void(^PlusButtonBlock)(NSString *goodsNum);
typedef void(^CutButtonBlock)(NSString *goodsNum);
typedef void (^ChangeNumBlock)();
@interface PlusCutView : UIView{
    UIButton    *plusButton;   // plus
    UIButton    *cutButton;    // cut
    int         maxNum;
    BOOL        plusBool;
}

@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic, strong) PlusButtonBlock   plusBlock;
@property (nonatomic, strong) CutButtonBlock    cutBlock;
@property (nonatomic, strong) ChangeNumBlock    changeBlock;
@property (nonatomic, strong) GoodsEntity       *goodsEntity1;
@property (nonatomic, assign) ReturnOrCart      myType;

- (id)initWithFrame:(CGRect)frame GoodsEntity:(GoodsEntity *)goodsEntity Type:(ReturnOrCart)type setPlusBlock:(PlusButtonBlock)plusBlock1 CutButtonBlock:(CutButtonBlock)cutBlock1 ChangeNumBlock:(ChangeNumBlock)changeBlock1;
@end
