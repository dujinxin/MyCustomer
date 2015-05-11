//
//  YHNewSearchGoodsViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHSearchListTableViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHSearchResultsViewController.h"
#import "HotWordsEntity.h"
#import "KeyWordsEntity.h"


@interface YHNewSearchGoodsViewController : YHRootViewController <UITextFieldDelegate,PassValueDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{
    NSMutableArray * _searchListArray;
    UITextField * _textField;
    UISearchBar * _searchView;
    NSString * _searchStr;
    YHSearchListTableViewController * _searchListView;
    NSMutableDictionary * postDic;
    NSString * hiddenStr;//判断界面消失后是否隐藏narBar
}
//@property (nonatomic ,strong)UITextField * searchView;
@property (nonatomic ,strong)UISearchBar * searchView;
@property (nonatomic ,copy)NSString * searchStr;
@property (nonatomic ,strong)NSMutableArray * searchListArray;
@property (nonatomic ,strong)YHSearchListTableViewController * searchListView;

- (void)setSearchListHidden:(BOOL)hidden;
- (void)setRequstParams:(NSMutableDictionary *)param;

@end
