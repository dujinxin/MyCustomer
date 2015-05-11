
//
//  FeedBackListEntity.m
//  YHCustomer
//
//  Created by lichentao on 14-2-15.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "FeedBackListEntity.h"

@implementation FeedBackListEntity
@synthesize rep_add_time,add_time,content,rep_content,user_id;

@end

@implementation FeedBackListNetTransObj

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
                             NSMutableArray *array = [NSMutableArray array];
                             for (NSDictionary *dataDic in datas)
                             {
                                 FeedBackListEntity* entity = [[FeedBackListEntity alloc] init];
                                 
                                 if ([dataDic objectForKey:@"user_id"]) {
                                     entity.user_id = [dataDic valueForKey:@"user_id"];
                                 }
                                 
                                 if ([dataDic objectForKey:@"content"]) {
                                     entity.content = [dataDic valueForKey:@"content"];
                                 }
                                 
                                 if ([dataDic objectForKey:@"add_time"]) {
                                     NSString *addTime = [dataDic objectForKey:@"add_time"];
                                     entity.add_time = [NSString stringWithFormat:@"%@",addTime];
                                 }
                                 if ([dataDic objectForKey:@"reply_list"])
                                 {
                                     
                                     NSMutableArray *tmpArray =[dataDic objectForKey:@"reply_list"];
                                     if (tmpArray.count > 0)
                                     {
                                         NSDictionary *dic = [tmpArray objectAtIndex:0];
                                         entity.rep_add_time= [dic valueForKey:@"add_time"];
                                         entity.rep_content = [dic valueForKey:@"content"];
                                     }
                                 }
                                 [array addObject:entity];
                             }
//                                 [_uinet responseSuccess:array nTag:self._nApiTag];
                             [_uinet responseSuccessObj:array nTag:self._nApiTag];
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
    
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSArray* datas = [jsonDic objectForKey:@"data"];
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([datas count] == 0){
        if ([jsonDic valueForKey:@"total"]==0)
        {
            if ([status isEqualToString:WEB_STATUS_3])
            {
                [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"没有数据。"];
                [[NetTrans getInstance]cancelRequest:self];
                return YES;
            }
            else
            {
                [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
                [[NetTrans getInstance]cancelRequest:self];
                return YES;
            }
            
        }
    }
    
    
    NSMutableArray *array = [NSMutableArray array];
    
    if([status isEqualToString:WEB_STATUS_1] ){
        
        for (NSDictionary *dataDic in datas) {
            FeedBackListEntity* entity = [[FeedBackListEntity alloc] init];
            
            if ([dataDic objectForKey:@"user_id"]) {
                entity.user_id = [dataDic valueForKey:@"user_id"];
            }
            
            if ([dataDic objectForKey:@"content"]) {
                entity.content = [dataDic valueForKey:@"content"];
            }
            
            if ([dataDic objectForKey:@"add_time"]) {
                NSString *addTime = [dataDic objectForKey:@"add_time"];
                entity.add_time = [NSString stringWithFormat:@"%@",addTime];
            }
            if ([dataDic objectForKey:@"reply_list"]) {
                
                NSMutableArray *tmpArray =[dataDic objectForKey:@"reply_list"];
                if (tmpArray.count > 0) {
                    NSDictionary *dic = [tmpArray objectAtIndex:0];
                    entity.rep_add_time= [dic valueForKey:@"add_time"];
                    entity.rep_content = [dic valueForKey:@"content"];
                }
            }
            [array addObject:entity];
        }
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"没有数据。"];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSLog(@"status 10000 %@",[jsonDic objectForKey:@"message"]);
    }
 
    if ([_uinet respondsToSelector:@selector(responseSuccess:nTag:)])
    {
        [_uinet responseSuccess:array nTag:self._nApiTag];
    }
    
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}
 */
@end