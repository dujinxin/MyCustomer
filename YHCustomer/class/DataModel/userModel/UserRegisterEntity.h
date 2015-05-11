//
//  UserRegisterEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRegisterEntity : NSObject

@property (nonatomic, strong) NSString *cardStatus;
@property (nonatomic, strong) NSString *message;

@end
@interface UserRegisterTrans : NetTransObj

@end
