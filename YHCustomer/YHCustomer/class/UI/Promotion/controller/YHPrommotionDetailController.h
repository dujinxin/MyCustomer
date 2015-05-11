//
//  YHPrommotionDetailController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-22.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  促销详情页面

#import "YHRootViewController.h"
#import "GoodDetailEntity.h"
#import "PromotionShareEntity.h"

@interface YHPrommotionDetailController : YHRootViewController<UIWebViewDelegate,ISSShareViewDelegate ,YHAlertViewDelegate>{
    UIWebView *webView;
    NSString  *url;
    NSString *dm_id;
}

@property (nonatomic, strong) NSString *dm_id;
@property (nonatomic, strong) GoodDetailEntity *goodsEntity;
@property (nonatomic,strong) PromotionShareEntity *promotionShareEntity;
- (void)setDMId:(NSString *)dmId;
@end
