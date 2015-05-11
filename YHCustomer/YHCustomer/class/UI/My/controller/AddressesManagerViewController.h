//
//  AddressesManagerViewController.h
//  THCustomer
//
//  Created by ioswang on 13-9-28.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderAddressEntity.h"
typedef void (^THOrderGetAddressBlock)(OrderAddressEntity *entity,NSMutableArray *addressArray);

@interface AddressesManagerViewController : YHRootViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView    *_tableView;
@property (nonatomic, strong) NSMutableArray *_arrAddress;
@property (nonatomic, strong) NSIndexPath    *_indexPath;
@property (nonatomic, assign) BOOL           fromMore;
@property (nonatomic, copy) NSString         *entityID;

@property (nonatomic, copy) NSString         *goods_id;//15-0517新增
-(void)setNavTitle:(NSString *)title;
#if NS_BLOCKS_AVAILABLE
@property (nonatomic, strong) THOrderGetAddressBlock addressDefaultCallBack;
#endif
@end
