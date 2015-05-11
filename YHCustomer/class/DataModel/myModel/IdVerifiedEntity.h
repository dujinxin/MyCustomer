//
//  IdVerifiedEntity.h
//  YHCustomer
//
//  Created by wangliang on 14-10-22.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdVerifiedEntity : NSObject
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *is_verify;
@property(nonatomic,strong)NSString *is_binding;
@property(nonatomic,strong)NSString *id_no;
@property(nonatomic,strong)NSString *msg;
@property(nonatomic,strong)NSMutableArray *card_list;
@property(nonatomic,strong)NSString *card_no;
@property(nonatomic,strong)NSString *is_binding_type;
@property(nonatomic,strong)NSString *binding_msg;
@property(nonatomic,strong)NSString *no_bind_msg;
@property(nonatomic,strong)NSString *bind_msg;
@property(nonatomic,strong)NSString *total_score;
@property(nonatomic,strong)NSString *latest_time;
@property(nonatomic,strong)NSString *card_type;
@property(nonatomic,strong)NSMutableArray *bind_card_list;
@property(nonatomic,strong)NSMutableArray *no_bind_card_list;
@end
@interface IdVerifiedNetTransObj : NetTransObj

@end
