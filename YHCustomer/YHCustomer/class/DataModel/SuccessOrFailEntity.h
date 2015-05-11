//
//  SuccessOrFailEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuccessOrFailEntity : NSObject

@property (nonatomic, copy) NSString *_status;
@property (nonatomic, copy) NSString *_message;
@property (nonatomic, copy) NSString *_message_count;
@property (nonatomic, copy) NSString *_data;

@end
//返回StoreEntity的通信对象
@interface SuccessOrFailTrans :NetTransObj
{
    
}
@end
