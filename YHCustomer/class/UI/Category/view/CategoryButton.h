//
//  CategoryButton.h
//  YHCustomer
//
//  Created by lichentao on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryButton : UIButton

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSNumber *bu_category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString * has_son;
@property (nonatomic, strong) NSMutableArray * next_cate;
@end
