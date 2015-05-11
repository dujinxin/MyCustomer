//
//  NetTrans.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark --------------------------API start

typedef  void (^netWork)(NSString * someThing);

// 用户相关
#define API_USER_PLATFORM_VERCODE_API               @"v1/message/get/captcha"         // 获取验证码
#define API_USER_VALIDATION_VERCODE_API             @"v3/message/check_captcha"   //验证验证码
#define API_MODIFY_CONTACT_API                      @"v3/user/update_mobile"  //修改联系方式
#define API_BIND_MOBILE_API                         @"v3/user/bind_mobile"    //绑定邮箱登录时,用户没有手机号
//#define API_MEMBER_BIND_CARD_API                    @"v3/card/bind"
//                    //会员卡绑定
#define API_USER_PLATFORM_REGISTER_API              @"v3/user/register"               // 注册
#define API_USER_PLATFORM_REGISTER_IDCARD_API       @"v3/user/card/register"          // 绑定积分卡注册
#define API_USER_LOGIN_FORGET_PASSWORD              @"v3/user/check_username"    //忘记密码 第一步

#define API_USER_LOGIN_FORGET_MODIFY_PASSWORD       @"v3/user/find/password"          //忘记密码 第二步

#define API_USER_PLATFORM_LOGIN_API                 @"v3/user/login"                  // 登陆
#define API_USER_UPLOAD_IMAGE_API                   @"v1/uploadimage"                 // 上传图片
#define API_USER_PLATFORM_LOGIN_OUT_API             @"v2/user/logout"                 // 退出登陆
#define API_USER_PLATFORM_RESET_PASSWORD_API        @"v2/user/reset/password"         // 重置密码
#define API_USER_PLATFORM_FINDBACK_PWD_API          @"v2/user/find/password"          // 找回密码
#define API_USER_PLATFORM_MODIFY_PWD_API            @"v2/user/password/update"        // 修改密码
#define API_USER_PLATFORM_PERSONINFO_API            @"v2/user/profile"                // 用户信息
#define API_USER_PLATFORM_MODIFYINFO_API            @"v2/user/profile/update"         // 修改用户信息
#define API_VERSION                                 @"v1/version"                           // 版本控制
#define API_USER_ADDDEVICE_TOKEN                    @"v1/user/add/devicetoken"              // 上传devicetoken
#define API_USER_FEED_BACK                          @"v2/suggestion"                        // 意见反馈
#define API_USER_FADELIST_API                       @"v2/suggestion/list"                   // 意见反馈列表
#define API_USER_PLATFORM_BINDCARD_API              @"v2/card/bind"                         // 绑定会员卡

// 分类模块相关
#define API_CATEGORY_LIST                           @"v2/bu/category/list"                 // 品类列表
#define API_NEW_CATEGORY_LIST                       @"v2/category/list"
// 新品类列表
#define API_BRAND_LIST                              @"v2/bu/brand/list"                 // 品牌列表
#define API_NEW_BRAND_LIST                          @"v2/brand/list"                 // 新品牌列表
// 订单购物车相关
#define API_BUY_PLATFORM_SUBMITORDER                @"v3/orders/confirm"                                        // 提交订单 (我的购物车)
#define API_BUY_PLATFORM_ORDER_UPDATE               @"v2/order/order_update"           // 修改－订单时间
#define API_BUY_PLATFORM_CANCELORDER                @"v2/orders/cancel"                // 取消订单
#define API_BUY_PLATFORM_ORDERPAY                   @"v2/orders/pay"                   // 支付订单
#define API_BUY_PLATFORM_DONATION_API               @"v2/order/donation"               // 支付转赠
#define API_CHANGE_DONATION_STATE_API               @"v2//order/donation/status"       // 转赠状态
#define API_SCAN_CODE                               @"v2/orders/scan_code"             // 快速扫瞄
#define API_ADDCART_GOODS                           @"v3/carts/add"                    // 加入购物车
#define API_BUY_PLATFORM_CARTUPDATE                 @"v2/cart/update_pay"              // 是否勾选购物车
#define API_CART_GOODSLISET_API                     @"v3/cart/list"                    // 获取购物车列表
#define API_DELETEGOODS_API                         @"v2/cart/del"                     // 删除购物车中单件商品
#define API_UPDATETOTAL_API                         @"v2/cart/update_count"            // 修改购物车中单件商品数量
#define API_CART_TOTAL_API                          @"v2/cart/goods/total"             // 获取购物车总数量
#define API_PS_CART_UPDATE_GOODS_NUM                @"v2/carts/update_goods_num"


#define API_DM_MAIN_TOP                             @"v2/bu/dm"                         // 首页顶部促销活动
//#define API_MAIN_ACTIVITY                           @"v2/home/activitie"                // 首页运营区
//#define API_MAIN_ACTIVITY                           @"v2/home/new_activitie"
#define API_MAIN_ACTIVITY                           @"v2/home/new/activitie"
#define API_MAIN_CATYGORY                           @"v2/home/category"                 // 首页分类商品

