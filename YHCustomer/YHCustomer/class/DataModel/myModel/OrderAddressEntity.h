//
//  OrderAddressEntity.h
//  THCustomer
//
//  Created by ioswang on 13-9-30.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 
 参数  	必选  	类型及范围  	说明  	备注
 true_name	TRUE	string	真实姓名
 mobile	TRUE	string	手机号码
 telephone	FALSE	string	固定电话
 zip_code	TRUE	string	邮编
 logistics_area	TRUE	string	省-市-区 编码
 logistics_address	TRUE	string	详细地址
 logistics_area_name true string 省市区 名称
 */
@interface OrderAddressEntity : NSObject
@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *true_name;
@property (nonatomic, copy) NSString  *mobile;
@property (nonatomic, copy) NSString  *telephone;
@property (nonatomic, copy) NSString  *zip_code;
@property (nonatomic, copy) NSString  *logistics_area;
@property (nonatomic, copy) NSString  *logistics_area_name;
@property (nonatomic, copy) NSString  *logistics_area_list;
@property (nonatomic, copy) NSString  *logistics_address;
@property (nonatomic, assign) BOOL    is_default;
/*用于修改本地保存的配送信息
 
 "province_code": "10",//省级编码
 "province_name": "福建省",//省级名称
 "city_code": "1001",//市级编码
 "city_name": "福州",//市级名称
 "area_code": "100104",//区级编码
 "area_name": "仓山区",//区级名称
 "street_code": "1001040010",//街级编码
 "street_name": "建新镇",//街级名称
 "bu_code": "9010"//和库存门店对比时使用！！！！！！！！！
 */
@property (nonatomic, copy) NSString  *province_code;
@property (nonatomic, copy) NSString  *province_name;
@property (nonatomic, copy) NSString  *city_code;
@property (nonatomic, copy) NSString  *city_name;
@property (nonatomic, copy) NSString  *area_code;
@property (nonatomic, copy) NSString  *area_name;
@property (nonatomic, copy) NSString  *street_code;
@property (nonatomic, copy) NSString  *street_name;
@property (nonatomic, copy) NSString  *bu_code;

- (NSMutableDictionary *)convertAddressEntityToDictionary;

@end

@interface OrderAddressNetTransObj:NetTransObj

@end


@interface AddressAreaObj : NetTransObj

@end



@interface NewAddressEntity : OrderAddressEntity

@end

@interface NewAddressObj : NetTransObj

@end
