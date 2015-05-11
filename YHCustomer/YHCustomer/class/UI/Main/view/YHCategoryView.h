//
//  YHCategoryView.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCategoryEntity.h"

typedef void(^categoryBlock)(NSString *tpye,NSString *category_code,NSString *title, NSInteger is_parent_category);
typedef void(^tapActionBlock)();

@interface YHCategoryView : UIView <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

{
    
    SearchCategoryEntity *firstEntity;
    
    UITableView *firstList;
    UITableView *secondList;
    
    //    NSMutableArray *categoryData;
    
    NSInteger select_row;
    
}

@property (nonatomic,strong) categoryBlock block;
@property (nonatomic,strong) tapActionBlock tapBlock;

@property (nonatomic,assign)  BOOL isPromotion;

@property (nonatomic,assign)  BOOL select_row;
@property (nonatomic,assign)  BOOL isOut;

@property (nonatomic,strong)  NSMutableArray *categoryData;

-(void)request_type:(NSString *)type bu_brand_id:(NSString *)bu_brand_id tag_id:(NSString *)tag_id key:(NSString *)key ;


-(void)addFirstEntity;
-(void)deleteFirstEntity;
-(void)refresh;

@end
