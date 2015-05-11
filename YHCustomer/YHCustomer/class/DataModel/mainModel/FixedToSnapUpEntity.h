//
//  FixedToSnapUpEntity.h
//  YHCustomer
//
//  Created by wangliang on 15-1-9.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FixedToSnapUpEntity : NSObject
@property(nonatomic,strong)NSString *activity_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *start_date;
@property(nonatomic,strong)NSString *end_date;
@property(nonatomic,strong)NSString *date;
@end
@interface FixedToSnapUpTransObj : NetTransObj

@end

@interface BuyActiviteListEntity : NSObject
@property(nonatomic,strong)NSString *iid;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *discount_price;
@property(nonatomic,strong)NSString *goods_image;

@property(nonatomic,strong)NSString *stock;
@property(nonatomic,strong)NSString *out_of_stock;
@property(nonatomic,strong)NSString *start_time;
@property(nonatomic,strong)NSString *end_time;
@property(nonatomic,strong)NSString *is_or_not_salse;

@property(nonatomic,strong)NSString *date_time;
@property(nonatomic,strong)NSString *limit_the_purchase_type;
@property(nonatomic,strong)NSString *salse_num;
@property(nonatomic,strong)NSString *salse_deductions_num;
@property(nonatomic,strong)NSString *goods_introduction;
@property(nonatomic,strong)NSString * goods_status;
@property(nonatomic,strong)NSString * goods_status_name;
@property(nonatomic,strong)NSString * total;
@property(nonatomic,strong)NSString * transaction_type;

@end
@interface BuyActiviteListTransObj : NetTransObj


@end