//
//  OrderEntity.m
//  THCustomer
//
//  Created by lichentao on 13-8-29.
//  Copyright (c) 2013年 efuture. All rights reserved.
//


#import "OrderEntity.h"
#import "GoodsEntity.h"

@implementation OrderSubmitEntity
@synthesize order_list_no,bu_name,address,tel,goods_count,total_amount,order_list_id,order_id;
@synthesize order_Status;
@end

@implementation GoodList
@synthesize coupon,goods_amount,goodsArray;
@synthesize couponArray;
//- (void)dealloc{
//    [goodsArray         release];
//    [coupon             release];
//    [goods_amount       release];
//    [couponArray        release];
//    [super dealloc];
//}

- (void)setGoodListEntity:(NSDictionary *)dic{
    if ([dic objectForKey:@"goods"]) {

        goodsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic1 in [dic objectForKey:@"goods"]) {
            GoodsEntity *goods = [[GoodsEntity alloc] init];
            [goods setGoodEntity:dic1];
            [self.goodsArray addObject:goods];
        }
    }
    if ([dic objectForKey:@"coupon_list"]) {
        couponArray = [[NSMutableArray alloc] init];
        self.couponArray = [dic objectForKey:@"coupon_list"];
    }
    if ([dic objectForKey:@"coupon"]) {
        self.coupon = [dic objectForKey:@"coupon"];
    }
    if ([dic objectForKey:@"goods_amount"]) {
        self.goods_amount = [dic objectForKey:@"goods_amount"];
    }
}

@end

// 我的订单
@implementation MyOrderEntity
@synthesize orderArray,order_id,orderInfo,orderStatus,totalAmount;
@synthesize order_list_no,pay_method,pay_status,is_handsel,order_type;
@synthesize pay_method_name,delivery_id,create_date;
@synthesize order_list_id;
- (void)setMyOrderEntity:(NSDictionary *)dic{
    
    if ([dic objectForKey:@"order_id"]) {
        self.order_id = [dic objectForKey:@"order_id"];
    }
    if ([dic objectForKey:@"id"]) {
        self.order_list_id = [dic objectForKey:@"id"];
    }
    if ([dic objectForKey:@"orderInfo"]) {
        self.orderInfo = [dic objectForKey:@"orderInfo"];
    }
    if ([dic objectForKey:@"total_state_str"]) {
        self.orderStatus = [dic objectForKey:@"total_state_str"];
    }
    if ([dic objectForKey:@"msg"]) {
        self.msg = [dic objectForKey:@"msg"];
    }
    if ([dic objectForKey:@"total_amount"]) {
        self.totalAmount = [dic objectForKey:@"total_amount"];
    }
    if ([dic objectForKey:@"is_handsel"]) {
        self.is_handsel = [dic objectForKey:@"is_handsel"];
    }
    if ([dic objectForKey:@"order_list_no"]) {
        self.order_list_no = [dic objectForKey:@"order_list_no"];
    }
    if ([dic objectForKey:@"pay_method"]) {
        self.pay_method = [dic objectForKey:@"pay_method"];
    }
    if ([dic objectForKey:@"total_state"]) {
        id total_state = [dic objectForKey:@"total_state"];
        if ([total_state isKindOfClass:[NSNumber class]]) {
            self.total_state = [total_state stringValue];
        } else if ([total_state isKindOfClass:[NSString class]]) {
            self.total_state = total_state;
        }
    }
    if ([dic objectForKey:@"pay_status"]) {
        self.pay_status = [dic objectForKey:@"pay_status"];
        NSLog(@"%@",self.pay_status);
    }
    if ([dic objectForKey:@"pay_status_name"]) {
        self.pay_status_name = [dic objectForKey:@"pay_status_name"];
    }
    if ([dic objectForKey:@"region_id"]) {
        self.region_id = [dic objectForKey:@"region_id"];
    }
    if ([dic objectForKey:@"order_type"]) {
        self.order_type = [dic objectForKey:@"order_type"];
    }
    if ([dic objectForKey:@"delivery_id"]) {
        id del_id = [dic objectForKey:@"delivery_id"];
        if ([del_id isKindOfClass:[NSNumber class]]) {
            self.delivery_id = [del_id stringValue];
        } else if ([del_id isKindOfClass:[NSString class]]) {
            self.delivery_id = del_id;
        }
    }
    if ([dic objectForKey:@"pay_method_name"]) {
        self.pay_method_name = [dic objectForKey:@"pay_method_name"];
    }
    if ([dic objectForKey:@"create_date"]) {
        self.create_date = [dic objectForKey:@"create_date"];
    }
    if ([dic objectForKey:@"total_state_name"]) {
        self.total_state_name = [dic objectForKey:@"total_state_name"];
    }
    if ([dic objectForKey:@"transaction_type"]) {
        self.transaction_type = [dic objectForKey:@"transaction_type"];
    }

    // 订单商品
    if ([dic objectForKey:@"goods"]) {
        NSMutableArray *array = [dic objectForKey:@"goods"];
        orderArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            GoodsEntity *goodsEntity = [[GoodsEntity alloc] init];
            [goodsEntity setGoodEntity:dic];
            [orderArray addObject:goodsEntity];
        }
    }
    
    // 退货商品
    if ([dic objectForKey:@"return_goods"]) {
        NSMutableArray *array = [dic objectForKey:@"return_goods"];
        orderArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            GoodsEntity *goodsEntity = [[GoodsEntity alloc] init];
            [goodsEntity setGoodEntity:dic];
            [orderArray addObject:goodsEntity];
        }
    }
}