//#define API_MAIN_THEME                              @"v2/home/subject"                  // 首页主题区
#define API_MAIN_THEME                              @"v2/home/new/subject"                  // 首页主题区
#define API_MAIN_NEW_THEME                          @"v2/home/new/subject"
//首页改版主题区
#define API_MAIN_HOTGOODS                           @"v2/home/new_goods"
// 首页热销商品区
#define API_MAIN_LAUNCH                             @"v2/get_start_page"
// 启动附加页
#define API_UNIQUE_IDETIFIDER                       @"unique_identifier"
// 用户唯一标识
#define API_PROMOTION_COLLECT_LIST                  @"v2/dm/collect_list"               // 用户收藏促销列表
#define API_BUY_PLATFORM_PROMOTION_COLLECT          @"v2/dm/collect"                    // 促销收藏/取消收藏
#define API_BUY_PLATFORM_PROMOTION_COMMENTLIST      @"v2/dm/comment_reply/list"         // 促销评论列表
#define API_BUY_PLATFORM_PROMOTION_COMMENT          @"v2/dm/comment"                    // 促销评论
#define API_BUY_PLATFORM_DM_COLLECT_STATUS          @"v2/dm/status"                     // 获取促销收藏状态
#define API_BUY_PLATFORM_PROMOTION_DETAIL           @"v2/dm/info"                       // 促销详情

//商品相关
#define API_GOODS_COLLECT_LIST                      @"v3/goods/list"
                                // 收藏商品列表  与 商品列表一样，暂时先不合并
#define API_BUY_PLATFORM_GOODS_COMMENTLIST          @"v2/goods/comment_reply/list"    // 商品评论列表
#define API_BUY_PLATFORM_GOODS_COMMENT              @"v2/goods/comment"               // 评论商品
#define API_BUY_PLATFORM_GOODS_COLLECT_STATUS       @"v2/goods/status"                // 获取商品收藏状态
#define API_BUY_PLATFORM_GOODS_COLLECT              @"v2/goods/collect"               // 收藏商品
#define API_BUY_PLATFORM_GOODS_PRAISE               @"v2/goods/laud"                  // 赞商品
#define API_BUY_PLATFORM_GOODS_STARUS               @"v2/goods/buy_status"            // 商品的状态
#define API_BUY_PLATFORM_GOODS_STOCK                @"v2/get_sku_is_show"       // 商品的是否下架
#define API_BUY_PLATFORM_GOODDS_ETAIL_SHARE         @"v2/dm/info"                     // 商品详情分享部分
#define API_BUY_PLATFORM_GOODDS_DETAIL              @"v2/goods/info"                  // 商品详情

#define API_BUY_PLATFORM_GOODS_LIST                 @"v3/goods/list"                  // 商品列表
#define API_BUY_PLATFORM_DMGOODS_LIST               @"v2/home/goods/page"             // 首页主题推荐商品 － 废弃
#define API_BUY_PLATFORM_BU_LIST                    @"v3/bu/list"                     // 门店列表
//blw 14-10-21
#define API_SAOMIAO_GOODS                           @"v2/goods/scan_code_info"          //[扫描商品条码获取信息]
//摇一摇
#define API_SHAKE_INFO                              @"v2/shake/info"
#define API_SHAKE_DOING                             @"v2/shake/do_shake"
#define API_SHAKE_INTERGRAL_EXCHANGE                @"v2/shake/intergral_exchange"
#define API_SHAKE_EXPRESS_ADDRESS                   @"v2/shake/express_address"
#define API_SHAKE_ADDRESD_LIST                      @"v2/shake/address_list"
#define API_SHAKE_SHARE_RECORD                      @"v2/shake/share_record"
#define API_SHAKE_AWARD_LIST                        @"v2/shake/user_win_list"

//促销分享
#define API_PROMOTION_SHARE @"v2/dm/share"
//商品详情分享
#define API_GOODS_SHARE @"v2/goods/share"


#define API_SIGN_INFO @"v2/sign_info"//获取签到信息
#define API_SIGNIN       @"v2/sign"//签到

//永辉卡（不用）
#define API_YHCARD_ISOPEN   @"v2/stored_value_card/is_open"//判断永辉卡是否存在
#define API_YHCARD_INFO    @"v2/stored_value_card/info"//我的永辉卡信息接口
#define API_YHCARD_ACTIVATION @"v2/stored_value_card/activation"//永辉卡激活接口
#define API_YHCARD_UPDATE_PWD   @"v2/stored_value_card/update_pwd"//永辉卡密码修改
#define API_YHCARD_RECHARGE @"v2/stored_value_card/recharge"//永辉卡充值接口
#define API_YHCARD_RECHARGE_PAY @"v2/stored_value_card/recharge_pay"//永辉卡充值支付接口
#define API_YHCARD_NET @"v1/page/service_info?type=4"//永辉卡网络显示
#define API_YHCARD_HELP @"v1/page/service_info?type=5"//永辉卡使用帮助

