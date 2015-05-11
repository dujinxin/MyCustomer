//
//  YHShakeRecordViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-11-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"

@interface YHShakeRecordViewController : YHBaseTableViewController
{
    NSMutableArray * dataArray;
}
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) NSString * totalNum;
@property (nonatomic, assign) BOOL isFromAddress;
@end
