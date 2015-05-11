//
//  YHSecondCategoryViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "CateBrandEntity.h"


@interface YHSecondCategoryViewController : YHBaseTableViewController

@property (nonatomic, strong) NSMutableArray *cateSecondArray;
@property (nonatomic, strong)CateBrandEntity *entity;

@end
