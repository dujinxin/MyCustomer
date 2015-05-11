//
//  YHCouponListViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-2-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
typedef void (^YHCoupoonListSuccessBlock)(NSDictionary *dic);

@interface YHCouponListViewController : YHBaseTableViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath    *selectIndexPath;;
@property (nonatomic, strong) NSDictionary   *selectDictionary;
@property (nonatomic, strong) YHCoupoonListSuccessBlock successCallBlock;
@property (nonatomic, copy) NSString * payMethod;
@end
