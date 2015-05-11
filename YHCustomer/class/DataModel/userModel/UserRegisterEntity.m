//
//  UserRegisterEntity.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "UserRegisterEntity.h"

@implementation UserRegisterEntity
@synthesize cardStatus,message;
@end
@implementation UserRegisterTrans

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
                     NSDictionary* datas = [jsonObject objectForKey:@"data"];
//                     if (!datas || (datas == nil))
//                     {
//                         //                        [[NetTrans getInstance] cancelRequest:self];
//                         //[_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
//                         [_uinet responseSuccessObj:nil nTag:self._nApiTag];
//                         return ;
//                     }
//                     else
//                     {
                         NSString *cardStatus = [datas objectForKey:@"card_status"];
                         [_uinet responseSuccessObj:cardStatus nTag:self._nApiTag];
                         return;
//                     }
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
/*
-(BOOL)responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
    NSString * myResponseStr = [[[NSString alloc] initWithData:myResponseData encoding:enc] autorelease];
    
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    NSString *message = [jsonDic objectForKey:@"message"];
    
    if ([status isEqualToString:WEB_STATUS_1]) {
 
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            NSString *cardStatus = [[jsonDic objectForKey:@"data"] objectForKey:@"card_status"];
            [_uinet responseSuccessObj:cardStatus nTag:self._nApiTag];
        }
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
    }
    else{
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:message];
    }
    [[NetTrans getInstance] cancelRequest:self];
    return YES;
}
 成功返回*/
@end
