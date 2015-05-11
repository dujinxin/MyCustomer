//
//  PSPatternEntity.h
//  YHCustomer
//
//  Created by dujinxin on 15-4-20.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSPatternEntity : NSObject
/*
 "data": [
             {
                 "type": 1,             //配送方式的类型，1、送货上门，2、门店自提
                 "type_name": "送货上门",//配送方式的名称
                 "is_usable": 0         //配送方式是否可用，1、可用，0、不可用
             }
 ],
 */
@end

@interface PSPatternObj :NetTransObj

@end

@interface PSCountryStreetEntity : NSObject
/*
 "data": [
             {
                 "id": "100104",
                 "name": "仓山区",
                 "p_id": "1001",  //父id
                 "level": "3"     //1 省 2 市 3 区 4 街道
             }
        ],
 */
@end

@interface PSCountryStreetObj : NetTransObj

@end

@interface PSStreetSupermarketEntity : NSObject
/*
 "data": [
             {
                 "bu_code": "9018", //门店code
                 "type": "0"   //门店类型：0 实体店 ， 1 虚拟店
             }
        ],
 */
@end

@interface PSStreetSupermarketObj : NetTransObj

@end

@interface PSPickupSupermarketEntity : NSObject
/*
 "data": [
             {
                 "id": "370",
                 "bu_code": "9296",
                 "bu_name": "永辉福建福州市--大儒世家店",
                 "address": "福建省福州市鼓楼区金牛山北侧甘洪路东侧大儒世家"
             },
         ],
 */
@end

@interface PSPickupSupermarketObj : NetTransObj

@end


@interface BuCodeEntity : NSObject

@end

@interface BuCodeObj : NetTransObj

@end
