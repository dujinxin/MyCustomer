//
//  YHShakeAddressViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-11-17.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

#define ADDRESS_PROVINCE_BTN 10000
#define ADDRESS_CITY_BTN 10001
#define ADDRESS_AREA_BTN 10002
#define ADDRESS_STREET_BTN 10003
typedef enum{
    REQUSET_TYPE_PROVINCE,
    REQUSET_TYPE_CITY,
    REQUSET_TYPE_AREA,
    REQUSET_TYPE_STREET,
}RequestType;

enum {
    ENUM_TEXTFIELD_NAME = 100,
    ENUM_TEXTFIELD_MOBILE,
    ENUM_TEXTFIELD_CITY,
    ENUM_TEXTFIELD_STREET,
};
typedef void (^addressBlock) (NSString * name,NSString * mobile,NSString * address);
@interface YHShakeAddressViewController : YHRootViewController<UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>
@property (nonatomic, copy) NSString * activityId;
@property (nonatomic, copy) addressBlock block;
@end
