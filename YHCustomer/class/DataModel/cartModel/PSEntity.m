//
//  PSEntity.m
//  YHCustomer
//
//  Created by lichentao on 14-3-30.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  配送相关数据封装

#import "PSEntity.h"

@implementation PSEntity

@end

@implementation  DeliveryStyleEntity

@end

// 送货上门－半日送｜｜飞速达
@implementation LogisticModelEntity
@synthesize logisId,title,info,delivery_time;

- (void)setLogisticModelEntity:(NSDictionary *)dic{
    if ([dic objectForKey:@"id"]) {
        self.logisId = [dic objectForKey:@"id"];
    }
    if ([dic objectForKey:@"title"]) {
        self.title = [dic objectForKey:@"title"];
    }
    if ([dic objectForKey:@"info"]) {
        self.info = [dic objectForKey:@"info"];
    }
    if ([dic objectForKey:@"delivery_time"]) {
        self.delivery_time = [dic objectForKey:@"delivery_time"];
    }
    if ([dic objectForKey:@"date_num"]) {
        self.date_num = [dic objectForKey:@"date_num"];
    }
}

@end

// 物流信息
@implementation SendLogisticToStoreObj

/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}

-(BOOL) responseSuccess:(ASIHTTPRequest *)request
 {
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSMutableDictionary *dictionary = [jsonDic objectForKey:@"data"];
        NSMutableArray *array = [NSMutableArray array];
        if (nil == dictionary) {
            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }else{
            LogisticModelEntity *allEntity = [[LogisticModelEntity alloc] init];
            if ([dictionary objectForKey:@"now_date"]) {
                allEntity.now_date = [dictionary objectForKey:@"now_date"];
            }
            
            NSMutableArray * lm_info = [dictionary objectForKey:@"lm_info"];
            NSMutableDictionary * d = [NSMutableDictionary dictionary];
            for (NSDictionary * dic in lm_info) {
                LogisticModelEntity *entity = [[LogisticModelEntity alloc] init];
                entity.now_date = [dictionary objectForKey:@"now_date"];
                entity.logisId = [dic objectForKey:@"id"];
                entity.title = [dic objectForKey:@"title"];
                entity.info = [dic objectForKey:@"info"];
                entity.delivery_time = [dic objectForKey:@"delivery_time"];
                entity.date_num = [dic objectForKey:@"date_num"];
                
                if ([entity.title isEqualToString:@"半日达"]) {
                    [d setValue:entity forKey:@"半日达"];
                    [array addObject:d];
                }else{
                    [d setValue:entity forKey:@"飞速达"];
                    [array addObject:d];
                }
            }
            [_uinet responseSuccessObj:array nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
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
                             NSMutableArray *array = [NSMutableArray array];
                             LogisticModelEntity *allEntity = [[LogisticModelEntity alloc] init];
                             if ([datas objectForKey:@"now_date"]) {
                                 allEntity.now_date = [datas objectForKey:@"now_date"];
                             }
                             NSMutableArray * lm_info = [datas objectForKey:@"lm_info"];
                             NSMutableDictionary * d = [NSMutableDictionary dictionary];
                             for (NSDictionary * dic in lm_info) {
                                 LogisticModelEntity *entity = [[LogisticModelEntity alloc] init];
                                 entity.now_date = [datas objectForKey:@"now_date"];
                                 entity.logisId = [dic objectForKey:@"id"];
                                 entity.title = [dic objectForKey:@"title"];
                                 entity.info = [dic objectForKey:@"info"];
                                 entity.delivery_time = [dic objectForKey:@"delivery_time"];
                                 entity.date_num = [dic objectForKey:@"date_num"];
                                 
//                                 if ([entity.title isEqualToString:@"半日达"]) {
//                                     [d setValue:entity forKey:@"半日达"];
//                                     [array addObject:d];
//                                 }else{
//                                     [d setValue:entity forKey:@"飞速达"];
//                                     [array addObject:d];
//                                 }
                                 [d setObject:entity forKey:@"delivery_time"];
                                 [array addObject:entity];
                             }
                             [_uinet responseSuccessObj:array nTag:self._nApiTag];
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


// 配送信息
@implementation CommonArrayObj
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSMutableArray *dicArray = [jsonDic objectForKey:@"data"];
        if (nil == dicArray) {
            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }else{
            [_uinet responseSuccessObj:dicArray nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
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
                     NSMutableArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         [_uinet responseSuccessObj:datas nTag:self._nApiTag];
                         return;
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

@implementation ModifyPayMethod
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    ModifyPayMethod * entity = [[ModifyPayMethod alloc]init ];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSMutableDictionary * dict = [jsonDic objectForKey:@"data"];
        NSMutableArray * dicArray = [NSMutableArray array ];
        entity.status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
        entity.msg = [dict objectForKey:@"msg"];
        entity.total_amount = [dict objectForKey:@"total_amount"];
        [dicArray addObject:entity];
        
        [_uinet responseSuccessObj:dicArray nTag:self._nApiTag];
        [[NetTrans getInstance]cancelRequest:self];
    }else if ([status isEqualToString:WEB_STATUS_2]){
        NSMutableArray * dicArray  = [NSMutableArray array ];
        entity.status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
        [dicArray addObject:entity];
        [_uinet responseSuccessObj:dicArray nTag:self._nApiTag];
        [[NetTrans getInstance]cancelRequest:self];
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
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
                             ModifyPayMethod * entity = [[ModifyPayMethod alloc]init ];
//                             NSMutableDictionary * dict = [jsonDic objectForKey:@"data"];
                             NSMutableArray * dicArray = [NSMutableArray array ];
                             entity.status = [NSString stringWithFormat:@"%@",status];
                             entity.msg = [datas objectForKey:@"msg"];
                             entity.total_amount = [datas objectForKey:@"total_amount"];
                             [dicArray addObject:entity];
                             [_uinet responseSuccessObj:dicArray nTag:self._nApiTag];
                             return;
                         }
                         else
                         {
                             [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
                             return;
                         }
                     }
                 }
                 else if ([status isEqualToString:WEB_STATUS_2])
                 {
                     ModifyPayMethod * entity = [[ModifyPayMethod alloc]init ];
                     NSMutableArray * dicArray  = [NSMutableArray array ];
                     entity.status = [NSString stringWithFormat:@"%@",status];
                     [dicArray addObject:entity];
                     [_uinet responseSuccessObj:dicArray nTag:self._nApiTag];
                     return;
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

// 优惠券使用
@implementation CouponNetTransObj
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] )
 {
        NSMutableArray *dicArray = [jsonDic objectForKey:@"data"];
        if (nil == dicArray) {
            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }else{
            [_uinet responseSuccessObj:dicArray nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
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
                     NSMutableArray* datas = [jsonObject objectForKey:@"data"];
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
                              [_uinet responseSuccessObj:datas nTag:self._nApiTag];
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

@implementation PickUpTimeEntity

@end