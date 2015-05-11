//
//  YHPSStorePickViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-3-28.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHModifyPickTimeViewController.h"
#import "BuListEntity.h"
#import "POPDViewController.h"
#import "PSEntity.h"

typedef void(^StorePickBlock)(NSString *bu_id,NSString *bu_name,NSString *timeStamp,NSString *dayTimeStr,NSString *address);

@interface YHPSStorePickViewController : YHRootViewController<
UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIActionSheet           *as;
    UITableView             *popMenu;
    BOOL                    isShow;
    UIImageView             *accessUpImg;
    UIButton                *selectStoreBtn;
    UILabel                 *selectStoreLabel;
    
    
    UILabel *pickTime;
    UIView *bgPickTime;
    UIButton *confirmBtn;
    
    UIView  *bgPopView;
    NSString *dayStr;
    
    PickUpTimeEntity *pickUpTimeEntity;
    
    NSString *dateString;
    NSString *today;
    NSString *tomorrow;
    
    NSMutableArray *tempMY;
}

@property (nonatomic, strong) NSString      *order_list_id;
@property (nonatomic, strong)BuListEntity   *listEntity;
@property (nonatomic, strong) StorePickBlock pickTimeBlock;
@property (nonatomic, strong) NSString      *dateStringDefault;
@property (nonatomic, strong) NSString       *monthDayStr;
@property (nonatomic, strong)NSDictionary   *storeDic;
@property (nonatomic, strong) NSMutableArray *popArray;

@property (nonatomic, strong) NSMutableArray *ymdArray;//年月日数组
@property (nonatomic, strong) NSString       *myTimeStamp;
@property (nonatomic, strong) NSString       *uploadTimeStr;//最后的时间戳
@property (nonatomic, strong) NSString       *hourMinuteStr;
@property (nonatomic, strong) NSString       *pickTimeLabel;
@property (nonatomic, strong) NSString       *defaultPickTime;
@property (nonatomic, strong) NSMutableArray *hourMinuteArray;//时分数组
@property (nonatomic, strong) NSMutableArray *firstDayHMArray;//第一天时分数组
@end
