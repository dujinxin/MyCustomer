//
//  YHPSCityListViewController.h
//  YHCustomer
//
//  Created by lichentao on 14-5-15.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  城市列表 - 定位相关

#import "YHBaseTableViewController.h"

typedef void(^ChooseCityBlock)(NSString *cityName);

@interface YHPSCityListViewController :YHRootViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate , MBProgressHUDDelegate>{
    
    UITextField         *searchField;           // 搜索输入框
        
    UITableView         *searchTableView;       // 搜索列表
    UITableView         *cityListTable;
    TableViewStyle      tableStyle;             // 模式：1-列表模式 2-搜索模式
    LocationStyle       locationStyle  ;         // 定位模式 成功｜｜失败
    
    NSMutableDictionary *cityDic;
}

// 定位的城市id
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *locationCityName;
@property (nonatomic, strong)ChooseCityBlock cityBlock;
- (void)restoreCityReloadData:(NSDictionary *)locationDic1;

@end
