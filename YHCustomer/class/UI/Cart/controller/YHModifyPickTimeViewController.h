//
//  YHModifyPickTimeViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-1-18.
//  Changed by dujinxin on 14-10-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "PSEntity.h"
typedef void (^YHPickTimeCallBlock)(NSString *pickTime);

@interface YHModifyPickTimeViewController : YHRootViewController

@property (nonatomic, strong) NSString *order_list_id;
@property (nonatomic, strong) YHPickTimeCallBlock pickTimeBlock;

@property (nonatomic, strong) NSString       *time_id;//最后的时间戳
@property (nonatomic, strong) NSString       *showTimeString;

@end
