//
//  GoodEntity.m
//  YHCustomer
//
//  Created by lichentao on 13-12-15.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  商品实体

#import "GoodsEntity.h"

@implementation GoodsEntity

@synthesize price,discount,discount_price,cart_id,goods_image,is_sell,pay_type,specifications;
@synthesize stock;
@synthesize bu_goods_id,goods_id;
@synthesize goodNum,goods_name,photo;
- (void)setGoodEntity:(NSDictionary *)goodDic{
    
    if ([goodDic objectForKey:@"price"]) {
        self.price = [goodDic objectForKey:@"price"];
    }
    if ([goodDic objectForKey:@"goods_num"]) {
        self.goodNum = [goodDic objectForKey:@"goods_num"];
    }
    if ([goodDic objectForKey:@"goods_name"]) {
        self.goods_name = [goodDic objectForKey:@"goods_name"];
    }
    if ([goodDic objectForKey:@"discount"]) {
        self.discount = [goodDic objectForKey:@"discount"];
    }
    if ([goodDic objectForKey:@"promotion"]) {
        self.discount_price = [goodDic objectForKey:@"promotion"];
    }
    if ([goodDic objectForKey:@"discount_price"]) {
        self.discount_price = [goodDic objectForKey:@"discount_price"];
    }
    if ([goodDic objectForKey:@"id"]) {
        self.cart_id = [goodDic objectForKey:@"id"];
    }
    if ([goodDic objectForKey:@"bu_goods_id"]) {
        self.bu_goods_id = [goodDic objectForKey:@"bu_goods_id"];
    }
    if ([goodDic objectForKey:@"bu_goods_code"]) {
        self.bu_goods_code = [goodDic objectForKey:@"bu_goods_code"];
    }
    if ([goodDic objectForKey:@"id"]) {
        self.goods_id = [goodDic objectForKey:@"id"];
    }
    if ([goodDic objectForKey:@"total"]) {
        self.goodNum = [goodDic objectForKey:@"total"];
    }
    if ([goodDic objectForKey:@"goods_image"]) {
        self.goods_image = [goodDic objectForKey:@"goods_image"];
    }
    if ([goodDic objectForKey:@"photo"]) {
        self.goods_image = [goodDic objectForKey:@"photo"];
    }
    if ([goodDic objectForKey:@"pay_type"]) {
        self.pay_type = [goodDic objectForKey:@"pay_type"];
    }
    if ([goodDic objectForKey:@"is_sell"]) {
        self.is_sell = [goodDic objectForKey:@"is_sell"];
    }
    if ([[goodDic objectForKey:@"specifications"] isKindOfClass:[NSArray class]]) {
        self.specifications = [NSMutableArray arrayWithArray:[goodDic objectForKey:@"specifications"]];
    }
    if ([goodDic objectForKey:@"stock"]) {
        self.stock = [goodDic objectForKey:@"stock"];
    }
    if ([goodDic objectForKey:@"out_of_stock"]) {
        self.out_of_stock = [goodDic objectForKey:@"out_of_stock"];
    }
    if ([goodDic objectForKey:@"transaction_type"]) {
        self.transaction_type = [goodDic objectForKey:@"transaction_type"];
    }
    if ([goodDic objectForKey:@"region_id"]) {
        self.region_id = [goodDic objectForKey:@"region_id"];
    }
    if ([goodDic objectForKey:@"region_name"]) {
        self.region_name = [goodDic objectForKey:@"region_name"];
    }
    if ([goodDic objectForKey:@"goods_weight"]) {
        self.goods_weight = [goodDic objectForKey:@"goods_weight"];
    }
    
    if ([goodDic objectForKey:@"date_time"]) {
        self.date_time = [goodDic objectForKey:@"date_time"];
    }
    if ([goodDic objectForKey:@"start_time"]) {
        self.start_time = [goodDic objectForKey:@"start_time"];
    }
    if ([goodDic objectForKey:@"end_time"]) {
        self.end_time = [goodDic objectForKey:@"end_time"];
    }
    if ([goodDic objectForKey:@"is_or_not_salse"]) {
        self.is_or_not_salse =[ goodDic objectForKey:@"is_or_not_salse"];
    }
    if ([goodDic objectForKey:@"limit_the_purchase_type"]) {
        self.limit_the_purchase_type = [goodDic objectForKey:@"limit_the_purchase_type"];
    }
    if ([goodDic objectForKey:@"goods_introduction"]) {
        self.goods_introduction = [goodDic objectForKey:@"goods_introduction"];
    }
}

