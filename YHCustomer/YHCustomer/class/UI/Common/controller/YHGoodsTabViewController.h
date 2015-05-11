//
//  YHGoodsTabViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-8-12.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  商品列表，按各种条件排序

#import "YHBaseTableViewController.h"
#import "YHCartView.h"
#import "CategoryView.h"

@interface YHGoodsTabViewController : YHBaseTableViewController <CartViewDelegate>
{
    UIButton *tab1;
    UIButton *tab2;
    UIButton *tab3;
    UIButton *tab4;
    NSArray *tabs;
    
    UIImageView *selectView;
    UIImageView *checkView;
    
    UIView *moreView;
    UIView *shadow;
    
    UIButton *moreTab1;
    UIButton *moreTab2;
    UIButton *moreTab3;
    UIButton *moreTab4;
    UIButton *moreTab5;
    UIButton *moreTab6;
    UIButton *moreTab7;
    UIButton *moreTab8;
    UIButton *moreTab9;
    NSArray *moreTabs;
    
    YHCartView *cartView;
    
    NSMutableArray *goodsData;
    NSMutableArray *enoughGoodsData;
    BOOL enoughGoods;
    
    
    NSMutableDictionary *params;
    
    
    CategoryView *categoryView;
    NSString *bu_category_id_default;
    
    NSString *category_type;
}

-(void)setRequstParams:(NSMutableDictionary *)param;
@end
