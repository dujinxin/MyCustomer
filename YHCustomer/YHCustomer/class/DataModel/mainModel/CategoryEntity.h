//
//  CategoryEntity.h
//  YHCustomer
//
//  Created by kongbo on 14-3-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  首页分类商品区实体

#import <Foundation/Foundation.h>
#import "ActivityEntity.h"

@interface CategoryEntity : NSObject
@property(nonatomic,strong)NSString *show_type;
@property(nonatomic,retain)ActivityEntity *title;
@property(nonatomic,retain)ActivityEntity *image;
@property(nonatomic,retain)NSMutableArray *tabs;
@end

@interface CategoryTransObj : NetTransObj

@end


@interface NewCategoryEntity : NSObject
@property (nonatomic, strong) NSString *bu_category_id;
@property (nonatomic, strong) NSString *category_name;

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSMutableArray *last_category_list;
@end

@interface NewCategoryNetTransObj : NetTransObj

@end