// 将商品entity转换为NSDictionary
- (NSMutableDictionary *)convertGoodsEntityToDictionary{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.order_goods_id) {
        [dataDic setValue:self.order_goods_id forKey:@"order_goods_id"];
    }
    if (self.bu_goods_id) {
        [dataDic setValue:self.bu_goods_id forKey:@"bu_goods_id"];
    }
    if (self.bu_goods_code) {
        [dataDic setValue:self.bu_goods_code forKey:@"bu_goods_code"];
    }
    if (self.photo) {
        [dataDic setValue:self.photo forKey:@"photo"];
    }
    if (self.goods_image) {
        [dataDic setValue:self.goods_image forKey:@"photo"];
    }
    if (self.goods_name) {
        [dataDic setValue:self.goods_name forKey:@"goods_name"];
    }
    if (self.goodNum) {
        [dataDic setValue:self.goodNum forKey:@"goods_num"];
    }
    if (self.transaction_type)
    {
        [dataDic setValue:self.transaction_type forKey:@"transaction_type"];
    }
    return dataDic;
}
@end


@implementation GoodsListEntity
@synthesize goodsArray;
@synthesize total;
@synthesize active_info;

- (void)setGoodsListEntity:(NSMutableArray *)listArray{
    goodsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in listArray) {
        GoodsEntity *good = [[GoodsEntity alloc] init];
        [good setGoodEntity:dic];
        [self.goodsArray addObject:good];
    }
}

@end

@implementation GoodsListTrans:NetTransObj
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
     NSLog(@"request :%@",request.error.description);
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
    //    if([datas count] == 0){
    //        if ([jsonDic valueForKey:@"total"]==0) {
    //            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
    //            [[NetTrans getInstance]cancelRequest:self];
    //            return YES;
    //        }
    //    }
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    GoodsListEntity *goodsList = [[GoodsListEntity alloc] init];
    if([status isEqualToString:WEB_STATUS_1] ){
        goodsList.total = [jsonDic objectForKey:@"total"];
        [goodsList setGoodsListEntity:datas];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:[jsonDic objectForKey:@"message"]];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSLog(@"status 10000 %@",[jsonDic objectForKey:@"message"]);
    }
 
    if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
    {
        [_uinet responseSuccessObj:goodsList nTag:self._nApiTag];
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
         NSString * responseString;
         NSRange range1 = [base64String rangeOfString:@"\r\n"];
         NSRange range2 = [base64String rangeOfString:@"\n"];
         NSRange range3 = [base64String rangeOfString:@"\t"];
         if (range1.location != NSNotFound || range2.location != NSNotFound ||range3.location != NSNotFound) {
             NSLog(@"range1 = %@\n range2 = %@\n range3 = %@",NSStringFromRange(range1),NSStringFromRange(range2),NSStringFromRange(range3))
         }
//         base64String = [base64String stringByReplacingOccurrencesOfString : @"\r\n" withString : @"" ];
//         
//         base64String = [base64String stringByReplacingOccurrencesOfString : @"\n" withString : @"" ];
//         
//         base64String = [base64String stringByReplacingOccurrencesOfString : @"\t" withString : @"" ];
         
         NSLog(@"responseString = %@" ,responseString);
         NSLog(@"yesOrNo:%d",[NSJSONSerialization isValidJSONObject:responseObject] );
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];

//         id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//         id jsonObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
         
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
                             GoodsListEntity *goodsList = [[GoodsListEntity alloc] init];
                             goodsList.total = [jsonObject objectForKey:@"total"];
                             [goodsList setGoodsListEntity:datas];
                             [_uinet responseSuccessObj:goodsList nTag:self._nApiTag];
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
             NSLog(@"response error:%@ %@",[self class],error.localizedDescription);
             UIViewController * vc =(UIViewController *)_uinet;
             [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
         }
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


@implementation GoodsTrans
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
    NSDictionary *data = [jsonDic valueForKey:@"data"];

    GoodsEntity *entity = [[GoodsEntity alloc] init];

    entity.goods_name = [data objectForKey:@"goods_name"];
 
    
    if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
    {
        
        [_uinet responseSuccessObj:entity nTag:self._nApiTag];
        //消除持有对象。
        //[_uinet release];
    }
    
    [[NetTrans getInstance] cancelRequest:self];
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
                     NSDictionary* datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         GoodsEntity *entity = [[GoodsEntity alloc] init];
                         entity.goods_name = [datas objectForKey:@"goods_name"];
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

