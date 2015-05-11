//
//  YHMyCouponViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

typedef enum{
    Coupon_List = 0,  // 优惠券列表
    Coupon_LIST_History   // 优惠券历史列表
} CouponType;

@interface YHMyCouponViewController : YHBaseTableViewController{

    UIButton        *couponBtn;
    UIButton        *historyBtn;
    CouponType      requestCouponType;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@end
