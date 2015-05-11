//
//  CartEntity.m
//  YHCustomer
//
//  Created by lichentao on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  购物车entity

#import "CartEntity.h"
#import "GoodsEntity.h"
@implementation CartEntity

@end

/*购物车列表*/
@implementation CartListTransObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}

-(BOOL) responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSMutableDictionary* datas = [jsonDic objectForKey:@"data"];
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([datas count] == 0){
        if ([jsonDic valueForKey:@"total"]==0)
        {
            if ([status isEqualToString:WEB_STATUS_3]) {
                [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"没有数据。"];
                [[NetTrans getInstance]cancelRequest:self];
                return YES;
            }
            else
            {
                [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
                [[NetTrans getInstance]cancelRequest:self];
                return YES;
            }
            
        }
    }
    
    GoodsListEntity *collectEntity = [[GoodsListEntity alloc] init];
    
    if([status isEqualToString:WEB_STATUS_1] ){
        collectEntity.total = [jsonDic objectForKey:@"total"];
        
        collectEntity.title = [datas objectForKey:@"title"];
        collectEntity.content = [datas objectForKey:@"content"];
        collectEntity.goods_weight = [datas objectForKey:@"goods_weight"];
        
        NSMutableArray *goods = [datas objectForKey:@"goods"];
        [collectEntity setGoodsListEntity:goods];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"没有数据。"];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSLog(@"status 10000 %@",[jsonDic objectForKey:@"message"]);
    }
 
    if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
    {
        [_uinet responseSuccessObj:collectEntity nTag:self._nApiTag];
    }
    
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}
 */
-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)]) {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"请检查网络连接！"];
        }
        return;
    }
    
    NSError *error = nil;
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *serializedRequest = [requestSerializer requestWithMethod:@"POST" URLString:request parameters:dic error:&error];
    if (error != nil) {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)]) {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"错误请求！"];
        }
    }
    [serializedRequest setTimeoutInterval:OUTTIME];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:serializedRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *base64String = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         //        NSString *str = [SQAESDE deCryptBase64:base64String key:kTORKey];
         //        if (kTORDEBUG) {NSLog(@"%@",str);}
         
         if (!base64String)
         {
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"数据返回错误，请重新请求！"];
             return ;
         }
         
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
         
         if (!error && jsonObject)
         {
             NSLog(@"jsonObject = %@" , jsonObject);
             //            NSString *responseClass = [NSStringFromClass([request class]) replaceCharacter:@"Request" withString:@"Response"];
             //            _torResponse = [[NSClassFromString(responseClass) alloc] init];
             //            _torResponse = [_torResponse initWithDictionary:jsonObject];
             if (_uinet && [_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
             {
                 NSString *status = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"status"]];
                 NSString * message = [jsonObject objectForKey:@"message"];
                 
                 if ([status isEqualToString:@"0"])
                 {
                     [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:message];
                     return;
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSMutableDictionary* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         if (datas.count > 0)
                         {
                             GoodsListEntity *collectEntity = [[GoodsListEntity alloc] init];
                             collectEntity.total = [jsonObject objectForKey:@"total"];
                             
                             collectEntity.title = [datas objectForKey:@"title"];
                             collectEntity.content = [datas objectForKey:@"content"];
                             collectEntity.goods_weight = [datas objectForKey:@"goods_weight"];
                             
                             NSMutableArray *goods = [datas objectForKey:@"goods"];
                             [collectEntity setGoodsListEntity:goods];
                             [_uinet responseSuccessObj:collectEntity nTag:self._nApiTag];
                             return;
                         }
                         else
                         {
                             [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
                             return;
                         }
                     }
                 }
                 else if ([status isEqualToString:WEB_STATUS_3])
                 {
                     [_uinet requestFailed:_nApiTag withStatus:WEB_STATUS_3 withMessage:message];
                     return;
                 }
                 else
                 {
                     [_uinet requestFailed:_nApiTag withStatus:status withMessage:message];
                     return;
                 }
             }
         }
         else
         {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
         {
             //            [_delegate torNetwork:self didFailLoadWithError:error];
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
         
     }];
    [operation start];
}
@end