//永辉钱包接口
#define API_YH_CARD_ISOPEN @"v2/stored_value_card/is_open"//进入永辉钱包请求接口API
#define API_YH_CARD_REGISTER @"v2/stored_value_card/wallet_register"//永辉钱包注册接口API
#define API_YH_CARD_LIST_CARDS_VALUE @"v2/stored_value_card/the_cards_list"//永辉卡销售面额列表接口API
#define API_YH_CARD_BUY @"v2/stored_value_card/buy_card_submit"//购买永辉卡提交接口API
#define API_YH_CARD_SHARE @"v2/stored_value_card/examples_of_card_list"//转赠永辉卡列表接口API
#define API_YH_CARD_EXAMPLES @"v2/stored_value_card/examples_of_card_submit" //转赠永辉卡提交接口API
#define API_YH_CARD_PAY @"v2/stored_value_card/card_offline_pay"//永辉卡线下超市支付接口API
#define API_YH_CARD_RECHARGE @"v2/stored_value_card/recharge"//永辉卡充值接口API
#define API_YH_CARD_METHODS @"v2/stored_value_card/recharge_methods"//充值方式列表接口API
#define API_YH_CARD_RECHARGE_PAY @"v2/stored_value_card/recharge_pay"//永辉卡充值支付接口API
#define API_YH_CARD_CARD_TRANSFER_PAY @"v2/stored_value_card/card_transfer_pay"//永辉卡转账提交接口API
#define API_YH_CARD_UPDATE_PWD @"v2/stored_value_card/update_pwd"//永辉卡激活接口API
#define API_YH_CARD_FORGOT_PASSWORD @"v2/stored_value_card/forgot_password"//忘记密码提交接口API
#define API_YH_CARD_OFFLINE_INFO @"v2/stored_value_card/card_offline_info"//永辉卡线下超市支付页面信息接口API
#define API_YH_CARD_INFO    @"v2/stored_value_card/info"//我的永辉卡信息接口
#define API_YH_CARD_LIST_VICE @"v2/stored_value_card/card_list"//1，有余额的卡列表。2，无余额的卡列表
#define API_YH_CARD_TRANS_LIST @"v2/stored_value_card/card_trans_list"//永辉卡收支明细接口API
#define API_YH_CARD_HISTORY_LIST @"v2/stored_value_card/history_examples_of_card_list"//历史转赠信息列表展示接口API
#define API_SPEED_ENTRY                             @"v2/home/express/lane"                     // 首页快速通道区


#pragma mark - 抢购

#define API_YH_BUY_ACTIVITY_INFO  @"v2/panic_buying/activity" //抢购活动信息
#define API_YH_BUY_ACTIVITY_LIST  @"v3/goods/list"  //抢购活动商品列表

#pragma mark - 积分卡绑定(430)
#define API_YH_MY_CARD_BINDING_STATUS    @"v3/card/bind/status"     //绑卡状态
#define API_YH_MY_CARD_BINDING           @"v3/card/bind"            //绑卡操作

#pragma mark - 星级包邮卡
#define API_YH_STAR_POST_CARD_SHOW             @"v3/ppc/show" //是否在我的界面中添加星级包邮卡的人口
#define API_YH_STAR_POST_CARD_GOODS_LIST       @"v3/ppc/goods"//星级包邮卡的卡片列表
#define API_YH_STAR_POST_CARD_RECORD_LIST      @"v3/ppc/list"//星级包邮卡记录列表
#define API_YH_STAR_POST_CARD_PAY_METHOD       @"v3/ppc/pay_method"//星级包邮卡支付方式显示
#define API_YH_STAR_POST_CARD_BUY_CARD         @"v3/ppc/ppc_pay"//星级包邮卡购买接口
#pragma mark --------------------------API end

