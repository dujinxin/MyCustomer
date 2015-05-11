//
//  DmEntity.m
//  YHCustomer
//
//  Created by kongbo on 13-12-18.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "DmEntity.h"

@implementation DmEntity

@end

@implementation DmMainTopTransObj
-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    if (([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) )//||([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown))
    {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
        {
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
                     NSMutableArray * datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *array = [NSMutableArray array];
                         for (NSDictionary *dic in datas)
                         {
                             DmEntity* entity = [[DmEntity alloc] init];
                             if ([dic objectForKey:@"dm_id"]) {
                                 entity.dm_id = [dic objectForKey:@"dm_id"];
                             }
                             if ([dic objectForKey:@"bu_id"]) {
                                 entity.bu_id = [dic objectForKey:@"bu_id"];
                             }
                             if ([dic objectForKey:@"title"]) {
                                 entity.title = [dic objectForKey:@"title"];
                             }
                             if ([dic objectForKey:@"dm_image"]) {
                                 entity.dm_image = [dic objectForKey:@"dm_image"];
                             }
                             
                             if ([dic objectForKey:@"image_url"]) {
                                 entity.image_url = [dic objectForKey:@"image_url"];
                             }
                             if ([dic objectForKey:@"description"]) {
                                 entity._description = [dic objectForKey:@"description"];
                             }
                             if ([dic objectForKey:@"home_show_id"])
                             {
                                 id showId = [dic objectForKey:@"home_show_id"];
                                 if ([showId isKindOfClass:[NSNumber class]]) {
                                     entity.home_show_id = [showId stringValue];
                                 }else{
                                     entity.home_show_id = [dic objectForKey:@"home_show_id"];
                                 }
                             }
                             
                             if ([dic objectForKey:@"region_name"]) {
                                 entity.region_name = [dic objectForKey:@"region_name"];
                             }
                             if ([dic objectForKey:@"region_id"]) {
                                 entity.region_id = [dic objectForKey:@"region_id"];
                             }
                             
                             if ([dic objectForKey:@"background_color"]) {
                                 entity.background_color = [dic objectForKey:@"background_color"];
                             }
                             if ([dic objectForKey:@"page_type"]) {
                                 entity.page_type = [dic objectForKey:@"page_type"];
                             }
                             if ([dic objectForKey:@"image_url"]) {
                                 entity.image_url = [dic objectForKey:@"image_url"];
                             }
                             if ([dic objectForKey:@"connect_goods"]) {
                                 entity.connect_goods = [dic objectForKey:@"connect_goods"];
                             }
                             
                             if ([dic objectForKey:@"id"]) {
                                 entity.type = [dic objectForKey:@"id"];
                             }
                             if ([dic objectForKey:@"name"]) {
                                 entity.name = [dic objectForKey:@"name"];
                             }
                             if ([dic objectForKey:@"is_sign"])
                             {
                                 entity.is_sign = [dic objectForKey:@"is_sign"];
                             }
                             [array addObject:entity];
                         }

                         
                         [_uinet responseSuccessObj:array nTag:self._nApiTag];
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
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
         {
             //            [_delegate torNetwork:self didFailLoadWithError:error];
//            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];             NSLog(@"error = %@" , error);
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
         
     }];
    [operation start];
}
@end


@implementation DmPushNetTransObj
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
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                    // NSMutableArray * datas = [jsonObject objectForKey:@"data"];
                     //返回结果是以Dictionary存在
                     NSDictionary* datas = [[jsonObject objectForKey:@"data"] objectAtIndex:0];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         DmEntity* entity = [[DmEntity alloc] init];
                         entity.type = [datas objectForKey:@"id"];
                         entity.name = [datas objectForKey:@"name"];
                         if ([[datas objectForKey:@"dm_info"] isKindOfClass:[NSArray class]] && [datas objectForKey:@"dm_info"]) {
                             NSArray *dmInfo = [datas objectForKey:@"dm_info"];
                             if (dmInfo.count > 0)
                             {
                                 NSDictionary *dic = [[datas objectForKey:@"dm_info"] objectAtIndex:0];
                                 
                                 if ([dic objectForKey:@"dm_id"]) {
                                     entity.dm_id = [dic objectForKey:@"dm_id"];
                                 }
                                 if ([dic objectForKey:@"bu_id"]) {
                                     entity.bu_id = [dic objectForKey:@"bu_id"];
                                 }
                                 if ([dic objectForKey:@"title"]) {
                                     entity.title = [dic objectForKey:@"title"];
                                 }
                                 if ([dic objectForKey:@"dm_image"]) {
                                     entity.dm_image = [dic objectForKey:@"dm_image"];
                                 }
                                 
                                 if ([dic objectForKey:@"image_url"]) {
                                     entity.image_url = [dic objectForKey:@"image_url"];
                                 }
                                 if ([dic objectForKey:@"description"]) {
                                     entity._description = [dic objectForKey:@"description"];
                                 }
                                 if ([dic objectForKey:@"home_show_id"]) {
                                     id showId = [dic objectForKey:@"home_show_id"];
                                     if ([showId isKindOfClass:[NSNumber class]]) {
                                         entity.home_show_id = [showId stringValue];
                                     }else{
                                         entity.home_show_id = [dic objectForKey:@"home_show_id"];
                                     }
                                 }
                                 
                                 if ([dic objectForKey:@"region_name"]) {
                                     entity.region_name = [dic objectForKey:@"region_name"];
                                 }
                                 if ([dic objectForKey:@"region_id"]) {
                                     entity.region_id = [dic objectForKey:@"region_id"];
                                 }
                                 
                                 if ([dic objectForKey:@"background_color"]) {
                                     entity.background_color = [dic objectForKey:@"background_color"];
                                 }
                                 if ([dic objectForKey:@"page_type"]) {
                                     entity.page_type = [dic objectForKey:@"page_type"];
                                 }
                                 if ([dic objectForKey:@"image_url"]) {
                                     entity.image_url = [dic objectForKey:@"image_url"];
                                 }
                                 if ([dic objectForKey:@"connect_goods"]) {
                                     entity.connect_goods = [dic objectForKey:@"connect_goods"];
                                 }
                                 
                             }
                             
                         }
                         
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

@implementation DmGoodsTransObj
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
                 }
                 else if ([status isEqualToString:@"1"])
                 {
                     NSDictionary * datas = [jsonObject objectForKey:@"data"];
                     if (!datas || datas == nil)
                     {
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSNumber *collectStatus;
                         if ([datas objectForKey:@"collect_status"]) {
                             collectStatus= [[jsonObject objectForKey:@"data"] objectForKey:@"collect_status"];
                         }else{
                             collectStatus = [datas objectForKey:@"operate_status"];
                             
                         }
                         [_uinet responseSuccessObj:collectStatus nTag:self._nApiTag];
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