//
//  YHDeliveryTimeViewController.h
//  YHCustomer
//
//  Created by dujinxin on 15-3-11.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "PSEntity.h"
typedef void (^YHPickTimeCallBlock)(NSString *pickTime);
typedef void (^YHDeliveryTimeBlock)(NSString * timeString ,NSString * paramString,NSMutableArray * array,NSString * payId,NSNumber * type, NSString * msg);

@interface YHDeliveryTimeViewController : YHRootViewController

@property (nonatomic, strong) NSString *order_list_id;
@property (nonatomic, strong) YHPickTimeCallBlock pickTimeBlock;
@property (nonatomic, copy) YHDeliveryTimeBlock deliveryBlock;

@property (nonatomic, strong) NSString       *time_id;//最后的时间戳
@property (nonatomic, strong) NSString       *showTimeString;

@property (nonatomic, assign) BOOL isFromPSDeliveryOrder;
@property (nonatomic, assign) BOOL isFromConfirmOrder;

@property (nonatomic, strong) LogisticModelEntity * entity;
@end