#pragma mark --------------------------API tag start
typedef enum
{
    t_API_USER_LOGIN_API = 0,
    t_API_USER_PLATFORM_VERCODE_API,
    t_API_USER_VALIDATION_VERCODE_API,
    t_API_USER_PLATFORM_REGISTER_API,
    t_API_USER_PLATFORM_LOGIN_API,
    t_API_USER_PLATFORM_RAINBOW_LOGIN_API,
    t_API_USER_PLATFORM_THIRDPART_BIND_API,
    t_API_USER_PLATFORM_THIRDPART_LOGIN_API,
    t_API_USER_PLATFORM_UPLOAD_IMAGE_API,
    t_API_USER_PLATFORM_LOGIN_OUT_API,
    t_API_USER_PLATFORM_RESET_PASSWORD_API,
    t_API_USER_PLATFORM_MODIFY_PWD_API,
    t_API_USER_PLATFORM_FINDBACK_PWD_API,
    t_API_USER_PLATFORM_PERSONINFO_API,
    t_API_USER_PLATFORM_MODIFYINFO_API,
    t_API_USER_PLATFORM_BINDCARD_API,
    t_API_USER_ADDDEVICE_TOKEN,
    t_API_BU_FEED_BACK_API,
    t_API_USER_FEED_BACK,
    t_API_USER_TAG_LIST_API,
    t_API_USER_TAG_UPDATE_API,
    t_API_USER_PLATFORM_PERFECT_MOBILE,
    t_API_TAG_LIST_API,
    t_API_CATEGORY_LIST,
    t_API_NEW_CATEGORY_LIST,
    t_API_BRAND_LIST,
    t_API_NEW_BRAND_LIST,
    t_API_SPEED_ENTRY,
    t_API_BUY_PLATFORM_GOODDS_ETAIL_SHARE,
    t_API_BUY_PLATFORM_GOODDS_DETAIL,
    t_API_BUY_PLATFORM_ORDERINFO_API,
    t_API_BUY_PLATFORM_ORDER_UPDATE,
    t_API_BUY_PLATFORM_SUBMITORDER_API,
    t_API_BUY_PLATFORM_BU_NEAREAST,
    t_API_BUY_PLATFORM_GOODS_COMMENTLIST,
    t_API_BUY_PLATFORM_GOODS_COMMENT,
    t_API_BUY_PLATFORM_GOODS_COLLECT,
    t_API_BUY_PLATFORM_GOODS_PRAISE,
    t_API_BUY_PLATFORM_GOODS_STARUS,
    t_API_BUY_PLATFORM_GOODS_STOCK,
    t_API_BUY_PLATFORM_GOODS_ID,
    t_API_BUY_PLATFORM_GOODS_LIST,
    t_API_BUY_PLATFORM_PROMOTION_PARISE,
    t_API_BUY_PLATFORM_PROMOTION_COLLECT,
    t_API_BUY_PLATFORM_PROMOTION_COMMENTLIST,
    t_API_BUY_PLATFORM_PROMOTION_COMMENT,
    t_API_BUY_PLATFORM_ORDERPAY_API,
    t_API_BUY_PLATFORM_CANCELORDER_API,
    t_API_BUY_PLATFORM_DONATION_API,
    t_API_CHANGE_DONATION_STATE_API,
    t_API_BUY_PLATFORM_PROMOTION_DETAIL,
    t_API_BUY_PLATFORM_CARTUPDATE,
    t_API_BUY_PLATFORM_ORDERPAY,
    t_API_BUY_PLATFORM_BU_LIST,
    t_API_BUY_PLATFORM_GOODS_COLLECT_STATUS,
    t_API_BUY_PLATFORM_DM_COLLECT_STATUS,
    t_API_SHAKE_ADD_STOCK,
    t_API_STOREBRANDLIST,
    t_API_STORECATEGORYLIST,
    t_API_SUBBRANDLISTTRANS,
    t_API_CART_TOTAL_API,
    t_API_SUBSCRIBE_MY_SUBSCRIBES,
    t_API_GOODS_COLLECT_LIST,
    t_API_GOODS_REG_COLLECT_LIST,
    t_API_USER_FADELIST_API,
    t_API_PROMOTION_COLLECT_LIST,
    t_API_PROMOTION_REG_COLLECT_LIST,
    t_API_SUBSTORELIST,
    t_API_SEARCH_BRANDLISTTRANS,
    t_API_SEARCH_CATEGORY,
    t_API_SEARCH_SUBSTORELIST,
    t_API_STORELIST,
    t_API_SUBSTORE,
    t_API_SUBBRAND,
    t_API_SUBCATEGORY,
    t_API_SUBSHOPPE,
    t_API_SCAN_CODE,
    t_API_SHOP_BRAND_SUBSTATUS,
    t_API_CANCEL_SUBSTORE,
    t_API_CANCEL_SUBBRAND,
    t_API_CANCEL_SUBCATEGORY,
    t_API_CANCEL_SUBSHOPPE,
    t_API_BRAND_GOODSLIST,
    t_API_CATEGORY_GOODSLIST,
    t_API_BU_GOODSLIST,
    t_API_BU_SEARCH_GOODSLIST,
    t_API_BUY_PLATFORM_ORDERCONFIRM_API,
    t_API_BU_FLOOR_LIST,
    t_API_ADDCART_GOODS,
    t_API_CART_GOODSLISET_API,
    t_API_CART_DMGOODSLISET_API,
    t_API_CART_HOT_GOODSLISET_API,
    t_API_CART_DM_GOODSLISET_API,
    t_API_DELETEGOODS_API,
    t_API_UPDATETOTAL_API,
    t_API_FRIENDLIST_API,
    t_API_ADDFRIEND,
    t_API_FRIENDCX,
    t_API_DELFRIEND,
    t_API_SEARCHFRIEND,
    t_API_MYORDERLIST_API,
    t_API_GETPHONELIST,
    t_API_BU_FEEDBACk,
    t_API_MY_FEEDBACK_LIST,
    t_API_ORDER_ADDRESS_LIST,
    t_API_ORDER_ADDRESS_ADD,
    t_API_ORDER_ADDRESS_UPDATE,
    t_API_ORDER_ADDRESS_DELETE,
    t_API_ORDER_ADDRESS_SET,
    t_API_ORDER_AREA_LIST,
    t_API_SHAKE,
    t_API_SHAKE_LIST,
    t_API_SHAKE_VERTIFY_CODE,
    t_API_SHAKE_CERTAIN,
    t_API_DM_STATUS,
    t_API_BANK_PAY,
    t_API_COUPON_APPLY,
    t_API_VERSION,
    t_API_USER_SEND_TOKEN,
    t_API_DM_MAIN_TOP,
    t_API_MAIN_ACTIVITY,
    t_API_MAIN_CATEGORY,
    t_API_MAIN_THEME,
    t_API_MAIN_NEW_THEME,
    t_API_MAIN_HOTGOODS,
    t_API_MAIN_LAUNCH,
    t_API_UNIQUE_IDETIFIDER,
    t_API_SAOMIAO,//blw 14-10-21
    t_API_SIGN_INFO,
    t_API_SIGNIN,
    t_API_YHCARD_ISOPEN,
    t_API_YHCARD_INFO,
    t_API_YHCARD_ACTIVATION,
    t_API_YHCARD_UPDATE_PWD,
    t_API_YHCARD_RECHARGE,
    t_API_YHCARD_RECHARGE_PAY,
    t_API_SHAKE_INFO,
    t_API_SHAKE_DOING,
    t_API_SHAKE_INTERGRAL_EXCHANGE,
    t_API_SHAKE_EXPRESS_ADDRESS,
    t_API_SHAKE_ADDRESS_LIST,
    t_API_SHAKE_SHARE_RECORD,
    t_API_SHAKE_AWARD_LIST,
    t_API_PROMOTION_SHARE,
    t_API_GOODS_SHARE,
    t_API_YH_CARD_ISOPEN,
    t_API_YH_CARD_REGISTER,
    t_API_YH_CARD_LIST_CARDS_VALUE,
    t_API_YH_CARD_BUY,
    t_API_YH_CARD_SHARE,
    t_API_YH_CARD_EXAMPLES,
    t_API_YH_CARD_PAY,
    t_API_YH_CARD_RECHARGE,
    t_API_YH_CARD_METHODS,
    t_API_YH_CARD_RECHARGE_PAY,
    t_API_YH_CARD_CARD_TRANSFER_PAY,
    t_API_YH_CARD_UPDATE_PWD,
    t_API_YH_CARD_FORGOT_PASSWORD,
    t_API_YH_CARD_OFFLINE_INFO,
    t_API_YH_CARD_INFO,
    t_API_YH_CARD_LIST_VICE,
    t_API_YH_CARD_TRANS_LIST,
    t_API_YH_CARD_HISTORY_LIST,
    t_API_YH_BUY_ACTIVITY_INFO,
    t_API_YH_BUY_ACTIVITY_LIST,
    t_API_MODIFY_CONTACT_API,
    t_API_BIND_MOBILE_API,
    t_API_USER_LOGIN_FORGET_PASSWORD,
    t_API_USER_LOGIN_FORGET_MODIFY_PASSWORD,
    t_API_YH_MY_CARD_BINDING_STATUS,
    t_API_YH_MY_CARD_BINDING,
    t_API_YH_STAR_POST_CARD_SHOW,
    t_API_YH_STAR_POST_CARD_GOODS_LIST,
    t_API_YH_STAR_POST_CARD_RECORD_LIST,
    t_API_YH_STAR_POST_CARD_PAY_METHOD,
    t_API_YH_STAR_POST_CARD_BUY_CARD,
}EnumApiTag;

