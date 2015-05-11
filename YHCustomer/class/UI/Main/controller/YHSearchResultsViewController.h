//
//  YHSearchResultsViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHGarbageViewController.h"
#import "YHSearchSelectViewController.h"
#import "YHCartView.h"

typedef void (^SelectCB)(id sender);

@interface YHSearchResultsViewController : YHGarbageViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CartViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    UITextField * textField;
    UITableView * mainTableView;
    UITableView * rightTableView;
    NSInteger index;
    NSString * screenString;
    NSString * keyWord;
    
    
}
@property (nonatomic ,strong)UITextField * textField;
@property (nonatomic ,strong)UITableView * mainTableView;
@property (nonatomic ,strong)UITableView * rightTableView;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,copy)NSString * keyWord;
@property (nonatomic ,copy)NSString * screenString;
@property (nonatomic ,copy)SelectCB selectScreenGoods;

@property (nonatomic, strong) Reachability * hostReach;

//@property(nonatomic,assign)BOOL IsRight;
//
//@property(nonatomic,assign)BOOL RightDrawerIsShow;
//
//@property(nonatomic,retain)UITapGestureRecognizer *tapRight;
//
////点击右按钮
//
//- (void)tapRightDrawerButton;
//
////关闭右抽屉,方便调用
//
//- (void)closeRightDrawer;

-(void)setRequstParams:(NSMutableDictionary *)param;
@end

