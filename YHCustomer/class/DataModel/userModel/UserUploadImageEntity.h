//
//  UserUploadImageEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserUploadImageEntity : NSObject

@property (nonatomic, strong) NSString  *image_id;
@property (nonatomic, strong) NSString  *image_url;
@end
@interface UserUploadImageTrans : NetTransObj

@end
