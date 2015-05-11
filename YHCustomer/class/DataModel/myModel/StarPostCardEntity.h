//
//  StarPostCardEntity.h
//  YHCustomer
//
//  Created by wangliang on 15-5-1.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>
//星级包邮卡的包邮卡列表
@interface StarPostCardEntity : NSObject

@property(nonatomic,strong)NSString *ppc_goods_code;
@property(nonatomic,strong)NSString *ppc_goods_name;


@end
@interface StarPostCardNetTransObj : NetTransObj

@end

//星级包邮卡的记录列表
@interface StarPostCardRecordList : NSObject
@property(nonatomic,strong)NSString *ppc_goods_name;
@property(nonatomic,strong)NSString *create_time;

@end
@interface StarPostCardRecordListNetTransObj : NetTransObj

@end
//星级包邮卡的支付方式显示
@interface StarPostCardPayMethod : NSObject

@property(nonatomic,strong)NSString *_id;
@property(nonatomic,strong)NSString *name;

@end
@interface StarPostCardPayMethodNetTransObj : NetTransObj

@end
//购买接口
@interface StarPostCardBuyCard : NSObject

@property(nonatomic,strong)NSString *pay_method;
@property(nonatomic,strong)NSString *pay_str;
@property(nonatomic,strong)NSString *message;

@end
@interface StarPostCardBuyCardNetTransObj : NetTransObj

@end

