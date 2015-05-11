//
//  CommentEntity.h
//  THCustomer
//
//  Created by lichentao on 13-9-5.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentEntity : NSObject

@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *photo_url;
@property (nonatomic, strong) NSString *region_name;
@property (nonatomic, strong) NSString *rep_Content;
@property (nonatomic, strong) NSString *rep_add_time;


- (void)setCommentEntity:(NSDictionary *)dic;
@end


@interface CommentTransObj : NetTransObj

@end


@interface GetGoodsIdTransObj : NetTransObj

@end