#pragma mark --------------------------API tag end

//网络通信总控
@interface NetTrans : NSObject
{
    NSMutableArray* _arrRequst;//value:NetTransObj
    NSMutableArray* _arrTongJiKey;
}

@property (nonatomic, retain) NSMutableArray* _arrRequst;
@property (nonatomic, retain) NSMutableArray* _arrTongJiKey;
@property (nonatomic, assign) netWork netWorkBlock;

+(NetTrans*)getInstance;

#pragma mark --------------------------取消某一请求   netObj:NetTransObj
-(void)cancelRequest:(id)netObj;

#pragma mark --------------------------取消界面发起的所有 request  ui:当前界面对象
-(void)cancelRequestByUI:(id)ui;

#pragma mark --------------------------根据apitag获取请求对象（NetTransObj）  nTag：apitag re:NetTransObj

-(id)getNetTransByAPITag:(EnumApiTag)nTag;

// 用户信息相关
// 获取验证码
-(void)user_getVercode:(id)transdel Mobile:(NSString*)mobile setType:(NSString*)type;
//验证验证码
-(void)user_validation:(id)transdel captcha:(NSString*)captcha mobile:(NSString*)mobile;
//修改联系方式
-(void)user_modify_contact:(id)transdel mobile:(NSString *)mobile captcha:(NSString *)captcha;
//绑定邮箱登录时，没有手机号的用户的手机号
-(void)user_login_bindMobile:(id)transdel mobile:(NSString *)mobile captcha:(NSString *)captcha;
////会员卡绑定
//-(void)user_member_bindCard:(id)transdel mobile:(NSString *)mobile captcha:(NSString *)captcha card_no:(NSString *)card_no;
//登录界面忘记密码
-(void)user_forget_password:(id)transdel user_name:(NSString *)user_name;
//登录界面忘记密码第二步
-(void)user_forget_modify_password:(id)transdel mobile:(NSString *)mobile type:(NSString *)type user_name:(NSString *)user_name captcha:(NSString *)captcha new_password:(NSString *)new_password confirm_password:(NSString *)confirm_password;
// 登陆
-(void)user_login:(id)transdel UserName:(NSString*)user_name Password:(NSString*)password;
// 注册
-(void)user_register:(id)transdel Mobile:(NSString*)mobile passWordCode:(NSString*)password Captcha:(NSString*)captcha Id:(NSString*)id_no recommend_mobile:(NSString *)recommend_mobile;
// 积分卡绑定注册
-(void)user_register:(id)transdel Mobile:(NSString*)mobile passWordCode:(NSString*)password Captcha:(NSString*)captcha IdNumber:(NSString *)idNumber recommend_mobile:(NSString *)recommend_mobile card_no:(NSString *)card_no;
// 上传图片
- (void) user_upLoadImage:(id)transdel Type:(NSString *)type Image:(NSString *)imagePath;
// 退出登陆
- (void)user_loginOut:(id)transdel;
// 重置密码
- (void)user_resetPassword:(id)transdel :(NSString *)newpassword;
// 找回密码
- (void)user_findBackPassword:(id)transdel Mobile:(NSString*)mobile Captcha:(NSString*)captcha;
// 修改密码
- (void)user_modifyPassWord:(id)transdel OldPwd:(NSString *)oldpwd NewPassword:(NSString *)newPassword ConfirmPassWord:(NSString *)confirmPassWord;
// 获取个人信息
- (void)user_getPersonInfo:(id)transdel setUserId:(NSString *)userid;
// 修改个人信息
- (void)user_modifyPersonInfo:(id)transdel UserName:(NSString *)username Email:(NSString *)email Mobile:(NSString *)mobile Intro:(NSString *)intro TrueName:(NSString *)trueName Gender:(NSString *)gender PhotoId:(NSString *)photoid ShoppingWall:(NSString *)shoppingwall;
// 上传deviceToken
- (void)user_uploadDevice_Token:(id)transdel DeviceToken:(NSString *)deviceToken;

