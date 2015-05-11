//
//  ValidationEntity.m
//  YHCustomer
//
//  Created by wangliang on 14-10-24.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "ValidationEntity.h"

@implementation ValidationEntity

@end
@implementation ValidationNetTransObj
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
                         NSMutableArray *array = [NSMutableArray array];
                         ValidationEntity *entity = [[ValidationEntity alloc]init];
                         //    遍历数组中的所有数组
                         for (NSDictionary *dic in datas)
                         {
                             //entity.is_verify = [dic objectForKey:@"is_verify"];
                             //entity.is_binding = [dic objectForKey:@"is_binding"];
                             entity.mobile = [dic objectForKey:@"mobile"];
                             entity.id_no = [dic objectForKey:@"id_no"];
                             entity.msg = [dic objectForKey:@"msg"];
                             //entity.no_bind_msg = [dic objectForKey:@"no_bind_msg"];
                             //entity.bind_msg = [dic objectForKey:@"bind_msg"];
                             entity.card_list = [NSMutableArray array];
                             NSMutableArray *card_list = [NSMutableArray array];
                             
                             card_list = [dic objectForKey:@"card_list"];
                             if (card_list.count != 0) {
                                 for (NSMutableDictionary *dic_list in card_list) {
                                     ValidationEntity *entity1 = [[ValidationEntity alloc]init];
                                     entity1.card_no = [dic_list objectForKey:@"card_no"];
                                     entity1.mobile = [dic_list objectForKey:@"mobile"];
                                     entity1.id_no = [dic_list objectForKey:@"id_no"];
                                     entity1.is_binding_type = [dic_list objectForKey:@"is_binding_type"];
                                     entity1.binding_msg = [dic_list objectForKey:@"binding_msg"];
                                     entity1.total_score = [dic_list objectForKey:@"total_score"];
                                     entity1.card_type = [dic_list objectForKey:@"card_type"];
                                     entity1.latest_time = [dic_list objectForKey:@"latest_time"];
                                     [entity.card_list addObject:entity1];
                                     
                                 }
                                 
                             }
                             [array addObject:entity];
                             NSLog(@"%@",array);
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