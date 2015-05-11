//
//  YHGoodsDetailViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

typedef void(^refreshBlock)();
@interface YHGoodsDetailViewController : YHRootViewController<UIWebViewDelegate,YHAlertViewDelegate>
{
    UIWebView *webView;
    NSString  *url;
    NSString  *isBuy;
    
    BOOL isLogin;
    BOOL isOutOfStocks;
}

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *bu_goods_id;
@property (nonatomic, assign) BOOL fromCart;//来自购物车，防止闭环
@property (nonatomic, strong) refreshBlock refresh;
- (void)setBu_GoodsUrl:(NSString *)goodsDetailUrl Paramer:(NSDictionary *)dic;
-(void)setMainGoodsUrl:(NSString *)goodsUrl goodsID:(NSString *)goodID;
@end
