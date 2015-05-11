//
//  MyFeedBackEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFeedBackEntity : NSObject
/*
 id:13
 bu_name:门店名称
 content:内容,
 commit_type:0,//'0'建议,'1'咨询,'2'投诉
 add_time:"2013-09-26" 时间
 */
@property (nonatomic, copy) NSString   *bu_name;
@property (nonatomic, copy) NSString   *image_url;
@property (nonatomic, copy) NSString   *content;
@property (nonatomic, copy) NSString   *add_time;
@property (nonatomic, copy) NSString   *commit_type;
@property (nonatomic, copy) NSString   *bu_id;
@end

@interface MyFeedBackNetTrans : NetTransObj


@end
