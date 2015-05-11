//
//  YHCollectViewController.h
//  YHCustomer
//
//  Created by dujinxin on 15-1-20.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "YHCartView.h"
#import "YHCartViewController.h"

@interface YHCollectViewController : YHBaseTableViewController <CartViewDelegate>{
    UIButton       * dmBtn;
    UIButton       * goodsBtn;
    NSMutableArray * dmDataArray;
    
    NSMutableArray * goodsDataArray;
    
    CollectType      collectType;
    
    UIWebView      * webView;
    UIImageView    * resultImage;
    
    YHCartView     * cartView;
    
    NSString       * region_id;
    NSString       * region_name;
    
}

@end
