//
//  YHReturnCell.h
//  YHCustomer
//
//  Created by lichentao on 14-5-4.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"

@interface YHReturnCell : UITableViewCell

@property (nonatomic, assign) id            returnController;
@property (nonatomic, strong) NSIndexPath   *returnIndexPath;
@property (nonatomic, assign) NSInteger     returnOrderType;
@property (nonatomic, strong) ReturnOrderEntity *returnOrderEntity;

- (void)setReturnCell:(ReturnOrderEntity *)orderEntity NSIndexPath:(NSIndexPath *)indexPath OrderType:(NSInteger)myType;
@end
