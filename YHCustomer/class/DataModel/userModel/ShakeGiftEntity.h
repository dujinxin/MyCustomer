//
//  ShakeGiftEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShakeGiftEntity : NSObject

@property (nonatomic, copy) NSString   *name;
@property (nonatomic, copy) NSString   *image_url;
@property (nonatomic, copy) NSString   *address;
@property (nonatomic, copy) NSString   *start_time;
@property (nonatomic, copy) NSString   *end_time;
@property (nonatomic, copy) NSString   *money;
@property (nonatomic, copy) NSString   *type;
@property (nonatomic, copy) NSString   *code;
@property (nonatomic, copy) NSString   *object_id;  //商品或者优惠券id
@property (nonatomic, copy) NSString   *bu_id;
@property (nonatomic, copy) NSString   *bu_logo;
@property (nonatomic, copy) NSString   *bu_name;
@property (nonatomic, copy) NSString   *prize_id;
@property (nonatomic, copy) NSString   *shake_id;
@end

@interface ShakeGiftNetTrans : NetTransObj


@end
