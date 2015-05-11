//
//  YHMyCollectViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "YHCartView.h"
#import "YHCartViewController.h"

@interface YHMyCollectViewController : YHBaseTableViewController <CartViewDelegate>{
    UIButton *dmBtn;
    UIButton *goodsBtn;
    NSMutableArray *dmDataArray;

    NSMutableArray *goodsDataArray;

    CollectType collectType;
    
    UIImageView     *resultImage;
    
    YHCartView *cartView;
    
    NSString *region_id;
    NSString *region_name;

}

@end
