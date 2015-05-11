//
//  GoodsStatusEntity.h
//  THCustomer
//
//  Created by ioswang on 13-10-6.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsStatusEntity : NSObject
@property (nonatomic, copy) NSString *collect_status; //收藏状态
@property (nonatomic, copy) NSString *buy_status;
@property (nonatomic, copy) NSString *laud_status;
@property (nonatomic, copy) NSString *_isSell;  //是否可购买
@end

@interface GoodsStockEntity : NSObject
@property (nonatomic, copy) NSString *is_show;
@end

@interface GoodsStatusNetTrans : NetTransObj

@end

@interface GoodsStockNetTrans : NetTransObj

@end

