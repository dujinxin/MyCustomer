//
//  NetTransObj.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetTrans.h"

#pragma mark --------------------------界面对象接口
@protocol UINetTransDelegate <NSObject>
@optional
//用到的
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg;
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg withObject:(id)object;
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag;


-(void)requestCancel:(int)nTag;
-(void)setProgress:(float)newProgress;

@end
typedef BOOL (^NetWork)(NSString * str);

@interface NetTransObj : NSObject
{
    id<UINetTransDelegate> _uinet;//界面对象
    int _nApiTag;
    NSString  * _postRequst;
}

@property(nonatomic , strong)id<UINetTransDelegate> _uinet;
@property(nonatomic , assign)int _nApiTag;
@property(nonatomic , strong)NSString * _postRequst;
@property(nonatomic , strong)NSDictionary * _postDic;
@property(nonatomic , strong)NetWork  block_New;
@property(nonatomic , strong)NSString * _filePath;


-(id)init:(id<UINetTransDelegate>)ui nApiTag:(int)nApiTag;
- (void)request:(NSString *)request andDic:(NSDictionary *)dic;

#pragma mark --------------------------检测非法字符串
-(NSString*)testErroStr:(id)text;
#pragma mark --------------------------检测非法数组类型
-(id)testErroArray:(id)text;


@end
