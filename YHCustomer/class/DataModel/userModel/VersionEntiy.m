//
//  VersionEntiy.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "VersionEntiy.h"

@implementation VersionEntiy

@synthesize _id;
@synthesize _agent_id;
@synthesize _is_current;
@synthesize _url;
@synthesize _version;
@synthesize _version_name;
@synthesize force_update;
@synthesize version_caption = _version_caption;

@end

@implementation VersionTrans

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
                         if (datas.count > 0)
                         {
                             VersionEntiy *versionEn = [[VersionEntiy alloc] init];
                             NSDictionary *dataDic = [datas objectAtIndex:0];
                             versionEn._id = [dataDic valueForKey:@"id"];
                             versionEn._agent_id = [dataDic valueForKey:@"agent_id"];
                             versionEn._is_current = [dataDic valueForKey:@"is_current"];
                             versionEn._url = [dataDic valueForKey:@"url"];
                             versionEn._version = [dataDic valueForKey:@"version_code"];
                             versionEn._version_name = [dataDic valueForKey:@"version_name"];
                             versionEn.force_update = [dataDic valueForKey:@"force_update"];
                             versionEn.version_caption = [dataDic objectForKey:@"version_caption"];
                             [_uinet responseSuccessObj:versionEn nTag:self._nApiTag];
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
/*
-(BOOL) responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
    NSString * myResponseStr = [[[NSString alloc] initWithData:myResponseData encoding:enc] autorelease];
    
    
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    //    NSLog(@"jsonre fren %@",jsonDic);
    
    //返回结果是以Dictionary存在
    NSArray* datas = [jsonDic objectForKey:@"data"];
    if([datas count] == 0){
        //  if ([jsonDic valueForKey:@"total"]==0) {
        [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
        // }
    }
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1]){
        if (datas.count > 0)
        {
            NSDictionary *dataDic = [datas objectAtIndex:0];
            VersionEntiy *versionEn = [[[VersionEntiy alloc] init] autorelease];
            
            versionEn._id = [dataDic valueForKey:@"id"];
            versionEn._agent_id = [dataDic valueForKey:@"agent_id"];
            versionEn._is_current = [dataDic valueForKey:@"is_current"];
            versionEn._url = [dataDic valueForKey:@"url"];
            versionEn._version = [dataDic valueForKey:@"version_code"];
            versionEn._version_name = [dataDic valueForKey:@"version_name"];
            versionEn.force_update = [dataDic valueForKey:@"force_update"];
            versionEn.version_caption = [dataDic objectForKey:@"version_caption"];
 
            if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
            {
                [_uinet responseSuccessObj:versionEn nTag:self._nApiTag];
            }
        }
    }else{
        NSString *message = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"message"]];
        
        [_uinet requestFailed:self._nApiTag withStatus:status withMessage:message];
    }
    
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}
*/
@end
