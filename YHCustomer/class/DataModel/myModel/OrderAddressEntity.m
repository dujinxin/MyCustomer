//
//  OrderAddressEntity.m
//  THCustomer
//
//  Created by ioswang on 13-9-30.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "OrderAddressEntity.h"

@implementation OrderAddressEntity
@synthesize ID;
@synthesize true_name;
@synthesize mobile;
@synthesize telephone;
@synthesize zip_code;
@synthesize logistics_area;
@synthesize logistics_address;
@synthesize is_default;
@synthesize logistics_area_name;
@synthesize logistics_area_list;

- (NSMutableDictionary *)convertAddressEntityToDictionary
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.ID) {
        [dataDic setValue:self.ID forKey:@"id"];
    }
    if (self.true_name) {
        [dataDic setValue:self.true_name forKey:@"true_name"];
    }
    if (self.mobile) {
        [dataDic setValue:self.mobile forKey:@"mobile"];
    }
    if (self.telephone) {
        [dataDic setValue:self.telephone forKey:@"telephone"];
    }
    if (self.zip_code) {
        [dataDic setValue:self.zip_code forKey:@"zip_code"];
    }
    if (self.logistics_area) {
        [dataDic setValue:self.logistics_area forKey:@"logistics_area"];
    }
    if (self.logistics_address) {
        [dataDic setValue:self.logistics_address forKey:@"logistics_address"];
    }
    if (self.logistics_area_name) {
        [dataDic setValue:self.logistics_area_name forKey:@"logistics_area_name"];
    }
    if (self.logistics_area_list) {
        [dataDic setValue:self.logistics_area_list forKey:@"logistics_area_list"];
    }
    if (self.is_default) {
        [dataDic setValue:[NSNumber numberWithBool:self.is_default] forKey:@"is_default"];
    }
    //517
    if (self.province_code){
        [dataDic setValue:self.bu_code forKey:@"province_code"];
    }
    if (self.province_name){
        [dataDic setValue:self.bu_code forKey:@"province_name"];
    }
    if (self.city_code){
        [dataDic setValue:self.bu_code forKey:@"city_code"];
    }
    if (self.city_name){
        [dataDic setValue:self.bu_code forKey:@"city_name"];
    }
    if (self.area_code){
        [dataDic setValue:self.bu_code forKey:@"area_code"];
    }
    if (self.area_name){
        [dataDic setValue:self.bu_code forKey:@"area_name"];
    }
    if (self.street_code){
        [dataDic setValue:self.bu_code forKey:@"street_code"];
    }
    if (self.street_name){
        [dataDic setValue:self.bu_code forKey:@"street_name"];
    }
    if (self.bu_code){
        [dataDic setValue:self.bu_code forKey:@"bu_code"];
    }

    return dataDic;
}

@end

@implementation OrderAddressNetTransObj

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
    if (error != nil)
    {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
        {
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
         NSString * responseString;
         NSRange range1 = [base64String rangeOfString:@"\r\n"];
         NSRange range2 = [base64String rangeOfString:@"\n"];
         NSRange range3 = [base64String rangeOfString:@"\t"];
         if (range1.location != NSNotFound || range2.location != NSNotFound ||range3.location != NSNotFound) {
             NSLog(@"range1 = %@\n range2 = %@\n range3 = %@",NSStringFromRange(range1),NSStringFromRange(range2),NSStringFromRange(range3))
         }
         
         NSLog(@"yesOrNo:%d",[NSJSONSerialization isValidJSONObject:responseObject] );
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
                     NSArray * datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *arrRe = [NSMutableArray array];
                         if ([datas count] > 0)
                         {
                             for (NSDictionary *dataDic in datas)
                             {
                                 OrderAddressEntity*coudEn = [[OrderAddressEntity alloc] init];
                                 coudEn.ID = [dataDic valueForKey:@"id"];
                                 coudEn.true_name = [dataDic valueForKey:@"true_name"];
                                 coudEn.mobile = [dataDic valueForKey:@"mobile"];
                                 coudEn.telephone = [dataDic valueForKey:@"telephone"];
                                 coudEn.zip_code = [dataDic valueForKey:@"zip_code"];
                                 coudEn.logistics_area = [dataDic valueForKey:@"logistics_area"];
                                 coudEn.logistics_address = [dataDic valueForKey:@"logistics_address"];
                                 coudEn.logistics_area_name = [dataDic valueForKey:@"logistics_area_name"];
                                 coudEn.logistics_area_list =[dataDic valueForKey:@"logistics_area_list"];
                                 NSString *isdefault = [dataDic valueForKey:@"is_default"];
                                 coudEn.is_default = [isdefault isEqualToString:@"1"]?YES:NO;
                                 //517
                                 coudEn.province_code = [dataDic valueForKey:@"province_code"];
                                 coudEn.province_name = [dataDic valueForKey:@"province_name"];
                                 coudEn.city_code = [dataDic valueForKey:@"city_code"];
                                 coudEn.city_name = [dataDic valueForKey:@"city_name"];
                                 coudEn.area_code = [dataDic valueForKey:@"area_code"];
                                 coudEn.area_name = [dataDic valueForKey:@"area_name"];
                                 coudEn.street_code = [dataDic valueForKey:@"street_code"];
                                 coudEn.street_name = [dataDic valueForKey:@"street_name"];
                                 coudEn.bu_code = [dataDic valueForKey:@"bu_code"];
                                 [arrRe addObject:coudEn];
                             }
                             
                             [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
                             return;
                         }else{
                             [_uinet responseSuccessObj:arrRe nTag:self._nApiTag];
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


@implementation AddressAreaObj

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
                     NSArray * datas = [jsonObject objectForKey:@"data"];
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



@implementation NewAddressEntity

@end

@implementation NewAddressObj

-(void)request:(NSString *)request andDic:(NSDictionary *)dic{
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
    if (error != nil)
    {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
        {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"错误请求！"];
        }
    }
    [serializedRequest setTimeoutInterval:OUTTIME];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:serializedRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *base64String = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         
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
             NSString *status = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"status"]];
             NSString * message = [jsonObject objectForKey:@"message"];
             
             if ([status isEqualToString:@"0"])
             {
                 [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:message];
             }
             else if ([status isEqualToString:@"1"])
             {
                 NSDictionary * dataDic = [jsonObject objectForKey:@"data"];
                 if (!dataDic || (dataDic == nil) || dataDic.count == 0)
                 {
                     [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"库存门店切换失败"];
                     return ;
                 }
                 else
                 {
                     NewAddressEntity *newAddress = [[NewAddressEntity alloc] init];
                         //517
                     newAddress.province_code = [dataDic valueForKey:@"province_code"];
                     newAddress.province_name = [dataDic valueForKey:@"province_name"];
                     newAddress.city_code = [dataDic valueForKey:@"city_code"];
                     newAddress.city_name = [dataDic valueForKey:@"city_name"];
                     newAddress.area_code = [dataDic valueForKey:@"area_code"];
                     newAddress.area_name = [dataDic valueForKey:@"area_name"];
                     newAddress.street_code = [dataDic valueForKey:@"street_code"];
                     newAddress.street_name = [dataDic valueForKey:@"street_name"];
                     newAddress.bu_code = [dataDic valueForKey:@"bu_code"];
                     
                     [_uinet responseSuccessObj:newAddress nTag:self._nApiTag];
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