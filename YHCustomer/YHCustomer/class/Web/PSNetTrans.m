//
//  PSNetTrans.m
//  YHCustomer
//
//  Created by lichentao on 14-3-27.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  配送相关api

#import "PSNetTrans.h"
#import "PSEntity.h"
#import "SuccessOrFailEntity.h"
#import "OrderAddressEntity.h"
#import "OrderEntity.h"
#import "ReturnEntity.h"
#import "GoodsEntity.h"
#import "DmEntity.h"
#import "CategoryEntity.h"
#import "HotWordsEntity.h"
#import "KeyWordsEntity.h"
#import "SearchCategoryEntity.h"
#import "BrandEntity.h"
#import "IdVerifiedEntity.h"
#import "ValidationEntity.h"
#import "BindCardEntity.h"
#import "PSPatternEntity.h"

static PSNetTrans* trans = nil;

@implementation PSNetTrans
@synthesize _arrRequst,_arrTongJiKey;

+ (PSNetTrans*) getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        trans = [[PSNetTrans alloc] init];
//        [trans initData];
    });
    return trans;
}
-(void)initData
{
    self._arrRequst = [NSMutableArray array];
}

-(ASIHTTPRequest *)get:(NSString *)strUrl
{
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        [[iToast makeText:@"网络不可用，请检查网络设置！"]show];
        return NULL;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.timeOutSeconds = 30;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(responseSuccess:)];
    [request setRequestMethod:@"GET"];
    [request setDownloadDestinationPath:@""];
    [request setUseCookiePersistence:YES];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    return request;
}

-(ASIFormDataRequest *)post:(NSString*)strUrl
{
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        [[iToast makeText:@"网络不可用，请检查网络设置！"]show];
        return NULL;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.timeOutSeconds = 30;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(responseSuccess:)];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIURLEncodedPostFormat];
    [request setUseCookiePersistence:YES];
    
    return request;
}

-(id)getNetTransByAPITag:(EnumApiTag)nTag;
{
    for(int n = 0; n < [_arrRequst count]; n++)
    {
        NetTransObj* obj = [_arrRequst objectAtIndex:n];
        if(obj._nApiTag == nTag)
        {
            return obj;
        }
    }
    return NULL;
}

-(void)cancelRequestByUI:(id)ui
{
    for(int n = 0; n < [_arrRequst count];n++)
    {
        NetTransObj* obj = [_arrRequst objectAtIndex:n];
        if(obj._uinet == ui)
        {
            [self cancelRequest:obj];
        }
    }
}

-(void)cancelRequest:(NetTransObj*)netObj
{
    /*
    if(netObj._postRequst != NULL)
    {
        netObj._postRequst.delegate = nil;
        [netObj._postRequst cancel];
        [_arrRequst removeObject:netObj];
    }
    else if(netObj._getRequest != NULL)
    {
        netObj._getRequest.delegate = nil;
        [netObj._getRequest cancel];
        [_arrRequst removeObject:netObj];
    }
     */
}

#pragma mark --------------------------根据apitag获取请求对象（NetTransObj）  nTag：apitag re:NetTransObj
#pragma mark -/*配送部分*/

