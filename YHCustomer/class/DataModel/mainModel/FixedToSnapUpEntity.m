//
//  FixedToSnapUpEntity.m
//  YHCustomer
//
//  Created by wangliang on 15-1-9.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "FixedToSnapUpEntity.h"

@implementation FixedToSnapUpEntity

@end


@implementation FixedToSnapUpTransObj
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
         NSLog(@"base64String = %@" , base64String);
         if (!base64String)
         {
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"数据返回错误，请重新请求！"];
             return ;
         }
         
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
         NSLog(@"jsonObject = %@" , jsonObject);
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

                             NSMutableArray *arrRe = [NSMutableArray array];
                             for (NSDictionary *dic in datas)
                             {
                                 FixedToSnapUpEntity* entity = [[FixedToSnapUpEntity alloc] init];
                                 if ([dic objectForKey:@"activity_id"]) {
                                     NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"activity_id"]];
                                     entity.activity_id = str;
                                 }
                                 if ([dic objectForKey:@"title"]) {
                                     NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
                                     entity.title = str;
                                 }
                                 if ([dic objectForKey:@"start_date"]) {
                                     NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_date"]];
                                     entity.start_date = str;
                                 }
                                 if ([dic objectForKey:@"end_date"]) {
                                     NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"end_date"]];
                                     entity.end_date = str;
                                 }
                                 if ([dic objectForKey:@"date"]) {
                                     NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date"]];
                                     entity.date = str;
                                 }
                                 [arrRe addObject:entity];
                             }

                             [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
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
@implementation BuyActiviteListEntity


@end
@implementation BuyActiviteListTransObj

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
         NSLog(@"base64String = %@" , base64String);
         if (!base64String)
         {
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"数据返回错误，请重新请求！"];
             return ;
         }
         
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
         NSLog(@"jsonObject = %@" , jsonObject);
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
                     NSLog(@"datas = %@" , datas);
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                             NSMutableArray *arrRe = [NSMutableArray array];
                         NSLog(@"datas = %@" , datas);
                         for (int i = 0 ; i < datas.count ; i++)
                             {
                                 NSDictionary * dic = [datas objectAtIndex:i];
                                 NSLog(@"dic = %@" , dic);
                                 BuyActiviteListEntity* entity = [[BuyActiviteListEntity alloc] init];
                                 if ([dic objectForKey:@"id"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"id"]];
                                     entity.iid = str;
                                 }
                                 if ([dic objectForKey:@"goods_name"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"goods_name"]];
                                     entity.goods_name = str;
                                 }
                                 if ([dic objectForKey:@"price"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"price"]];
                                     entity.price = str;
                                 }
                                 if ([dic objectForKey:@"discount_price"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"discount_price"]];
                                     entity.discount_price = str;
                                 }
                                 if ([dic objectForKey:@"goods_image"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"goods_image"]];
                                     entity.goods_image = str;
                                 }
                                 if ([dic objectForKey:@"stock"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"stock"]];
                                     entity.stock = str;
                                 }
                                 
                                 
                                 if ([dic objectForKey:@"out_of_stock"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"out_of_stock"]];
                                     entity.out_of_stock = str;
                                 }
                                 if ([dic objectForKey:@"start_time"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"start_time"]];
                                     entity.start_time = str;
                                 }
                                 if ([dic objectForKey:@"end_time"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"end_time"]];
                                     entity.end_time = str;
                                 }
                                 if ([dic objectForKey:@"is_or_not_salse"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"is_or_not_salse"]];
                                     entity.is_or_not_salse = str;
                                 }
                                 
                                 if ([dic objectForKey:@"date_time"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"date_time"]];
                                     entity.date_time = str;
                                 }
                                 if ([dic objectForKey:@"limit_the_purchase_type"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"limit_the_purchase_type"]];
                                     entity.limit_the_purchase_type = str;
                                 }
                                 if ([dic objectForKey:@"salse_num"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"salse_num"]];
                                     entity.salse_num = str;
                                 }
                                 if ([dic objectForKey:@"salse_deductions_num"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"salse_deductions_num"]];
                                     entity.salse_deductions_num = str;
                                 }
                                 
                                 if ([dic objectForKey:@"goods_introduction"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"goods_introduction"]];
                                     entity.goods_introduction = str;
                                 }
                                 if ([dic objectForKey:@"goods_status"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"goods_status"]];
                                     entity.goods_status = str;
                                 }
                                 if ([dic objectForKey:@"goods_status_name"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [dic objectForKey:@"goods_status_name"]];
                                     entity.goods_status_name = str;
                                 }
                                 if ([jsonObject objectForKey:@"total"])
                                 {
                                     NSString * str = [NSString stringWithFormat:@"%@" , [jsonObject objectForKey:@"total"]];
                                     entity.total = str;
                                 }
                                 if ([dic objectForKey:@"transaction_type"])
                                 {
                                     NSString * transaction_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"transaction_type"]];
                                     entity.transaction_type = transaction_type;
                                 }
                                 [arrRe addObject:entity];
                             }
                             NSLog(@"%@" , arrRe);
                             [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
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