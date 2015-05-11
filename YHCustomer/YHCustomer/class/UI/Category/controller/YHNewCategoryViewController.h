//
//  YHNewCategoryViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-10-13.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

typedef void (^SelectCB)(id sender);

@interface YHNewCategoryViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *categoryBtn;
    
    UIButton *brandBtn;
    UIView * line;
    SubType  subType;
    WallLoadStyle  requestStyle;
}
@property(assign, nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *secondCategoryArray;

@property (nonatomic, strong) NSMutableArray *hotBrandArray;
@property (nonatomic, strong) NSMutableArray *allBrandArray;
@property (nonatomic, strong) NSMutableArray *sectionTitleArray;
@property (nonatomic ,copy)NSString * string;
@property (nonatomic ,copy)NSString * selectName;
@property (nonatomic ,strong)UITableView *table;
@property (nonatomic ,copy)SelectCB selectScreenGoods;

//@property (strong, nonatomic) NSArray *cates;
//@property (strong, nonatomic) UIFolderTableView *foldTableView;
//@property (strong, nonatomic) YHSubCategoryViewController *subVc;
//@property (strong, nonatomic) NSDictionary *currentCate;
@end
