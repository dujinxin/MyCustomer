//
//  ThemeEntity.m
//  YHCustomer
//
//  Created by dujinxin on 14-8-28.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "ThemeEntity.h"

@implementation ThemeEntity

@end

@implementation ThemeTransObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSError *error = request.error;
    [_uinet requestFailed:self._nApiTag withStatus:0 withMessage:[NSString stringWithString:[error description]]];
    [request cancel];
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
    
    //    NSLog(@"jsonre fren %@",myResponseStr);
    
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    NSDictionary *data = [jsonDic valueForKey:@"data"];
    NSMutableArray *arrRe = [NSMutableArray array];
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        for (NSDictionary *dataDic in data) {
            
            //返回结果是以Dictionary存在
            ThemeEntity *entity = [[ThemeEntity alloc] init];
            entity.show_type = [dataDic objectForKey:@"show_type"];
            entity.title = [dataDic objectForKey:@"title"];
            entity.image_url = [dataDic objectForKey:@"image_url"];
            entity.jump_type = [dataDic objectForKey:@"jump_type"];
            entity.jump_parametric = [dataDic objectForKey:@"jump_parametric"];
            [arrRe addObject:entity];
        }
    }
    else{
        NSLog(@"status 10000 %@",[jsonDic objectForKey:@"message"]);
    }
 
    if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
    {
        [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
    }
    
    [[NetTrans getInstance] cancelRequestByUI:self];
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
                         NSMutableArray *arrRe = [NSMutableArray array];
                         for (NSDictionary * d in datas)
                         {
                             [arrRe addObject:[d objectForKey:@"activitie_info"]];
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