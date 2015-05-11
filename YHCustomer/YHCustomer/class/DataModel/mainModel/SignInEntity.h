//
//  SignInEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 14/11/13.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInEntity : NSObject


@property(nonatomic , strong) NSString * is_sign;//当前日期中是否签单  0未签 1已签
@property(nonatomic , strong) NSString * content;
@property(nonatomic , strong) NSString * date;
@property(nonatomic , strong) NSMutableArray * sign_record;
@property(nonatomic , strong) NSString * year_month;
@property(nonatomic , strong) NSString * sign_day;
@property(nonatomic ,strong )NSString * total;

@end

@interface SignInNetTransObj : NetTransObj

@end