//意见反馈
-(void)API_user_feed_back:(id)transdel Content:(NSString*)content;
// 意见列表
- (void)API_user_feed_back_list:(id)transdel Page:(NSString *)page;
//绑定会员卡
- (void)user_bindMemberCard:(id)transdel CardNumber:(NSString *)card_no;
//门店咨询投诉
-(void)sendbuFeedBack:(id)transdel Bu_id:(NSString*)bu_id User_id:(NSString*)user_id Mobile_num:(NSString*)mobile_num Content:(NSString *)content Commit_type:(NSString*)commit_type;
//我的咨询投诉
-(void)myFeedBackList:(id)transdel Page:(NSString*)page Limit:(NSString*)limit;
//版本监测
-(void)API_version_check:(id)transdel AgentID:(NSString*)agentID Type:(NSString*)type;

#pragma -
#pragma 购物车商品相关api

// 商品列表-根据type返回相应的商品列表
- (void)buy_getGoodsList:(id)transdel Type:(NSString *)type TypeId:(NSString *)typeId ApiTag:(int)tag;
// 首页主题促销商品 － 废弃
- (void)buy_getDMGoodsList:(id)transdel buId:(NSString *)buId;
// 商品评论列表
- (void)buy_goodOrDMCommentList:(id)transdel Id:(NSString *)i_d Page:(NSInteger)page  Limit:(NSString *)limit CommentType:(CommentType)type;
// 评论商品||评论促销
- (void)buy_goodOrDMComment:(id)transdel ID:(NSString *)Id Comment:(NSString *)comment CommentType:(CommentType)type;
// 促销－收藏／取消收藏
- (void)buy_collectPromotion:(id)transdel Type:(NSString *)type DM_id:(NSString *)dm_id;
// 获取商品促销详情信息 FOR share
- (void)buy_GoodDetailForShare:(id)transdel BuDmOrGoodsId:(NSString *)bu_DmOrGoods_id Type:(DetailTypeForShare)type;
// 获取商品bu_goods_id
- (void)buy_GetBuGoodsId:(id)transdel BuId:(NSString *)bu_id GoodsID:(NSString *)goods_id;
// 结算订单 (购物车列表) && 立即购买(商品列表/*15-0517新增*/)
- (void)buy_confirmOrder:(id)transdel CouponId:(NSString *)coupon_id lm_id:(NSString *)lm_id goods_id:(NSString *)goods_id total:(NSString *)total;
// 提交订单
- (void)buy_submitOrder:(id)transdel Bu_id:(NSString *)bu_id Time:(NSString *)time CouponId:(NSString *)coupon_id;
// 修改订单时间
- (void)buy_modifyOrderTime:(id)transdel Bu_id:(NSString *)bu_id Time:(NSString *)time;

// 取消订单
- (void)buy_cancelOrder:(id)transdel OrderId:(NSString *)order_id;
// 获取支付订单字符串
- (void)getPayOrder:(id)transdel OrderId:(NSString *)order_id PayMethod:(NSString *)pay_method
             nLimit:(NSInteger)nlimit nType:(SubType)nType;
