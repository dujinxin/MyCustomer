//
//  CateBrandEntity.h
//  YHCustomer
//
//  Created by lichentao on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateBrandEntity : NSObject

@property (nonatomic, strong) NSString *bu_category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString * has_son;
@property (nonatomic, strong) NSMutableArray * next_cate;

@property (nonatomic, strong) NSString *bu_brand_id;
@property (nonatomic, strong) NSString *brand_name;
@property (nonatomic, strong) NSString *icon;
@end

@interface CateNetTransObj : NetTransObj

@end
