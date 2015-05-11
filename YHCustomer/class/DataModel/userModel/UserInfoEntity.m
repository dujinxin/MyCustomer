//
//  UserInfoEntity.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "UserInfoEntity.h"

@implementation UserInfoEntity
@synthesize mobile,email,gender,intro,photo_url,shoppingwall_url,true_name,user_id,user_name,login_user_name;
@end
@implementation UserInfoTrans

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
                         NSDictionary *dataDic = [datas objectAtIndex:0];
                         if([dataDic count] == 0)
                         {
                             [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
                             return;
                         }
                         UserInfoEntity *useren = [[UserInfoEntity alloc] init] ;
                         useren.user_id = [dataDic valueForKey:@"user_id"];
                         useren.user_name = [dataDic valueForKey:@"user_name"];
                         useren.login_user_name = [dataDic valueForKey:@"login_user_name"];
                         useren.mobile = [dataDic valueForKey:@"mobile"];
                         useren.email = [dataDic valueForKey:@"email"];
                         useren.intro = [dataDic valueForKey:@"intro"];
                         useren.true_name = [dataDic valueForKey:@"true_name"];
                         useren.gender = [dataDic valueForKey:@"gender"];
                         useren.shoppingwall_url = [dataDic valueForKey:@"shoppingwall_url"];
                         useren.photo_url = [dataDic valueForKey:@"photo_url"];
                         [_uinet responseSuccessObj:useren nTag:self._nApiTag];
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
    //返回结果是以Dictionary存在
    NSArray* dataArray = [jsonDic objectForKey:@"data"];
    NSString *error = [jsonDic objectForKey:@"message"];
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if ([status isEqualToString:WEB_STATUS_3]) {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"请先登录"];
        [[NetTrans getInstance] cancelRequest:self];
        return YES;
    }
    
    NSLog(@"%@",error);
    if (dataArray.count > 0) {
        NSDictionary *dataDic = [dataArray objectAtIndex:0];
        // 数据处理s
        if([dataDic count] == 0){
            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            [[NetTrans getInstance] cancelRequest:self];
            return YES;
        }
        UserInfoEntity *useren = [[[UserInfoEntity alloc] init] autorelease];
        if([status isEqualToString:@"1"] )
        {
            useren.user_id = [dataDic valueForKey:@"user_id"];
            useren.user_name = [dataDic valueForKey:@"user_name"];
            useren.mobile = [dataDic valueForKey:@"mobile"];
            useren.email = [dataDic valueForKey:@"email"];
            useren.intro = [dataDic valueForKey:@"intro"];
            useren.true_name = [dataDic valueForKey:@"true_name"];
            useren.gender = [dataDic valueForKey:@"gender"];
            useren.shoppingwall_url = [dataDic valueForKey:@"shoppingwall_url"];
            useren.photo_url = [dataDic valueForKey:@"photo_url"];
        }

        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:useren nTag:self._nApiTag];
        }
    }
    
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
    
}
*/

@end
