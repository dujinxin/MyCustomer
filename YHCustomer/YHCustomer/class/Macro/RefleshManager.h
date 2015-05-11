//
//  RefleshManager.h
//  myappone
//
//  Created by wbw on 12-12-11.
//  Copyright (c) 2012年 ChangShengTianDi std. All rights reserved.
//  管理页面刷新

#import <Foundation/Foundation.h>

@interface RefleshManager : NSObject
{
    NSInteger   _tableThreeReflesh; //我的购物墙刷新
    NSInteger   _tableOneReflesh;   //逛一逛界面刷新
    NSInteger   _tableFiveReflesh;  //微通社刷新
    NSInteger   _tableFourReflesh;//消息刷新
    
    BOOL        _tableThreeToLogin;
    BOOL        _tableFiveToLogin;
    BOOL        _tableFourToLogin;
}

@property (nonatomic, assign) NSInteger   _tableThreeReflesh;
@property (nonatomic, assign) NSInteger   _tableOneReflesh;
@property (nonatomic, assign) NSInteger   _tableFiveReflesh;
@property (nonatomic, assign) NSInteger   _tableFourReflesh;

@property (nonatomic, assign) BOOL        _tableThreeToLogin;
@property (nonatomic, assign) BOOL        _tableFiveToLogin;
@property (nonatomic, assign) BOOL        _tableFourToLogin;

@property (nonatomic, assign) NSInteger   _nMoreRefresh;
@property (nonatomic, assign) NSInteger   _accountManagerRefresh;//个人资料设置刷新
@property (nonatomic, assign) NSInteger   _mainViewRefresh;//首页列表设置刷新

@property (nonatomic, assign) NSInteger    _bindCardRefresh;//绑定积分卡刷新

+(id) sharedRefleshManager;


/* set reflesh count */
-(void)setTabThreeRefleshCount:(NSInteger)count;
-(void)setTabOneRefleshCount:(NSInteger)count;
-(void)setTabFiveRefleshCount:(NSInteger)count; 
-(void)setTabFourRefleshCount:(NSInteger)count;

/* get reflesh count */
-(NSInteger)getTabThreeRefleshCount;
-(NSInteger)getTabOneRefleshCount;
-(NSInteger)getTabFiveRefleshCount;
-(NSInteger)getTabFourRefleshCount;

/* get to login */
-(BOOL)getTableThreeToLogin;
-(BOOL)getTableFiveToLogin;
-(BOOL)getTableFourToLogin;

/* set to login */
-(void)setTableThreeToLogin:(BOOL)isToLogin;
-(void)setTableFiveToLogin:(BOOL)isToLogin;
-(void)setTableFourToLogin:(BOOL)isToLogin;


/* 控制more的刷新 */
//我的界面刷新
-(void)setMoreRefresh:(BOOL)isRefresh;
-(BOOL)getMoreRefresh;

/*个人资料设置刷新*/
-(void)setAccountManagerRefresh:(BOOL)isRefresh;
-(BOOL)getAccountManagerRefresh;

/*绑定积分卡设置刷新*/
-(void)setBindCardRefresh:(BOOL)isRefresh;
-(BOOL)getBindCardRefresh;

/*首页列表刷新*/
-(void)setMainViewRefresh:(BOOL)isRefresh;
-(BOOL)getMainViewRefresh;
@end
