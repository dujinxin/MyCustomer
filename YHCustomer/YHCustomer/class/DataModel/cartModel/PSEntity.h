//
//  PSEntity.h
//  YHCustomer
//
//  Created by dujinxin on 14-10-16.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSEntity : NSObject

@end

@interface LogisticModelEntity : NSObject
//"id": "1",//lm_id 结算页面计算运费的时候会用到
//7             "title": "半日达",//标题
//8             "info": "1kg运费1元，每满68元送5kg运费",//介绍
//9             "delivery_time"
/*
 data": {
         "now_date": "2014-10-15 16:22:43",//当前服务器时间
         "lm_info": [//物流模型集合
         {
                 "id": "2",//lm_id 结算页面计算运费的时候会用到
                 "title": "半日达",//物流模型标题
                 "info": "半日达",//物流模型描述
                 "date_num": 2,//支持天数
                 "delivery_time": {//物流模型下选项集合
                 "today": [//当日选项集合
                         {
                         "id": "2",//送货时间编码提交订单会用到
                         "lm_id": "2",
                         "title": "08点至10点",//送货选项名称
                         "date_type": "1",//当日、次日标识 1当日 2次日
                         "delivery_start_time": "00:00:00",
                         "delivery_end_time": "09:30:00",
                         "type": 0,//提示标识：1 提示 ，0 不提示
                         "msg": "",//如果提示标识为1 ，则提示此字段的内容
                         "is_use": 1//是否可用 1不可用 0可用
                         },
         */
@property (nonatomic, copy) NSString * now_date;
@property (nonatomic, copy) NSNumber * date_num;
@property (nonatomic, strong) NSString *logisId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSMutableDictionary *delivery_time;

- (void)setLogisticModelEntity:(NSDictionary *)dic;
@end


// 物流信息
@interface SendLogisticToStoreObj : NetTransObj

@end

// 通用obj返回数组（dic）格式直接返回给调用对象
@interface CommonArrayObj: NetTransObj

@end

// 配送方式
@interface DeliveryStyleEntity : NSObject
@property (nonatomic, strong) NSString *i_d;
@property (nonatomic, strong) NSString *name;
@end

// 优惠券列表
@interface CouponNetTransObj : NetTransObj

@end
//修改支付方式--刷新支付金额
@interface ModifyPayMethod : NetTransObj
@property (nonatomic, copy )NSString * status;
@property (nonatomic, copy )NSString * msg;
@property (nonatomic, copy )NSString * total_amount;

@end

//自提时间
@interface PickUpTimeEntity : NSObject
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *support_days;
@property (nonatomic, strong) NSString *fastest_pick_up_time;
@property (nonatomic, strong) NSString *fastest_pick_up_time_min;
@property (nonatomic, strong) NSString *date;
@end
