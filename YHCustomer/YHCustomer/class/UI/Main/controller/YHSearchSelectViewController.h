//
//  YHSearchSelectViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

typedef void (^SelectCB)(id sender);

@interface YHSearchSelectViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString * string;
    UITableView * table;
    NSString * selectName;
    NSMutableDictionary * params;
    //    NSString * keyWord;
}
@property (nonatomic ,copy)NSString * string;
@property (nonatomic ,copy)NSString * selectName;
@property (nonatomic ,strong)UITableView *table;
@property (nonatomic ,copy)SelectCB selectScreenGoods;

-(void)setRequstParams:(NSMutableDictionary *)param;

@end

