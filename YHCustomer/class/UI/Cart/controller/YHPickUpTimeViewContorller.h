//
//  YHPickUpTimeViewContorller.h
//  YHCustomer
//
//  Created by dujinxin on 15-3-6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "PSEntity.h"
typedef void (^YHPickTimeCallBlock)(NSString *pickTime);
typedef void (^YHPickUpTimeBlock)(NSString * timeString ,NSString * paramString);

@interface YHPickUpTimeViewContorller : YHRootViewController

@property (nonatomic, strong) NSString *order_list_id;
@property (nonatomic, strong) YHPickTimeCallBlock pickTimeBlock;
@property (nonatomic, copy) YHPickUpTimeBlock pickUpBlock;

@property (nonatomic, strong) NSString       *time_id;//最后的时间戳
@property (nonatomic, strong) NSString       *showTimeString;

@property (nonatomic, assign) BOOL isFromNewOrder;
@property (nonatomic, assign) BOOL isFromConfirmOrder;

@end
