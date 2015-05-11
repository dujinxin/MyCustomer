//
//  RefleshManager.m
//  myappone
//
//  Created by wbw on 12-12-11.
//  Copyright (c) 2012年 ChangShengTianDi std. All rights reserved.
//

#import "RefleshManager.h"

@implementation RefleshManager
@synthesize _tableOneReflesh, _tableFiveReflesh, _tableThreeReflesh, _tableThreeToLogin, _tableFiveToLogin, _tableFourReflesh, _tableFourToLogin;

@synthesize _nMoreRefresh;

static RefleshManager* shareRefleshManager = nil;
+(id) sharedRefleshManager {
	if (nil == shareRefleshManager) {
		shareRefleshManager = [[RefleshManager alloc] init];
	}
	return shareRefleshManager;
}

/* get reflesh count */
-(NSInteger)getTabThreeRefleshCount
{
    return self._tableThreeReflesh;
}
-(NSInteger)getTabOneRefleshCount
{
    return self._tableOneReflesh;
}
-(NSInteger)getTabFiveRefleshCount
{
    return self._tableFiveReflesh;
}
-(NSInteger)getTabFourRefleshCount
{
    return self._tableFourReflesh;
}
/* set reflesh count */
-(void)setTabThreeRefleshCount:(NSInteger)count
{
    if (count == 0) {
        self._tableThreeReflesh = 0;
    }else {
        self._tableThreeReflesh += count;
    }
}
-(void)setTabOneRefleshCount:(NSInteger)count
{
    if (count == 0) {
        self._tableOneReflesh = 0;
    }else {
        self._tableOneReflesh += count;
    }
}
-(void)setTabFiveRefleshCount:(NSInteger)count
{
    if (count == 0) {
        self._tableFiveReflesh = 0;
    }else {
        self._tableFiveReflesh += count;
    }
}
-(void)setTabFourRefleshCount:(NSInteger)count
{
    if (count == 0) {
        self._tableFourReflesh = 0;
    }else {
        self._tableFourReflesh += count;
    }
}
/**/
-(BOOL)getTableThreeToLogin
{
    return self._tableThreeToLogin;
}
-(BOOL)getTableFiveToLogin
{
    return self._tableFiveToLogin;
}
-(BOOL)getTableFourToLogin
{
    return self._tableFourToLogin;
}

/**/
-(void)setTableThreeToLogin:(BOOL)isToLogin
{
    self._tableThreeToLogin = isToLogin;
}
-(void)setTableFiveToLogin:(BOOL)isToLogin
{
    self._tableFiveToLogin = isToLogin;
}
-(void)setTableFourToLogin:(BOOL)isToLogin
{
    self._tableFourToLogin = isToLogin;
}

/* 控制more的刷新 */
-(void)setMoreRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        self._nMoreRefresh += 1;
    }else {
        self._nMoreRefresh = 0;
    }
}
-(BOOL)getMoreRefresh
{
    if (self._nMoreRefresh>0) {
        return YES;
    }else{
        return NO;
    }
}

/* 控制个人资料设置的刷新 */
-(void)setAccountManagerRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        self._accountManagerRefresh += 1;
    }else {
        self._accountManagerRefresh = 0;
    }
}
-(BOOL)getAccountManagerRefresh
{
    if (self._accountManagerRefresh>0) {
        return YES;
    }else{
        return NO;
    }
}

/*绑定积分卡设置刷新*/
-(void)setBindCardRefresh:(BOOL)isRefresh
{
    if (isRefresh)
    {
        self._bindCardRefresh += 1;
    }
    else
    {
        self._bindCardRefresh = 0;
    
    }



}
-(BOOL)getBindCardRefresh
{

    if (self._bindCardRefresh > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }


}

/*首页列表刷新*/
-(void)setMainViewRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        self._mainViewRefresh += 1;
    }else {
        self._mainViewRefresh = 0;
    }
}
-(BOOL)getMainViewRefresh
{
    if (self._mainViewRefresh>0) {
        return YES;
    }else{
        return NO;
    }
}
@end
