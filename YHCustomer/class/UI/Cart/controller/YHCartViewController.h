//
//  YHCartViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  购物车

#import "YHRootViewController.h"
#import "GoodsEntity.h"
typedef void (^YHCartBlockCallBack)();

@interface YHCartViewController : YHRootViewController<UITableViewDelegate,UITableViewDataSource> {
    UIButton *backBtn;
    UIView *footView;
    UIButton *allSelectBtn;
    NSOperationQueue *queue; 
    NSMutableArray *stockoutArray; //缺货的商品
    NSInteger stockoutCount;
}

@property (nonatomic, strong) NSMutableArray     *cartArray;
@property (nonatomic, strong) UITableView        *contentTable;
@property (nonatomic, copy)   NSString           *totolPrice;
@property (nonatomic, strong) GoodsListEntity   *listEntity;

@property (nonatomic, strong) UILabel           *totalGoodsLabel;
@property (nonatomic, strong) UILabel           *weightLabel;
@property (nonatomic, strong) UILabel           *savePriceLabel;
@property (nonatomic, strong) UILabel           *totalAmount;

@property (nonatomic, strong) NSString           *totalNum;
@property (nonatomic, assign) BOOL editor;
@property (nonatomic, assign) BOOL allSelect;
@property (nonatomic, assign) BOOL isFromOther;
@property (nonatomic, strong) YHCartBlockCallBack callBack;
@property (nonatomic, strong) NSString       *bu_Goods_Id;
@property (nonatomic, strong) NSMutableDictionary *active_info;
@property (nonatomic, assign) float height;

-(void)deleteOrderById:(NSString*)bu_goods_id NSIndexPath:(NSIndexPath *)indexPath;
- (void)requestCartList;
-(void)selectOneGood:(GoodsEntity *)cellGoodEntity Type:(NSString *)type;
- (void)modifyCartGoodsNum:(NSString *)bu_goods_id GoodsNum:(NSString *)goodsNum;

@end