@end


@implementation ReturnOrderEntity
@synthesize sales_return_no,sdate,retamt,total_state_str,returns_method;
@synthesize apply_type,returnsImagesArray;
@synthesize carry_or_not,region_id;
@synthesize pay_method_str;

- (void)setReturnOrderEntity:(NSDictionary *)dic{
    if ([dic objectForKey:@"order_id"]) {
        self.order_id = [dic objectForKey:@"order_id"];
    }
    if ([dic objectForKey:@"id"]) {
        self.order_list_id = [dic objectForKey:@"id"];
    }
    if ([dic objectForKey:@"orderInfo"]) {
        self.orderInfo = [dic objectForKey:@"orderInfo"];
    }
    if ([dic objectForKey:@"total_state_str"]) {
        self.orderStatus = [dic objectForKey:@"total_state_str"];
    }
    if ([dic objectForKey:@"how_to_apply_str"]) {

        self.how_to_apply_str = [dic objectForKey:@"how_to_apply_str"];
    }
    if ([dic objectForKey:@"msg"]) {
        self.msg = [dic objectForKey:@"msg"];
    }
    if ([dic objectForKey:@"returns_name"]) {
        self.returns_name = [dic objectForKey:@"returns_name"];
    }
    if ([dic objectForKey:@"total_amount"]) {
        self.totalAmount = [dic objectForKey:@"total_amount"];
    }
    if ([dic objectForKey:@"is_handsel"]) {
        self.is_handsel = [dic objectForKey:@"is_handsel"];
    }
    if ([dic objectForKey:@"order_list_no"]) {
        self.order_list_no = [dic objectForKey:@"order_list_no"];
    }
    if ([dic objectForKey:@"pay_method"]) {
        self.pay_method = [dic objectForKey:@"pay_method"];
    }
    if ([dic objectForKey:@"total_state"]) {
        self.total_state = [dic objectForKey:@"total_state"];
    }
    if ([dic objectForKey:@"pay_status"]) {
        self.pay_status = [dic objectForKey:@"pay_status"];
    }
    if ([dic objectForKey:@"pay_status_name"]) {
        self.pay_status_name = [dic objectForKey:@"pay_status_name"];
    }
    if ([dic objectForKey:@"order_type"]) {
        self.order_type = [dic objectForKey:@"order_type"];
    }
    if ([dic objectForKey:@"returns_method"]) {
        self.returns_method = [dic objectForKey:@"returns_method"];
    }
    if ([dic objectForKey:@"returns_reason_info"]) {
        self.returns_reason_info = [dic objectForKey:@"returns_reason_info"];
    }
    if ([dic objectForKey:@"returns_reason_explanation"]) {
        self.returns_reason_explanation = [dic objectForKey:@"returns_reason_explanation"];
    }
    if ([dic objectForKey:@"returns_account"]) {
        self.returns_account = [dic objectForKey:@"returns_account"];
    }
    if ([dic objectForKey:@"returns_card_num"]) {
        self.returns_card_num = [dic objectForKey:@"returns_card_num"];
    }
    if ([dic objectForKey:@"returns_method_a"]) {
        self.returns_method_a = [dic objectForKey:@"returns_method_a"];
    }
    if ([dic objectForKey:@"returns_method_b"]) {
        self.returns_method_b = [dic objectForKey:@"returns_method_b"];
    }
    if ([dic objectForKey:@"returns_method_c"]) {
        self.returns_method_c = [dic objectForKey:@"returns_method_c"];
    }
    if ([dic objectForKey:@"returns_method_d"]) {
        self.returns_method_d = [dic objectForKey:@"returns_method_d"];
    }
    if ([dic objectForKey:@"returns_method_e"]) {
        self.returns_method_e = [dic objectForKey:@"returns_method_e"];
    }
    if ([dic objectForKey:@"returns_method_f"]) {
        self.returns_method_f = [dic objectForKey:@"returns_method_f"];
    }
    if ([dic objectForKey:@"returns_method_g"]) {
        self.returns_method_g = [dic objectForKey:@"returns_method_g"];
    }
    if ([dic objectForKey:@"apply_retamt"]) {
        self.apply_retamt = [dic objectForKey:@"apply_retamt"];
    }
    if ([dic objectForKey:@"returns_logistics_amount"]) {
        self.returns_logistics_amount = [dic objectForKey:@"returns_logistics_amount"];
    }
    if ([dic objectForKey:@"fc_amt"]) {
        self.fc_amt = [dic objectForKey:@"fc_amt"];
    }
    
    if ([dic objectForKey:@"carry_or_not"]) {
        self.carry_or_not = [dic objectForKey:@"carry_or_not"];
    }
    if ([dic objectForKey:@"delivery_id"]) {
        id del_id = [dic objectForKey:@"delivery_id"];
        if ([del_id isKindOfClass:[NSNumber class]]) {
            self.delivery_id = [del_id stringValue];
        } else if ([del_id isKindOfClass:[NSString class]]) {
            self.delivery_id = del_id;
        }
    }
    if ([dic objectForKey:@"pay_method_name"]) {
        self.pay_method_name = [dic objectForKey:@"pay_method_name"];
    }
    if ([dic objectForKey:@"create_date"]) {
        self.create_date = [dic objectForKey:@"create_date"];
    }
    if ([dic objectForKey:@"total_state_name"]) {
        self.total_state_name = [dic objectForKey:@"total_state_name"];
    }
    if ([dic objectForKey:@"sales_return_id"]) {
        self.sales_return_id = [dic objectForKey:@"sales_return_id"];
    }
    if ([dic objectForKey:@"sales_return_no"]) {
        self.sales_return_no = [dic objectForKey:@"sales_return_no"];
    }
    if ([dic objectForKey:@"sdate"]) {
        self.sdate = [dic objectForKey:@"sdate"];
    }
    if ([dic objectForKey:@"retamt"]) {
        self.retamt = [dic objectForKey:@"retamt"];
    }
    if ([dic objectForKey:@"total_state_str"]) {
        NSLog(@"total_state_str = %@" , [dic objectForKey:@"total_state_str"]);
        self.total_state_str = [dic objectForKey:@"total_state_str"];
    }
    if ([dic objectForKey:@"returns_reason_id"]) {
        self.returns_reason_id = [dic objectForKey:@"returns_reason_id"];
    }
    if ([dic objectForKey:@"returns_reject_info"]) {
        self.returns_reject_info = [dic objectForKey:@"returns_reject_info"];
    }
    if ([dic objectForKey:@"pay_method_str"])
    {
        self.pay_method_str = [dic objectForKey:@"pay_method_str"];
    }
    if ([dic objectForKey:@"apply_type"])
    {
        id app_type = [dic objectForKey:@"apply_type"];
        if ([app_type isKindOfClass:[NSNumber class]]) {
            self.apply_type = [app_type stringValue];
        } else if ([app_type isKindOfClass:[NSString class]]) {
            self.apply_type = app_type;
        }
    }
    
    // 退货商品－退货申请
    if ([dic objectForKey:@"goods"])
    {
        NSMutableArray *array = [dic objectForKey:@"goods"];
        self.orderArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array)
        {
            GoodsEntity *goodsEntity = [[GoodsEntity alloc] init];
            [goodsEntity setGoodEntity:dic];
            [self.orderArray addObject:goodsEntity];
        }
    }
    // 退货商品
    if ([dic objectForKey:@"return_goods"])
    {
        NSMutableArray *array = [dic objectForKey:@"return_goods"];
        self.orderArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array)
        {
            GoodsEntity *goodsEntity = [[GoodsEntity alloc] init];
            [goodsEntity setGoodEntity:dic];
            [self.orderArray addObject:goodsEntity];
        }
    }
    // 退货商品图片数组
    if ([dic objectForKey:@"returns_goods_images"]) {
        NSMutableArray *imageArray = [dic objectForKey:@"returns_goods_images"];
        returnsImagesArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in imageArray) {
            GoodsEntity *goodsEntity = [[GoodsEntity alloc] init];
            [goodsEntity setGoodEntity:dic];
            [self.returnsImagesArray addObject:goodsEntity];
        }
    }
    
    if ([dic objectForKey:@"region_id"]) {
        self.region_id = [dic objectForKey:@"region_id"];
    }
}
@end


