//
//  SignInEntity.m
//  YHCustomer
//
//  Created by 白利伟 on 14/11/13.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "SignInEntity.h"

@implementation SignInEntity

@end

@implementation SignInNetTransObj
/*
-(BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if (![super requestFailed:request]) {
        return NO;
    }
    NSLog(@"request fail");
    if ([request isCancelled]) {
        NSLog(@"requset cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试!"];
    [[NetTrans getInstance]cancelRequest:self];
    return  YES;
}
-(BOOL)responseSuccess:(ASIHTTPRequest *)request
{
    if (![super responseSuccess:request]) {
        return NO;
    }
    NSData *myResponseData = [request responseData];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);
    NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    //    返回结果是以NSDictionary存在
    if (!jsonDic || (jsonDic == nil))
    {
        [[NetTrans getInstance]cancelRequest:self];
        [[iToast makeText:@"网络请求错误"] show];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_4 withMessage:@""];
        return NO;
    }
    NSMutableArray* datas = [jsonDic objectForKey:@"data"];
//    if([datas count] == 0)
//    {
//        if ([jsonDic valueForKey:@"total"]==0)
//        {
//            [[NetTrans getInstance]cancelRequest:self];
//            return YES;
//        }
//    }
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if (!status || (status == nil)||[status isEqualToString:@""])
    {
        [[NetTrans getInstance]cancelRequest:self];
        [[iToast makeText:@"网络请求错误"] show];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_4 withMessage:@""];
        return NO;
    }
    NSMutableArray *array = [NSMutableArray array];
    SignInEntity *entity = [[SignInEntity alloc]init];
    if([status isEqualToString:WEB_STATUS_1] )
    {
        //    遍历数组中的所有数组
        if ([datas count] == 0)
        {
            [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_4 withMessage:@""];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
        else
        {
            for (NSDictionary *dic in datas)
            {
                entity.is_sign = [dic objectForKey:@"is_sign"];
                entity.content = [dic objectForKey:@"content"];
                entity.date = [dic objectForKey:@"date"];
                entity.sign_record = [NSMutableArray array];
                NSMutableArray *bind_card_list = [NSMutableArray array];
                bind_card_list = [dic objectForKey:@"sign_record"];
                if (bind_card_list.count != 0)
                {
                    for (NSMutableDictionary *dic_bind_list in bind_card_list)
                    {
                        SignInEntity *entity2 = [[SignInEntity alloc]init];
                        entity2.year_month = [dic_bind_list objectForKey:@"year_month"];
                        entity2.sign_day = [dic_bind_list objectForKey:@"sign_day"];
                        [entity.sign_record addObject:entity2];
                    }
                }
            }
            [array addObject:entity];
        }
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:array nTag:self._nApiTag];
        }
    } else if ([status isEqualToString:WEB_STATUS_0]){
        NSLog(@"status %@",[jsonDic objectForKey:@"message"]);
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:[jsonDic objectForKey:@"message"]];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:[jsonDic objectForKey:@"message"]];
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
                     NSMutableArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         if ([datas count] > 0)
                         {
                             NSMutableArray *array = [NSMutableArray array];
                             SignInEntity *entity = [[SignInEntity alloc]init];
                             for (NSDictionary *dic in datas)
                             {
                                 entity.is_sign = [dic objectForKey:@"is_sign"];
                                 entity.content = [dic objectForKey:@"content"];
                                 entity.date = [dic objectForKey:@"date"];
                                 entity.sign_record = [NSMutableArray array];
                                 NSMutableArray *bind_card_list = [NSMutableArray array];
                                 bind_card_list = [dic objectForKey:@"sign_record"];
                                 if (bind_card_list.count != 0)
                                 {
                                     for (NSMutableDictionary *dic_bind_list in bind_card_list)
                                     {
                                         SignInEntity *entity2 = [[SignInEntity alloc]init];
                                         entity2.year_month = [dic_bind_list objectForKey:@"year_month"];
                                         entity2.sign_day = [dic_bind_list objectForKey:@"sign_day"];
                                         [entity.sign_record addObject:entity2];
                                     }
                                 }
                             }
                             [array addObject:entity];
                             [_uinet responseSuccessObj:array nTag:self._nApiTag];
                             return;

                         }
                         else
                         {
                             [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_4 withMessage:@""];
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
