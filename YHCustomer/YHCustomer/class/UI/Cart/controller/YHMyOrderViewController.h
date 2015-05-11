//
//  YHMyOrderViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-14.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "GoodsEntity.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "OrderEntity.h"

@interface YHMyOrderViewController : YHBaseTableViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
    UIButton        *readyPay;     // 全部订单
    UIButton        *alreadyPay;   // 待付款
    UIButton        *finishPay;    // 待收获
    UIButton        *getAlreadyPay; // 已收获
    UIImage         *buttonBackgroundImage;  // 处理中
    UIImage         *buttonSelectImage;

    UIImage         *buttonFinishBgImage;    // 已完成
    UIImage         *buttonFinishSelectImage;
    
    UIImage         *buttonCancelBgImage;
    UIImage         *buttonCancelSelectImage;// 已取消
    
    UIImageView     *resultImage;
    MFMessageComposeViewController *_msgVC;
    MyOrderEntity *_orderEntity;//支付的那个
    
    
    NSString *donation_order_id;//转赠的订单id，用于改变转赠状态
}
@property (nonatomic, strong) NSMutableArray *orderListArray;
@property (nonatomic, assign) NSInteger  sectionTag;
@property (nonatomic, assign) NSInteger  cancelSectionTag;
@property (nonatomic, assign) NSInteger  forwardSelectTag;
@property (nonatomic, assign) NSInteger  fromType;     // 1:表示 确认运费跳转  0:表示:我的跳转(默认不传为0)
@property (nonatomic, assign) NSInteger myOrderType;

@property (nonatomic, strong) NSMutableArray   *handleSelArray;// 转赠数组
- (void)goGoodsDetailWithBuyFinish:(GoodsEntity *)goodEntity;

@end
