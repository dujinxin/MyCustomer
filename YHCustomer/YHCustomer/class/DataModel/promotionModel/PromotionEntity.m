//
//  PromotionListEntity.m
//  THCustomer
//
//  Created by lichentao on 13-9-9.
//  Copyright (c) 2013年 efuture. All rights reserved.
//  促销列表（门店&&专柜）

#import "PromotionEntity.h"

@implementation PromotionEntity

@end


@implementation PromotionCollectListTransObj
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
                     NSMutableArray * datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *arrRe = [NSMutableArray array];
                         for (NSDictionary *dataDic in datas)
                         {
                             //返回结果是以Dictionary存在
                             PromotionEntity *entity = [[PromotionEntity alloc] init];
                             entity._dmId = [dataDic objectForKey:@"dm_id"];
                             entity._commentNum = [[dataDic objectForKey:@"comment"] description];
                             entity._description = [self testErroStr:[dataDic objectForKey:@"description"]];
                             entity._laud = [[dataDic objectForKey:@"laud"] description];
                             entity._dmPublishTime = [self testErroStr:[dataDic objectForKey:@"publish_time"]];
                             entity._dmPhoto = [self testErroStr:[dataDic objectForKey:@"dm_image"]];
                             entity._dmTitle = [self testErroStr:[dataDic objectForKey:@"title"]];
                             entity.region_id = [dataDic objectForKey:@"region_id"];
                             entity.region_name = [dataDic objectForKey:@"region_name"];
                             
                             if ([dataDic objectForKey:@"background_color"]) {
                                 entity.background_color = [dataDic objectForKey:@"background_color"];
                             }
                             if ([dataDic objectForKey:@"page_type"]) {
                                 entity.page_type = [dataDic objectForKey:@"page_type"];
                             }
                             if ([dataDic objectForKey:@"image_url"]) {
                                 entity.image_url = [dataDic objectForKey:@"image_url"];
                             }
                             if ([dataDic objectForKey:@"connect_goods"]) {
                                 entity.connect_goods = [dataDic objectForKey:@"connect_goods"];
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