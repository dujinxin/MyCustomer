//
//  NetTrans.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "NetTrans.h"
#import "NetTransObj.h"
#import "Reachability.h"
#import "SuccessOrFailEntity.h"
#import "UserLoginEntity.h"
#import "CartEntity.h"
#import "GoodsEntity.h"
#import "OrderEntity.h"
#import "UserRegisterEntity.h"
#import "UserUploadImageEntity.h"
#import "UserInfoEntity.h"
#import "DmEntity.h"
#import "BuListEntity.h"
#import "CateBrandEntity.h"
#import "CategoryGoodsEntity.h"
#import "BrandEntity.h"
#import "PromotionEntity.h"
#import "CommentEntity.h"
#import "GoodDetailEntity.h"
#import "GoodsStatusEntity.h"
#import "VersionEntiy.h"
#import "DMGoodsEntity.h"
#import "DonationEntity.h"
#import "FeedBackListEntity.h"
#import "ActivityEntity.h"
#import "CategoryEntity.h"
#import "ThemeEntity.h"
//#import "NewThemeEntity.h"
#import "GoodSaoDetailEntity.h"
#import "ShakeEntity.h"

#import "PromotionShareEntity.h"
#import "GoodShareEntity.h"
#import "SignInEntity.h"
#import "CateBrandEntity.h"

#import "YHCardBag.h"
#import "FixedToSnapUpEntity.h"
#import "ForgetPasswordEntity.h"
#import "CardBindStatusEntity.h"
#import "StarPostCardEntity.h"

static NetTrans* trans = nil;
@implementation NetTrans
@synthesize _arrRequst,_arrTongJiKey;
@synthesize netWorkBlock;


+ (NetTrans*) getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       trans = [[NetTrans alloc] init];
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
    [request setUseCookiePersistence:YES];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    return request;
}

-(ASIFormDataRequest *)post:(NSString*)strUrl
{
    NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    if (networkStatus == NotReachable)
    {
        [[iToast makeText:@"网络不可用，请检查网络设置！"]show];
        //
        return NULL;
    }
    
    
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.timeOutSeconds = 30;
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(responseSuccess:)];
    [request setRequestMethod:@"POST"];
    [request setPostFormat:ASIURLEncodedPostFormat];
    [request setUseCookiePersistence:YES];
    //测试ASI
//    [request setShouldAttemptPersistentConnection:NO];
//    [request setValidatesSecureCertificate:NO];
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
#pragma mark -/*用户部分*/

/*监测新版本*/
//版本监测
//agent_id	TRUE	integer	系统类型	1为android,2为iphone
//type	TRUE	string	类型	consumer为消费者,clerk店员