@implementation CartNumTransObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}

-(BOOL) responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSMutableArray* datas = [jsonDic objectForKey:@"data"];
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if ([datas isKindOfClass:[NSArray class]])
    {
        if([datas count] == 0)
        {
            if ([jsonDic valueForKey:@"total"]==0)
            {
                if ([status isEqualToString:WEB_STATUS_3])
                {
                    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@""];
                }
                [[NetTrans getInstance]cancelRequest:self];
                return YES;
            }
        }
        
        
        NSDictionary *dic = [datas objectAtIndex:0];
        if([status isEqualToString:WEB_STATUS_1] ){
            NSString *total = [NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]];
 
            if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
            {
                [_uinet responseSuccessObj:total nTag:self._nApiTag];
            }
        }
        else if ([status isEqualToString:WEB_STATUS_3])
        {
            [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@""];
        }
        
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    return YES;
}
 */
-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)]) {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"请检查网络连接！"];
        }
        return;
    }
    
    NSError *error = nil;
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableURLRequest *serializedRequest = [requestSerializer requestWithMethod:@"POST" URLString:request parameters:dic error:&error];
    if (error != nil) {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)]) {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"错误请求！"];
        }
    }
    [serializedRequest setTimeoutInterval:OUTTIME];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:serializedRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *base64String = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         //        NSString *str = [SQAESDE deCryptBase64:base64String key:kTORKey];
         //        if (kTORDEBUG) {NSLog(@"%@",str);}
         
         if (!base64String)
         {
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"数据返回错误，请重新请求！"];
             return ;
         }
         
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
         
         if (!error && jsonObject)
         {
             NSLog(@"jsonObject = %@" , jsonObject);
             //            NSString *responseClass = [NSStringFromClass([request class]) replaceCharacter:@"Request" withString:@"Response"];
             //            _torResponse = [[NSClassFromString(responseClass) alloc] init];
             //            _torResponse = [_torResponse initWithDictionary:jsonObject];
             if (_uinet && [_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
             {
                 NSString *status = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"status"]];
                 NSString * message = [jsonObject objectForKey:@"message"];
                 
                 if ([status isEqualToString:@"0"])
                 {
                     [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:message];
                     return;
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
//                         if (datas.count > 0)
//                         {
                             NSDictionary *dic = [datas objectAtIndex:0];
                             NSString *total = [NSString stringWithFormat:@"%@",[dic objectForKey:@"total"]];
                             [_uinet responseSuccessObj:total nTag:self._nApiTag];
                             return;
//                         }
//                         else
//                         {
//                             [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
//                             return;
//                         }
                     }
                 }
                 else if ([status isEqualToString:WEB_STATUS_3])
                 {
                     [_uinet requestFailed:_nApiTag withStatus:WEB_STATUS_3 withMessage:message];
                     return;
                 }
                 else
                 {
                     [_uinet requestFailed:_nApiTag withStatus:status withMessage:message];
                     return;
                 }
             }
         }
         else
         {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
         {
             //            [_delegate torNetwork:self didFailLoadWithError:error];
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
         
     }];
    [operation start];
}
@end



// 报销
//
//通讯费：100元
//
//出差补助： 6月1日 － 7月2日  32 ＊ 75 ＝ 2400
//
//室内交通费：138 ＋ 30 ＋ 10+ 25 ＋100 ＝ 303
//
//误餐费： 3、4、5、6 ＊ 35 ＝ 140
//
//        7、8 ＊ 70 ＝ 140
//
//        9、10、11 ＊ 35 ＝ 105
//
//        14、15 ＊70 ＝ 140
//
//        16、17、18、19 ＊35 140
//
//        28、29 ＊70 140
//
//
//    ／／ 805
//






