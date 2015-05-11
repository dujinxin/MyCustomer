//
//  ShakeEntity.m
//  YHCustomer
//
//  Created by dujinxin on 14-11-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "ShakeEntity.h"

@implementation ShakeEntity

@synthesize activity_id = _activity_id;
@synthesize title = _title;
@synthesize _description = __description;
@synthesize background_image = _background_image;
@synthesize description_image = _description_image;
@synthesize intergral_exchange = _intergral_exchange;
@synthesize free_times = _free_times;
@synthesize total_shake = _total_shake;
@synthesize remanent_times = _remanent_times;
@synthesize total_score = _total_score;
@synthesize win_total = _win_total;
@synthesize share_title = _share_title;
@synthesize share_tip = _share_tip;
@synthesize share_num = _share_num;
@synthesize image_url = _image_url;
@synthesize page_url =_page_url;
@synthesize download_url = _download_url;

@end

@implementation ShakeObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
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
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSMutableArray * datas = [jsonDic objectForKey:@"data"];
    if([datas count] == 0){
        if ([jsonDic valueForKey:@"total"]==0) {
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
    }
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        ShakeEntity * entity = [[ShakeEntity alloc]init ];
        for (NSDictionary *dic in datas) {
            entity.activity_id = [dic objectForKey:@"activity_id"];
            entity.title = [dic objectForKey:@"title"];
            entity._description = [dic objectForKey:@"description"];
            entity.background_image = [dic objectForKey:@"background_image"];
            entity.description_image = [dic objectForKey:@"description_image"];
            entity.intergral_exchange = [dic objectForKey:@"intergral_exchange"];
            entity.free_times = [dic objectForKey:@"free_times"];
            entity.total_shake = [dic objectForKey:@"total_shake"];
            entity.remanent_times = [dic objectForKey:@"remanent_times"];
            entity.total_score = [dic objectForKey:@"total_score"];
            entity.win_total = [dic objectForKey:@"win_total"];
            entity.share_tip = [dic objectForKey:@"share_tip"];
            entity.share_title = [dic objectForKey:@"share_title"];
            entity.share_num = [dic objectForKey:@"share_num"];
            entity.image_url = [dic objectForKey:@"image_url"];
            entity.page_url = [dic objectForKey:@"page_url"];
            entity.download_url = [dic objectForKey:@"download_url"];
        }
 
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:entity nTag:self._nApiTag];
        }
    }else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else if ([status isEqualToString:WEB_STATUS_0]){
        NSLog(@"status %@",[jsonDic objectForKey:@"message"]);
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:[jsonDic objectForKey:@"message"]];
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
                     NSArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                             ShakeEntity * entity = [[ShakeEntity alloc]init ];
                             for (NSDictionary *dic in datas) {
                                 entity.activity_id = [dic objectForKey:@"activity_id"];
                                 entity.title = [dic objectForKey:@"title"];
                                 entity._description = [dic objectForKey:@"description"];
                                 entity.background_image = [dic objectForKey:@"background_image"];
                                 entity.description_image = [dic objectForKey:@"description_image"];
                                 entity.intergral_exchange = [dic objectForKey:@"intergral_exchange"];
                                 entity.free_times = [dic objectForKey:@"free_times"];
                                 entity.total_shake = [dic objectForKey:@"total_shake"];
                                 entity.remanent_times = [dic objectForKey:@"remanent_times"];
                                 entity.total_score = [dic objectForKey:@"total_score"];
                                 entity.win_total = [dic objectForKey:@"win_total"];
                                 entity.share_tip = [dic objectForKey:@"share_tip"];
                                 entity.share_title = [dic objectForKey:@"share_title"];
                                 entity.share_num = [dic objectForKey:@"share_num"];
                                 entity.image_url = [dic objectForKey:@"image_url"];
                                 entity.page_url = [dic objectForKey:@"page_url"];
                                 entity.download_url = [dic objectForKey:@"download_url"];
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
             //            [_delegate torNetwork:self didFailLoadWithError:error];
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
     }];
    [operation start];
}
@end
/*
 *中奖信息
 */
@implementation AwardEntity

@synthesize prize_type = _prize_type;
@synthesize prize_title = _prize_title;
@synthesize notice = _notice;
@synthesize recommend_goods = _recommend_goods;

@end

@implementation AwardObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
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
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    //返回结果是以Dictionary存在
    NSMutableArray * datas = [jsonDic objectForKey:@"data"];
