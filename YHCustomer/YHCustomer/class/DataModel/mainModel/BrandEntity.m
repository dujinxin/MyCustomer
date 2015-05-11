//
//  BrandEntity.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "BrandEntity.h"

@implementation BrandEntity

@synthesize brand_name = _brand_name;
@synthesize letter = _letter;
@synthesize isSelected = _isSelected;

@end

@implementation BrandNetTrans
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
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray *hotArray = [NSMutableArray array];
    NSMutableArray *brandArray = [NSMutableArray array];
    if([status isEqualToString:WEB_STATUS_1] ){
        for (NSDictionary *dic in datas) {
            NSMutableArray * hot_brand_list = [dic objectForKey:@"hot_brand_list"];
            NSMutableArray * brand_list = [dic objectForKey:@"brand_list"];
            if (hot_brand_list.count != 0) {
                for (NSDictionary * d in hot_brand_list) {
                    BrandEntity * entity =[[BrandEntity alloc]init ];
                    entity.brand_name = [d objectForKey:@"brand_name"];
                    entity.bu_brand_id = [d objectForKey:@"bu_brand_id"];
                    [hotArray addObject:entity];
                    
                }
                [dict setValue:hotArray forKey:@"hot_brand_list"];
            }else{
                //
            }
            if(brand_list.count != 0){
                for (NSDictionary * d in brand_list) {
                    BrandEntity * entity =[[BrandEntity alloc]init ];
                    entity.brand_name = [d objectForKey:@"brand_name"];
                    entity.bu_brand_id = [d objectForKey:@"bu_brand_id"];
                    entity.letter = [d objectForKey:@"letter"];
                    entity.isSelected = NO;
                    [brandArray addObject:entity];
                }
                [dict setValue:brandArray forKey:@"brand_list"];
            }else{
                
            }
            
        }
        
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:dict nTag:self._nApiTag];
        }
    } else if ([status isEqualToString:WEB_STATUS_0]){
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
                             NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                             NSMutableArray *hotArray = [NSMutableArray array];
                             NSMutableArray *brandArray = [NSMutableArray array];
                             for (NSDictionary *dic in datas)
                             {
                                 NSMutableArray * hot_brand_list = [dic objectForKey:@"hot_brand_list"];
                                 NSMutableArray * brand_list = [dic objectForKey:@"brand_list"];
                                 if (hot_brand_list.count != 0)
                                 {
                                     for (NSDictionary * d in hot_brand_list)
                                     {
                                         BrandEntity * entity =[[BrandEntity alloc]init ];
                                         entity.brand_name = [d objectForKey:@"brand_name"];
                                         entity.bu_brand_id = [d objectForKey:@"bu_brand_id"];
                                         [hotArray addObject:entity];
                                         
                                     }
                                     [dict setValue:hotArray forKey:@"hot_brand_list"];
                                 }
                                 else
                                 {
                                     //
                                 }
                                 if(brand_list.count != 0)
                                 {
                                     for (NSDictionary * d in brand_list)
                                     {
                                         BrandEntity * entity =[[BrandEntity alloc]init ];
                                         entity.brand_name = [d objectForKey:@"brand_name"];
                                         entity.bu_brand_id = [d objectForKey:@"bu_brand_id"];
                                         entity.letter = [d objectForKey:@"letter"];
                                         entity.isSelected = NO;
                                         [brandArray addObject:entity];
                                     }
                                     [dict setValue:brandArray forKey:@"brand_list"];
                                 }
                                 else
                                 {
                                     
                                 }
                             }
                            [_uinet responseSuccessObj:dict nTag:self._nApiTag];
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
