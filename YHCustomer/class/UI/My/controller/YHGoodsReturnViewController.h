//
//  YHGoodsReturnViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-5-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  商品列表

#import "YHBaseTableViewController.h"
#import "OrderEntity.h"
#import "GoodsEntity.h"

typedef void(^GoodsReturnBlock)(NSMutableArray *formatArray,NSString *totalReturnNum);

@interface YHGoodsReturnViewController : YHBaseTableViewController{
    UILabel *priceInfo;
    UIButton *allSelectBtn;
}

@property (nonatomic, strong) NSMutableArray    *cartArray;     // 商品数组
@property (nonatomic, strong) NSMutableArray    *calulateArray; // 加减商品后的数组字典
@property (nonatomic, strong) NSMutableArray    *selectAllArray; //
@property (nonatomic, strong) GoodsReturnBlock  returnBlock;

@property(nonatomic , strong)NSIndexPath * indexPathSelected;

- (void)calculateReturnArray:(NSIndexPath *)indexPath GoodNum:(NSString *)num;

@end