//    if([datas count] == 0){
//        if ([jsonDic valueForKey:@"total"]==0) {
//            [[NetTrans getInstance]cancelRequest:self];
//            return YES;
//        }
//    }
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        AwardEntity * entity = [[AwardEntity alloc]init ];
        for (NSDictionary * dic in datas) {
            entity.prize_type = [dic objectForKey:@"prize_type"];
            entity.prize_title = [dic objectForKey:@"prize_title"];
            entity.notice = [dic objectForKey:@"notice"];
            if([dic objectForKey:@"recommend_goods"]){
                entity.recommend_goods = [dic objectForKey:@"recommend_goods"];
            }
            entity.share_title = [dic objectForKey:@"share_title"];
            entity.share_tip = [dic objectForKey:@"share_tip"];
            entity.image_url = [dic objectForKey:@"image_url"];
            entity.page_url = [dic objectForKey:@"page_url"];
            entity.download_url = [dic objectForKey:@"download_url"];
            entity.activity_id = [dic objectForKey:@"id"];
        }
        
 
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)]){
            [_uinet responseSuccessObj:entity nTag:self._nApiTag];
        }
    }else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }else if ([status isEqualToString:WEB_STATUS_0]){
        NSLog(@"status %@",[jsonDic objectForKey:@"message"]);
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:[jsonDic objectForKey:@"message"]];
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
                     NSArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         AwardEntity * entity = [[AwardEntity alloc]init ];
                         for (NSDictionary * dic in datas) {
                             entity.prize_type = [dic objectForKey:@"prize_type"];
                             entity.prize_title = [dic objectForKey:@"prize_title"];
                             entity.notice = [dic objectForKey:@"notice"];
                             if([dic objectForKey:@"recommend_goods"]){
                                 entity.recommend_goods = [dic objectForKey:@"recommend_goods"];
                             }
                             entity.share_title = [dic objectForKey:@"share_title"];
                             entity.share_tip = [dic objectForKey:@"share_tip"];
                             entity.image_url = [dic objectForKey:@"image_url"];
                             entity.page_url = [dic objectForKey:@"page_url"];
                             entity.download_url = [dic objectForKey:@"download_url"];
                             entity.activity_id = [dic objectForKey:@"id"];
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
             //            [_delegate torNetwork:self didFailLoadWithError:error];
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
     }];
    [operation start];
}
@end

@implementation AwardListEntity

@end

@implementation AwardListObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
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
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSMutableArray* datas = [jsonDic objectForKey:@"data"];
    if([datas count] == 0){
        if ([jsonDic valueForKey:@"total"]==0) {
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
    }
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    
    if([status isEqualToString:WEB_STATUS_1] ){
        AwardListEntity * entity = [[AwardListEntity alloc]init ];
        entity.awardArray = [[NSMutableArray alloc]initWithArray:datas];
        entity.total = [jsonDic valueForKey:@"total"];
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)]){
            [_uinet responseSuccessObj:entity nTag:self._nApiTag];
        }
    }else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }else if ([status isEqualToString:WEB_STATUS_0]){
        NSLog(@"status %@",[jsonDic objectForKey:@"message"]);
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:[jsonDic objectForKey:@"message"]];
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
                     NSArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                             AwardListEntity * entity = [[AwardListEntity alloc]init ];
                             entity.awardArray = [[NSMutableArray alloc]initWithArray:datas];
                             entity.total = [jsonObject valueForKey:@"total"];
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
             //            [_delegate torNetwork:self didFailLoadWithError:error];
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];         }
         
     }];
    [operation start];
}
@end
@implementation IntergralObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
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
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)]){
            [_uinet responseSuccessObj:nil nTag:self._nApiTag];
        }
    }else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }else if ([status isEqualToString:WEB_STATUS_0]){
        NSLog(@"status %@",[jsonDic objectForKey:@"message"]);
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:[jsonDic objectForKey:@"message"]];
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
    [serializedRequest setTimeoutInterval:10];
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
                     [_uinet responseSuccessObj:nil nTag:self._nApiTag];
                     return;
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


@implementation AddressEntity

@synthesize region_id = _region_id;
@synthesize region_name = _region_name;
@synthesize level = _level;
@synthesize province = _province;
@synthesize city = _city;
@synthesize area = _area;
@synthesize street = _street;
@synthesize provinceId = _provinceId;
@synthesize cityId = _cityId;
@synthesize areaId = _areaId;
@synthesize streetId = _streetId;
@synthesize name = _name;
@synthesize mobile = _mobile;
@synthesize detail = _detail;

@end

@implementation AddressObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
    
    NSLog(@"request fail");
    
    if([request isCancelled])
    {
        NSLog(@"request cancel");
    }
    [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:@"网络不给力，请稍后重试！"];
    [[NetTrans getInstance]cancelRequest:self];
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
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    //返回结果是以Dictionary存在
    NSMutableArray* datas = [jsonDic objectForKey:@"data"];
    if([datas count] == 0){
        if ([jsonDic valueForKey:@"total"]==0) {
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
    }
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];

    if([status isEqualToString:WEB_STATUS_1] ){
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)]){
            [_uinet responseSuccessObj:datas nTag:self._nApiTag];
        }
    }else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }else if ([status isEqualToString:WEB_STATUS_0]){
        NSLog(@"status %@",[jsonDic objectForKey:@"message"]);
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_0 withMessage:[jsonDic objectForKey:@"message"]];
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
                     NSArray* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {

                             [_uinet responseSuccessObj:datas nTag:self._nApiTag];
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
