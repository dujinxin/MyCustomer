//
//  YHPSReturnViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-4-30.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  退货/退款-服务

#import "YHBaseTableViewController.h"

@interface YHPSReturnViewController : YHBaseTableViewController
{
    UIButton        *readyPay;      // 申请退货
    UIButton        *alreadyPay;    // 退货中
    UIButton        *finishPay;     // 退货完成
    UIButton        *getAlreadyPay; // 退货取消
    
    UIImage         *buttonBackgroundImage;
    UIImage         *buttonSelectImage;
    UIImageView     *resultImage;
    
    
}

@property (nonatomic, strong) NSMutableArray *orderListArray;
@property (nonatomic, assign) NSInteger myOrderType;

@end