// 获取配送方式
-(void)ps_getDeliveryStyle:(id)transdel transaction_type:(NSString *)transaction_type{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_DELIVERY_STYLE,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_DELIVERY_STYLE];
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_DELIVERY_STYLE,[UserAccount instance].session_id,[UserAccount instance].region_id ];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_DELIVERY_STYLE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (transaction_type) {
        [dic setValue:transaction_type forKey:@"transaction_type"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/**
 * 选择支付方式
 */
- (void)ps_PayMentStyle:(id)transdel Type:(NSString *)_type
{
    /* NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PAYMENT_STYLE,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_PAYMENT_STYLE];
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     
     //_type为1的时候 是支付订单，所获取的支付方式
     // _type其他任何值 是为永辉卡充值  所获取支付方式（我现在传的是0）
     
     if ([_type isEqualToString:@"1"])
     {
     [webTrans._postRequst setPostValue:@"1" forKey:@"type"];
     }
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PAYMENT_STYLE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_PAYMENT_STYLE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if ([_type isEqualToString:@"1"])
    {
        [dic setObject:@"1" forKey:@"type"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
    
}
- (void)ps_PayMentStyle:(id)transdel pay_method:(NSString *)pay_method order_list_no:(NSString *)order_list_no{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PAYMENT_STYLE_MONEY,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     ModifyPayMethod *webTrans = [[ModifyPayMethod alloc] init:transdel nApiTag:t_API_PS_PAYMENT_STYLE_MONEY];
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:pay_method forKey:@"pay_method"];
     [webTrans._postRequst setPostValue:order_list_no forKey:@"order_list_no"];
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];*/
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PAYMENT_STYLE_MONEY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ModifyPayMethod *webTrans = [[ModifyPayMethod alloc] init:transdel nApiTag:t_API_PS_PAYMENT_STYLE_MONEY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (pay_method)
    {
        [dic setObject:pay_method forKey:@"pay_method"];
    }
    else
    {
        [dic setObject:@"" forKey:@"pay_method"];

    }
    if (order_list_no)
    {
        [dic setObject:order_list_no forKey:@"order_list_no"];

    }
    else
    {
        [dic setObject:@"" forKey:@"order_list_no"];

    }
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:pay_method,@"pay_method",order_list_no,@"order_list_no",nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
    
}
/*
 * 获取物流配送方式
 */
- (void)ps_getLogisticStyle:(id)transdel goods_id:(NSString *)goods_id{
    /*NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_LOGISTIC_STYLE,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     SendLogisticToStoreObj *webTrans = [[SendLogisticToStoreObj alloc] init:transdel nApiTag:t_API_PS_LOGISTIC_STYLE];
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];*/
    
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_PS_LOGISTIC_STYLE,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    SendLogisticToStoreObj *webTrans = [[SendLogisticToStoreObj alloc] init:transdel nApiTag:t_API_PS_LOGISTIC_STYLE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (goods_id) {
        [dic setValue:goods_id forKey:@"goods_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
    
    
    
    
    
}

// 修改配送物流快递类型_时间段
-(void)API_order_modifyDelivery_time_func:(id)transdel order_list_id:(NSString *)order_list_id lm_id:(NSString *)lm_id lm_time_id:(NSString *)lm_time_id IsTel:(BOOL)is_tel{
    
    /*NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_MODIFY_DELIVERY_TIME,[UserAccount instance].session_id,[UserAccount instance].region_id];
     
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_PS_MODIFY_DELIVERY_TIME];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];
     [webTrans._postRequst setPostValue:lm_id forKey:@"lm_id"];
     [webTrans._postRequst setPostValue:lm_time_id forKey:@"lm_time_id"];
     [webTrans._postRequst setPostValue:[NSNumber numberWithBool:is_tel] forKey:@"is_tel"];
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];*/
    
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_MODIFY_DELIVERY_TIME,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_PS_MODIFY_DELIVERY_TIME];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:order_list_id,@"order_list_id",lm_id,@"lm_id",lm_time_id,@"lm_time_id",[NSNumber numberWithBool:is_tel],@"is_tel",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if (order_list_id)
    {
        [dic setObject:order_list_id forKey:@"order_list_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"order_list_id"];
        
    }
    if (lm_id)
    {
        [dic setObject:lm_id forKey:@"lm_id"];
        
    }
    else
    {
        [dic setObject:@"" forKey:@"lm_id"];
        
    }
    if (lm_time_id)
    {
        [dic setObject:lm_time_id forKey:@"lm_time_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"lm_time_id"];
        
    }
    if ([NSNumber numberWithBool:is_tel])
    {
        [dic setObject:[NSNumber numberWithBool:is_tel] forKey:@"is_tel"];
        
    }
    else
    {
        [dic setObject:@"" forKey:@"is_tel"];
        
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

// 优惠券列表（可用）CommonArrayObj
- (void)ps_getCouponList:(id)transdel payMethod:(NSString *)payMethod lm_idForPs:(NSString *)lm_id goods_id:(NSString *)goods_id total:(NSString *)total{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_ORDER_COUPON_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_ORDER_COUPON_LIST];
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     if (payMethod) {
     [webTrans._postRequst setPostValue:payMethod forKey:@"pay_method"];
     }
     webTrans._postRequst.delegate = webTrans;
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_PS_ORDER_COUPON_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_ORDER_COUPON_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (payMethod)
    {
        [dic setObject:payMethod forKey:@"pay_method"];
    }
    if (lm_id)
    {
        [dic setObject:lm_id forKey:@"lm_id"];
    }
    if (goods_id)
    {
        [dic setObject:goods_id forKey:@"goods_id"];
    }
    if (total)
    {
        [dic setObject:total forKey:@"total"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
    
    
    
    
}

// 商品列表
- (void)ps_getGoodsList:(id)transdel goods_id:(NSString *)goods_id total:(NSString *)total
{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_GOODS_LIST];
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_PS_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (goods_id) {
        [dic setObject:goods_id forKey:@"goods_id"];
    }
    if (total) {
        [dic setObject:total forKey:@"total"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}


#pragma -
#pragma -mark ------------------------------------地址相关
-(void)API_order_address_list_func:(id)transdel goods_id:(NSString *)goods_id
{
    /*
     //NSString *requestName = API_ORDER_ADDRESS_LIST;
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ADDRESS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
     
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[OrderAddressNetTransObj alloc]init:transdel nApiTag:t_API_ADDRESS_LIST];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_ADDRESS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[OrderAddressNetTransObj alloc]init:transdel nApiTag:t_API_ADDRESS_LIST];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (goods_id) {
        [dic setValue:goods_id forKey:@"goods_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    if (dic) {
        [webTrans request:strurl andDic:dic];
    }else{
        [webTrans request:strurl andDic:nil];
    }
    
}

-(void)API_order_address_add_func:(id)transdel TrueName:(NSString*)true_name
                           Mobile:(NSString*)mobile Telephone:(NSString*)telephone
                          ZipCode:(NSString*)zip_code LogisticsArea:(NSString*)logistics_area
                 LogisticsAddress:(NSString*)logistics_address IsDefault:(NSString *)is_default goods_id:(NSString *)goods_id
{
    /*
     // NSString *requestName = API_ORDER_ADDRESS_ADD;
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ADD_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
     
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_ADD_ADDRESS];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:true_name forKey:@"true_name"];
     [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
     //    [webTrans._postRequst setPostValue:telephone forKey:@"telephone"];
     //    [webTrans._postRequst setPostValue:zip_code forKey:@"zip_code"];
     [webTrans._postRequst setPostValue:logistics_area forKey:@"logistics_area"];
     [webTrans._postRequst setPostValue:logistics_address forKey:@"logistics_address"];
     [webTrans._postRequst setPostValue:is_default forKey:@"is_default"];
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ADD_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[NewAddressObj alloc]init:transdel nApiTag:t_API_ADD_ADDRESS];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:true_name,@"true_name",mobile,@"mobile",telephone,@"telephone",zip_code,@"zip_code",logistics_area,@"logistics_area",logistics_address,@"logistics_address",is_default,@"is_default",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (true_name)
    {
        [dic setObject:true_name forKey:@"true_name"];
    }
    else
    {
        [dic setObject:@"" forKey:@"true_name"];
    }
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    if (telephone)
    {
        [dic setObject:telephone forKey:@"telephone"];
    }
    else
    {
        [dic setObject:@"" forKey:@"telephone"];

    }
    if (zip_code)
    {
        [dic setObject:zip_code forKey:@"zip_code"];
    }
    else
    {
        [dic setObject:@"" forKey:@"zip_code"];
    }
    if (logistics_area)
    {
        [dic setObject:logistics_area forKey:@"logistics_area"];
    }
    else
    {
        [dic setObject:@"" forKey:@"logistics_area"];
    }
    if (logistics_address)
    {
        [dic setObject:logistics_address forKey:@"logistics_address"];
    }
    else
    {
        [dic setObject:@"" forKey:@"logistics_address"];
    }
    if (is_default)
    {
        [dic setObject:is_default forKey:@"is_default"];
    }
    else
    {
        [dic setObject:@"" forKey:@"is_default"];
    }
    if (goods_id) {
        [dic setObject:goods_id forKey:@"goods_id"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

-(void)API_order_address_update_func:(id)transdel ID:(NSString*)Id TrueName:(NSString*)true_name
                              Mobile:(NSString*)mobile Telephone:(NSString*)telephone
                             ZipCode:(NSString*)zip_code LogisticsArea:(NSString*)logistics_area
                    LogisticsAddress:(NSString*)logistics_address sDefault:(NSString *)is_default
{
    /*
     //NSString *requestName = API_ORDER_ADDRESS_UPDATE;
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_UPDATE_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
     
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_UPDATE_ADDRESS];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:Id forKey:@"id"];
     [webTrans._postRequst setPostValue:true_name forKey:@"true_name"];
     [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
     //    [webTrans._postRequst setPostValue:telephone forKey:@"telephone"];
     //    [webTrans._postRequst setPostValue:zip_code forKey:@"zip_code"];
     [webTrans._postRequst setPostValue:logistics_area forKey:@"logistics_area"];
     [webTrans._postRequst setPostValue:logistics_address forKey:@"logistics_address"];
     [webTrans._postRequst setPostValue:is_default forKey:@"is_default"];
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_UPDATE_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_UPDATE_ADDRESS];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:Id,@"id",true_name,@"true_name",mobile,@"mobile",telephone,@"telephone",zip_code,@"zip_code",logistics_area,@"logistics_area",logistics_address,@"logistics_address",is_default,@"is_default",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (Id)
    {
        [dic setObject:Id forKey:@"id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"id"];
    }
    if (true_name)
    {
        [dic setObject:true_name forKey:@"true_name"];
    }
    else
    {
        [dic setObject:@"" forKey:@"true_name"];
    }
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    if (telephone)
    {
        [dic setObject:telephone forKey:@"telephone"];
    }
    else
    {
        [dic setObject:@"" forKey:@"telephone"];

    
    }
    if (zip_code)
    {
        [dic setObject:zip_code forKey:@"zip_code"];
    }
    else
    {
        [dic setObject:@"" forKey:@"zip_code"];
    }
    if (logistics_area)
    {
        [dic setObject:logistics_area forKey:@"logistics_area"];
    }
    else
    {
        [dic setObject:@"" forKey:@"logistics_area"];
    }
    if (logistics_address)
    {
        [dic setObject:logistics_address forKey:@"logistics_address"];
    }
    else
    {
        [dic setObject:@"" forKey:@"logistics_address"];
    }
    if (is_default)
    {
        [dic setObject:is_default forKey:@"is_default"];
    }
    else
    {
        [dic setObject:@"" forKey:@"is_default"];
    }
    
    
    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}
-(void)API_order_address_delete_func:(id)transdel ID:(NSString*)Id
{
    /*
     //NSString *requestName = API_ORDER_ADDRESS_DELETE;
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_DELETE_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_DELETE_ADDRESS];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     
     [webTrans._postRequst setPostValue:Id forKey:@"id"];
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_DELETE_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_DELETE_ADDRESS];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:Id,@"id",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (Id)
    {
        [dic setObject:Id forKey:@"id"];
    }
    else
    {
    
        [dic setObject:@"" forKey:@"id"];

    }
    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
    
}

-(void)API_order_address_set_func:(id)transdel ID:(NSString*)Id
{
    /*
     //NSString *requestName = API_ORDER_ADDRESS_SET;
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SETDEFAULT_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_SETDEFAULT_ADDRESS];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:Id forKey:@"id"];
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SETDEFAULT_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_SETDEFAULT_ADDRESS];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:Id,@"id",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if (Id)
    {
        [dic setValue:Id forKey:@"id"];
    }
    else
    {
        [dic setValue:@"" forKey:@"id"];

    }
    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

/*省市区列表*/
- (void) API_areaList:(id)transdel AreaType:(NSString *)type AreaId:(NSString *)region_id{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_AREA_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[AddressAreaObj alloc]init:transdel nApiTag:t_API_ORDER_AREA_LIST];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     
     [webTrans._postRequst setPostValue:type forKey:@"type"];
     if (![type isEqualToString:@"1"]) {
     [webTrans._postRequst setPostValue:region_id forKey:@"region_id"];
     }
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_AREA_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[AddressAreaObj alloc]init:transdel nApiTag:t_API_ORDER_AREA_LIST];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if (type)
    {
        [dic setObject:type forKey:@"type"];
    }
    else
    {
    
        [dic setObject:@"" forKey:@"type"];
    }
    
    
    if (![type isEqualToString:@"1"])
    {
        [dic setObject:region_id forKey:@"region_id"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

#pragma -
#pragma - mark --------------------------------------订单相关
-(void)submit_order:(id)transdel delivery_id:(NSString *)delivery_id lm_id:(NSString *)lm_id lm_time_id:(NSString *)lm_time_id is_tel:(NSString *)is_tel receipt_type:(NSString *)receipt_type receipt_title:(NSString *)receipt_title order_address_id:(NSString *)order_address_id coupon_id:(NSString *)coupon_id remark:(NSString *)remark pay_method:(NSString *)pay_method bu_id:(NSString *)bu_id time:(NSString *)time goods_id:(NSString *)goods_id total:(NSString *)total
{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SUBMIT_ORDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[ConfirmTransObj alloc]init:transdel nApiTag:t_API_SUBMIT_ORDER];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:delivery_id forKey:@"delivery_id"];
     if ([delivery_id isEqualToString:@"1"]) {
     [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
     [webTrans._postRequst setPostValue:time forKey:@"time"];
     [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
     [webTrans._postRequst setPostValue:remark forKey:@"remark"];
     [webTrans._postRequst setPostValue:pay_method forKey:@"pay_method"];
     } else if ([delivery_id isEqualToString:@"2"]) {
     [webTrans._postRequst setPostValue:lm_id forKey:@"lm_id"];
     [webTrans._postRequst setPostValue:lm_time_id forKey:@"lm_time_id"];
     [webTrans._postRequst setPostValue:is_tel forKey:@"is_tel"];
     [webTrans._postRequst setPostValue:receipt_type forKey:@"receipt_type"];
     [webTrans._postRequst setPostValue:receipt_title forKey:@"receipt_title"];
     [webTrans._postRequst setPostValue:order_address_id forKey:@"order_address_id"];
     [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
     [webTrans._postRequst setPostValue:remark forKey:@"remark"];
     [webTrans._postRequst setPostValue:pay_method forKey:@"pay_method"];
     }
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_SUBMIT_ORDER,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[ConfirmTransObj alloc]init:transdel nApiTag:t_API_SUBMIT_ORDER];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:delivery_id,@"delivery_id",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (delivery_id)
    {
        [dic setObject:delivery_id forKey:@"delivery_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"delivery_id"];

    }
    
    
    if ([delivery_id isEqualToString:@"1"])
    {
        if (bu_id)
        {
             [dic setObject:bu_id forKey:@"bu_id"];
        }
        if (time)
        {
            [dic setObject:time forKey:@"time"];
        }
        if (coupon_id)
        {
            [dic setObject:coupon_id forKey:@"coupon_id"];
        }
        if (remark)
        {
            [dic setObject:remark forKey:@"remark"];
        }
        if(pay_method)
        {
            [dic setObject:pay_method forKey:@"pay_method"];
        }
//        [dic setObject:time forKey:@"time"];
//        [dic setObject:coupon_id forKey:@"coupon_id"];
//        [dic setObject:remark forKey:@"remark"];
//        [dic setObject:pay_method forKey:@"pay_method"];
        /*[webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
         [webTrans._postRequst setPostValue:time forKey:@"time"];
         [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
         [webTrans._postRequst setPostValue:remark forKey:@"remark"];
         [webTrans._postRequst setPostValue:pay_method forKey:@"pay_method"];
         */
    } else if ([delivery_id isEqualToString:@"2"]) {
        
        if(lm_id)
        {
            [dic setObject:lm_id forKey:@"lm_id"];
        }
        if(lm_time_id)
        {
            [dic setObject:lm_time_id forKey:@"lm_time_id"];
        }
        if(is_tel)
        {
            [dic setObject:is_tel forKey:@"is_tel"];
        }
        if(receipt_type)
        {
            [dic setObject:receipt_type forKey:@"receipt_type"];
        }
        if(receipt_title)
        {
            [dic setObject:receipt_title forKey:@"receipt_title"];
        }
        if(order_address_id)
        {
            [dic setObject:order_address_id forKey:@"order_address_id"];
        }
        if(coupon_id)
        {
            [dic setObject:coupon_id forKey:@"coupon_id"];
        }
        if(pay_method)
        {
            [dic setObject:pay_method forKey:@"pay_method"];
        }
        if(remark)
        {
            [dic setObject:remark forKey:@"remark"];
        }
        if (goods_id) {
            [dic setObject:goods_id forKey:@"goods_id"];
        }
        if (total) {
            [dic setObject:total forKey:@"total"];
        }
//        [dic setObject:lm_id forKey:@"lm_id"];
//        [dic setObject:lm_time_id forKey:@"lm_time_id"];
//        [dic setObject:is_tel forKey:@"is_tel"];
//        [dic setObject:receipt_type forKey:@"receipt_type"];
//        [dic setObject:receipt_title forKey:@"receipt_title"];
//        [dic setObject:order_address_id forKey:@"order_address_id"];
//        [dic setObject:coupon_id forKey:@"coupon_id"];
//        [dic setObject:remark forKey:@"remark"];
//        [dic setObject:pay_method forKey:@"pay_method"];
        /*
         [webTrans._postRequst setPostValue:lm_id forKey:@"lm_id"];
         [webTrans._postRequst setPostValue:lm_time_id forKey:@"lm_time_id"];
         [webTrans._postRequst setPostValue:is_tel forKey:@"is_tel"];
         [webTrans._postRequst setPostValue:receipt_type forKey:@"receipt_type"];
         [webTrans._postRequst setPostValue:receipt_title forKey:@"receipt_title"];
         [webTrans._postRequst setPostValue:order_address_id forKey:@"order_address_id"];
         [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
         [webTrans._postRequst setPostValue:remark forKey:@"remark"];
         [webTrans._postRequst setPostValue:pay_method forKey:@"pay_method"];
         */
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

//订单支付成功
-(void)order_pay_succeed:(id)transdel order_list_id:(NSString *)order_list_id{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_PAY_SUCCEED,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     NetTransObj* webTrans = NULL;
     webTrans = [[ConfirmTransObj alloc]init:transdel nApiTag:T_API_ORDER_PAY_SUCCEED];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];
     
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_PAY_SUCCEED,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[ConfirmTransObj alloc]init:transdel nApiTag:T_API_ORDER_PAY_SUCCEED];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:order_list_id,@"order_list_id",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (order_list_id)
    {
        [dic setObject:order_list_id forKey:@"order_list_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"order_list_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 我的订单
- (void)my_orderList:(id)transdel Type:(int)type Page:(NSString *)page
{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_MYORDER_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     MyOrderTransObj* webTrans = NULL;
     webTrans = [[MyOrderTransObj alloc]init:transdel nApiTag:t_API_PS_MYORDER_LIST];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     
     NSString *typeStr = nil;
     switch (type) {
     case 1:{
     typeStr = @"0";
     }
     break;
     case 2:{
     typeStr = @"25";
     }
     break;
     case 3:{
     typeStr = @"50";
     }
     break;
     case 4:{
     typeStr = @"100";
     }
     break;
     default:
     break;
     }
     
     [webTrans._postRequst setPostValue:typeStr forKey:@"type"];
     [webTrans._postRequst setPostValue:page forKey:@"page"];
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_MYORDER_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    MyOrderTransObj* webTrans = NULL;
    webTrans = [[MyOrderTransObj alloc]init:transdel nApiTag:t_API_PS_MYORDER_LIST];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    NSString *typeStr = nil;
    switch (type) {
        case 1:{
            typeStr = @"0";
        }
            break;
        case 2:{
            typeStr = @"25";
        }
            break;
        case 3:{
            typeStr = @"50";
        }
            break;
        case 4:{
            typeStr = @"100";
        }
            break;
        default:
            break;
    }
    
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:typeStr,@"typeStr",page,@"page",nil];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (typeStr)
    {
        [dic setObject:typeStr forKey:@"type"];
    }
    if (page)
    {
        [dic setObject:page forKey:@"page"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}
//app订单详情
- (void)my_orderDetail:(id)transdel order_list_id:(NSString *)order_list_id
{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_DETAIL_APP,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     AppOrderDetailObj * webTrans = NULL;
     webTrans = [[AppOrderDetailObj alloc]init:transdel nApiTag:t_API_ORDER_DETAIL_APP];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_DETAIL_APP,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    AppOrderDetailObj * webTrans = NULL;
    webTrans = [[AppOrderDetailObj alloc]init:transdel nApiTag:t_API_ORDER_DETAIL_APP];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:order_list_id,@"order_list_id",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (order_list_id)
    {
        [dic setObject:order_list_id forKey:@"order_list_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"order_list_id"];

    
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    NSLog(@"order_list_id:%@",order_list_id);
    NSLog(@"dic:%@",dic);
    
    
}
//PDA订单详情
- (void)my_orderDetailForPDA:(id)transdel order_list_no:(NSString *)order_list_no
{
    /*
     NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_DETAIL_PDA,[UserAccount instance].session_id,[UserAccount instance].region_id];
     NSString *requestPort = BASE_URL;
     PdaOrderDetailObj * webTrans = NULL;
     webTrans = [[PdaOrderDetailObj alloc]init:transdel nApiTag:t_API_ORDER_DETAIL_PDA];
     
     NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
     webTrans._postRequst = [self post:strurl];
     if(webTrans._postRequst == NULL)
     {
     return;
     }
     webTrans._postRequst.delegate = webTrans;
     [webTrans._postRequst setPostValue:order_list_no forKey:@"order_list_no"];
     
     [_arrRequst addObject:webTrans];
     [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_DETAIL_PDA,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    PdaOrderDetailObj * webTrans = NULL;
    webTrans = [[PdaOrderDetailObj alloc]init:transdel nApiTag:t_API_ORDER_DETAIL_PDA];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:order_list_no,@"order_list_no",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

// 退货订单
- (void)return_orderList:(id)transdel Type:(int)type Page:(NSString *)page{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_RETURN_ORDER_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ReturnOrderTransObj* webTrans = NULL;
    webTrans = [[ReturnOrderTransObj alloc]init:transdel nApiTag:t_API_PS_RETURN_ORDER_LIST];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    NSString *typeStr = nil;
    switch (type) {
        case 1:{
            typeStr = @"0";
        }
            break;
        case 2:{
            typeStr = @"50";
        }
            break;
        case 3:{
            typeStr = @"100";
        }
            break;
        case 4:{
            typeStr = @"10";
        }
            break;
        default:
            break;
    }
    
    [webTrans._postRequst setPostValue:typeStr forKey:@"type"];
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_RETURN_ORDER_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ReturnOrderTransObj *webTrans = [[ReturnOrderTransObj alloc] init:transdel nApiTag:t_API_PS_RETURN_ORDER_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString *typeStr = nil;
    switch (type) {
        case 1:{
            typeStr = @"0";
        }
            break;
        case 2:{
            typeStr = @"50";
        }
            break;
        case 3:{
            typeStr = @"100";
        }
            break;
        case 4:{
            typeStr = @"10";
        }
            break;
        default:
            break;
    }
//    
//    [webTrans._postRequst setPostValue:typeStr forKey:@"type"];
//    [webTrans._postRequst setPostValue:page forKey:@"page"];
//
    [dic setValue:typeStr forKey:@"type"];
     [dic setValue:page forKey:@"page"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 退货商品列表
-(void)ps_returnGoodsList:(id)transdel OrderListId:(NSString *)order_list_id{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_RETURN_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_PS_RETURN_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];

    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_RETURN_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_PS_RETURN_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:order_list_id forKey:@"order_list_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}


//退货原因列表
-(void)order_return_reason:(id)transdel order_state:(NSString *)order_state{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_REASON,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[ReasonEntityObj alloc]init:transdel nApiTag:T_API_ORDER_RETURN_REASON];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_state forKey:@"type"];
    
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_REASON,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ReasonEntityObj *webTrans = [[ReasonEntityObj alloc] init:transdel nApiTag:T_API_ORDER_RETURN_REASON];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (order_state) {
        [dic setValue:order_state forKey:@"type"];

    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//退货方式列表
-(void)order_return_method:(id)transdel {
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_METHOD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[ReturnMethodObj alloc]init:transdel nApiTag:T_API_ORDER_RETURN_METHOD];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_METHOD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ReturnMethodObj *webTrans = [[ReturnMethodObj alloc] init:transdel nApiTag:T_API_ORDER_RETURN_METHOD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}

//退货门店列表
-(void)order_return_store:(id)transdel order_list_id:(NSString *)order_list_id{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_STORE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[ReturnStoreObj alloc]init:transdel nApiTag:T_API_ORDER_RETURN_STORE];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_STORE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ReturnStoreObj *webTrans = [[ReturnStoreObj alloc] init:transdel nApiTag:T_API_ORDER_RETURN_STORE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:order_list_id forKey:@"order_list_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//申请退货未提货
-(void)apply_return_goods:(id)transdel order_list_id:(NSString *)order_list_id reason_code:(NSString *)reason_code reason_name:(NSString *)reason_name returns_name:(NSString *)returns_name returns_account:(NSString *)returns_account{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_SUBMIT,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:T_API_ORDER_RETURN_SUBMIT];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];
    [webTrans._postRequst setPostValue:reason_code forKey:@"reason_code"];
    [webTrans._postRequst setPostValue:reason_name forKey:@"reason_name"];
    if (returns_name && returns_name.length>0) {
        [webTrans._postRequst setPostValue:returns_name forKey:@"returns_name"];
    }
    if (returns_account && returns_account.length>0) {
        [webTrans._postRequst setPostValue:returns_account forKey:@"returns_account"];
    }
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_SUBMIT,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:T_API_ORDER_RETURN_SUBMIT];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:order_list_id forKey:@"order_list_id"];
    [dic setValue:reason_code forKey:@"reason_code"];
    [dic setValue:reason_name forKey:@"reason_name"];
    if (returns_name && returns_name.length>0)
    {
//        [webTrans._postRequst setPostValue:returns_name forKey:@"returns_name"];
        [dic setValue:returns_name forKey:@"returns_name"];
    }
    if (returns_account && returns_account.length>0) {
//        [webTrans._postRequst setPostValue:returns_account forKey:@"returns_account"];
        [dic setValue:returns_account forKey:@"returns_account"];
    }
    NSLog(@"order_list_id = %@" , order_list_id);
    NSLog(@"reason_code = %@" , reason_code);
    NSLog(@"reason_name = %@" , reason_name);
    NSLog(@"returns_name = %@" , returns_name);
    NSLog(@"returns_account = %@" , returns_account);
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//申请退货已提货
-(void)apply_return_goods_delivered:(id)transdel order_list_id:(NSString *)order_list_id reason_code:(NSString *)reason_code reason_name:(NSString *)reason_name returns_name:(NSString *)returns_name returns_account:(NSString *)returns_account reason_info:(NSString *)reason_info goods_info:(NSString *)goods_info returns_goods_images:(NSString *)returns_goods_images returns_card_num:(NSString *)returns_card_num returns_method:(NSString *)returns_method store_name:(NSString *)store_name store_address:(NSString *)store_address user_name:(NSString *)user_name user_tel:(NSString *)user_tel logistics_area:(NSString *)logistics_area logistics_address:(NSString *)logistics_address order_address_id:(NSString *)order_address_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_SUBMIT,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:T_API_ORDER_RETURN_SUBMIT];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_list_id forKey:@"order_list_id"];
    [webTrans._postRequst setPostValue:reason_code forKey:@"reason_code"];
    [webTrans._postRequst setPostValue:reason_name forKey:@"reason_name"];
    [webTrans._postRequst setPostValue:returns_name forKey:@"returns_name"];
    [webTrans._postRequst setPostValue:returns_account forKey:@"returns_account"];
    [webTrans._postRequst setPostValue:reason_info forKey:@"reason_info"];
    [webTrans._postRequst setPostValue:goods_info forKey:@"goods_info"];
    [webTrans._postRequst setPostValue:returns_goods_images forKey:@"returns_goods_images"];
    [webTrans._postRequst setPostValue:returns_card_num forKey:@"returns_card_num"];
    [webTrans._postRequst setPostValue:returns_method forKey:@"returns_method"];


    
    if ([returns_method isEqualToString:@"1"] || [returns_method isEqualToString:@"3"]) {
        [webTrans._postRequst setPostValue:store_name forKey:@"store_name"];
        [webTrans._postRequst setPostValue:store_address forKey:@"store_address"];
    }
    if ([returns_method isEqualToString:@"2"]) {
        [webTrans._postRequst setPostValue:user_name forKey:@"user_name"];
        [webTrans._postRequst setPostValue:user_tel forKey:@"user_tel"];
        [webTrans._postRequst setPostValue:logistics_area forKey:@"logistics_area"];
        [webTrans._postRequst setPostValue:logistics_address forKey:@"logistics_address"];
        [webTrans._postRequst setPostValue:order_address_id forKey:@"order_address_id"];
    }
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ORDER_RETURN_SUBMIT,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:T_API_ORDER_RETURN_SUBMIT];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];

    if (order_list_id)
    {
         [dic setValue:order_list_id forKey:@"order_list_id"];
    }
    else
    {
         [dic setValue:@"" forKey:@"order_list_id"];
    }
    if (reason_code)
    {
        [dic setValue:reason_code forKey:@"reason_code"];
    }
    else
    {
        [dic setValue:@"" forKey:@"reason_code"];
    }
    if (reason_name)
    {
        [dic setValue:reason_name forKey:@"reason_name"];
    }
    else
    {
        [dic setValue:@"" forKey:@"reason_name"];
    }
    if (returns_name)
    {
         [dic setValue:returns_name forKey:@"returns_name"];
    }
    else
    {
         [dic setValue:@"" forKey:@"returns_name"];
    }
    if (returns_account)
    {
         [dic setValue:returns_account forKey:@"returns_account"];
    }
    else
    {
        [dic setValue:@"" forKey:@"returns_account"];
    }
    if (reason_info)
    {
         [dic setValue:reason_info forKey:@"reason_info"];
    }
    else
    {
        [dic setValue:@"" forKey:@"reason_info"];
    }
    if (goods_info)
    {
         [dic setValue:goods_info forKey:@"goods_info"];
    }
    else
    {
         [dic setValue:@"" forKey:@"goods_info"];
    }
    if (returns_goods_images)
    {
        [dic setValue:returns_goods_images forKey:@"returns_goods_images"];
    }
    else
    {
        [dic setValue:@"" forKey:@"returns_goods_images"];
    }
    if (returns_card_num)
    {
        [dic setValue:returns_card_num forKey:@"returns_card_num"];
    }
    else
    {
        [dic setValue:@"" forKey:@"returns_card_num"];
    }
    if (returns_method)
    {
         [dic setValue:returns_method forKey:@"returns_method"];
    }
   else
   {
        [dic setValue:returns_method forKey:@"returns_method"];
   }
    
    if ([returns_method isEqualToString:@"1"] || [returns_method isEqualToString:@"3"])
    {
//        [webTrans._postRequst setPostValue:store_name forKey:@"store_name"];
//        [webTrans._postRequst setPostValue:store_address forKey:@"store_address"];
        [dic setValue:store_name forKey:@"store_name"];
        [dic setValue:store_address forKey:@"store_address"];
    }
    if ([returns_method isEqualToString:@"2"]) {
//        [webTrans._postRequst setPostValue:user_name forKey:@"user_name"];
//        [webTrans._postRequst setPostValue:user_tel forKey:@"user_tel"];
//        [webTrans._postRequst setPostValue:logistics_area forKey:@"logistics_area"];
//        [webTrans._postRequst setPostValue:logistics_address forKey:@"logistics_address"];
//        [webTrans._postRequst setPostValue:order_address_id forKey:@"order_address_id"];
        [dic setValue:user_name forKey:@"user_name"];
        [dic setValue:user_tel forKey:@"user_tel"];
        [dic setValue:logistics_area forKey:@"logistics_area"];
        [dic setValue:logistics_address forKey:@"logistics_address"];
        [dic setValue:order_address_id forKey:@"order_address_id"];
    }
    
    NSLog(@"dic = %@" , dic);
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//取消退货
-(void)cancel_return_goods:(id)transdel sales_return_id:(NSString *)sales_return_id {
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CANCEL_RETURN_GOODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:T_API_CANCEL_RETURN_GOODS];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:sales_return_id forKey:@"sales_return_id"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CANCEL_RETURN_GOODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:T_API_CANCEL_RETURN_GOODS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:sales_return_id forKey:@"sales_return_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 输入快递单号
- (void)API_order_InputExpress:(id)transdel sales_return_id:(NSString *)sales_return_id express_name:(NSString *)express_name express_num:(NSString *)express_num{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_RETURN_ORDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_PS_RETURN_ORDER];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:express_name forKey:@"express_name"];
    [webTrans._postRequst setPostValue:express_num forKey:@"express_num"];
    [webTrans._postRequst setPostValue:sales_return_id forKey:@"sales_return_id"];

    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_RETURN_ORDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_PS_RETURN_ORDER];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:express_name forKey:@"express_name"];
    [dic setValue:express_num forKey:@"express_num"];
    [dic setValue:sales_return_id forKey:@"sales_return_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//购物车手动改变数量
- (void)API_cart_change_count:(id)transdel cart_id:(NSString *)cart_id num:(NSString *)num {
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_CART_UPDATE_GOODS_NUM,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_PS_CART_UPDATE_GOODS_NUM];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:cart_id forKey:@"cart_id"];
    [webTrans._postRequst setPostValue:num forKey:@"num"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_CART_UPDATE_GOODS_NUM,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_PS_CART_UPDATE_GOODS_NUM];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:cart_id forKey:@"cart_id"];
    [dic setValue:num forKey:@"num"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark ------------------------------首页城市界面选择配送方式api
//  城市列表
- (void)API_RegionCityList:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_REGION_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_REGION_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_REGION_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_REGION_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
// 城市配送方式
- (void)API_RegionCityPattern:(id)transdel region_id:(NSString *)region_id{
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_PS_REGION_PATTERN];
    NSString *requestPort = BASE_URL;
    PSPatternObj *webTrans = [[PSPatternObj alloc] init:transdel nApiTag:t_API_PS_REGION_PATTERN];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:region_id forKey:@"region_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
// 城市对应区县,区县对应街道
- (void)API_RegionCountry_StreetList:(id)transdel p_id:(NSString *)p_id{
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_PS_COUNTRY_STREET_LIST];
    NSString *requestPort = BASE_URL;
    PSCountryStreetObj *webTrans = [[PSCountryStreetObj alloc] init:transdel nApiTag:t_API_PS_COUNTRY_STREET_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:p_id forKey:@"p_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
// 街道对应门店
- (void)API_RegionStreet_SupermarketList:(id)transdel region_id:(NSString *)region_id street_id:(NSString *)street_id{
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_PS_STREET_SUPERMARKET_LIST];
    NSString *requestPort = BASE_URL;
    PSStreetSupermarketObj *webTrans = [[PSStreetSupermarketObj alloc] init:transdel nApiTag:t_API_PS_STREET_SUPERMARKET_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:region_id forKey:@"region_id"];
    [dic setValue:street_id forKey:@"street_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
// 自提门店
- (void)API_RegionPickUpSuperMarketList:(id)transdel region_id:(NSString *)region_id page:(NSString *)page limit:(NSString *)limit{
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_PU_SUPERMARKET_LIST];
    NSString *requestPort = BASE_URL;
    PSPickupSupermarketObj *webTrans = [[PSPickupSupermarketObj alloc] init:transdel nApiTag:t_API_PU_SUPERMARKET_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:region_id forKey:@"region_id"];
    [dic setValue:page forKey:@"page"];
    [dic setValue:limit forKey:@"limit"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)API_RegionBuCode:(id)transdel region_id:(NSString *)region_id{
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_PS_REGION_BUCODE];
    NSString *requestPort = BASE_URL;
    BuCodeObj *webTrans = [[BuCodeObj alloc] init:transdel nApiTag:t_API_PS_REGION_BUCODE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,region_id];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (region_id) {
        [dic setValue:region_id forKey:@"region_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
// 优惠券列表
- (void)API_MyCouponList:(id)transdel Type:(int)type Page:(NSString *)page
{
    /*
      NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_REGION_COUPON_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_REGION_COUPON_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];

    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    NSString *typeCoupon;
    if (type == 0) {
        typeCoupon = @"can_use";
    }else{
        typeCoupon = @"history";
    }
    [webTrans._postRequst setPostValue:typeCoupon forKey:@"type"];
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [webTrans._postRequst setPostValue:@"5" forKey:@"limit"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_REGION_COUPON_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_REGION_COUPON_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString *typeCoupon;
    if (type == 0) {
        typeCoupon = @"can_use";
    }else{
        typeCoupon = @"history";
    }
    [dic setValue:typeCoupon forKey:@"type"];
    [dic setValue:page forKey:@"page"];
    [dic setValue:@"10" forKey:@"limit"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//   goods/list  商品列表
- (void)buy_getGoodsList:(id)transdel type:(NSString *)type page_type:(NSString *)page_type bu_id:(NSString *)bu_id bu_brand_id:(NSString *)bu_brand_id bu_category_id:(NSString *)bu_category_id bu_goods_id:(NSString *)bu_goods_id dm_id:(NSString *)dm_id page:(NSString *)page limit:(NSString *)limit order:(NSString *)order tag_id:(NSString *)tag_id ApiTag:(int)tag key:(NSString *)key is_stock:(NSString *)is_stock
{

    //门店编码
    NSString *bu_code = [[NSUserDefaults standardUserDefaults]objectForKey:@"bu_code"];
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_BUY_PLATFORM_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id,bu_code];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:tag];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (type) {
//        [webTrans._postRequst setPostValue:type forKey:@"type"];
        [dic setValue:type forKey:@"type"];
    }
    if (page_type) {
        //        [webTrans._postRequst setPostValue:page_type forKey:@"page_type"];
        [dic setValue:page_type forKey:@"page_type"];
    }
    if (bu_id) {
//        [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
        [dic setValue:bu_id forKey:@"bu_id"];
    }
    if (bu_brand_id) {
//        [webTrans._postRequst setPostValue:bu_brand_id forKey:@"bu_brand_id"];
        [dic setValue:bu_brand_id forKey:@"bu_brand_id"];
    }
    if (bu_category_id) {
//        [webTrans._postRequst setPostValue:bu_category_id forKey:@"bu_category_id"];
        [dic setValue:bu_category_id forKey:@"bu_category_id"];
    }
    if (bu_goods_id) {
//        [webTrans._postRequst setPostValue:bu_goods_id forKey:@"bu_goods_id"];
        [dic setValue:bu_goods_id forKey:@"bu_goods_id"];
    }
    if (dm_id) {
//        [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
        [dic setValue:dm_id forKey:@"dm_id"];
    }
    if (page) {
//        [webTrans._postRequst setPostValue:page forKey:@"page"];
        [dic setValue:page forKey:@"page"];
    }
    if (limit) {
//        [webTrans._postRequst setPostValue:limit forKey:@"limit"];
        [dic setValue:limit forKey:@"limit"];
    }
    if (order) {
//        [webTrans._postRequst setPostValue:order forKey:@"order"];
        [dic setValue:order forKey:@"order"];
    }
    if (tag_id) {
//        [webTrans._postRequst setPostValue:tag_id forKey:@"tag_id"];
        [dic setValue:tag_id forKey:@"tag_id"];
    }
    if (key) {
        //        [webTrans._postRequst setPostValue:key forKey:@"key"];
        [dic setValue:key forKey:@"key"];
    }
    if (is_stock) {
        [dic setValue:is_stock forKey:@"is_stock"];
    }
    webTrans._postRequst = strurl;
//    NSLog(@"%@",dic);
//    NSLog(@"%@",strurl);
//    NSLog(@"session_id = %@",[UserAccount instance].session_id);
//    NSLog(@"region_id = %@",[UserAccount instance].region_id);
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

- (void)getSearchGooosList:(id)transdel key:(NSString *)key bu_id:(NSString *)bu_id order:(NSString *)order page:(NSString *)page limit:(NSString *)limit{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_SEARCH_GOODS_LIST];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_SEARCH_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    if (key) {
        [webTrans._postRequst setPostValue:key forKey:@"key"];
    }
    if (bu_id) {
        [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
    }

    if (page) {
        [webTrans._postRequst setPostValue:page forKey:@"page"];
    }
    if (limit) {
        [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    }
    if (order) {
        [webTrans._postRequst setPostValue:order forKey:@"order"];
    }

    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SEARCH_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_SEARCH_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (key) {
//        [webTrans._postRequst setPostValue:key forKey:@"key"];
        [dic setValue:key forKey:@"key"];
    }
    if (bu_id) {
//        [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
        [dic setValue:bu_id forKey:@"bu_id"];
    }
    
    if (page) {
//        [webTrans._postRequst setPostValue:page forKey:@"page"];
        [dic setValue:page forKey:@"page"];
    }
    if (limit) {
//        [webTrans._postRequst setPostValue:limit forKey:@"limit"];
        [dic setValue:limit forKey:@"limit"];
    }
    if (order) {
//        [webTrans._postRequst setPostValue:order forKey:@"order"];
        [dic setValue:order forKey:@"order"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

-(void)get_DM_Info:(id)transdel DMId:(NSString*)dm_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_DM_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DmMainTopTransObj *webTrans = [[DmMainTopTransObj alloc] init:transdel nApiTag:t_API_PS_DM_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    /* set param
    [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
    [webTrans._postRequst setPostValue:@"1" forKey:@"page"];
    [webTrans._postRequst setPostValue:@"100" forKey:@"limit"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_DM_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DmMainTopTransObj *webTrans = [[DmMainTopTransObj alloc] init:transdel nApiTag:t_API_PS_DM_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:dm_id,@"dm_id" ,@"1" ,@"page" ,@"100" , @"limit", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 获取push内容API_PS_PUSH_INFO
- (void)get_Push_Info:(id)transdel PushId:(NSString *)pushId SetType:(NSString *)type{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PUSH_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DmPushNetTransObj *webTrans = [[DmPushNetTransObj alloc] init:transdel nApiTag:t_API_PS_PUSH_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    /* set param
    
    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    [webTrans._postRequst setPostValue:pushId forKey:@"push_id"];
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PUSH_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DmPushNetTransObj *webTrans = [[DmPushNetTransObj alloc] init:transdel nApiTag:t_API_PS_PUSH_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserAccount instance].region_id,@"region_id" ,pushId ,@"push_id" ,type , @"type", nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([UserAccount instance].region_id)
    {
        [dic setObject:[UserAccount instance].region_id forKey:@"region_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"region_id"];
    }
    if (pushId)
    {
        [dic setObject:pushId forKey:@"pushId"];
    }
    else
    {
        [dic setObject:@"" forKey:@"pushId"];
    }
    if (type)
    {
        [dic setObject:type forKey:@"type"];
    }
    else
    {
        [dic setObject:@"" forKey:@"type"];
    }

    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 修改提货时间
- (void)get_PickUp_Time:(id)transdel ReginId:(NSString *)region_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PICK_UP_TIME_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_PICK_UP_TIME_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PS_PICK_UP_TIME_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CommonArrayObj *webTrans = [[CommonArrayObj alloc] init:transdel nApiTag:t_API_PS_PICK_UP_TIME_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if ([UserAccount instance].region_id)
    {
        [dic setObject:[UserAccount instance].region_id forKey:@"region_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"region_id"];
    
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

#pragma mark - 搜索
- (void)get_Category_Screen_list:(id)transdel type:(NSString *)type bu_brand_id:(NSString *)bu_brand_id tag_id:(NSString *)tag_id key:(NSString *)key
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CATEGORY_SCREEN_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NewCategoryNetTransObj *webTrans = [[NewCategoryNetTransObj alloc] init:transdel nApiTag:t_API_CATEGORY_SCREEN_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    set param
    
    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    [webTrans._postRequst setPostValue:bu_brand_id forKey:@"bu_brand_id"];
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    [webTrans._postRequst setPostValue:tag_id forKey:@"tag_id"];
    [webTrans._postRequst setPostValue:key forKey:@"key"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CATEGORY_SCREEN_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NewCategoryNetTransObj *webTrans = [[NewCategoryNetTransObj alloc] init:transdel nApiTag:t_API_CATEGORY_SCREEN_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"strurl = %@" , strurl);
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserAccount instance].region_id,@"region_id" ,bu_brand_id ,@"bu_brand_id" ,type , @"type",tag_id , @"tag_id",key ,@"key", nil];
//
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserAccount instance].region_id,@"region_id" , nil];
    if (bu_brand_id)
    {
        [dic setObject:bu_brand_id forKey:@"bu_brand_id"];
    }
    if (tag_id)
    {
        [dic setObject:tag_id forKey:@"tag_id"];
    }
    if (type)
    {
        [dic setObject:type forKey:@"type"];
    }
    if (key)
    {
        [dic setObject:key forKey:@"key"];
    }
    NSLog(@"type = %@" , type);
    NSLog(@"bu_brand_id = %@" , bu_brand_id);
    NSLog(@"region_id = %@" , [UserAccount instance].region_id);
    NSLog(@"tag_id = %@" , tag_id);
    NSLog(@"key = %@" , key);
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:webTrans._postDic];
}


- (void)getKeyWordsSearchList:(id)transdel keyWord:(NSString *)key{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_SEARCH_KEY_WORDS_LIST];
    NSString *requestPort = BASE_URL;
    KeyWordTrans * webTrans = [[KeyWordTrans alloc] init:transdel nApiTag:t_API_SEARCH_KEY_WORDS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    if (key) {
        [webTrans._postRequst setPostValue:key forKey:@"key"];
    }
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SEARCH_KEY_WORDS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    KeyWordTrans *webTrans = [[KeyWordTrans alloc] init:transdel nApiTag:t_API_SEARCH_KEY_WORDS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (key) {
//        [webTrans._postRequst setPostValue:key forKey:@"key"];
        [dic setValue:key forKey:@"key"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)getHotWordsSearchList:(id)transdel{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_SEARCH_HOT_WORDS_LIST];
    NSString *requestPort = BASE_URL;
    HotWordsTrans * webTrans = [[HotWordsTrans alloc] init:transdel nApiTag:t_API_SEARCH_HOT_WORDS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SEARCH_HOT_WORDS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    HotWordsTrans *webTrans = [[HotWordsTrans alloc] init:transdel nApiTag:t_API_SEARCH_HOT_WORDS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:bu_brand_id , @"bu_brand_id" ,type ,@"type" , tag_id,@"tag_id" , key, @"key",nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
- (void)getKeySearchGoodsList:(id)transdel type:(NSString *)type key:(NSString *)key category_code:(NSString *)category_code is_parent_category:(NSInteger)is_parent_category brand_name:(NSString *)brand_name  order:(NSString *)order page:(NSString *)page limit:(NSString *)limit{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_SEARCH_KEY_GOODS_LIST];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_SEARCH_KEY_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    if (key) {
        [webTrans._postRequst setPostValue:key forKey:@"key"];
    }
    if (category_code) {
        [webTrans._postRequst setPostValue:category_code forKey:@"category_code"];
    }
    if (is_parent_category) {
        [webTrans._postRequst setPostValue:[NSNumber numberWithInteger: is_parent_category] forKey:@"is_parent_category"];
    }
    if (brand_name) {
        [webTrans._postRequst setPostValue:brand_name forKey:@"brand_name"];
    }
    if (page) {
        [webTrans._postRequst setPostValue:page forKey:@"page"];
    }
    if (limit) {
        [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    }
    if (order) {
        [webTrans._postRequst setPostValue:order forKey:@"order"];
    }
    
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_SEARCH_KEY_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_SEARCH_KEY_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (type)
    {
        [dic setValue:type forKey:@"type"];
    }
    if (key) {
//        [webTrans._postRequst setPostValue:key forKey:@"key"];
        [dic setValue:key forKey:@"key"];
    }
    if (category_code) {
//        [webTrans._postRequst setPostValue:category_code forKey:@"category_code"];
        [dic setValue:category_code forKey:@"category_code"];
    }
    if (is_parent_category) {
//        [webTrans._postRequst setPostValue:[NSNumber numberWithInteger: is_parent_category] forKey:@"is_parent_category"];
        [dic setValue:[NSNumber numberWithInteger: is_parent_category] forKey:@"is_parent_category"];
    }
    if (brand_name) {
//        [webTrans._postRequst setPostValue:brand_name forKey:@"brand_name"];
        [dic setValue:brand_name forKey:@"brand_name"];
    }
    if (page) {
//        [webTrans._postRequst setPostValue:page forKey:@"page"];
        [dic setValue:page forKey:@"page"];
    }
    if (limit) {
//        [webTrans._postRequst setPostValue:limit forKey:@"limit"];
        [dic setValue:limit forKey:@"limit"];
    }
    if (order) {
//        [webTrans._postRequst setPostValue:order forKey:@"order"];
        [dic setValue:order forKey:@"order"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)get_Key_Category_Screen_list:(id)transdel type:(NSString *)type bu_brand_id:(NSString *)bu_brand_id tag_id:(NSString *)tag_id key:(NSString *)key{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_KEY_CATEGORY_SCREEN_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SearchCategoryNetTransObj *webTrans = [[SearchCategoryNetTransObj alloc] init:transdel nApiTag:t_API_KEY_CATEGORY_SCREEN_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [webTrans._postRequst setPostValue:bu_brand_id forKey:@"bu_brand_id"];
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    [webTrans._postRequst setPostValue:tag_id forKey:@"tag_id"];
    [webTrans._postRequst setPostValue:key forKey:@"key"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_KEY_CATEGORY_SCREEN_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SearchCategoryNetTransObj *webTrans = [[SearchCategoryNetTransObj alloc] init:transdel nApiTag:t_API_KEY_CATEGORY_SCREEN_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:bu_brand_id , @"bu_brand_id" ,type ,@"type" , tag_id,@"tag_id" , key, @"key",nil];
    NSMutableDictionary * dic1 = [NSMutableDictionary dictionary];
    if (bu_brand_id) {
        [dic1 setValue:bu_brand_id forKey:@"bu_brand_id"];
    }
    if (type) {
        [dic1 setValue:type forKey:@"type"];
    }
    if (tag_id) {
        [dic1 setValue:tag_id forKey:@"tag_id"];
    }
    if (key) {
        [dic1 setValue:key forKey:@"key"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic1;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic1];
}
- (void)get_Key_Brand_Screen_list:(id)transdel category_code:(NSString *)category_code key:(NSString *)key is_parent_category:(NSInteger)is_parent_category
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_KEY_BRAND_SCREEN_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BrandNetTrans *webTrans = [[BrandNetTrans alloc] init:transdel nApiTag:t_API_KEY_BRAND_SCREEN_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [webTrans._postRequst setPostValue:category_code forKey:@"category_code"];
    [webTrans._postRequst setPostValue:[NSNumber numberWithInteger: is_parent_category] forKey:@"is_parent_category"];
    [webTrans._postRequst setPostValue:key forKey:@"key"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_KEY_BRAND_SCREEN_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BrandNetTrans *webTrans = [[BrandNetTrans alloc] init:transdel nApiTag:t_API_KEY_BRAND_SCREEN_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:category_code , @"category_code" ,[NSNumber numberWithInteger: is_parent_category] ,@"is_parent_category" , key,@"key" ,nil];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (category_code)
    {
        [dic setValue:category_code forKey:@"category_code"];
    }
    if ([NSNumber numberWithInteger: is_parent_category])
    {
        [dic setValue:[NSNumber numberWithInteger: is_parent_category] forKey:@"is_parent_category"];
    }
    if (key)
    {
        [dic setValue:key forKey:@"key"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark - 积分卡绑定
-(void)get_Card_Binding:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CARD_BINDING,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IdVerifiedNetTransObj *webTrans = [[IdVerifiedNetTransObj alloc] init:transdel nApiTag:t_API_CARD_BINDING];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    //NSLog(@"%@",strurl);
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
*/
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CARD_BINDING,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IdVerifiedNetTransObj *webTrans = [[IdVerifiedNetTransObj alloc] init:transdel nApiTag:t_API_CARD_BINDING];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:id_no , @"id_no" ,nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
-(void)get_User_Card_Validation:(id)transdel IdNumber:(NSString *)id_no
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CARD_VALIDATION,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ValidationNetTransObj *webTrans = [[ValidationNetTransObj alloc] init:transdel nApiTag:t_API_CARD_VALIDATION];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    NSLog(@"%@",strurl);
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:id_no forKey:@"id_no"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CARD_VALIDATION,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ValidationNetTransObj *webTrans = [[ValidationNetTransObj alloc] init:transdel nApiTag:t_API_CARD_VALIDATION];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:id_no , @"id_no" ,nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}
-(void)get_Binding_Card:(id)transdel Captcha:(NSInteger)captcha Info:(NSString *)cardinfo
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BIND_VIPCARD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BindCardNetTransObj *webTrans = [[BindCardNetTransObj alloc] init:transdel nApiTag:t_API_BIND_VIPCARD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    NSLog(@"%@",strurl);
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:[NSNumber numberWithInteger:captcha] forKey:@"captcha"];
    [webTrans._postRequst setPostValue:cardinfo forKey:@"cardinfo"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];

     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BIND_VIPCARD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BindCardNetTransObj *webTrans = [[BindCardNetTransObj alloc] init:transdel nApiTag:t_API_BIND_VIPCARD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:captcha] , @"captcha" ,cardinfo, @"cardinfo",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([NSNumber numberWithInteger:captcha])
    {
        [dic setObject:[NSNumber numberWithInteger:captcha] forKey:@"captcha"];
        
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];

    }
    if (cardinfo)
    {
        [dic setObject:cardinfo forKey:@"cardinfo"];
    }
    else
    {
        [dic setObject:@"" forKey:@"cardinfo"];
        
    }
    
    NSLog(@"%@",strurl);

    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
@end
