//
//  OneOrderEditorView.h
//  THCustomer
//
//  Created by 任 清阳 on 13-9-12.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsEntity.h"

typedef void(^ChangeGoodsNumBlock)(NSIndexPath *indexPath, NSString *num);
typedef void(^OneGoodSelectBlock)(BOOL isSelect,NSIndexPath *indexPath);
@interface OneOrderEditorView : UIView{
    
}

@property (nonatomic, strong) GoodsEntity   *myEntity;
@property (nonatomic, assign) id            mController;
@property (nonatomic, strong) NSIndexPath   *myIndexPath;
@property (nonatomic, assign) BOOL          isOneGoodSelect;
@property (nonatomic, strong) ChangeGoodsNumBlock changeNumBlock;   // plus || cut
@property (nonatomic, strong) OneGoodSelectBlock  oneGoodBlock;     // 选择某一个商品

//退货商品用到
@property (nonatomic, strong) NSIndexPath   *selectedIndexPath;

// 购物车
-(void)drawEditorView:(GoodsEntity *)entity NSIndex:(NSIndexPath *)indexPath;
// 退货商品
-(void)drawGoodsReturnView:(GoodsEntity *)entity IsSelect:(BOOL)isSelect NSIndex:(NSIndexPath *)indexPath ChangeGoodsNumBlock:(ChangeGoodsNumBlock)block OneGoodSelectBlock:(OneGoodSelectBlock)oneBlock1;
// 输入框更改数量
- (void)chageGoodsNumWithAlert;

@end