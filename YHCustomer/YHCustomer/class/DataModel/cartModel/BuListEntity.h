//
//  BuListEntity.h
//  YHCustomer
//
//  Created by lichentao on 13-12-19.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuListEntity : NSObject

@property (nonatomic, strong) NSString *bu_id;
@property (nonatomic, strong) NSString *bu_name;
@property (nonatomic, strong) NSString *bu_code;//15-0517新增
@property (nonatomic, strong) NSString *address;

@end


@interface BuListNetTransObj : NetTransObj

@end