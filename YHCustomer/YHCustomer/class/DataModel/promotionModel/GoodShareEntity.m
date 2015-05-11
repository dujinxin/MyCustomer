//
//  GoodShareEntity.m
//  YHCustomer
//
//  Created by wangliang on 14-11-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "GoodShareEntity.h"

@implementation GoodShareEntity
@synthesize title = _title;
@synthesize page_url = _page_url;
@synthesize photo = _photo;
@synthesize download_url = _download_url;
@synthesize wx_content = _wx_content;
@synthesize sina_content = _sina_content;
@synthesize qr_code_content = _qr_code_content;
@synthesize qr_code_src = _qr_code_src;
@end
@implementation GoodShareObj
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
                         GoodShareEntity * entity = [[GoodShareEntity alloc]init ];
                         for (NSDictionary *dic in datas)
                         {
                             entity.title = [dic objectForKey:@"title"];
                             NSLog(@"%@",entity.title);
                             entity.page_url = [dic objectForKey:@"page_url"];
                             NSLog(@"%@",entity.page_url);
                             entity.photo = [dic objectForKey:@"photo"];
                             entity.download_url = [dic objectForKey:@"download_url"];
                             entity.wx_content = [dic objectForKey:@"wx_content"];
                             NSLog(@"%@",entity.wx_content);
                             entity.sina_content = [dic objectForKey:@"sina_content"];
                             NSLog(@"%@",entity.sina_content);
                             entity.qr_code_content = [dic objectForKey:@"qr_code_content"];
                             entity.qr_code_src = [dic objectForKey:@"qr_code_src"];
                             
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
             //            [_delegate torNetwork:self didFailLoadWithError:error];error.domain
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.domain]];
         }
         
     }];
    [operation start];
}


@end