-(void)API_version_check:(id)transdel AgentID:(NSString*)agentID   Type:(NSString*)type
{
    //NSString *requestName = API_VERSION;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_VERSION,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[VersionTrans alloc] init:transdel nApiTag:t_API_VERSION];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:agentID , @"agent_id",type ,@"type",nil];
    if (agentID)
    {
        [dic setObject:agentID forKey:@"agent_id"];
    }
    else
    {
        [dic setObject:@"" forKey:@"agent_id"];
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

/* 登陆*/
-(void)user_login:(id)transdel UserName:(NSString*)user_name Password:(NSString*)password
{
    NSString *requestName = API_USER_PLATFORM_LOGIN_API;
    NSString *requestPort = BASE_URL;
    UserTrans *webTrans = [[UserTrans alloc] init:transdel nApiTag:t_API_USER_LOGIN_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:name , @"user_name",password ,@"password",nil];
    if (user_name)
    {
        [dic setValue:user_name forKey:@"user_name"];
    }
    else
    {
        [dic setValue:@"" forKey:@"user_name"];
    }
    
    if (password)
    {
        [dic setValue:password forKey:@"password"];
    }
    else
    {
        [dic setValue:@"" forKey:@"password"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/* 获取验证码*/
-(void)user_getVercode:(id)transdel Mobile:(NSString*)mobile setType:(NSString*)type

{
   /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_VERCODE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_VERCODE_API]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        return;
    }
    webTrans._postRequst.delegate = webTrans;
     set param
    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_VERCODE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_VERCODE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
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
//    NSLog(@"%@\n%@\n%@",strurl,mobile,type);
   
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
/*验证验证码*/
-(void)user_validation:(id)transdel captcha:(NSString*)captcha mobile:(NSString*)mobile
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_VALIDATION_VERCODE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_VALIDATION_VERCODE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (captcha)
    {
        [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];
    }
    
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}
//修改联系方式
-(void)user_modify_contact:(id)transdel mobile:(NSString *)mobile captcha:(NSString *)captcha
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MODIFY_CONTACT_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_MODIFY_CONTACT_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    if (captcha)
    {
        [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];


}
//绑定邮箱登录时，没有手机号的用户的手机号
-(void)user_login_bindMobile:(id)transdel mobile:(NSString *)mobile captcha:(NSString *)captcha
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BIND_MOBILE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BIND_MOBILE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    if (captcha)
    {
        [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];
    }
    NSLog(@"%@",strurl);
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];



}
////会员卡绑定
//-(void)user_member_bindCard:(id)transdel mobile:(NSString *)mobile captcha:(NSString *)captcha card_no:(NSString *)card_no
//{
//
//
//    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MEMBER_BIND_CARD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
//    NSString *requestPort = BASE_URL;
//    
//    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_MEMBER_BIND_CARD_API];
//    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
//    if (mobile)
//    {
//        [dic setObject:mobile forKey:@"mobile"];
//    }
//    else
//    {
//        [dic setObject:@"" forKey:@"mobile"];
//    }
//    if (captcha)
//    {
//        [dic setObject:captcha forKey:@"captcha"];
//    }
//    else
//    {
//        [dic setObject:@"" forKey:@"captcha"];
//    }
//    if (card_no)
//    {
//        [dic setObject:card_no forKey:@"card_no"];
//    }
//    else
//    {
//        [dic setObject:@"" forKey:@"card_no"];
//    }
//    webTrans._postRequst = strurl;
//    webTrans._postDic = dic;
//    webTrans._uinet = transdel;
//    [webTrans request:strurl andDic:dic];
//
//
//
//
//}
//登录界面忘记密码
-(void)user_forget_password:(id)transdel user_name:(NSString *)user_name
{

    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_LOGIN_FORGET_PASSWORD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    ForgetPasswordTrans *webTrans = [[ForgetPasswordTrans alloc] init:transdel nApiTag:t_API_USER_LOGIN_FORGET_PASSWORD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (user_name)
    {
        [dic setObject:user_name forKey:@"user_name"];
    }
    else
    {
        [dic setObject:@"" forKey:@"user_name"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];


}
//登录界面忘记密码第二步
-(void)user_forget_modify_password:(id)transdel mobile:(NSString *)mobile type:(NSString *)type user_name:(NSString *)user_name captcha:(NSString *)captcha new_password:(NSString *)new_password confirm_password:(NSString *)confirm_password
{

    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_LOGIN_FORGET_MODIFY_PASSWORD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_LOGIN_FORGET_MODIFY_PASSWORD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"%@",strurl);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    if (type)
    {
        [dic setObject:type forKey:@"type"];
    }
    else
    {
        [dic setObject:@"" forKey:@"type"];
    }
    if (user_name)
    {
        [dic setObject:user_name forKey:@"user_name"];
    }
    else
    {
        [dic setObject:@"" forKey:@"user_name"];
    }
    if (captcha)
    {
        [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];
    }
    if (new_password)
    {
        [dic setObject:new_password forKey:@"new_password"];
    }
    else
    {
        [dic setObject:@"" forKey:@"new_password"];
    }
    if (confirm_password)
    {
        [dic setObject:confirm_password forKey:@"confirm_password"];
    }
    else
    {
        [dic setObject:@"" forKey:@"confirm_password"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];



}
/* 注册*/
-(void)user_register:(id)transdel Mobile:(NSString*)mobile passWordCode:(NSString*)password Captcha:(NSString*)captcha Id:(NSString*)id_no recommend_mobile:(NSString *)recommend_mobile
{
    /*
    NSString *requestName = API_USER_PLATFORM_REGISTER_API;
    NSString *requestPort = BASE_URL;
    
    UserRegisterTrans *webTrans = [[UserRegisterTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_REGISTER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
     set param
    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    [webTrans._postRequst setPostValue:password forKey:@"password"];
    [webTrans._postRequst setPostValue:captcha forKey:@"captcha"];
    
    if (id_no) {
        [webTrans._postRequst setPostValue:id_no forKey:@"id_no"];
    }
    
    if (recommend_mobile) {
        [webTrans._postRequst setPostValue:recommend_mobile forKey:@"recommend_mobile"];
    }
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName = API_USER_PLATFORM_REGISTER_API;
    NSString *requestPort = BASE_URL;
    
    UserRegisterTrans *webTrans = [[UserRegisterTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_REGISTER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",password ,@"password",captcha ,@"captcha", nil];// , id_no , @"id_no" , recommend_mobile , @"recommend_mobile"
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    
    if (password)
    {
        [dic setObject:password forKey:@"password"];
    }
    else
    {
        [dic setObject:@"" forKey:@"password"];
    }
    

    
    if (recommend_mobile)
    {
        //        [webTrans._postRequst setPostValue:recommend_mobile forKey:@"recommend_mobile"];
        [dic setObject:recommend_mobile forKey:@"recommend_mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"recommend_mobile"];
    }
    
    if (captcha)
    {
         [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
         [dic setObject:@"" forKey:@"captcha"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 积分卡绑定注册
-(void)user_register:(id)transdel Mobile:(NSString*)mobile passWordCode:(NSString*)password Captcha:(NSString*)captcha IdNumber:(NSString *)idNumber recommend_mobile:(NSString *)recommend_mobile card_no:(NSString *)card_no
{
    /*
    NSString *requestName = API_USER_PLATFORM_REGISTER_IDCARD_API;
    NSString *requestPort = BASE_URL;
    
    UserRegisterTrans *webTrans = [[UserRegisterTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_REGISTER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    set param
    [webTrans._postRequst setPostValue:idNumber forKey:@"id_no"];
    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    [webTrans._postRequst setPostValue:password forKey:@"password"];
    [webTrans._postRequst setPostValue:captcha forKey:@"captcha"];
    
    if (recommend_mobile) {
        [webTrans._postRequst setPostValue:recommend_mobile forKey:@"recommend_mobile"];
    }
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName = API_USER_PLATFORM_REGISTER_IDCARD_API;
    NSString *requestPort = BASE_URL;
    
    UserRegisterTrans *webTrans = [[UserRegisterTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_REGISTER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:idNumber , @"id_no",mobile ,@"mobile",password ,@"password",captcha , @"captcha", nil];// , id_no , @"id_no" , recommend_mobile , @"recommend_mobile"
    if (idNumber)
    {
        [dic setObject:idNumber forKey:@"id_no"];
    }
    else
    {
        [dic setObject:@"" forKey:@"id_no"];
    }
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    if (password)
    {
        [dic setObject:password forKey:@"password"];
    }
    else
    {
        [dic setObject:@"" forKey:@"password"];
    }
    
    if (captcha)
    {
        [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];
    }
    if (recommend_mobile)
    {
        //        [webTrans._postRequst setPostValue:recommend_mobile forKey:@"recommend_mobile"];
        [dic setObject:recommend_mobile forKey:@"recommend_mobile"];
    }
    if (card_no)
    {
        [dic setObject:card_no forKey:@"card_no"];
    }
    else
    {
        [dic setObject:@"" forKey:@"card_no"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/* 重置密码 */
- (void)user_resetPassword:(id)transdel :(NSString *)newpassword
{
     /*
    //NSString *requestName = API_USER_PLATFORM_RESET_PASSWORD_API;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_RESET_PASSWORD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_RESET_PASSWORD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    set param
    [webTrans._postRequst setPostValue:newpassword forKey:@"new_password"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
      */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_RESET_PASSWORD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_RESET_PASSWORD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//’WithObjectsAndKeys:newpassword , @"new_password" ,nil];
    if (newpassword)
    {
        [dic setObject:newpassword forKey:@"new_password"];
    }
    else
    {
         [dic setObject:@"" forKey:@"new_password"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/*找回密码*/
- (void)user_findBackPassword:(id)transdel Mobile:(NSString*)mobile Captcha:(NSString*)captcha
{
    /*
    NSString *requestName = API_USER_PLATFORM_FINDBACK_PWD_API;
    NSString *requestPort = BASE_URL;
    UserTrans *webTrans = [[UserTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_FINDBACK_PWD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
     set param
    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    [webTrans._postRequst setPostValue:captcha forKey:@"captcha"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    
    NSString *requestName = API_USER_PLATFORM_FINDBACK_PWD_API;
    NSString *requestPort = BASE_URL;
    UserTrans *webTrans = [[UserTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_FINDBACK_PWD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    //    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    //    [webTrans._postRequst setPostValue:captcha forKey:@"captcha"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",captcha ,@"captcha",nil];
    if (mobile)
    {
        [dic setValue:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setValue:@"" forKey:@"mobile"];
    }
    
    if (captcha)
    {
        [dic setValue:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setValue:@"" forKey:@"captcha"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/* 修改密码 */
- (void)user_modifyPassWord:(id)transdel OldPwd:(NSString *)oldpwd NewPassword:(NSString *)newPassword ConfirmPassWord:(NSString *)confirmPassWord
{
    /*
    //NSString *requestName = API_USER_PLATFORM_MODIFY_PWD_API;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_MODIFY_PWD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_MODIFYINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
   set param
    [webTrans._postRequst setPostValue:oldpwd forKey:@"old_password"];
    [webTrans._postRequst setPostValue:newPassword forKey:@"new_password"];
    [webTrans._postRequst setPostValue:confirmPassWord forKey:@"confirm_password"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_MODIFY_PWD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_MODIFYINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:oldpwd forKey:@"old_password"];
    //    [webTrans._postRequst setPostValue:newPassword forKey:@"new_password"];
    //    [webTrans._postRequst setPostValue:confirmPassWord forKey:@"confirm_password"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:oldpwd , @"old_password",newPassword ,@"new_password",confirmPassWord , @"confirm_password" ,nil];
    if (oldpwd)
    {
        [dic setValue:oldpwd forKey:@"old_password"];
    }
    else
    {
        [dic setValue:@"" forKey:@"old_password"];
    }
    if (newPassword)
    {
        [dic setValue:newPassword forKey:@"new_password"];
    }
    else
    {
        [dic setValue:@"" forKey:@"new_password"];
    }
    if (confirmPassWord)
    {
        [dic setValue:confirmPassWord forKey:@"confirm_password"];
    }
    else
    {
        [dic setValue:@"" forKey:@"confirm_password"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/*上传图片*/
- (void)user_upLoadImage:(id)transdel Type:(NSString *)type Image:(NSString *)imagePath
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_UPLOAD_IMAGE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    //NSString *requestName = API_USER_UPLOAD_IMAGE_API;
    NSString *requestPort = BASE_URL;
    
    UserUploadImageTrans *webTrans = [[UserUploadImageTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_UPLOAD_IMAGE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
     set param
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    [webTrans._postRequst addFile:imagePath forKey:@"image"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_UPLOAD_IMAGE_API, [UserAccount instance].session_id , [UserAccount instance].region_id];
    
    NSString *requestPort = BASE_URL;
    UserUploadImageTrans *webTrans = [[UserUploadImageTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_UPLOAD_IMAGE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:type , @"type", nil];
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
    webTrans._filePath = imagePath;
    [webTrans request:strurl andDic:dic];
}

/*修改个人信息*/
- (void)user_modifyPersonInfo:(id)transdel UserName:(NSString *)username Email:(NSString *)email Mobile:(NSString *)mobile Intro:(NSString *)intro TrueName:(NSString *)trueName Gender:(NSString *)gender PhotoId:(NSString *)photoid ShoppingWall:(NSString *)shoppingwall
{
    /*
    //NSString *requestName = API_USER_PLATFORM_MODIFYINFO_API;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_MODIFYINFO_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_MODIFYINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
     set param
    if (username) {
        [webTrans._postRequst setPostValue:username forKey:@"user_name"];
    }
    if (email){
        [webTrans._postRequst setPostValue:email forKey:@"email"];
    }
    if (mobile) {
        [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    }
    if (intro) {
        [webTrans._postRequst setPostValue:intro forKey:@"intro"];
    }
    if (trueName) {
        [webTrans._postRequst setPostValue:trueName forKey:@"true_name"];
    }
    if (gender) {
        [webTrans._postRequst setPostValue:gender forKey:@"gender"];
    }
    if (photoid) {
        [webTrans._postRequst setPostValue:photoid forKey:@"photo_url"];
    }
    //    [webTrans._postRequst setPostValue:shoppingwall forKey:@"shoppingwall_id"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_MODIFYINFO_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_MODIFYINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (username) {
        //        [webTrans._postRequst setPostValue:username forKey:@"user_name"];
        [dic setObject:username forKey:@"user_name"];
    }
    if (email){
        //        [webTrans._postRequst setPostValue:email forKey:@"email"];
        [dic setObject:email forKey:@"email"];
    }
    if (mobile) {
        //        [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
        [dic setObject:mobile forKey:@"mobile"];
    }
    if (intro) {
        //        [webTrans._postRequst setPostValue:intro forKey:@"intro"];
        [dic setObject:intro forKey:@"intro"];
    }
    if (trueName) {
        //        [webTrans._postRequst setPostValue:trueName forKey:@"true_name"];
        [dic setObject:trueName forKey:@"true_name"];
    }
    if (gender) {
        //        [webTrans._postRequst setPostValue:gender forKey:@"gender"];
        [dic setObject:gender forKey:@"gender"];
    }
    if (photoid) {
        //        [webTrans._postRequst setPostValue:photoid forKey:@"photo_url"];
        [dic setObject:photoid forKey:@"photo_url"];
    }
    NSLog(@"%@",strurl);
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}

// 获取个人信息
- (void)user_getPersonInfo:(id)transdel setUserId:(NSString *)userid
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_PERSONINFO_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    //NSString *requestName = API_USER_PLATFORM_PERSONINFO_API;
    NSString *requestPort = BASE_URL;
    UserInfoTrans *webTrans = [[UserInfoTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_PERSONINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
     set param
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_PERSONINFO_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    UserInfoTrans *webTrans = [[UserInfoTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_PERSONINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:card_no , @"id_no", nil];
    //    [webTrans._postRequst setPostValue:card_no forKey:@"id_no"];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_PERSONINFO_API, [UserAccount instance].session_id , [UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    UserUploadImageTrans *webTrans = [[UserUploadImageTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_PERSONINFO_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:type , @"type", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
//    webTrans._filePath = imagePath;
    [webTrans request:strurl andDic:nil];
     */
}

// 上传deviceToken
- (void)user_uploadDevice_Token:(id)transdel DeviceToken:(NSString *)deviceToken
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_ADDDEVICE_TOKEN,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_ADDDEVICE_TOKEN];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    /* set param
    [webTrans._postRequst setPostValue:deviceToken forKey:@"token"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_ADDDEVICE_TOKEN,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_ADDDEVICE_TOKEN];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:deviceToken forKey:@"token"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:deviceToken , @"token" ,nil];
    if (deviceToken)
    {
        [dic setValue:deviceToken forKey:@"token"];
    }
    else
    {
         [dic setValue:@"" forKey:@"token"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/*绑定会员卡*/
- (void)user_bindMemberCard:(id)transdel CardNumber:(NSString *)card_no Mobile:(NSString *)mobile
{
    /*
    //NSString *requestName = API_USER_PLATFORM_BINDCARD_API;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_BINDCARD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_BINDCARD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    /* set param
    [webTrans._postRequst setPostValue:card_no forKey:@"card_no"];
    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_BINDCARD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_BINDCARD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:card_no , @"id_no", nil];
    if (card_no)
    {
        [dic setValue:card_no forKey:@"id_no"];
    }
    else
    {
         [dic setValue:@"" forKey:@"id_no"];
    }
    //    [webTrans._postRequst setPostValue:card_no forKey:@"id_no"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/*退出登陆*/
- (void)user_loginOut:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_LOGIN_OUT_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    //NSString *requestName = API_USER_PLATFORM_LOGIN_OUT_API;
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_LOGIN_OUT_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_LOGIN_OUT_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    //NSString *requestName = API_USER_PLATFORM_LOGIN_OUT_API;
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_LOGIN_OUT_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}

/*绑定会员卡*/
- (void)user_bindMemberCard:(id)transdel CardNumber:(NSString *)card_no
{
    /*
    //NSString *requestName = API_USER_PLATFORM_BINDCARD_API;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_BINDCARD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_BINDCARD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:card_no forKey:@"id_no"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_PLATFORM_BINDCARD_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_PLATFORM_BINDCARD_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:card_no , @"id_no", nil];
    //    [webTrans._postRequst setPostValue:card_no forKey:@"id_no"];
    if (card_no)
    {
        [dic setValue:card_no forKey:@"id_no"];
    }
    else
    {
        [dic setValue:@"" forKey:@"id_no"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}


/**
 * 意见反馈列表
 */
- (void)API_user_feed_back_list:(id)transdel Page:(NSString *)page
{
    /*
    // NSString *requestName = API_USER_FEED_BACK;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_FADELIST_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    FeedBackListNetTransObj *webTrans = [[FeedBackListNetTransObj alloc] init:transdel nApiTag:t_API_USER_FADELIST_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [webTrans._postRequst setPostValue:@"10" forKey:@"limit"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_FADELIST_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    FeedBackListNetTransObj *webTrans = [[FeedBackListNetTransObj alloc] init:transdel nApiTag:t_API_USER_FADELIST_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:page forKey:@"page"];
    //    [webTrans._postRequst setPostValue:@"10" forKey:@"limit"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:page , @"page" ,@"10"  , @"limit" , nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//意见反馈
-(void)API_user_feed_back:(id)transdel Content:(NSString*)content
{
    /*
    // NSString *requestName = API_USER_FEED_BACK;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_FEED_BACK,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_FEED_BACK];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:content forKey:@"content"];
    
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_USER_FEED_BACK,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_USER_FEED_BACK];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:content forKey:@"content"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:content , @"content" ,nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

#pragma mark -/*促销*/
-(void)API_dm_main_top:(id)transdel DMId:(NSString*)dm_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_DM_MAIN_TOP,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DmMainTopTransObj *webTrans = [[[DmMainTopTransObj alloc] init:transdel nApiTag:t_API_DM_MAIN_TOP] autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
    [webTrans._postRequst setPostValue:@"1" forKey:@"page"];
    [webTrans._postRequst setPostValue:@"100" forKey:@"limit"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_DM_MAIN_TOP,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[DmMainTopTransObj alloc] init:transdel nApiTag:t_API_DM_MAIN_TOP];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:dm_id , @"dm_id", @"1", @"page", @"100" , @"limit" ,nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//首页运营区
-(void)API_main_activity:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_ACTIVITY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ActivityTransObj *webTrans = [[[ActivityTransObj alloc] init:transdel nApiTag:t_API_MAIN_ACTIVITY]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
     
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_ACTIVITY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[ActivityTransObj alloc] init:transdel nApiTag:t_API_MAIN_ACTIVITY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
/*
//首页改版主题区
-(void)API_main_new_theme:(id)transdel
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_NEW_THEME,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NewThemeTransObj*webTrans = [[[NewThemeTransObj alloc] init:transdel nApiTag:t_API_MAIN_NEW_THEME]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    
}
 */

//首页主题区
-(void)API_main_theme:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_THEME,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ThemeTransObj *webTrans = [[[ThemeTransObj alloc] init:transdel nApiTag:t_API_MAIN_THEME]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_THEME,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[ThemeTransObj alloc] init:transdel nApiTag:t_API_MAIN_THEME];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}

//首页分类区
-(void)API_main_category:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_CATYGORY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CategoryTransObj *webTrans = [[[CategoryTransObj alloc] init:transdel nApiTag:t_API_MAIN_CATEGORY]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_CATYGORY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CategoryTransObj *webTrans = [[CategoryTransObj alloc] init:transdel nApiTag:t_API_MAIN_CATEGORY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:type, @"type", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
    
}
-(void)API_speed_entry:(id)transdel type:(NSString*)type
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SPEED_ENTRY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SpeedEntryObj *webTrans = [[[SpeedEntryObj alloc] init:transdel nApiTag:t_API_SPEED_ENTRY]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SPEED_ENTRY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SpeedEntryObj *webTrans = [[SpeedEntryObj alloc] init:transdel nApiTag:t_API_SPEED_ENTRY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:type, @"type", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//首页热销商品区
-(void)API_main_hotGoods:(id)transdel udid:(NSString *)udidString
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_HOTGOODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DMGoodsTrans *webTrans = [[[DMGoodsTrans alloc] init:transdel nApiTag:t_API_MAIN_HOTGOODS]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"热销商品区url:%@",strurl);
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_HOTGOODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[DMGoodsTrans alloc] init:transdel nApiTag:t_API_MAIN_HOTGOODS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (udidString) {
        [dict setValue:udidString forKey:@"device_token"];
    }else{
        [dict setValue:@"" forKey:@"device_token"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dict;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dict];
}

-(void)API_main_launch:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_LAUNCH,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    LaunchTransObj *webTrans = [[[LaunchTransObj alloc] init:transdel nApiTag:t_API_MAIN_LAUNCH]autorelease];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"附加启动页url:%@",strurl);
    
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        //        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    //    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MAIN_LAUNCH,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    LaunchTransObj *webTrans = [[LaunchTransObj alloc] init:transdel nApiTag:t_API_MAIN_LAUNCH];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
-(void)unique_identifier:(id)transdel
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_UNIQUE_IDETIFIDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    UdidTransObj *webTrans = [[UdidTransObj alloc] init:transdel nApiTag:t_API_UNIQUE_IDETIFIDER];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}

//我的商品收藏列表
-(void)getGoodsCollectList:(id)transdel page:(NSInteger)page limit:(NSInteger)limit region_id:(NSString *)region_id type:(NSString *)type
{
    /*
    //NSString *requestName = API_GOODS_COLLECT_LIST;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_GOODS_COLLECT_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    
    webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_GOODS_COLLECT_LIST];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:[NSNumber numberWithInt:limit]
                                forKey:@"limit"];
    [webTrans._postRequst setPostValue:[NSNumber numberWithInt:page]
                                forKey:@"page"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",@"v3/goods/list",[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:t_API_GOODS_COLLECT_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (limit) {
        [dic setValue:[NSNumber numberWithInt:limit] forKey:@"limit"];
    }
    if (page) {
        [dic setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    }
    if (type) {
        [dic setValue:type forKey:@"type"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//我的活动收藏列表
-(void)getPromotionCollectList:(id)transdel page:(NSInteger)page limit:(NSInteger)limit region_id:(NSString *)region_id
{
    /*
    //NSString *requestName = API_PROMOTION_COLLECT_LIST;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PROMOTION_COLLECT_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[DmMainTopTransObj alloc] init:transdel nApiTag:t_API_PROMOTION_COLLECT_LIST];
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:region_id
                                forKey:@"region_id"];
    [webTrans._postRequst setPostValue:[NSNumber numberWithInt:limit]
                                forKey:@"limit"];
    [webTrans._postRequst setPostValue:[NSNumber numberWithInt:page]
                                forKey:@"page"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PROMOTION_COLLECT_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[DmMainTopTransObj alloc] init:transdel nApiTag:t_API_PROMOTION_COLLECT_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:region_id
    //                                forKey:@"region_id"];
    //    [webTrans._postRequst setPostValue:[NSNumber numberWithInt:limit]
    //                                forKey:@"limit"];
    //    [webTrans._postRequst setPostValue:[NSNumber numberWithInt:page]
    //                                forKey:@"page"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:region_id , @"region_id",[NSNumber numberWithInt:limit] , @"limit" ,[NSNumber numberWithInt:page] ,@"page", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark - shake
- (void)shake_info:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ShakeObj * webTrans = NULL;
    
    webTrans = [[ShakeObj alloc] init:transdel nApiTag:t_API_SHAKE_INFO];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    ShakeObj* webTrans = NULL;
    webTrans = [[ShakeObj alloc] init:transdel nApiTag:t_API_SHAKE_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
- (void)shake_doing:(id)transdel shake_id:(NSString *)shake_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_DOING,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    AwardObj * webTrans = NULL;
    
    webTrans = [[AwardObj alloc] init:transdel nApiTag:t_API_SHAKE_DOING];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:shake_id forKey:@"shake_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_DOING,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    AwardObj* webTrans = NULL;
    webTrans = [[AwardObj alloc] init:transdel nApiTag:t_API_SHAKE_DOING];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:shake_id , @"shake_id", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)shake_intergral_exchange:(NSString *)exchange transdel:(id)transdel activity_id:(NSString *)activity_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_INTERGRAL_EXCHANGE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IntergralObj * webTrans = NULL;
    webTrans = [[IntergralObj alloc] init:transdel nApiTag:t_API_SHAKE_INTERGRAL_EXCHANGE];
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:exchange forKey:@"exchange"];
    [webTrans._postRequst setPostValue:activity_id forKey:@"shake_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_INTERGRAL_EXCHANGE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IntergralObj *webTrans = [[IntergralObj alloc] init:transdel nApiTag:t_API_SHAKE_INTERGRAL_EXCHANGE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:exchange , @"exchange",activity_id,@"shake_id",nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)shake_express_area:(NSString *)area address:(NSString *)address name:(NSString *)name mobile:(NSString *)mobile activityId:(NSString *)activityId transdel:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_EXPRESS_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IntergralObj * webTrans = NULL;
    
    webTrans = [[IntergralObj alloc] init:transdel nApiTag:t_API_SHAKE_EXPRESS_ADDRESS];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:area forKey:@"area"];
    [webTrans._postRequst setPostValue:address forKey:@"address"];
    [webTrans._postRequst setPostValue:name forKey:@"name"];
    [webTrans._postRequst setPostValue:mobile forKey:@"mobile"];
    [webTrans._postRequst setPostValue:activityId forKey:@"id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_EXPRESS_ADDRESS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IntergralObj *webTrans = [[IntergralObj alloc] init:transdel nApiTag:t_API_SHAKE_EXPRESS_ADDRESS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary ];//WithObjectsAndKeys:area , @"area",address,@"address",name,@"name",mobile,@"mobile",activityId,@"id",nil];
    if (area)
    {
        [dic setValue:area forKey:@"area"];
    }
    else
    {
        [dic setValue:@"" forKey:@"area"];
    }
    if (address)
    {
        [dic setValue:address forKey:@"address"];
    }
    else
    {
        [dic setValue:@"" forKey:@"address"];
    }
    if (name)
    {
        [dic setValue:name forKey:@"name"];
    }
    else
    {
        [dic setValue:@"" forKey:@"name"];
    }
    if (mobile)
    {
        [dic setValue:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setValue:@"" forKey:@"mobile"];
    }
    if (activityId)
    {
        [dic setValue:activityId forKey:@"id"];
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
- (void)shake_address_list:(id)transdel level:(NSString *)level pid:(NSString *)pid
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@",API_SHAKE_ADDRESD_LIST,[UserAccount instance].session_id];
    NSString *requestPort = BASE_URL;
    AddressObj * webTrans = NULL;
    
    webTrans = [[AddressObj alloc] init:transdel nApiTag:t_API_SHAKE_ADDRESS_LIST];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:level forKey:@"level"];
    [webTrans._postRequst setPostValue:pid forKey:@"pid"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_ADDRESD_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    AddressObj *webTrans = [[AddressObj alloc] init:transdel nApiTag:t_API_SHAKE_ADDRESS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:level , @"level",pid,@"pid",nil];
    if (level)
    {
        [dic setValue:level forKey:@"level"];
    }
    else
    {
        [dic setValue:@"" forKey:@"level"];
    }
    if (pid)
    {
        [dic setValue:pid forKey:@"pid"];
    }
    else
    {
        [dic setValue:@"" forKey:@"pid"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)shake_share_record:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_SHARE_RECORD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IntergralObj * webTrans = NULL;
    
    webTrans = [[IntergralObj alloc] init:transdel nApiTag:t_API_SHAKE_SHARE_RECORD];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_SHARE_RECORD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    IntergralObj *webTrans = [[IntergralObj alloc] init:transdel nApiTag:t_API_SHAKE_SHARE_RECORD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
- (void)shake_award_list:(id)transdel page:(NSString *)page
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_AWARD_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    AwardListObj * webTrans = NULL;
    
    webTrans = [[AwardListObj alloc] init:transdel nApiTag:t_API_SHAKE_AWARD_LIST];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SHAKE_AWARD_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    AwardListObj *webTrans = [[AwardListObj alloc] init:transdel nApiTag:t_API_SHAKE_AWARD_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:page , @"page",nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark - 促销分享
-(void)promotion_share:(id)transdel dm_id:(NSString *)dm_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PROMOTION_SHARE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    PromotionShareObj * webTrans = NULL;
    
    webTrans = [[PromotionShareObj alloc] init:transdel nApiTag:t_API_PROMOTION_SHARE];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"%@",strurl);
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
    //    [webTrans._postRequst setPostValue:level forKey:@"level"];
    //    [webTrans._postRequst setPostValue:pid forKey:@"pid"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_PROMOTION_SHARE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    PromotionShareObj *webTrans = [[PromotionShareObj alloc] init:transdel nApiTag:t_API_PROMOTION_SHARE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:dm_id , @"dm_id" , nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark - 商品详情分享
-(void)goods_share:(id)transdel bu_goods_id:(NSString *)bu_goods_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_GOODS_SHARE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodShareObj * webTrans = NULL;
    
    webTrans = [[GoodShareObj alloc] init:transdel nApiTag:t_API_GOODS_SHARE];
    
    if(webTrans == NULL)
        return;
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"%@",strurl);
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:bu_goods_id forKey:@"bu_goods_id"];
    //    [webTrans._postRequst setPostValue:level forKey:@"level"];
    //    [webTrans._postRequst setPostValue:pid forKey:@"pid"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_GOODS_SHARE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodShareObj *webTrans = [[GoodShareObj alloc] init:transdel nApiTag:t_API_GOODS_SHARE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:bu_goods_id , @"bu_goods_id" , nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}


#pragma mark -/*购物部分*/
/* 获取商品列表 */
//t_API_CART_GOODSLISET_API
//t_API_CART_HOT_GOODSLISET_API  热销商品tag
//t_API_CART_DM_GOODSLISET_API   促销商品tag
- (void)buy_getGoodsList:(id)transdel Type:(NSString *)type TypeId:(NSString *)typeId ApiTag:(int)tag
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_BUY_PLATFORM_GOODS_LIST];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:tag];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    NSString *changeString = [[NSString alloc] init];
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    
    if ([type isEqualToString:@"brand"]) {
        changeString = @"bu_brand_id";
    }else if([type isEqualToString:@"category"]){
        changeString = @"hot_goods";
    }else if([type isEqualToString:@"hot_goods"]){
        changeString= @"hot_goods";
    }else if([type isEqualToString:@"bu_dm_goods"]){
        changeString= @"bu_dm_goods";
    }else if([type isEqualToString:@"recommend_goods"]){
        changeString= @"recommend_goods";
    } else if ([type isEqualToString:@"home_goods"]) {
        changeString= @"home_goods";
    }
    
    [webTrans._postRequst setPostValue:typeId forKey:changeString];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_BUY_PLATFORM_GOODS_LIST];
    NSString *requestPort = BASE_URL;
    GoodsListTrans *webTrans = [[GoodsListTrans alloc] init:transdel nApiTag:tag];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    //    [webTrans._postRequst setPostValue:type forKey:@"type"];
    NSString *changeString = [[NSString alloc] init];
    if ([type isEqualToString:@"brand"]) {
        changeString = @"bu_brand_id";
    }else if([type isEqualToString:@"category"]){
        changeString = @"hot_goods";
    }else if([type isEqualToString:@"hot_goods"]){
        changeString= @"hot_goods";
    }else if([type isEqualToString:@"dm"]){
        changeString= @"dm";
    }else if([type isEqualToString:@"recommend_goods"]){
        changeString= @"recommend_goods";
    } else if ([type isEqualToString:@"home_goods"]) {
        changeString= @"home_goods";
    }
    //    [webTrans._postRequst setPostValue:typeId forKey:changeString];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:type , @"type" ,typeId , changeString , nil];
    if (type)
    {
        [dic setObject:type forKey:@"type"];
    }
    else
    {
        [dic setObject:@"" forKey:@"type"];
    }
    if (typeId)
    {
        [dic setObject:typeId forKey:changeString];
    }
    else
    {
        [dic setObject:@"" forKey:changeString];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 首页主题促销商品 - 废弃
- (void)buy_getDMGoodsList:(id)transdel buId:(NSString *)buId
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@",API_BUY_PLATFORM_DMGOODS_LIST];
    NSString *requestPort = BASE_URL;
    DMGoodsTrans *webTrans = [[DMGoodsTrans alloc] init:transdel nApiTag:t_API_CART_DMGOODSLISET_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    //    NSString *changeString = [[NSString alloc] init];
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:buId forKey:@"bu_id"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    //    [changeString release];
     */
}

// 获取收藏状态
-(void)buy_collectStatus:(id)transdel Type:(NSString *)type DM_id:(NSString *)dm_id{
    /*
    NSString *requestName;
    NSString *requestPort = BASE_URL;
    
    DmGoodsTransObj *webTrans;
    if ([type isEqualToString:@"goods"]) {
        requestName  =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COLLECT_STATUS,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COLLECT_STATUS];
        
    }else{
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_DM_COLLECT_STATUS,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_DM_COLLECT_STATUS];
    }
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;

    if ([type isEqualToString:@"goods"]) {
        [webTrans._postRequst setPostValue:dm_id forKey:@"bu_goods_id"];
    }else{
        [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
    }
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName;
    NSString *requestPort = BASE_URL;
    
    DmGoodsTransObj *webTrans;
    if ([type isEqualToString:@"goods"])
    {
        requestName  =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COLLECT_STATUS,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COLLECT_STATUS];
        
    }else{
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_DM_COLLECT_STATUS,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_DM_COLLECT_STATUS];
    }
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    if ([type isEqualToString:@"goods"])
    {
        //        [webTrans._postRequst setPostValue:dm_id forKey:@"bu_goods_id"];
        [dic setObject:dm_id forKey:@"bu_goods_id"];
    }else{
        //        [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
        [dic setObject:dm_id forKey:@"dm_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

// 收藏｜｜取消收藏
- (void)buy_collectPromotion:(id)transdel Type:(NSString *)type DM_id:(NSString *)dm_id{
    /*
    NSString *requestName;
    NSString *requestPort = BASE_URL;
    DmGoodsTransObj *webTrans;
    if ([type isEqualToString:@"goods"]) {
        requestName  =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COLLECT,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COLLECT];
        
    }else{
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_PROMOTION_COLLECT,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_COLLECT];
    }
    
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    if ([type isEqualToString:@"goods"]) {
        [webTrans._postRequst setPostValue:dm_id forKey:@"bu_goods_id"];
    }else{
        [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
    }
    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName;
    NSString *requestPort = BASE_URL;
    DmGoodsTransObj *webTrans;
    if ([type isEqualToString:@"goods"]) {
        requestName  =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COLLECT,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COLLECT];
        
    }else{
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_PROMOTION_COLLECT,[UserAccount instance].session_id,[UserAccount instance].region_id];
        webTrans = [[DmGoodsTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_COLLECT];
    }
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:[UserAccount instance].region_id,@"region_id", nil];
    if ([UserAccount instance].region_id)
    {
        [dic setValue:[UserAccount instance].region_id forKey:@"region_id"];
    }
    else
    {
         [dic setValue:@"" forKey:@"region_id"];
    }
    if ([type isEqualToString:@"goods"]) {
        //        [webTrans._postRequst setPostValue:dm_id forKey:@"bu_goods_id"];
        [dic setObject:dm_id forKey:@"bu_goods_id"];
    }else{
        //        [webTrans._postRequst setPostValue:dm_id forKey:@"dm_id"];
        [dic setObject:dm_id forKey:@"dm_id"];
    }
    //    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}

/*获取商品||促销 信息*/
- (void)buy_GoodDetailForShare:(id)transdel BuDmOrGoodsId:(NSString *)bu_DmOrGoods_id Type:(DetailTypeForShare)type
{
    /*
    NSString *requestName;
    GoodDetailNetTransobj *webTrans;
    if (type == GOODS_DETAIL_SHARE) {
        requestName = API_BUY_PLATFORM_GOODDS_ETAIL_SHARE;
        webTrans = [[GoodDetailNetTransobj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODDS_ETAIL_SHARE];
        
    }else{
        requestName = API_BUY_PLATFORM_PROMOTION_DETAIL;
        webTrans = [[GoodDetailNetTransobj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_DETAIL];
    }
    
    NSString *requestPort = BASE_URL;
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    if (type == GOODS_DETAIL_SHARE) {
        [webTrans._postRequst setPostValue:bu_DmOrGoods_id forKey:@"bu_goods_id"];
    }else{
        [webTrans._postRequst setPostValue:bu_DmOrGoods_id forKey:@"dm_id"];
    }
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName;
    GoodDetailNetTransobj *webTrans;
    if (type == GOODS_DETAIL_SHARE) {
        requestName = API_BUY_PLATFORM_GOODDS_ETAIL_SHARE;
        webTrans = [[GoodDetailNetTransobj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODDS_ETAIL_SHARE];
    }else{
        requestName = API_BUY_PLATFORM_PROMOTION_DETAIL;
        webTrans = [[GoodDetailNetTransobj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_DETAIL];
    }
    
    NSString *requestPort = BASE_URL;
    NSString* strurl= [NSString stringWithFormat:@"%@%@?region_id=%@",requestPort,requestName,[UserAccount instance].region_id];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (type == GOODS_DETAIL_SHARE) {
        //        [webTrans._postRequst setPostValue:bu_DmOrGoods_id forKey:@"bu_goods_id"];
        [dic setObject:bu_DmOrGoods_id forKey:@"bu_goods_id"];
    }else{
        //        [webTrans._postRequst setPostValue:bu_DmOrGoods_id forKey:@"dm_id"];
        [dic setObject:bu_DmOrGoods_id forKey:@"dm_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}

/*商品详情*/
- (void)buy_GoodDetail:(id)transdel BuDmOrGoodsId:(NSString *)goods_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODDS_DETAIL,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodsTrans *webTrans = [[GoodsTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODDS_DETAIL];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;

    [webTrans._postRequst setPostValue:goods_id forKey:@"bu_goods_id"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODDS_DETAIL,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    GoodsTrans *webTrans = [[GoodsTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODDS_DETAIL];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:goods_id forKey:@"bu_goods_id"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:goods_id , @"bu_goods_id", nil];
    if (goods_id)
    {
        [dic setValue:goods_id forKey:@"bu_goods_id"];
    }
    else
    {
        [dic setValue:@"" forKey:@"bu_goods_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 添加到购物车
-(void)addCart:(id)transdel GoodsID:(NSString *)goods_id Total:(NSString *)total
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_ADDCART_GOODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_ADDCART_GOODS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;

    [webTrans._postRequst setPostValue:goods_id forKey:@"goods_id"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_ADDCART_GOODS,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_ADDCART_GOODS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //     [webTrans._postRequst setPostValue:goods_id forKey:@"goods_id"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:goods_id , @"goods_id", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}


/*获取购物车商品中总的数量*/
- (void)getCartGoodsNum:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CART_TOTAL_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CartNumTransObj *webTrans = [[CartNumTransObj alloc] init:transdel nApiTag:t_API_CART_TOTAL_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;

    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CART_TOTAL_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CartNumTransObj *webTrans = [[CartNumTransObj alloc] init:transdel nApiTag:t_API_CART_TOTAL_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
        webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
    
}


/* 获取购物车列表 */
-(void)getBuyCartList:(id)transdel Page:(NSString *)page
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CART_GOODSLISET_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CartListTransObj *webTrans = [[CartListTransObj alloc] init:transdel nApiTag:t_API_CART_GOODSLISET_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_CART_GOODSLISET_API,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    CartListTransObj *webTrans = [[CartListTransObj alloc] init:transdel nApiTag:t_API_CART_GOODSLISET_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:page , @"page", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/* 删除购物车中单件商品 */
-(void)deleteGoods:(id)transdel ByGoodsId:(NSString *)bu_goods_id Type:(NSString *)type
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_DELETEGOODS_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_DELETEGOODS_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:bu_goods_id forKey:@"id"];
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_DELETEGOODS_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_DELETEGOODS_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:bu_goods_id forKey:@"id"];
    //    [webTrans._postRequst setPostValue:type forKey:@"type"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:bu_goods_id , @"id" , type , @"type", nil];
    if (bu_goods_id)
    {
        [dic setValue:bu_goods_id forKey:@"id"];
    }
    else
    {
        [dic setValue:@"" forKey:@"id"];
    }
    if (type)
    {
        [dic setValue:type forKey:@"type"];
    }
    else
    {
        [dic setValue:@"" forKey:@"type"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}


/*勾选购物车商品－是否可购买*/
- (void)update_pay:(id)transdel CartId:(NSString *)cart_id Type:(NSString *)type{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_CARTUPDATE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_CARTUPDATE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    if (nil != cart_id) {
        [webTrans._postRequst setPostValue:cart_id forKey:@"cart_id"];
    }
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_CARTUPDATE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_CARTUPDATE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:10];

    [dic setValue:type forKey:@"type"];
    if (nil != cart_id) {
        //        [webTrans._postRequst setPostValue:cart_id forKey:@"cart_id"];
        [dic setValue:cart_id forKey:@"cart_id"];
    }
    //    [webTrans._postRequst setPostValue:type forKey:@"type"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/* 更改购物车中单件商品数量 */
-(void)changeGoods:(id)transdel Bu_Goods_Id:(NSString *)bu_goods_id Type:(NSString *)type
{
    /*
    // NSString *requestName = API_UPDATETOTAL_API;
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_UPDATETOTAL_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_UPDATETOTAL_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:bu_goods_id forKey:@"bu_goods_id"];
    [webTrans._postRequst setPostValue:type forKey:@"type"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_UPDATETOTAL_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_UPDATETOTAL_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:bu_goods_id forKey:@"bu_goods_id"];
    //    [webTrans._postRequst setPostValue:type forKey:@"type"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:bu_goods_id , @"bu_goods_id", type , @"type", nil];
    if (bu_goods_id)
    {
        [dic setValue:bu_goods_id forKey:@"bu_goods_id"];
    }
    else
    {
         [dic setValue:@"" forKey:@"bu_goods_id"];
    }
    if (type)
    {
        [dic setValue:type forKey:@"type"];
    }
    else
    {
        [dic setValue:@"" forKey:@"type"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 结算购物车
- (void)buy_confirmOrder:(id)transdel CouponId:(NSString *)coupon_id lm_id:(NSString *)lm_id goods_id:(NSString *)goods_id total:(NSString *)total{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_SUBMITORDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    OrderTransObj *webTrans = [[OrderTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_SUBMITORDER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    
    if (nil != coupon_id) {
        [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
    }
    if (nil != lm_id) {
        [webTrans._postRequst setPostValue:lm_id forKey:@"lm_id"];
    }
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_BUY_PLATFORM_SUBMITORDER,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    OrderTransObj *webTrans = [[OrderTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_SUBMITORDER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (nil != coupon_id) {
        //        [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
        [dic setObject:coupon_id forKey:@"coupon_id"];
    }
    if (nil != lm_id) {
        //        [webTrans._postRequst setPostValue:lm_id forKey:@"lm_id"];
        [dic setObject:lm_id forKey:@"lm_id"];
    }
    if (nil != goods_id) {
        //        [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
        [dic setObject:goods_id forKey:@"goods_id"];
    }
    if (nil != total) {
        //        [webTrans._postRequst setPostValue:lm_id forKey:@"lm_id"];
        [dic setObject:total forKey:@"total"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

/*结算订单*/
//- (void)buy_submitOrder:(id)transdel Bu_id:(NSString *)bu_id Time:(NSString *)time CouponId:(NSString *)coupon_id{
//    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_ORDERCONFIRM_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
//    NSString *requestPort = BASE_URL;
//    ConfirmTransObj *webTrans = [[ConfirmTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_ORDERCONFIRM_API];
//    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    webTrans._postRequst = [self post:strurl];
//
//    if(webTrans._postRequst == NULL)
//    {
//        [webTrans release];
//        return;
//    }
//    webTrans._postRequst.delegate = webTrans;
//    [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
//    [webTrans._postRequst setPostValue:time forKey:@"time"];
//    if (nil != coupon_id) {
//        [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
//    }
//    [_arrRequst addObject:webTrans];
//    [webTrans._postRequst startAsynchronous];
//    [webTrans release];
//}

// 修改自提时间
- (void)buy_modifyOrderTime:(id)transdel Bu_id:(NSString *)bu_id Time:(NSString *)time{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_ORDER_UPDATE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_ORDER_UPDATE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:bu_id forKey:@"order_list_id"];
    [webTrans._postRequst setPostValue:time forKey:@"pick_up_time"];
    
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_ORDER_UPDATE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_ORDER_UPDATE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:bu_id forKey:@"order_list_id"];
    //    [webTrans._postRequst setPostValue:time forKey:@"pick_up_time"];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:bu_id , @"order_list_id", time ,@"pick_up_time" , nil];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (bu_id)
    {
        [dic setObject:bu_id forKey:@"order_list_id"];
    }
    if (time)
    {
        [dic setObject:time forKey:@"pick_up_time"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 获取订单字符串
-(void)API_Bank_Pay:(id)transdel OrderList:(NSString *)listId PayType:(NSString *)ayType Pwd:(NSString *)_pwd
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_ORDERPAY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    OrderPayTransObj *webTrans = [[OrderPayTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_ORDERPAY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:listId forKey:@"order_list_id"];
    [webTrans._postRequst setPostValue:ayType forKey:@"pay_method"];
    if (![_pwd isEqualToString:@"0"])
    {
        [webTrans._postRequst setPostValue:_pwd forKey:@"pay_pwd"];
    }
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_ORDERPAY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    OrderPayTransObj *webTrans = [[OrderPayTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_ORDERPAY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:listId , @"order_list_id" , ayType , @"pay_method", nil];
    //    [webTrans._postRequst setPostValue:listId forKey:@"order_list_id"];
    //    [webTrans._postRequst setPostValue:ayType forKey:@"pay_method"];
    /**
     ***   _pwd不为0的时候 是永辉卡支付
     ***   _pwd为0是为除永辉卡支付
     **/
    if (![_pwd isEqualToString:@"0"])
    {
        //        [webTrans._postRequst setPostValue:_pwd forKey:@"pay_pwd"];
        [dic setObject:_pwd forKey:@"pay_pwd"];
    }
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}

// 获取门店列表
- (void)getBuList:(id)transdel Page:(NSString *)page Limit:(NSString *)limit{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_BU_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BuListNetTransObj *webTrans = [[BuListNetTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_BU_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_BU_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BuListNetTransObj *webTrans = [[BuListNetTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_BU_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:page forKey:@"page"];
    //    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:page , @"page", limit , @"limit", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//获取我的订单列表
//-(void)getMyOrderList:(id)transdel ByOrderType:(MyOrderType)type withPage:(NSString *)page andLimit:(NSString *)limit{
//
//    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_MYORDERLIST_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
//    NSString *requestPort = BASE_URL;
//    MyOrderTransObj *webTrans = [[MyOrderTransObj alloc] init:transdel nApiTag:t_API_MYORDERLIST_API];
//    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    webTrans._postRequst = [self post:strurl];
//
//    if(webTrans._postRequst == NULL)
//    {
//        [webTrans release];
//        return;
//    }
//
//    NSString *typeStr;
//    if (type  == UnPay) {
//        typeStr = @"50";
//    }else if (type == HasPay){
//        typeStr = @"100";
//    }else{
//        typeStr = @"10";
//
//    }
//    webTrans._postRequst.delegate = webTrans;
//    [webTrans._postRequst setPostValue:typeStr forKey:@"type"];
//    [webTrans._postRequst setPostValue:page forKey:@"page"];
//    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
//
//    [_arrRequst addObject:webTrans];
//    [webTrans._postRequst startAsynchronous];
//    [webTrans release];
//}

// 取消订单
- (void)buy_cancelOrder:(id)transdel OrderId:(NSString *)order_id{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_CANCELORDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_CANCELORDER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_id forKey:@"order_list_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_CANCELORDER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_CANCELORDER_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:order_id forKey:@"order_list_id"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:order_id , @"order_list_id", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 转赠订单
- (void)donation_Order:(id)transdel OrderId:(NSString *)order_id{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_DONATION_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DonationTrans *webTrans = [[DonationTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_DONATION_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_id forKey:@"order_list_no"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_DONATION_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    DonationTrans *webTrans = [[DonationTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_DONATION_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:order_id , @"order_list_no", nil];
    //    [webTrans._postRequst setPostValue:order_id forKey:@"order_list_no"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//转赠状态改变
- (void)change_donation_order_state:(id)transdel OrderId:(NSString *)order_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CHANGE_DONATION_STATE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_CHANGE_DONATION_STATE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_id forKey:@"order_list_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CHANGE_DONATION_STATE_API,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_CHANGE_DONATION_STATE_API];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:order_id forKey:@"order_list_id"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:order_id , @"order_list_id", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 分类列表
- (void)API_CateGoryList:(id)transdel  Bu_id:(NSString *)bu_id Bu_category_id:(NSString *)bu_category_id Page:(NSString *)page Limit:(NSString *)limit{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CATEGORY_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CateNetTransObj *webTrans = [[CateNetTransObj alloc] init:transdel nApiTag:t_API_CATEGORY_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
    if(nil != bu_category_id){
        [webTrans._postRequst setPostValue:bu_category_id forKey:@"bu_category_id"];
    }
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_CATEGORY_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CateNetTransObj *webTrans = [[CateNetTransObj alloc] init:transdel nApiTag:t_API_CATEGORY_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
    //    if(nil != bu_category_id){
    //        [webTrans._postRequst setPostValue:bu_category_id forKey:@"bu_category_id"];
    //    }
    //    [webTrans._postRequst setPostValue:page forKey:@"page"];
    //    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    NSMutableDictionary * dic =[NSMutableDictionary dictionaryWithObjectsAndKeys:bu_id , @"bu_id",page ,@"page",limit,@"limit", nil];
    if (bu_category_id != nil)
    {
        [dic setObject:bu_category_id forKey:@"bu_category_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

- (void)API_New_CategoryList:(id)transdel Bu_category_id:(NSNumber *)bu_category_id Page:(NSNumber *)page Limit:(NSNumber *)limit
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_NEW_CATEGORY_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CategoryNetTransObj *webTrans = [[CategoryNetTransObj alloc] init:transdel nApiTag:t_API_NEW_CATEGORY_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    if(nil != bu_category_id){
        [webTrans._postRequst setPostValue:bu_category_id forKey:@"bu_category_id"];
    }
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_NEW_CATEGORY_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CategoryNetTransObj *webTrans = [[CategoryNetTransObj alloc] init:transdel nApiTag:t_API_NEW_CATEGORY_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if(nil != bu_category_id){
//        [webTrans._postRequst setPostValue:bu_category_id forKey:@"bu_category_id"];
        [dic setObject:bu_category_id forKey:@"bu_category_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
// 品牌列表
- (void)API_Brand_List:(id)transdel  Bu_id:(NSString *)bu_id Page:(NSString *)page Limit:(NSString *)limit{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BRAND_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CateNetTransObj *webTrans = [[CateNetTransObj alloc] init:transdel nApiTag:t_API_BRAND_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
    [webTrans._postRequst setPostValue:page forKey:@"page"];
    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BRAND_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    CateNetTransObj *webTrans = [[CateNetTransObj alloc] init:transdel nApiTag:t_API_BRAND_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
    //    [webTrans._postRequst setPostValue:page forKey:@"page"];
    //    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary ];//WithObjectsAndKeys:bu_id , @"bu_id", page,@"page",limit,@"limit",nil];
    if (bu_id)
    {
        [dic setValue:bu_id forKey:@"bu_id"];
    }
    else
    {
        [dic setValue:@"" forKey:@"bu_id"];
    }
    if (page)
    {
        [dic setValue:page forKey:@"page"];
    }
    else
    {
        [dic setValue:@"" forKey:@"page"];
    }
    if (limit)
    {
        [dic setValue:limit forKey:@"limit"];
    }
    else
    {
        [dic setValue:@"" forKey:@"limit"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
- (void)API_New_Brand_List:(id)transdel{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_NEW_BRAND_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BrandNetTrans *webTrans = [[BrandNetTrans alloc] init:transdel nApiTag:t_API_NEW_BRAND_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    //    [webTrans._postRequst setPostValue:bu_id forKey:@"bu_id"];
    //    [webTrans._postRequst setPostValue:page forKey:@"page"];
    //    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_NEW_BRAND_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    BrandNetTrans *webTrans = [[BrandNetTrans alloc] init:transdel nApiTag:t_API_NEW_BRAND_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
// 快速结算
- (void)API_ScanQuick:(id)transdel Order_List_No:(NSString *)order_list_no coupon_id:(NSString *)coupon_id
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SCAN_CODE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    OrderDetailNettransObj *webTrans = [[OrderDetailNettransObj alloc] init:transdel nApiTag:t_API_SCAN_CODE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:order_list_no forKey:@"order_list_no"];
    if (coupon_id) {
        [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
    }
    
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SCAN_CODE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    OrderDetailNettransObj *webTrans = [[OrderDetailNettransObj alloc] init:transdel nApiTag:t_API_SCAN_CODE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:order_list_no forKey:@"order_list_no"];
    //    if (coupon_id) {
    //        [webTrans._postRequst setPostValue:coupon_id forKey:@"coupon_id"];
    //    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:order_list_no , @"order_list_no", nil];
    if (coupon_id)
    {
        [dic setObject:coupon_id forKey:@"coupon_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}

// 商品/促销 评论列表
- (void)buy_goodOrDMCommentList:(id)transdel Id:(NSString *)i_d Page:(NSInteger)page  Limit:(NSString *)limit CommentType:(CommentType)type
{
    /*
    NSString *requestName ;
    if (type == GOODS_COMMENT_LIST) {
        //requestName = API_BUY_PLATFORM_GOODS_COMMENTLIST;
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COMMENTLIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    }else{
        //requestName = API_BUY_PLATFORM_PROMOTION_COMMENTLIST;
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_PROMOTION_COMMENTLIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    }
    NSString *requestPort = BASE_URL;
    CommentTransObj *webTrans = nil;
    
    if (type == GOODS_COMMENT_LIST) {
        webTrans = [[CommentTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COMMENTLIST];
    }else{
        webTrans = [[CommentTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_COMMENTLIST];
    }
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;

    [webTrans._postRequst setPostValue:i_d forKey:@"dm_id"];
    if (type == GOODS_COMMENT_LIST) {
        [webTrans._postRequst setPostValue:i_d forKey:@"bu_goods_id"];
    }else{
        [webTrans._postRequst setPostValue:i_d forKey:@"dm_id"];
    }
    [webTrans._postRequst setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    [_arrRequst addObject:webTrans];
    
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
    NSString *requestName ;
    if (type == GOODS_COMMENT_LIST) {
        //requestName = API_BUY_PLATFORM_GOODS_COMMENTLIST;
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COMMENTLIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    }else{
        //requestName = API_BUY_PLATFORM_PROMOTION_COMMENTLIST;
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_PROMOTION_COMMENTLIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    }
    NSString *requestPort = BASE_URL;
    CommentTransObj *webTrans = nil;
    
    if (type == GOODS_COMMENT_LIST) {
        webTrans = [[CommentTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COMMENTLIST];
    }else{
        webTrans = [[CommentTransObj alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_COMMENTLIST];
    }
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:i_d, @"dm_id" , [NSString stringWithFormat:@"%d",page],@"page" ,limit ,@"limit" , nil];
    if (type == GOODS_COMMENT_LIST) {
        //        [webTrans._postRequst setPostValue:i_d forKey:@"bu_goods_id"];
        [dic setObject:i_d forKey:@"bu_goods_id"];
    }else{
        //        [webTrans._postRequst setPostValue:i_d forKey:@"dm_id"];
        [dic setObject:i_d forKey:@"dm_id"];
    }
    //    [webTrans._postRequst setPostValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    //    [webTrans._postRequst setPostValue:limit forKey:@"limit"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

// 商品评论
- (void)buy_goodOrDMComment:(id)transdel ID:(NSString *)Id Comment:(NSString *)comment CommentType:(CommentType)type
{
    NSString *requestName;
    if (type == GOODS_COMMENT_LIST) {
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_COMMENT,[UserAccount instance].session_id,[UserAccount instance].region_id];
        //requestName = API_BUY_PLATFORM_GOODS_COMMENT;
    }else{
        //requestName = API_BUY_PLATFORM_PROMOTION_COMMENT;
        requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_PROMOTION_COMMENT,[UserAccount instance].session_id,[UserAccount instance].region_id];
    }
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = nil;
    if (type == GOODS_COMMENT_LIST) {
        webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_COMMENT];
    }else{
        webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_BUY_PLATFORM_PROMOTION_COMMENT];
    }
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:comment , @"comment", nil];
    if (type == GOODS_COMMENT_LIST) {
        //        [webTrans._postRequst setPostValue:Id forKey:@"bu_goods_id"];
        [dic setObject:Id forKey:@"bu_goods_id"];
    }else{
        //        [webTrans._postRequst setPostValue:Id forKey:@"dm_id"];
        [dic setObject:Id forKey:@"dm_id"];
    }
    //    [webTrans._postRequst setPostValue:comment forKey:@"comment"];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

-(void)API_goods_status_func:(id)transdel GoodsID:(NSString*)bu_goods_id
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_STARUS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[GoodsStatusNetTrans alloc]init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_STARUS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    // [webTrans._postRequst setPostValue:bu_goods_id forKey:@"bu_goods_id"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:bu_goods_id,@"bu_goods_id", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

-(void)API_goods_isOutOfStock:(id)transdel GoodsID:(NSString *)bu_goods_id{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_BUY_PLATFORM_GOODS_STOCK,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[GoodsStockNetTrans alloc]init:transdel nApiTag:t_API_BUY_PLATFORM_GOODS_STOCK];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //     [webTrans._postRequst setPostValue:bu_goods_id forKey:@"bu_goods_id"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:bu_goods_id , @"bu_goods_id", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//扫描条形码
-(void)API_Goods_Saomiao:(id)transdel Code:(NSString *)_code
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SAOMIAO_GOODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[GoodSaoDetailNetTransobj alloc]init:transdel nApiTag:t_API_SAOMIAO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    //    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    //    [webTrans._postRequst setPostValue:_code forKey:@"universal_code"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserAccount instance].region_id , @"region_id",_code,@"universal_code", nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

#pragma mark - 签到
//获取签到信息
-(void)API_Sign_Info:(id)transdel  block:(netWork)_block
{//NetTransObj* webTrans = NULL;SignInNetTransObj
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SIGN_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj* webTrans = NULL;
    webTrans = [[SignInNetTransObj alloc] init:transdel nApiTag:t_API_SIGN_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}

//签到
-(void)API_Sign_In:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_SIGNIN,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_SIGNIN];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}


#pragma mark --------------------------------------------------------永辉卡 无用
//判断永辉卡是否存在
-(void)API_YHCard_IsOpen:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YHCARD_ISOPEN,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[YHCardNetTransObj alloc]init:transdel nApiTag:t_API_YHCARD_ISOPEN];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    //    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
}

//我的永辉卡信息接口
-(void)API_YHCard_Info:(id)transdel
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YHCARD_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[YHCardNetTransObj alloc]init:transdel nApiTag:t_API_YHCARD_INFO];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    //    [webTrans._postRequst setPostValue:[UserAccount instance].region_id forKey:@"region_id"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
    */
}
//永辉卡激活接口
-(void)API_YHCard_Ativation:(id)transdel Card_no:(NSString *)_cardno Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain Captcha:(NSString *)_captcha
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YHCARD_ACTIVATION,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_YHCARD_ACTIVATION];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:_cardno forKey:@"card_no"];
    [webTrans._postRequst setPostValue:_pwd forKey:@"pwd"];
    [webTrans._postRequst setPostValue:_pwdAgain forKey:@"pwd_again"];
    [webTrans._postRequst setPostValue:_captcha forKey:@"captcha"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
}
//永辉卡修改密码
-(void)API_YHCard_Update_Pwd:(id)transdel Card_no:(NSString *)_cardno OldPwd:(NSString *)_oldPwd Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain Captcha:(NSString *)_captcha
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_UPDATE_PWD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc]init:transdel nApiTag:t_API_YH_CARD_UPDATE_PWD];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:_cardno forKey:@"card_no"];
    [webTrans._postRequst setPostValue:_oldPwd forKey:@"old_pwd"];
    [webTrans._postRequst setPostValue:_pwd forKey:@"new_pwd"];
    [webTrans._postRequst setPostValue:_pwdAgain forKey:@"new_pwd_again"];
    [webTrans._postRequst setPostValue:_captcha forKey:@"captcha"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
}
//永辉卡充值接口
-(void)API_YHCard_TapUp:(id)transdel Card_no:(NSString *)_cardno
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YHCARD_RECHARGE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[YHCardTapNetTransObj alloc] init:transdel nApiTag:t_API_YHCARD_RECHARGE];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:_cardno forKey:@"card_no"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
}
//辉卡充值支付接口
-(void)API_YHCard_Recharge_pay:(id)transdel Card_no:(NSString *)_cardno Money:(NSString *)_money Pay_method:(NSString *)_pay_method
{
    /*
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YHCARD_RECHARGE_PAY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    
    NSString *requestPort =BASE_URL;//;//
    NetTransObj* webTrans = NULL;
    webTrans = [[YHCardPayNetTransObj alloc] init:transdel nApiTag:t_API_YHCARD_RECHARGE_PAY];
    
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    webTrans._postRequst = [self post:strurl];
    if(webTrans._postRequst == NULL)
    {
        [webTrans release];
        return;
    }
    webTrans._postRequst.delegate = webTrans;
    [webTrans._postRequst setPostValue:_cardno forKey:@"card_no"];
    [webTrans._postRequst setPostValue:_money forKey:@"money"];
    [webTrans._postRequst setPostValue:_pay_method forKey:@"pay_method"];
    [_arrRequst addObject:webTrans];
    [webTrans._postRequst startAsynchronous];
    [webTrans release];
     */
}
#pragma mark -------------------------------------------------------永辉卡



#pragma mark -------------------------  永辉钱包
//进入永辉钱包(void (^)(void))completion
-(void)API_YH_Card_ISOpen:(id)trandel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_ISOPEN,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardBagTransObj alloc] init:trandel nApiTag:t_API_YH_CARD_ISOPEN];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSLog(@"strurl = %@",strurl);
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = trandel;
    [webTrans request:strurl andDic:nil];
}

//开通永辉钱包
-(void)API_YH_Card_Activation:(id)transdel Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain email:(NSString *)_email Captcha:(NSString *)_captcha block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_REGISTER,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardBagTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_REGISTER];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_pwd, @"pwd",_pwdAgain,@"pwd_again",_email,@"email",_captcha,@"captcha",nil];
    NSLog(@"%@",strurl);
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}
//永辉卡销售面额列表接口API
-(void)API_YH_Card_List_Value:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_LIST_CARDS_VALUE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardDenominationTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_LIST_CARDS_VALUE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}

//购买永辉卡提交接口API

-(void)API_YH_Card_Buy:(id)transdel Selling_card_id:(NSString *)_selling_card_id Num:(NSString *)_num Pay_method:(NSString *)_pay_method Password:(NSString *)_pay_the_password block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_BUY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardRechargePayTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_BUY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_selling_card_id, @"selling_card_id",_num,@"num",_pay_method,@"pay_method",nil];
    if (![_pay_the_password isEqualToString:@"0"])
    {
        [dic setObject:_pay_the_password forKey:@"pay_pwd"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//转赠永辉卡列表接口API
-(void)API_YH_Card_List_Share:(id)transdel pages:(NSString *)_page block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_SHARE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardViceTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_SHARE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_page, @"page",nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}

//转赠永辉卡提交接口API
-(void)API_YH_Card_Examples:(id)transdel CardNo:(NSString *)_cardNo GavingMobile:(NSString *)_gavingMobile Pay_the_password:(NSString *)_pay_the_password block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_EXAMPLES,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_YH_CARD_EXAMPLES];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_cardNo, @"card_no",_gavingMobile,@"giving_mobile",_pay_the_password,@"pay_the_password",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//永辉卡线下超市支付接口API
-(void)API_YH_Card_Pay:(id)transdel Pay_the_password:(NSString *)_pay_the_password block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_PAY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardPayTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_PAY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_pay_the_password, @"pay_the_password",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}

//永辉卡充值接口API(充值页面信息接口)
-(void)API_YH_Card_Recharge:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_RECHARGE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardRechargeTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_RECHARGE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
//充值方式列表接口API
-(void)API_YH_CArd_Methods:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_METHODS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardMethodesTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_METHODS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
//永辉卡充值支付接口API
-(void)API_YH_Card_Recharge_Pay:(id)transdel Money:(NSString *)_money Pay_method:(NSString *)_pay_method block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_RECHARGE_PAY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardRechargePayTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_RECHARGE_PAY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_money, @"money",_pay_method,@"pay_method",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//永辉卡转账提交接口API
-(void)API_YH_Card_Transfer_Pay:(id)transdel Card_no:(NSString *)_cardno Pay_the_password:(NSString *)_pay_the_password block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_CARD_TRANSFER_PAY,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_YH_CARD_CARD_TRANSFER_PAY];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_cardno, @"card_no",_pay_the_password,@"pay_the_password",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//[永辉卡修改支付密码接口]
-(void)API_YH_Card_Update_Pwd:(id)transdel OldPwd:(NSString *)_oldPwd Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain Captcha:(NSString *)_captcha block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_UPDATE_PWD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_YH_CARD_UPDATE_PWD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_oldPwd, @"old_pwd",_pwd,@"new_pwd",_pwdAgain,@"new_pwd_again",_captcha,@"captcha",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//忘记密码提交接口API
-(void)API_YH_Card_Forgot_Password:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_FORGOT_PASSWORD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_YH_CARD_FORGOT_PASSWORD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
//永辉卡线下超市支付页面信息接口API
-(void)API_YH_Card_Offline_Pay:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_OFFLINE_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardOfflineTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_OFFLINE_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
//我的永辉卡信息接口
-(void)API_YH_Card_Info:(id)transdel block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardBag_MainTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_INFO];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
    
    
}
//1，有余额的卡列表。2，无余额的卡列表
-(void)API_YH_Card_List:(id)transdel pages:(NSString *)_page Type:(NSString *)_type block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_LIST_VICE,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardBag_ViceTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_LIST_VICE];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_page, @"page",_type,@"type",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//永辉卡收支明细接口API
-(void)API_YH_Card_Trans_List:(id)transdel CardNo:(NSString *)_cardno Pages:(NSString *)_page block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_TRANS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardTransListTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_TRANS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_cardno, @"card_no",_page,@"page",nil];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
//历史转赠信息列表展示接口API
-(void)API_YH_Card_History_List:(id)transdel Pages:(NSString *)_page block:(netWork)_block
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_CARD_HISTORY_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[YHCardHistoryListTransObj alloc] init:transdel nApiTag:t_API_YH_CARD_HISTORY_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_page,@"page",nil];
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark - 抢购
-(void)API_YH_Buy_Activity_Info:(id)transdel type:(NSString *)type activity_id:(NSInteger)activity_id
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_BUY_ACTIVITY_INFO,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSLog(@"%@" , requestName);
    NSString *requestPort = BASE_URL;
    NSLog(@"%@" , BASE_URL);
    FixedToSnapUpTransObj *webTrans = [[FixedToSnapUpTransObj alloc] init:transdel nApiTag:t_API_YH_BUY_ACTIVITY_INFO];
    NSString * strurl = [[NSString alloc] initWithFormat:@"%@%@" , requestPort ,requestName];
    NSLog(@"%@" , strurl);
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type",nil];
    
    if ([type isEqualToString:@"2"]) {
        [dic setObject:[NSNumber numberWithInteger:activity_id] forKey:@"activity_id"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
}
#pragma mark - 抢购活动列表
-(void)API_YH_Buy_Activity_List:(id)transdel type:(NSString *)type activity_id:(NSInteger)activity_id page:(NSInteger)page limit:(NSInteger)limit
{
    //将门店号添加进去[[NSUserDefaults standardUserDefaults]objectForKey:@"bu_code"]
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@&bu_code=%@",API_YH_BUY_ACTIVITY_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults]objectForKey:@"bu_code"]];
    NSString *requestPort = BASE_URL;
    NetTransObj *webTrans = NULL;
    webTrans = [[BuyActiviteListTransObj alloc] init:transdel nApiTag:t_API_YH_BUY_ACTIVITY_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
//    NSString * str1 = [NSString stringWithFormat:@"%d" , activity_id];
//    NSString * str2 = [NSString stringWithFormat:@"%d" , page];
//    NSString * str3 = [NSString stringWithFormat:@"%d" , limit];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjects:@[str1 , str2 , str3] forKeys:@[@"activity_id" , @"page" , @"limit"]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (type)
    {
        [dic setObject:type forKey:@"type"];
    }
    if (activity_id)
    {
        [dic setObject:[NSNumber numberWithInteger:activity_id] forKey:@"activity_id"];
    }
    if (page) {
         [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    if (limit) {
        [dic setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    }
    NSLog(@"%@" , dic);
    NSLog(@"%@" , strurl);
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];
    
}
#pragma mark - 绑定积分卡(430)
-(void)API_YH_My_Card_Binding_Status:(id)transdel
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_MY_CARD_BINDING_STATUS,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    CardBindStatusNetTransObj *webTrans = [[CardBindStatusNetTransObj alloc] init:transdel nApiTag:t_API_YH_MY_CARD_BINDING_STATUS];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];



}
-(void)API_YH_My_Card_Binding:(id)transdel captcha:(NSString *)captcha card_no:(NSString *)card_no mobile:(NSString *)mobile
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_MY_CARD_BINDING,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_YH_MY_CARD_BINDING];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];//WithObjectsAndKeys:mobile , @"mobile",type ,@"type",nil];
    if (captcha)
    {
        [dic setObject:captcha forKey:@"captcha"];
    }
    else
    {
        [dic setObject:@"" forKey:@"captcha"];
    }
    if (card_no)
    {
        [dic setObject:card_no forKey:@"card_no"];
    }
    else
    {
        [dic setObject:@"" forKey:@"card_no"];
    }
    
    if (mobile)
    {
        [dic setObject:mobile forKey:@"mobile"];
    }
    else
    {
        [dic setObject:@"" forKey:@"mobile"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];


}
#pragma mark - 星级包邮卡
-(void)API_YH_Star_Post_Card_Show:(id)transdel
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_STAR_POST_CARD_SHOW,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    SuccessOrFailTrans *webTrans = [[SuccessOrFailTrans alloc] init:transdel nApiTag:t_API_YH_STAR_POST_CARD_SHOW];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];

}
//星级包邮卡的卡片列表
-(void)API_YH_Star_Post_Card_Goods_List:(id)transdel
{
    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_STAR_POST_CARD_GOODS_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    StarPostCardNetTransObj *webTrans = [[StarPostCardNetTransObj alloc] init:transdel nApiTag:t_API_YH_STAR_POST_CARD_GOODS_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];
}
//星级包邮卡的卡片记录列表
-(void)API_YH_Star_Post_Card_Record_List:(id)transdel page:(NSInteger)page
{

    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_STAR_POST_CARD_RECORD_LIST,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    StarPostCardRecordListNetTransObj *webTrans = [[StarPostCardRecordListNetTransObj alloc] init:transdel nApiTag:t_API_YH_STAR_POST_CARD_RECORD_LIST];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (page)
    {
        [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];

}
//星级包邮卡的支付方式显示
-(void)API_YH_Star_Post_Card_Pay_Method:(id)transdel
{

    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_STAR_POST_CARD_PAY_METHOD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
     StarPostCardPayMethodNetTransObj *webTrans = [[StarPostCardPayMethodNetTransObj alloc] init:transdel nApiTag:t_API_YH_STAR_POST_CARD_PAY_METHOD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    
    webTrans._postRequst = strurl;
    webTrans._postDic = nil;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:nil];

}
//星级包邮卡的购卡接口
-(void)API_YH_Star_Post_Card_Buy_Card:(id)transdel ppc_goods_code:(NSString *)ppc_goods_code pay_method:(NSString *)pay_method
{

    NSString *requestName =  [NSString stringWithFormat:@"%@?session_id=%@&region_id=%@",API_YH_STAR_POST_CARD_BUY_CARD,[UserAccount instance].session_id,[UserAccount instance].region_id];
    NSString *requestPort = BASE_URL;
    
    StarPostCardBuyCardNetTransObj *webTrans = [[StarPostCardBuyCardNetTransObj alloc] init:transdel nApiTag:t_API_YH_STAR_POST_CARD_BUY_CARD];
    NSString* strurl= [NSString stringWithFormat:@"%@%@",requestPort,requestName];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (ppc_goods_code)
    {
        [dic setObject:ppc_goods_code forKey:@"ppc_goods_code"];
    }
    else
    {
        [dic setObject:nil forKey:@"ppc_goods_code"];;
        
    }
    if (pay_method)
    {
        [dic setObject:pay_method forKey:@"pay_method"];
    }
    else
    {
        [dic setObject:nil forKey:@"pay_method"];

    }
    webTrans._postRequst = strurl;
    webTrans._postDic = dic;
    webTrans._uinet = transdel;
    [webTrans request:strurl andDic:dic];



}
@end
