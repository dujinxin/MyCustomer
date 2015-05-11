//
//  PromotionShareEntity.h
//  YHCustomer
//
//  Created by wangliang on 14-11-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionShareEntity : NSObject
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * page_url;
@property (nonatomic, copy)NSString * _description;
@property (nonatomic, copy)NSString * photo;
@property (nonatomic, copy)NSString * download_url;
@property (nonatomic, copy)NSString * wx_content;
@property (nonatomic, copy)NSString * sina_content;
@property (nonatomic, copy)NSString * qr_code_content;
@property (nonatomic, copy)NSString * qr_code_src;
@end
@interface PromotionShareObj : NetTransObj

@end