//
//  CategoryGoodsEntity.h
//  YHCustomer
//
//  Created by dujinxin on 14-10-13.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryGoodsEntity : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *bu_category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString * has_son;
@property (nonatomic, strong) NSMutableArray * next_cate;

@end

@interface CategoryNetTransObj : NetTransObj

@end
