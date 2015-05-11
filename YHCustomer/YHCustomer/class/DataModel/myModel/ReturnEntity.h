//
//  ReasonEntity.h
//  YHCustomer
//
//  Created by kongbo on 14-5-3.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnEntity : NSObject
//@property (nonatomic, copy) NSString  *i_d;
//@property (nonatomic, copy) NSString  *reason_code;
//@property (nonatomic, copy) NSString  *reason_name;
//@property (nonatomic, copy) NSString  *type;
@end

//退货门店
@interface ReturnStoreEntity : NSObject
@property (nonatomic, copy) NSString  *store_name;
@property (nonatomic, copy) NSString  *store_address;
@end
@interface ReturnStoreObj : NetTransObj

@end

//退货原因
@interface ReasonEntity : NSObject
@property (nonatomic, copy) NSString  *i_d;
@property (nonatomic, copy) NSString  *reason_code;
@property (nonatomic, copy) NSString  *reason_name;
@property (nonatomic, copy) NSString  *type;
@end

@interface ReasonEntityObj : NetTransObj

@end

//退货方式
@interface ReturnMethod : NSObject
@property (nonatomic, copy) NSString  *i_d;
@property (nonatomic, copy) NSString  *name;
@end

@interface ReturnMethodObj : NetTransObj

@end