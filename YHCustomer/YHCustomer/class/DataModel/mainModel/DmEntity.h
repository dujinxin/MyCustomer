//
//  DmEntity.h
//  YHCustomer
//
//  Created by kongbo on 13-12-18.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DmEntity : NSObject
@property(nonatomic,copy)NSString *dm_id;
@property(nonatomic,copy)NSString *bu_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *_description;
@property(nonatomic,copy)NSString *dm_image;
@property(nonatomic,copy)NSString *home_show_id;

@property(nonatomic,copy)NSString *background_color;
@property(nonatomic,copy)NSString *page_type;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *connect_goods;

@property (nonatomic, copy) NSString    *region_id;
@property (nonatomic, copy) NSString    *region_name;
@property (nonatomic, copy) NSString    * is_sign;
// dm_info用到（推送）
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@end

//首页顶部促销
@interface DmMainTopTransObj : NetTransObj

@end

// PUSH 返回dm信息
@interface DmPushNetTransObj : NetTransObj

@end

// 收藏（促销｜｜商品）

@interface DmGoodsTransObj : NetTransObj

@end