//
//  ActivityEntity.h
//  YHCustomer
//
//  Created by kongbo on 14-3-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  首页运营区实体

#import <Foundation/Foundation.h>

@interface ActivityEntity : NSObject

@property(nonatomic,strong)NSMutableArray *activity_info;
@property(nonatomic,copy)NSString *show_mode;
@property(nonatomic,copy)NSString *show_type;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *jump_type;
@property(nonatomic,copy)NSString *jump_parametric;
@property(nonatomic,copy)NSString *title;

@end

@interface LaunchEntity : ActivityEntity

@property (nonatomic, copy)NSString * photo;
@property (nonatomic, copy)NSString * show_time;
@end


@interface ActivityTransObj : NetTransObj

@end

@interface LaunchTransObj : NetTransObj

@end
//speedEntry
@interface SpeedEntryEntity : ActivityEntity
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,copy) NSString * image;
@end
@interface SpeedEntryObj : NetTransObj

@end
//udid
@interface UdidEntity : ActivityEntity

@end

@interface UdidTransObj : NetTransObj

@end