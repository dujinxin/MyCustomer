//
//  Donation.h
//  YHCustomer
//
//  Created by kongbo on 13-12-30.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DonationEntity : NSObject
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *order_list_id;
@end

@interface DonationTrans : NetTransObj
@end