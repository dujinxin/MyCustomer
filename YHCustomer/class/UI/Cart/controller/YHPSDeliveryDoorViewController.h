//
//  YHPSDeliveryDoorViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-3-27.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHModifyPickTimeViewController.h"
#import "PSEntity.h"

typedef void (^DeliveryCallBlock)(PSModel model,NSString * deliveryTime,NSString * orderListId);
typedef void(^DeliveryBlock)(NSString *lm_id,NSString *lm_name,NSString *Im_time_id,NSString *lm_time_name, BOOL isTel);

@interface YHPSDeliveryDoorViewController : YHBaseTableViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIActionSheet   *as;
    BOOL            isTel;
    UIPickerView    *pickerView;
    UIView          *popView;
    UIButton        *confirmBtn;
}

@property (nonatomic, copy) NSString * selectDateString;
@property (nonatomic, copy) NSString * showDeliveryTime;
@property (nonatomic, copy) NSString * deliveryTime;
@property (nonatomic, copy) NSString * deliveryId;
@property (nonatomic, copy) NSString * deliveryType;
@property (nonatomic, copy) NSString * payId;
@property (nonatomic, copy) NSNumber * type;
@property (nonatomic, copy) NSString * msg;

@property (nonatomic, strong) NSString *order_list_id;
@property (nonatomic, strong) DeliveryBlock pickTimeBlock;
@property (nonatomic, strong) DeliveryCallBlock deliveryTimeBlock;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) LogisticModelEntity *buEntity;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, copy) NSString *lm_time_id;
@property (nonatomic, copy) NSString *lm_time_name;
@property (nonatomic, copy) NSString *lm_name;
@property (nonatomic, assign) BOOL isTel;

@property (nonatomic, assign)BOOL fromPayment;

@property (nonatomic, strong) NSMutableArray *nSevenDateArray;

@property (nonatomic, copy) NSString * goods_id;

- (void)setDeliveryEntity:(NSString *)name;

@end
