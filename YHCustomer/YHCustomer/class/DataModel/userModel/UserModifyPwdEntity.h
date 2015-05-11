//
//  UserModifyPwdEntity.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModifyPwdEntity : NSObject

@property (nonatomic ,strong) NSString *user_name;
@property (nonatomic ,strong) NSString *email;
@property (nonatomic ,strong) NSString *mobile;
@property (nonatomic ,strong) NSString *intro;
@property (nonatomic ,strong) NSString *true_name;
@property (nonatomic ,strong) NSString *gender;
@property (nonatomic ,strong) NSString *photo_id;
@property (nonatomic ,strong) NSString *shoppingwall_id;

@end

@interface UserModifyTrans : NetTransObj

@end
