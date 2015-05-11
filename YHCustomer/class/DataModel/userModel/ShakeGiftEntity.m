//
//  ShakeGiftEntity.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "ShakeGiftEntity.h"

@implementation ShakeGiftEntity

@synthesize name;
@synthesize image_url;
@synthesize address;
@synthesize start_time;
@synthesize end_time;
@synthesize money;
@synthesize type;
@synthesize code;
@synthesize object_id;

@end

@implementation ShakeGiftNetTrans

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
                     if (self._nApiTag == t_API_SHAKE)
                     {
                         NSDictionary* datas = [jsonObject objectForKey:@"data"];
                         if (!datas || (datas == nil))
                         {
                             //                        [[NetTrans getInstance] cancelRequest:self];
                             [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                             return ;
                         }
                         else
                         {
                             ShakeGiftEntity *useren = [[ShakeGiftEntity alloc] init];
                             useren.name = [datas valueForKey:@"name"];
                             useren.image_url = [datas valueForKey:@"image_url"];
                             useren.address = [datas valueForKey:@"address"];
                             useren.start_time = [datas valueForKey:@"start_time"];
                             useren.end_time = [datas valueForKey:@"end_time"];
                             useren.money = [datas valueForKey:@"money"];
                             useren.type = [datas valueForKey:@"type"];
                             useren.code = [datas valueForKey:@"code"];
                             useren.object_id = [datas valueForKey:@"id"];
                             useren.bu_id = [datas valueForKey:@"bu_id"];
                             useren.bu_logo = [datas valueForKey:@"bu_logo"];
                             useren.bu_name = [datas valueForKey:@"bu_name"];
                             useren.shake_id = [datas valueForKey:@"shake_id"];
                             useren.prize_id = [datas valueForKey:@"prize_id"];
                             [_uinet responseSuccessObj:useren nTag:self._nApiTag];
                             return;
                         }
                     }
                     else if ( self._nApiTag == t_API_SHAKE_CERTAIN)
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
                             NSMutableArray *arrRe = [NSMutableArray array];
                             for (NSDictionary *dataDic in datas)
                             {
                                 ShakeGiftEntity *useren = [[ShakeGiftEntity alloc] init];
                                 useren.code = [dataDic valueForKey:@"code"];
                                 [arrRe addObject:useren];
                             }
                             [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
                             return;
                         }

                     }
                     else
                     {
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if ([status isEqualToString:@"0"])
    {
        NSString *error = [jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:error];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    
    if (self._nApiTag == t_API_SHAKE)
    {
        //返回结果是以Dictionary存在
        NSDictionary* dataArray = [jsonDic objectForKey:@"data"];
        NSString *error = [jsonDic objectForKey:@"message"];
        NSLog(@"%@",error);
        if (dataArray) {
            //NSDictionary *dataDic = [dataArray objectAtIndex:0];
            // 数据处理s
            NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
            //        if([dataDic count] == 0){
            //            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            //            [[NetTrans getInstance] cancelRequest:self];
            //            return YES;
            //        }
            ShakeGiftEntity *useren = [[[ShakeGiftEntity alloc] init] autorelease];
            if([status isEqualToString:@"1"] )
            {
                useren.name = [dataArray valueForKey:@"name"];
                useren.image_url = [dataArray valueForKey:@"image_url"];
                useren.address = [dataArray valueForKey:@"address"];
                useren.start_time = [dataArray valueForKey:@"start_time"];
                useren.end_time = [dataArray valueForKey:@"end_time"];
                useren.money = [dataArray valueForKey:@"money"];
                useren.type = [dataArray valueForKey:@"type"];
                useren.code = [dataArray valueForKey:@"code"];
                useren.object_id = [dataArray valueForKey:@"id"];
                useren.bu_id = [dataArray valueForKey:@"bu_id"];
                useren.bu_logo = [dataArray valueForKey:@"bu_logo"];
                useren.bu_name = [dataArray valueForKey:@"bu_name"];
                useren.shake_id = [dataArray valueForKey:@"shake_id"];
                useren.prize_id = [dataArray valueForKey:@"prize_id"];
                
            }
            
            if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
            {
                [_uinet responseSuccessObj:useren nTag:self._nApiTag];
            }
        }
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else if( self._nApiTag == t_API_SHAKE_CERTAIN)
    {
        //返回结果是以Dictionary存在
        NSArray* datas = [jsonDic objectForKey:@"data"];
        if([datas count] == 0)
        {
            if ([jsonDic valueForKey:@"total"]==0)
            {
                [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
                [[NetTrans getInstance]cancelRequest:self];
                return YES;
            }
        }
        NSMutableArray *arrRe = [NSMutableArray array];
        NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
        if([status isEqualToString:WEB_STATUS_1] )
        {
            for (NSDictionary *dataDic in datas)
            {
                ShakeGiftEntity *useren = [[ShakeGiftEntity alloc] init];
                useren.code = [dataDic valueForKey:@"code"];
                [arrRe addObject:useren];
                [useren release];
            }
        }
        else
        {
            NSLog(@"status 10000 %@",[jsonDic objectForKey:@"message"]);
        }
 
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
        
    }
    else
    {
        return YES;
    }
}
*/
@end
