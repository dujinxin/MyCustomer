//
//  ForgetPasswordEntity.h
//  YHCustomer
//
//  Created by wangliang on 15-3-24.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForgetPasswordEntity : NSObject
@property (nonatomic, retain) NSString  *type;
@property (nonatomic, retain) NSString  *mobile;
@property (nonatomic, retain) NSString  *email;
@end
@interface ForgetPasswordTrans : NetTransObj

@end