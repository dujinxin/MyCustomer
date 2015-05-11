//
//  FeedBackListEntity.h
//  YHCustomer
//
//  Created by lichentao on 14-2-15.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 6             "id": "1820",//意见反馈帖子ID
 7             "user_id": "8766",//用户ID
 8             "content": "这个app真好",//内容
 9             "add_time":"2014-02-12 10:58:48！",//时间
 10             "comment_id":"0",//0为用户发表的帖子，不为0为回复的帖子
 11             "app_type":"1",//1为用户 2为店员
 12             "reply_list": [  //回复的列表
 13                 {
 14                                "id": "1830",//意见反馈帖子ID
 15                                "user_id": "8766",//用户ID
 16                                "content": "这个app真好",//内容
 17                                "add_time":"2014-02-12 10:58:48！",//时间
 18                                "comment_id":"1820",//0为用户发表的帖子，不为0为回复的帖子
 19                                "app_type":"1",//1为用户 2为店员
 20                 }
 21             ]
 */
@interface FeedBackListEntity : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *rep_add_time;
@property (nonatomic, strong) NSString *rep_content;
@end

@interface FeedBackListNetTransObj : NetTransObj

@end
