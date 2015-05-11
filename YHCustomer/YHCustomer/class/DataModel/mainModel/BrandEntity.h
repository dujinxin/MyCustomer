//
//  BrandEntity.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandEntity : NSObject

@property (nonatomic ,copy)NSString * brand_name;
@property (nonatomic ,copy)NSString * letter;
@property (nonatomic ,copy)NSString * bu_brand_id;
@property (nonatomic ,assign)BOOL isSelected;

@end

@interface BrandNetTrans : NetTransObj

@end
