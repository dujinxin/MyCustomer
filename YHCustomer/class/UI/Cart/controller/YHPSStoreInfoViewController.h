//
//  YHPSStoreInfoViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-3-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHModifyPickTimeViewController.h"
#import "BuListEntity.h"
@interface YHPSStoreInfoViewController : YHRootViewController<
UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIActionSheet *as;
   
}

@property (nonatomic, strong) NSString *order_list_id;
@property (nonatomic, strong) YHPickTimeCallBlock pickTimeBlock;
@property (nonatomic, strong)BuListEntity *buEntity;
@property (nonatomic, strong) NSString *dateStringDefault;// 默认时间
@end
