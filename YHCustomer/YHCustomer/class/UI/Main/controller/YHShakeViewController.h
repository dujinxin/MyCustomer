//
//  YHShakeViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-11-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  摇一摇界面

#import "YHRootViewController.h"

typedef void(^shakeCallback)(id obj);

typedef enum {
    kCouponAward = 1,
    kIntergralAward,
    kGoodsAward,
    kNoneAward,
    kIntergralExchange,
    kNoneTimes,
    kNoneInfo,
}kAwardType;

@interface YHShakeViewController : YHRootViewController<UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) shakeCallback systemAudioCallback;
@property (nonatomic, copy) shakeCallback shareBlock;

@end
