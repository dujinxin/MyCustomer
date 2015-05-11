//
//  SearchCategoryEntity.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCategoryEntity : NSObject

@property (nonatomic, strong) NSString *bu_category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *category_code;
@property (nonatomic, strong) NSString *icon;
//@property (nonatomic, assign) NSInteger is_parent_category;
@property (nonatomic, strong) NSMutableArray *last_category_list;

@end

@interface SearchCategoryNetTransObj : NetTransObj

@end