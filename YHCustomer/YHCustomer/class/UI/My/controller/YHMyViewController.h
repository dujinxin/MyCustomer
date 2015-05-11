//
//  YHMyViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  我的

#import "YHRootViewController.h"
#import "ZBarReaderViewController.h"
#import "UserInfoEntity.h"

@interface YHMyViewController : YHRootViewController<UITableViewDataSource, UITableViewDelegate,ZBarReaderDelegate>

@property (nonatomic, strong) UITableView     *_tableView;
@property (nonatomic, strong) UserInfoEntity  *_userInfoEntity;

@end