//搜索商品
-(void)searchGoodsList:(id)transdel nPageIndex:(NSInteger)nPageIndex strStoreId:(NSString*)strStoreId strSearch:(NSString*)strSearch nLimit:(NSInteger)nlimit;
//取楼层
-(void)getFloor:(id)transdel strStoreId:(NSString*)strStoreId;
//加入购物车（确认添加到购物车）
-(void)addCart:(id)transdel GoodsID:(NSString *)goods_id Total:(NSString *)total;
//获取购物车列表
-(void)getBuyCartList:(id)transdel Page:(NSString *)page;
//删除购物车中单件商品
-(void)deleteGoods:(id)transdel ByGoodsId:(NSString *)bu_goods_id Type:(NSString *)type;
//勾选商品－是否需要购买
- (void)update_pay:(id)transdel CartId:(NSString *)cart_id Type:(NSString *)type;
//更改购物车中单件商品数量
-(void)changeGoods:(id)transdel Bu_Goods_Id:(NSString *)bu_goods_id Type:(NSString *)type;
// 获取购物车中商品总数量
- (void)getCartGoodsNum:(id)transdel;
// 获取门店列表
- (void)getBuList:(id)transdel Page:(NSString *)page Limit:(NSString *)limit;
//获取我的订单列表
-(void)getMyOrderList:(id)transdel ByOrderType:(MyOrderType)type withPage:(NSString *)page andLimit:(NSString *)limit;
// 支付
-(void)API_Bank_Pay:(id)transdel OrderList:(NSString *)listId PayType:(NSString *)ayType Pwd:(NSString *)_pwd;
// 快速扫瞄
- (void)API_ScanQuick:(id)transdel Order_List_No:(NSString *)order_list_no coupon_id:(NSString *)coupon_id;
- (void)donation_Order:(id)transdel OrderId:(NSString *)order_id;
//转赠状态改变
- (void)change_donation_order_state:(id)transdel OrderId:(NSString *)order_id;
/*分类相关*/
// 分类列表
- (void)API_CateGoryList:(id)transdel  Bu_id:(NSString *)bu_id Bu_category_id:(NSString *)bu_category_id Page:(NSString *)page Limit:(NSString *)limit;
- (void)API_New_CategoryList:(id)transdel Bu_category_id:(NSNumber *)bu_category_id Page:(NSNumber *)page Limit:(NSNumber *)limit;
// 品牌列表
- (void)API_Brand_List:(id)transdel  Bu_id:(NSString *)bu_id Page:(NSString *)page Limit:(NSString *)limit;
- (void)API_New_Brand_List:(id)transdel;
/*商品详情*/
- (void)buy_GoodDetail:(id)transdel BuDmOrGoodsId:(NSString *)goods_id;
/*
 * @brief  DM相关（促销活动相关）
 */
-(void)API_dm_status_func:(id)transdel DMId:(NSString*)dm_id;
-(void)API_dm_main_top:(id)transdel DMId:(NSString*)dm_id;

-(void)API_speed_entry:(id)transdel type:(NSString*)type;
-(void)API_main_hotGoods:(id)transdel udid:(NSString *)udidString;
-(void)API_main_category:(id)transdel;
//新增首页底部主题
-(void)API_main_new_theme:(id)transdel;
-(void)API_main_theme:(id)transdel;
-(void)API_main_activity:(id)transdel;
-(void)API_main_launch:(id)transdel;
-(void)unique_identifier:(id)transdel;
/*
 * @brief 收藏相关
 */
// 获取收藏状态
-(void)buy_collectStatus:(id)transdel Type:(NSString *)type DM_id:(NSString *)dm_id;
// 收藏商品/取消收藏
-(void)API_good_collect_func:(id)transdel BuGoodId:(NSString *)bu_goods_id;
-(void)API_goods_status_func:(id)transdel GoodsID:(NSString*)bu_goods_id;
//是否下架
-(void)API_goods_isOutOfStock:(id)transdel GoodsID:(NSString *)bu_goods_id;
// 我的收藏列表
-(void)getGoodsCollectList:(id)transdel page:(NSInteger)page limit:(NSInteger)limit region_id:(NSString *)region_id type:(NSString *)type;
// 我的活动收藏列表
-(void)getPromotionCollectList:(id)transdel page:(NSInteger)page limit:(NSInteger)limit region_id:(NSString *)region_id;
-(void)API_Goods_Saomiao:(id)transdel Code:(NSString *)_code;
/*
 *摇一摇
 */
- (void)shake_info:(id)transdel;
- (void)shake_doing:(id)transdel shake_id:(NSString *)shake_id;
- (void)shake_intergral_exchange:(NSString *)exchange transdel:(id)transdel activity_id:(NSString *)activity_id;
- (void)shake_express_area:(NSString *)area address:(NSString *)address name:(NSString *)name mobile:(NSString *)mobile activityId:(NSString *)activityId transdel:(id)transdel;
- (void)shake_address_list:(id)transdel level:(NSString *)level pid:(NSString *)pid;
- (void)shake_share_record:(id)transdel;
- (void)shake_award_list:(id)transdel page:(NSString *)page;
/*
 促销分享
 */
-(void)promotion_share:(id)transdel dm_id:(NSString *)dm_id;

-(void)goods_share:(id)transdel bu_goods_id:(NSString *)bu_goods_id;

