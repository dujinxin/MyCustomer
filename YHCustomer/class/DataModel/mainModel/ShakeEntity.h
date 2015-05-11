//
//  ShakeEntity.h
//  YHCustomer
//
//  Created by dujinxin on 14-11-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShakeEntity : NSObject

@property (nonatomic, copy) NSString * activity_id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * _description;
@property (nonatomic, copy) NSString * background_image;
@property (nonatomic, copy) NSString * description_image;
@property (nonatomic, copy) NSString * intergral_exchange;
@property (nonatomic, copy) NSString * free_times;
@property (nonatomic, copy) NSString * total_shake;
@property (nonatomic, copy) NSString * remanent_times;
@property (nonatomic, copy) NSString * total_score;
@property (nonatomic, copy) NSString * win_total;
@property (nonatomic, copy) NSString * share_title;
@property (nonatomic, copy) NSString * share_tip;
@property (nonatomic, copy) NSString * share_num;
@property (nonatomic, copy) NSString * image_url;
@property (nonatomic, copy) NSString * page_url;
@property (nonatomic, copy) NSString * download_url;


@end

@interface AwardEntity :ShakeEntity

@property (nonatomic, copy) NSString * prize_type;
@property (nonatomic, copy) NSString * prize_title;
@property (nonatomic, copy) NSString * notice;
@property (nonatomic, strong) NSMutableArray * recommend_goods;

/*
"recommend_goods":{//没摇中时返回的推荐热卖商品，可为空
    "goods_id":"72",//商品id
    "region_id":"1001",//区域编码
    "goods_name"："烤鸭",//商品名称
    "goods_image":"",//商品图片url
    "price":"14.5",//商品原价，可为空
    "discount_price":"12"//商品现价
},
 */
@end

@interface AwardListEntity : ShakeEntity

@property (nonatomic, strong)NSMutableArray * awardArray;
@property (nonatomic, copy) NSString * total;

@end

@interface AddressEntity : ShakeEntity

@property (nonatomic, copy)NSString * region_id;
@property (nonatomic, copy)NSString * region_name;
@property (nonatomic, copy)NSString * level;

@property (nonatomic, copy)NSString * province;
@property (nonatomic, copy)NSString * city;
@property (nonatomic, copy)NSString * area;
@property (nonatomic, copy)NSString * street;
@property (nonatomic, copy)NSString * provinceId;
@property (nonatomic, copy)NSString * cityId;
@property (nonatomic, copy)NSString * areaId;
@property (nonatomic, copy)NSString * streetId;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * mobile;
@property (nonatomic, copy)NSString * detail;

/*
 "region_id": 28,//区域id
 "region_name": "福建",//区域名称
 "level":"1",//区域等级
 */
@end

/*
 *
 */
@interface ShakeObj : NetTransObj

@end

@interface AwardObj : NetTransObj

@end

@interface AwardListObj : NetTransObj

@end
//积分兑换,提交地址,分享成功三者复用
@interface IntergralObj : NetTransObj

@end

@interface AddressObj : NetTransObj

@end

