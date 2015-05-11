//
//  YHCategoryViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  分类

#import "YHRootViewController.h"


@interface YHCategoryViewController : YHBaseTableViewController
{
    UIButton *categoryBtn;
    UIButton *brandBtn;
    SubType  subType;
}
@property(assign, nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *cateSecondArray;
@end