//获取签到信息
-(void)API_Sign_Info:(id)transdel  block:(netWork)_block;
//签到
-(void)API_Sign_In:(id)transdel block:(netWork)_block;
//判断永辉卡是否存在
-(void)API_YHCard_IsOpen:(id)transdel;
//我的永辉卡信息接口
-(void)API_YHCard_Info:(id)transdel;
//永辉卡激活接口
-(void)API_YHCard_Ativation:(id)transdel Card_no:(NSString *)_cardno Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain Captcha:(NSString *)_captcha;
//永辉卡修改密码
-(void)API_YHCard_Update_Pwd:(id)transdel Card_no:(NSString *)_cardno OldPwd:(NSString *)_oldPwd Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain Captcha:(NSString *)_captcha;
//永辉卡充值接口
-(void)API_YHCard_TapUp:(id)transdel Card_no:(NSString *)_cardno;
//辉卡充值支付接口
-(void)API_YHCard_Recharge_pay:(id)transdel Card_no:(NSString *)_cardno Money:(NSString *)_money Pay_method:(NSString *)_pay_method;


#pragma mark ==================  永辉钱包
//进入永辉钱包
//-(void)API_YH_Card_ISOpen:(id)trandel;
-(void)API_YH_Card_ISOpen:(id)trandel block:(netWork)_block;
//激活永辉钱包
-(void)API_YH_Card_Activation:(id)transdel Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain email:(NSString *)_email Captcha:(NSString *)_captcha block:(netWork)_block;
//永辉卡销售面额列表接口API
-(void)API_YH_Card_List_Value:(id)transdel block:(netWork)_block;
//购买永辉卡提交接口API
-(void)API_YH_Card_Buy:(id)transdel Selling_card_id:(NSString *)_selling_card_id Num:(NSString *)_num Pay_method:(NSString *)_pay_method Password:(NSString *)_pay_the_password block:(netWork)_block;
//转赠永辉卡列表接口API
-(void)API_YH_Card_List_Share:(id)transdel pages:(NSString *)_page block:(netWork)_block;
//转赠永辉卡提交接口API
-(void)API_YH_Card_Examples:(id)transdel CardNo:(NSString *)_cardNo GavingMobile:(NSString *)_gavingMobile Pay_the_password:(NSString *)_pay_the_password block:(netWork)_block;
//永辉卡线下超市支付接口API
-(void)API_YH_Card_Pay:(id)transdel Pay_the_password:(NSString *)_pay_the_password block:(netWork)_block;
//永辉卡充值接口API(充值页面信息接口)
-(void)API_YH_Card_Recharge:(id)transdel block:(netWork)_block;
//充值方式列表接口API
-(void)API_YH_CArd_Methods:(id)transdel block:(netWork)_block;
//永辉卡充值支付接口API
-(void)API_YH_Card_Recharge_Pay:(id)transdel Money:(NSString *)_money Pay_method:(NSString *)_pay_method block:(netWork)_block;
//永辉卡转账提交接口API
-(void)API_YH_Card_Transfer_Pay:(id)transdel Card_no:(NSString *)_cardno Pay_the_password:(NSString *)_pay_the_password block:(netWork)_block;
//[永辉卡修改支付密码接口]
-(void)API_YH_Card_Update_Pwd:(id)transdel OldPwd:(NSString *)_oldPwd Pwd:(NSString *)_pwd PwdAgain:(NSString *)_pwdAgain Captcha:(NSString *)_captcha block:(netWork)_block;
//忘记密码提交接口API
-(void)API_YH_Card_Forgot_Password:(id)transdel block:(netWork)_block;
//永辉卡线下超市支付页面信息接口API
-(void)API_YH_Card_Offline_Pay:(id)transdel block:(netWork)_block;
//我的永辉卡信息接口
-(void)API_YH_Card_Info:(id)transdel block:(netWork)_block;
//1，有余额的卡列表。2，无余额的卡列表
-(void)API_YH_Card_List:(id)transdel pages:(NSString *)_page Type:(NSString *)_type block:(netWork)_block;
//永辉卡收支明细接口API
-(void)API_YH_Card_Trans_List:(id)transdel CardNo:(NSString *)_cardno Pages:(NSString *)_page block:(netWork)_block;
//历史转赠信息列表展示接口API
-(void)API_YH_Card_History_List:(id)transdel Pages:(NSString *)_page block:(netWork)_block;

#pragma mark - 抢购活动
//抢购活动信息列表
-(void)API_YH_Buy_Activity_Info:(id)transdel type:(NSString *)type activity_id:(NSInteger)activity_id;
//抢购活动商品列表
-(void)API_YH_Buy_Activity_List:(id)transdel type:(NSString *)type activity_id:(NSInteger)activity_id page:(NSInteger)page limit:(NSInteger)limit;
#pragma mark - 绑定积分卡(430)
-(void)API_YH_My_Card_Binding_Status:(id)transdel;
-(void)API_YH_My_Card_Binding:(id)transdel captcha:(NSString *)captcha card_no:(NSString *)card_no mobile:(NSString *)mobile;

#pragma mark - 星级包邮卡
-(void)API_YH_Star_Post_Card_Show:(id)transdel;
-(void)API_YH_Star_Post_Card_Goods_List:(id)transdel;
-(void)API_YH_Star_Post_Card_Record_List:(id)transdel page:(NSInteger)page;
-(void)API_YH_Star_Post_Card_Pay_Method:(id)transdel;
-(void)API_YH_Star_Post_Card_Buy_Card:(id)transdel ppc_goods_code:(NSString *)ppc_goods_code pay_method:(NSString *)pay_method;
@end