#pragma -mark
#pragma ------------------------------------------------提交订单
@implementation OrderTransObj
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

-(BOOL) responseSuccess:(ASIHTTPRequest *)request
 {
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSArray *array = [jsonDic objectForKey:@"data"];
        OrderSubmitEntity *entity = [[OrderSubmitEntity alloc]init];
        if ([array count]>0) {
            NSMutableDictionary *data = [array objectAtIndex:0];
            entity.goods_num = [data objectForKey:@"goods_num"];
            entity.coupon_num = [data objectForKey:@"coupon_num"];
            entity.goods_amount = [data objectForKey:@"goods_amount"];
            entity.logistics_amount = [data objectForKey:@"logistics_amount"];
            entity.coupon_amount = [data objectForKey:@"coupon_amount"];
            entity.total_amount = [data objectForKey:@"total_amount"];
            entity.goods_weight = [data objectForKey:@"goods_weight"];
        }else {
            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
 
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:entity nTag:self._nApiTag];
        }
        
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
             
             NSString *status = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"status"]];
             NSString * message = [jsonObject objectForKey:@"message"];
             
             if ([status isEqualToString:@"0"])
             {
                 [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:message];
                 return;
             }else if ([status isEqualToString:@"2"]){
                 [_uinet requestFailed:_nApiTag withStatus:@"2" withMessage:message];
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
                         OrderSubmitEntity *entity = [[OrderSubmitEntity alloc]init];
                         NSMutableDictionary *data = [datas objectAtIndex:0];
                         entity.goods_num = [data objectForKey:@"goods_num"];
                         entity.coupon_num = [data objectForKey:@"coupon_num"];
                         entity.goods_amount = [data objectForKey:@"goods_amount"];
                         entity.logistics_amount = [data objectForKey:@"logistics_amount"];
                         entity.coupon_amount = [data objectForKey:@"coupon_amount"];
                         entity.total_amount = [data objectForKey:@"total_amount"];
                         entity.goods_weight = [data objectForKey:@"goods_weight"];
                         [_uinet responseSuccessObj:entity nTag:self._nApiTag];
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
         else
         {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];
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

#pragma -mark
#pragma ------------------------------------------------订单详情

// 订单详情
@implementation OrderDetailNettransObj
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

-(BOOL) responseSuccess:(ASIHTTPRequest *)request
 {
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
	NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSDictionary *dic = [jsonDic objectForKey:@"data"];
        
        OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
        submitEntity.order_list_no = [dic objectForKey:@"order_list_no"];
        submitEntity.bu_name = [dic objectForKey:@"bu_name"];
        submitEntity.address = [dic objectForKey:@"address"];
        submitEntity.tel = [dic objectForKey:@"tel"];
        submitEntity.goods_count = [dic objectForKey:@"goods_count"];
        submitEntity.total_amount = [dic objectForKey:@"total_amount"];
        submitEntity.goods_amount = [dic objectForKey:@"goods_amount"];
        submitEntity.coupon_amount = [dic objectForKey:@"coupon_amount"];
        id coupon_num = [dic objectForKey:@"coupon_num"];
        if ([coupon_num isKindOfClass:[NSNumber class]]) {
            submitEntity.coupon_num = [coupon_num stringValue];
        } else if ([coupon_num isKindOfClass:[NSString class]]) {
            submitEntity.coupon_num = coupon_num;
        }

        if ([dic objectForKey:@"id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"id"];
        }
        if ([dic objectForKey:@"order_list_id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"order_list_id"];
        }
        submitEntity.order_Status = [dic objectForKey:@"total_state_str"];
        
        if ([dic objectForKey:@"coupon_list"]) {
            NSMutableArray *couponArray = (NSMutableArray *)[dic objectForKey:@"coupon_list"];
            submitEntity.couponList = couponArray;
        }

        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
        }
        
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
//             if (_uinet && [_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
//             {
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
                     OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
                     submitEntity.order_list_no = [datas objectForKey:@"order_list_no"];
                     submitEntity.bu_name = [datas objectForKey:@"bu_name"];
                     submitEntity.address = [datas objectForKey:@"address"];
                     submitEntity.tel = [datas objectForKey:@"tel"];
                     submitEntity.goods_count = [datas objectForKey:@"goods_count"];
                     submitEntity.total_amount = [datas objectForKey:@"total_amount"];
                     submitEntity.goods_amount = [datas objectForKey:@"goods_amount"];
                     submitEntity.coupon_amount = [datas objectForKey:@"coupon_amount"];
                     id coupon_num = [datas objectForKey:@"coupon_num"];
                     if ([coupon_num isKindOfClass:[NSNumber class]]) {
                         submitEntity.coupon_num = [coupon_num stringValue];
                     } else if ([coupon_num isKindOfClass:[NSString class]]) {
                         submitEntity.coupon_num = coupon_num;
                     }
                     
                     if ([datas objectForKey:@"id"]) {
                         submitEntity.order_list_id = [dic objectForKey:@"id"];
                     }
                     if ([datas objectForKey:@"order_list_id"]) {
                         submitEntity.order_list_id = [datas objectForKey:@"order_list_id"];
                     }
                     submitEntity.order_Status = [datas objectForKey:@"total_state_str"];
                     
                     if ([datas objectForKey:@"coupon_list"]) {
                         NSMutableArray *couponArray = (NSMutableArray *)[datas objectForKey:@"coupon_list"];
                         submitEntity.couponList = couponArray;
                     }
                     
                     if ([datas objectForKey:@"update_apps_local_file_array"]) {
                         submitEntity.deliveryDict = (NSMutableDictionary *)[datas objectForKey:@"update_apps_local_file_array"];
                     }
                     [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
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
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];
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
#pragma - mark -------------------用于支付页面的订单详情
@implementation AppOrderDetailObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request{
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
- (BOOL)responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
    NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSMutableArray * array = [jsonDic objectForKey:@"data"];
        NSDictionary * dic = [array firstObject];
        OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
        submitEntity.order_list_no = [dic objectForKey:@"order_list_no"];
        submitEntity.bu_name = [dic objectForKey:@"bu_name"];
        submitEntity.address = [dic objectForKey:@"bu_address"];
//        submitEntity.tel = [dic objectForKey:@"tel"];
        submitEntity.goods_count = [dic objectForKey:@"goods_num"];
        submitEntity.total_amount = [dic objectForKey:@"total_amount"];
        submitEntity.goods_amount = [dic objectForKey:@"goods_amount"];
//        submitEntity.coupon_amount = [dic objectForKey:@"coupon_amount"];
        submitEntity.lm_title = [dic objectForKey:@"lm_title"];
        submitEntity.delivery_id = [dic objectForKey:@"delivery_id"];
        submitEntity.delivery_name = [dic objectForKey:@"delivery_name"];
        submitEntity.lm_time_title = [dic objectForKey:@"lm_time_title"];
        submitEntity.logistics_amount = [dic objectForKey:@"logistics_amount"];
        submitEntity.pick_up_time = [dic objectForKey:@"pick_up_time"];
        submitEntity.pay_method = [dic objectForKey:@"pay_method"];
//        NSArray * goods = [dic objectForKey:@"goods"];
//        NSDictionary *d = [goods firstObject];
//        submitEntity.goods_count = [d objectForKey:@"goods_num"];
        
        if ([dic objectForKey:@"id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"id"];
        }
        if ([dic objectForKey:@"order_list_id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"order_list_id"];
        }
        
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
        }
        
        [[NetTrans getInstance]cancelRequest:self];
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
                         NSDictionary * dic = [datas firstObject];
                         OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
                         submitEntity.order_list_no = [dic objectForKey:@"order_list_no"];
                         submitEntity.bu_name = [dic objectForKey:@"bu_name"];
                         submitEntity.address = [dic objectForKey:@"bu_address"];
                         //        submitEntity.tel = [dic objectForKey:@"tel"];
                         submitEntity.goods_count = [dic objectForKey:@"goods_num"];
                         submitEntity.total_amount = [dic objectForKey:@"total_amount"];
                         submitEntity.goods_amount = [dic objectForKey:@"goods_amount"];
                         //        submitEntity.coupon_amount = [dic objectForKey:@"coupon_amount"];
                         submitEntity.lm_title = [dic objectForKey:@"lm_title"];
                         submitEntity.delivery_id = [dic objectForKey:@"delivery_id"];
                         submitEntity.delivery_name = [dic objectForKey:@"delivery_name"];
                         submitEntity.lm_time_title = [dic objectForKey:@"lm_time_title"];
                         submitEntity.logistics_amount = [dic objectForKey:@"logistics_amount"];
                         submitEntity.pick_up_time = [dic objectForKey:@"pick_up_time"];
                         submitEntity.pay_method = [dic objectForKey:@"pay_method"];
                         //        NSArray * goods = [dic objectForKey:@"goods"];
                         //        NSDictionary *d = [goods firstObject];
                         //        submitEntity.goods_count = [d objectForKey:@"goods_num"];
                         
                         if ([dic objectForKey:@"id"]) {
                             submitEntity.order_list_id = [dic objectForKey:@"id"];
                         }
                         if ([dic objectForKey:@"order_list_id"]) {
                             submitEntity.order_list_id = [dic objectForKey:@"order_list_id"];
                         }
                         //517
                         if ([dic objectForKey:@"transaction_type"]) {
                             submitEntity.transaction_type = [dic objectForKey:@"transaction_type"];
                         }
                         if ([dic objectForKey:@"goods"]) {
                             submitEntity.orderArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"goods"]];
                         }
                         [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
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
//PDA
@implementation PdaOrderDetailObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request{
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
- (BOOL)responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
    NSString * myResponseStr = [[NSString alloc] initWithData:myResponseData encoding:enc];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSDictionary * dic = [jsonDic objectForKey:@"data"];
        OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
        submitEntity.order_list_no = [dic objectForKey:@"order_list_no"];
        submitEntity.bu_name = [dic objectForKey:@"bu_name"];
        submitEntity.address = [dic objectForKey:@"address"];
        submitEntity.tel = [dic objectForKey:@"tel"];
        submitEntity.goods_count = [dic objectForKey:@"goods_num"];
        submitEntity.total_amount = [dic objectForKey:@"total_amount"];
        submitEntity.goods_amount = [dic objectForKey:@"goods_amount"];
        submitEntity.coupon_amount = [dic objectForKey:@"coupon_amount"];
        submitEntity.coupon_num = [dic objectForKey:@"coupon_num"];
        submitEntity.couponList = [dic objectForKey:@"coupon_list"];
        submitEntity.pay_method = [dic objectForKey:@"pay_method"];
        
        if ([dic objectForKey:@"id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"id"];
        }
        if ([dic objectForKey:@"order_list_id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"order_list_id"];
        }
        
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
        }
        
        [[NetTrans getInstance]cancelRequest:self];
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
                         OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
                         submitEntity.order_list_no = [datas objectForKey:@"order_list_no"];
                         submitEntity.bu_name = [datas objectForKey:@"bu_name"];
                         submitEntity.address = [datas objectForKey:@"address"];
                         submitEntity.tel = [datas objectForKey:@"tel"];
                         submitEntity.goods_count = [datas objectForKey:@"goods_num"];
                         submitEntity.total_amount = [datas objectForKey:@"total_amount"];
                         submitEntity.goods_amount = [datas objectForKey:@"goods_amount"];
                         submitEntity.coupon_amount = [datas objectForKey:@"coupon_amount"];
                         submitEntity.coupon_num = [datas objectForKey:@"coupon_num"];
                         submitEntity.couponList = [datas objectForKey:@"coupon_list"];
                         submitEntity.pay_method = [datas objectForKey:@"pay_method"];
                         
                         if ([datas objectForKey:@"id"]) {
                             submitEntity.order_list_id = [datas objectForKey:@"id"];
                         }
                         if ([datas objectForKey:@"order_list_id"]) {
                             submitEntity.order_list_id = [datas objectForKey:@"order_list_id"];
                         }
                         [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
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

#pragma -mark
#pragma ------------------------------------------------确认订单
// 确认订单
@implementation ConfirmTransObj
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSDictionary *dic = [jsonDic objectForKey:@"data"];
        
        OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
        submitEntity.order_list_no = [dic objectForKey:@"order_list_no"];
        submitEntity.bu_name = [dic objectForKey:@"bu_name"];
        submitEntity.address = [dic objectForKey:@"address"];
        submitEntity.tel = [dic objectForKey:@"tel"];
        submitEntity.goods_count = [dic objectForKey:@"goods_count"];
        submitEntity.total_amount = [dic objectForKey:@"total_amount"];
        submitEntity.lm_time_title = [dic objectForKey:@"lm_time_title"];
        submitEntity.lm_title = [dic objectForKey:@"lm_title"];
        submitEntity.delivery_name = [dic objectForKey:@"delivery_name"];
        submitEntity.pick_up_time = [dic objectForKey:@"pick_up_time"];
        submitEntity.pay_method = [dic objectForKey:@"pay_method"];
        id del_id = [dic objectForKey:@"delivery_id"];
        if ([del_id isKindOfClass:[NSNumber class]]) {
            submitEntity.delivery_id = [del_id stringValue];
        } else if ([del_id isKindOfClass:[NSString class]]) {
            submitEntity.delivery_id = del_id;
        }
       
        if ([dic objectForKey:@"order_list_id"]) {
            submitEntity.order_list_id = [dic objectForKey:@"order_list_id"];
        }
        submitEntity.order_Status = [dic objectForKey:@"total_state_str"];
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
        }
        
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
                         OrderSubmitEntity *submitEntity = [[OrderSubmitEntity alloc] init];
                         submitEntity.order_list_no = [datas objectForKey:@"order_list_no"];
                         submitEntity.bu_name = [datas objectForKey:@"bu_name"];
                         submitEntity.address = [datas objectForKey:@"address"];
                         submitEntity.tel = [datas objectForKey:@"tel"];
                         submitEntity.goods_count = [datas objectForKey:@"goods_count"];
                         submitEntity.total_amount = [datas objectForKey:@"total_amount"];
                         submitEntity.lm_time_title = [datas objectForKey:@"lm_time_title"];
                         submitEntity.lm_title = [datas objectForKey:@"lm_title"];
                         submitEntity.delivery_name = [datas objectForKey:@"delivery_name"];
                         submitEntity.pick_up_time = [datas objectForKey:@"pick_up_time"];
                         submitEntity.pay_method = [datas objectForKey:@"pay_method"];
                         id del_id = [datas objectForKey:@"delivery_id"];
                         if ([del_id isKindOfClass:[NSNumber class]]) {
                             submitEntity.delivery_id = [del_id stringValue];
                         } else if ([del_id isKindOfClass:[NSString class]]) {
                             submitEntity.delivery_id = del_id;
                         }
                         
                         if ([datas objectForKey:@"order_list_id"]) {
                             submitEntity.order_list_id = [datas objectForKey:@"order_list_id"];
                         }
                         submitEntity.order_Status = [datas objectForKey:@"total_state_str"];
                         //517 new process
                         if ([datas objectForKey:@"update_apps_local_file_array"]) {
                             submitEntity.deliveryDict = (NSMutableDictionary *)[datas objectForKey:@"update_apps_local_file_array"];
                         }
                         [_uinet responseSuccessObj:submitEntity nTag:self._nApiTag];
                         return;
                     }
                 }
                 else if ([status isEqualToString:@"3"]){//更新本地信息
                     if ([jsonObject objectForKey:@"data"] && [[jsonObject objectForKey:@"data"]count]) {
                         NSDictionary * dict = [jsonObject objectForKey:@"data"];
                         NSArray * messArr = [message componentsSeparatedByString:@"&"];
                         NSString * messStr = [[[messArr lastObject] componentsSeparatedByString:@":"] lastObject];
                         if ([_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:withObject:)]) {
                             [_uinet requestFailed:_nApiTag withStatus:@"3" withMessage:messStr withObject:dict];
                         }
                     }else{
                         [_uinet requestFailed:_nApiTag withStatus:WEB_STATUS_0 withMessage:message];
                     }
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


#pragma -mark
#pragma ---------------------------------------------我的订单
@implementation MyOrderTransObj
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSMutableArray *array = [NSMutableArray array];
        
        id dicData = [jsonDic objectForKey:@"data"];
        NSMutableArray *dicArray;
        if ([dicData isKindOfClass:[NSArray class]]) {
            if ([dicData count] == 0) {
                [_uinet responseSuccessObj:nil nTag:self._nApiTag];
                return NO;
            }else{
                dicArray = dicData;
                for (NSDictionary *dic in dicArray) {
                    MyOrderEntity *myOrder = [[MyOrderEntity alloc] init];
                    [myOrder setMyOrderEntity:dic];
                    [array addObject:myOrder];
                }
                [_uinet responseSuccessObj:array nTag:self._nApiTag];
                return NO;
            }
        }else{
            if ([dicData objectForKey:@"order"]) {
                dicArray = [dicData objectForKey:@"order"];
            }
        }
        
        if ([dicData objectForKey:@"active_info"]) {
            NSString  *active_info= [dicData objectForKey:@"active_info"];
            if (active_info.length > 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:active_info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            for (NSDictionary *dic in dicArray) {
                MyOrderEntity *myOrder = [[MyOrderEntity alloc] init];
                [myOrder setMyOrderEntity:dic];
                [array addObject:myOrder];
            }
            [_uinet responseSuccessObj:array nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
    }  else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
                     id datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *array = [NSMutableArray array];
                         
//                         id dicData = [jsonDic objectForKey:@"data"];
                         NSMutableArray *dicArray;
                         if ([datas isKindOfClass:[NSArray class]]) {
                             if ([datas count] == 0) {
                                 [_uinet responseSuccessObj:nil nTag:self._nApiTag];
                                 return;
                             }else{
                                 dicArray = datas;
                                 for (NSDictionary *dic in dicArray) {
                                     MyOrderEntity *myOrder = [[MyOrderEntity alloc] init];
                                     [myOrder setMyOrderEntity:dic];
                                     [array addObject:myOrder];
                                 }
                                 [_uinet responseSuccessObj:array nTag:self._nApiTag];
                                 return;
                             }
                         }else{
                             if ([datas objectForKey:@"order"]) {
                                 dicArray = [datas objectForKey:@"order"];
                             }
                         }
                         
                         if ([datas objectForKey:@"active_info"]) {
                             NSString  *active_info= [datas objectForKey:@"active_info"];
                             if (active_info.length > 0) {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:active_info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                 [alertView show];
                             }
                         }
                         for (NSDictionary *dic in dicArray) {
                             MyOrderEntity *myOrder = [[MyOrderEntity alloc] init];
                             [myOrder setMyOrderEntity:dic];
                             [array addObject:myOrder];
                         }
                         [_uinet responseSuccessObj:array nTag:self._nApiTag];
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

#pragma -mark
#pragma -－－－－－－－－－－－－－－－－－－－－－－－－－－退货订单
// 退货订单
@implementation ReturnOrderTransObj
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] ){
        NSMutableArray *array = [NSMutableArray array];
        
        id dicData = [jsonDic objectForKey:@"data"];
        NSMutableArray *dicArray;
        if ([dicData isKindOfClass:[NSArray class]]) {
            if ([dicData count] == 0) {
                [_uinet responseSuccessObj:nil nTag:self._nApiTag];
                return NO;
            }else{
                dicArray = dicData;
                for (NSDictionary *dic in dicArray) {
                    ReturnOrderEntity *myOrder = [[ReturnOrderEntity alloc] init];
                    [myOrder setReturnOrderEntity:dic];
                    [array addObject:myOrder];
                }
                [_uinet responseSuccessObj:array nTag:self._nApiTag];
                return NO;
            }
        }else{
            if ([dicData objectForKey:@"order"]) {
                dicArray = [dicData objectForKey:@"order"];
            }
        }
        
        if ([dicData objectForKey:@"active_info"]) {
            NSString  *active_info= [dicData objectForKey:@"active_info"];
            if (active_info.length > 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:active_info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            for (NSDictionary *dic in dicArray) {
                MyOrderEntity *myOrder = [[MyOrderEntity alloc] init];
                [myOrder setMyOrderEntity:dic];
                [array addObject:myOrder];
            }
            [_uinet responseSuccessObj:array nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
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
                     id datas = [jsonObject objectForKey:@"data"];
                     if (!datas || (datas == nil))
                     {
                         //                        [[NetTrans getInstance] cancelRequest:self];
                         [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                         return ;
                     }
                     else
                     {
                         NSMutableArray *array = [NSMutableArray array];
                         
//                         id dicData = [jsonDic objectForKey:@"data"];
                         NSMutableArray *dicArray;
                         if ([datas isKindOfClass:[NSArray class]]) {
                             if ([datas count] == 0) {
                                 [_uinet responseSuccessObj:nil nTag:self._nApiTag];
                                 return ;
                             }else{
                                 dicArray = datas;
                                 for (NSDictionary *dic in dicArray)
                                 {
                                     ReturnOrderEntity *myOrder = [[ReturnOrderEntity alloc] init];
                                     [myOrder setReturnOrderEntity:dic];
                                     NSLog(@"dic = %@" , dic);
                                     [array addObject:myOrder];
                                 }
                                 [_uinet responseSuccessObj:array nTag:self._nApiTag];
                                 return ;
                             }
                         }else{
                             if ([datas objectForKey:@"order"]) {
                                 dicArray = [datas objectForKey:@"order"];
                             }
                         }
                         
                         if ([datas objectForKey:@"active_info"]) {
                             NSString  *active_info= [datas objectForKey:@"active_info"];
                             if (active_info.length > 0) {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:active_info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                 [alertView show];
                             }
                         }
                         for (NSDictionary *dic in dicArray) {
                             MyOrderEntity *myOrder = [[MyOrderEntity alloc] init];
                             [myOrder setMyOrderEntity:dic];
                             [array addObject:myOrder];
                         }
                         [_uinet responseSuccessObj:array nTag:self._nApiTag];
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

@implementation OrderPayTransObj
/*
- (BOOL)requestFailed:(ASIHTTPRequest *)request
{
    if(![super requestFailed:request])
    {
        return NO;
    }
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
    
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([status isEqualToString:WEB_STATUS_1] )
    {
        NSDictionary *dic = [jsonDic objectForKey:@"data"];
        
        if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
        {
            [_uinet responseSuccessObj:dic nTag:self._nApiTag];
        }
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if([status isEqualToString:@"2"]){
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"2" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
    }else if([status isEqualToString:@"3"]){
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"3" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
    }
    else if ([status isEqualToString:@"4"])
    {
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"4" withMessage:message];
        [[NetTrans getInstance]cancelRequest:self];
    }
    else{
        NSString *message =[jsonDic objectForKey:@"message"];
        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:message];
        [[NetTrans getInstance] cancelRequest:self];
    }
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
                         [_uinet requestFailed:self._nApiTag withStatus:@"1" withMessage:message];
                         return ;
                     }
                     else
                     {
                         [_uinet responseSuccessObj:datas nTag:self._nApiTag];
                         return;
                     }
                 }
                 else if([status isEqualToString:@"2"]){
                     [_uinet requestFailed:self._nApiTag withStatus:@"2" withMessage:message];
                     return;
                 }else if([status isEqualToString:@"3"]){
                    
                     [_uinet requestFailed:self._nApiTag withStatus:@"3" withMessage:message];
                     return;
                 }
                 else if ([status isEqualToString:@"4"])
                 {

                     [_uinet requestFailed:self._nApiTag withStatus:@"4" withMessage:message];
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
             [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"网络请求超时！"];
         }
         
     }];
    [operation start];
}
@end