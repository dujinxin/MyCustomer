//
//  StarPostCardEntity.m
//  YHCustomer
//
//  Created by wangliang on 15-5-1.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "StarPostCardEntity.h"

@implementation StarPostCardEntity

@end

@implementation StarPostCardNetTransObj

-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    //判断网络连接
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
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSArray * dataArray = [jsonObject objectForKey:@"data"];
                     if (!dataArray || (dataArray == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *starArray = [[NSMutableArray alloc]init];
                         for (NSDictionary *dic in dataArray)
                         {
                             StarPostCardEntity *entity = [[StarPostCardEntity alloc]init];
                             entity.ppc_goods_code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ppc_goods_code"]];
                             entity.ppc_goods_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ppc_goods_name"]];
                             [starArray addObject:entity];
                             
                         }
                         
                         [_uinet responseSuccessObj:starArray nTag:self._nApiTag];
                         
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
@implementation StarPostCardRecordList

@end
@implementation StarPostCardRecordListNetTransObj

-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    //判断网络连接
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
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSArray * dataArray = [jsonObject objectForKey:@"data"];
                     if (!dataArray || (dataArray == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *starArray = [[NSMutableArray alloc]init];
                         for (NSDictionary *dic in dataArray)
                         {
                             StarPostCardRecordList *entity = [[StarPostCardRecordList alloc]init];
                             entity.ppc_goods_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ppc_goods_name"]];
                             entity.create_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"create_time"]];
                             [starArray addObject:entity];
                             
                         }

                         [_uinet responseSuccessObj:starArray nTag:self._nApiTag];
                         
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
@implementation StarPostCardPayMethod

@end

@implementation StarPostCardPayMethodNetTransObj

-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    //判断网络连接
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
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSArray * dataArray = [jsonObject objectForKey:@"data"];
                     if (!dataArray || (dataArray == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *starArray = [[NSMutableArray alloc]init];
                         for (NSDictionary *dic in dataArray)
                         {
                             StarPostCardPayMethod *entity = [[StarPostCardPayMethod alloc]init];
                             entity._id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                             entity.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                             [starArray addObject:entity];
                             
                         }
                         
                         [_uinet responseSuccessObj:starArray nTag:self._nApiTag];
                         
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
@implementation StarPostCardBuyCard

@end

@implementation StarPostCardBuyCardNetTransObj

-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    //判断网络连接
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
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSDictionary * dic = [jsonObject objectForKey:@"data"];
                     if (!dic || (dic == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                        StarPostCardBuyCard *entity = [[StarPostCardBuyCard alloc]init];
                        entity.pay_method = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pay_method"]];
                        entity.pay_str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pay_str"]];
                         NSString *messageStr = [NSString stringWithFormat:@"%@",message];
                         entity.message = messageStr;
                         [_uinet responseSuccessObj:entity nTag:self._nApiTag];
                         
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
