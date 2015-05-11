//
//  PSNetTrans.h
//  YHCustomer
//
//  Created by lichentao on 14-3-27.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//   配送相关api

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "MACROS_P.h"

// 配送方式
#define API_PS_DELIVERY_STYLE           @"v3/orders/delivery"
#define API_PS_PAYMENT_STYLE            @"v2/orders/pay_method"
#define API_PS_PAYMENT_STYLE_MONEY      @"v2/orders/reset_order_pay"
#define API_PS_LOGISTIC_STYLE           @"v3/orders/distribution_model"
#define API_PS_ORDER_COUPON_LIST        @"v3/orders/user_coupon"
#define API_PS_GOODS_LIST               @"v3/orders/cart_goods"
#define API_PS_MYORDER_LIST             @"v2/orders/order_list"
#define API_PS_MODIFY_DELIVERY_TIME     @"v2/orders/delivery_update"
#define API_SUBMIT_ORDER                @"v3/orders/order_submit"
#define API_ORDER_PAY_SUCCEED           @"v2/orders/pay_succ"
#define API_ORDER_DETAIL_APP            @"v2/orders/order_info"
#define API_ORDER_DETAIL_PDA            @"v2/orders/pda_info"

#define API_ADDRESS_LIST                @"v3/address/list"
#define API_ADD_ADDRESS                 @"v3/address/add"
#define API_UPDATE_ADDRESS              @"v2/address/update"
#define API_DELETE_ADDRESS              @"v2/address/delete"
#define API_SETDEFAULT_ADDRESS          @"v2/address/set"
#define API_ORDER_AREA_LIST             @"v2/city/list"        // 省市区街道列表

#define API_ORDER_RETURN_REASON         @"v2/return/returns_reason"
#define API_ORDER_RETURN_METHOD         @"v2/return/returns_method"
#define API_ORDER_RETURN_STORE          @"v2/return/returns_store"
#define API_ORDER_RETURN_SUBMIT         @"v2/return/returns_submit"
#define API_CANCEL_RETURN_GOODS         @"v2/return/cancel"
#define API_PS_RETURN_ORDER_LIST        @"v2/return/apply_list"
#define API_PS_RETURN_GOODS_LIST        @"v2/return/returns_goods"
#define API_PS_RETURN_ORDER             @"v2/return/input_express"

#define API_PS_DM_INFO                  @"v2/dm/info"

#define API_SEARCH_GOODS_LIST           @"v2/goods/search"

// 区域配送
#define API_PS_REGION_LIST              @"v2/region/list"
#define API_PS_REGION_PATTERN           @"v3/get_delivery_methods"//配送方式
#define API_PS_COUNTRY_STREET_LIST      @"v3/get_address_list"    //区县&街道列表
#define API_PS_STREET_SUPERMARKET_LIST  @"v3/get_street_bu"       //街道对应超市列表
#define API_PU_SUPERMARKET_LIST         @"v3/get_picked_up_bu"    //自提超市列表
#define API_PS_REGION_BUCODE            @"v3/stock_store"  //517 new process

#define API_PS_REGION_COUPON_LIST       @"v2/coupon/list"
#define API_PS_PUSH_INFO                @"v2/push/info"
#define API_PS_PICK_UP_TIME_INFO        @"v2/pick_up_time/info"


//#define API_SEARCH_KEY_GOODS_LIST       @"v2/goods/search" 
#define API_SEARCH_KEY_GOODS_LIST       @"v3/goods/list"
#define API_SEARCH_HOT_WORDS_LIST       @"v2/search/hot/keyword"
#define API_SEARCH_KEY_WORDS_LIST       @"v2/search/keyword/list"
#define API_KEY_CATEGORY_SCREEN_LIST    @"v2/search/category/list"
#define API_KEY_BRAND_SCREEN_LIST       @"v2/search/brand/list"


#define API_CATEGORY_SCREEN_LIST        @"v2/category/category_screen_list"

//积分卡绑定
#define API_CARD_BINDING                @"v2/card/is_verify/id"
//积分卡验证
#define API_CARD_VALIDATION             @"v2/card/verify/id"
//绑卡
#define API_BIND_VIPCARD                @"v2/card/binding"


@interface PSNetTrans : NSObject
{
    NSMutableArray* _arrRequst;//value:NetTransObj
    NSMutableArray* _arrTongJiKey;
}

@property (nonatomic, retain) NSMutableArray* _arrRequst;
@property (nonatomic, retain) NSMutableArray* _arrTongJiKey;
+(PSNetTrans*)getInstance;
-(ASIFormDataRequest *)post:(NSString*)strUrl;
#pragma mark --------------------------取消某一请求   netObj:NetTransObj
-(void)cancelRequest:(id)netObj;
#pragma mark --------------------------取消界面发起的所有 request  ui:当前界面对象
-(void)cancelRequestByUI:(id)ui;
#pragma mark --------------------------根据apitag获取请求对象（NetTransObj）  nTag：apitag re:NetTransObj
-(id)getNetTransByAPITag:(EnumApiTag)nTag;
#pragma -mark -------------------------define-api

/**
 * 获取配送方式
 */
-(void)ps_getDeliveryStyle:(id)transdel transaction_type:(NSString *)transaction_type;
/**
 * 获取支付方式
 */
- (void)ps_PayMentStyle:(id)transdel Type:(NSString *)_type;
- (void)ps_PayMentStyle:(id)transdel pay_method:(NSString *)pay_method order_list_no:(NSString *)order_list_no;
/*
 * 获取物流方式
 */
- (void)ps_getLogisticStyle:(id)transdel goods_id:(NSString *)goods_id;
/**
 * 优惠券列表
 */
- (void)ps_getCouponList:(id)transdel payMethod:(NSString *)payMethod lm_idForPs:(NSString *)lm_id goods_id:(NSString *)goods_id total:(NSString *)total;

/**
 * 商品列表
 */
- (void)ps_getGoodsList:(id)transdel goods_id:(NSString *)goods_id total:(NSString *)total;

/**
 * 提交订单
 */
-(void)submit_order:(id)transdel delivery_id:(NSString *)delivery_id lm_id:(NSString *)lm_id lm_time_id:(NSString *)lm_time_id is_tel:(NSString *)is_tel receipt_type:(NSString *)receipt_type receipt_title:(NSString *)receipt_title order_address_id:(NSString *)order_address_id coupon_id:(NSString *)coupon_id remark:(NSString *)remark pay_method:(NSString *)pay_method bu_id:(NSString *)bu_id time:(NSString *)time goods_id:(NSString *)goods_id total:(NSString *)total;
-(void)order_pay_succeed:(id)transdel order_list_id:(NSString *)order_list_id;
/**
 * 我的订单
 */
- (void)my_orderList:(id)transdel Type:(int )type Page:(NSString *)page;
/*
 *app订单详情
 */
- (void)my_orderDetail:(id)transdel order_list_id:(NSString *)order_list_id;
/*
 *pda订单详情
 */
- (void)my_orderDetailForPDA:(id)transdel order_list_no:(NSString *)order_list_no;
/*
 * 退货订单
*/
- (void)return_orderList:(id)transdel Type:(int)type Page:(NSString *)page;
/*
 * 退货商品列表
 */
-(void)ps_returnGoodsList:(id)transdel OrderListId:(NSString *)order_list_id;
/*
 * 退货原因列表
 */
-(void)order_return_reason:(id)transdel order_state:(NSString *)order_state;
/*
 * 退货方式列表
 */
-(void)order_return_method:(id)transdel;
/*
 * 退货门店
 */
-(void)order_return_store:(id)transdel order_list_id:(NSString *)order_list_id;
//申请退货未提货
-(void)apply_return_goods:(id)transdel order_list_id:(NSString *)order_list_id reason_code:(NSString *)reason_code reason_name:(NSString *)reason_name returns_name:(NSString *)returns_name returns_account:(NSString *)returns_account;
-(void)apply_return_goods_delivered:(id)transdel order_list_id:(NSString *)order_list_id reason_code:(NSString *)reason_code reason_name:(NSString *)reason_name returns_name:(NSString *)returns_name returns_account:(NSString *)returns_account reason_info:(NSString *)reason_info goods_info:(NSString *)goods_info returns_goods_images:(NSString *)returns_goods_images returns_card_num:(NSString *)returns_card_num returns_method:(NSString *)returns_method store_name:(NSString *)store_name store_address:(NSString *)store_address user_name:(NSString *)user_name user_tel:(NSString *)user_tel logistics_area:(NSString *)logistics_area logistics_address:(NSString *)logistics_address order_address_id:(NSString *)order_address_id;
- (void)getSearchGooosList:(id)transdel key:(NSString *)key bu_id:(NSString *)bu_id order:(NSString *)order page:(NSString *)page limit:(NSString *)limit;
//取消退货
-(void)cancel_return_goods:(id)transdel sales_return_id:(NSString *)sales_return_id;

#pragma mark -------------------地址管理
/**
 * 地址管理列表
 */
-(void)API_order_address_list_func:(id)transdel goods_id:(NSString *)goods_id;
// 增加
-(void)API_order_address_add_func:(id)transdel TrueName:(NSString*)true_name
                           Mobile:(NSString*)mobile Telephone:(NSString*)telephone
                          ZipCode:(NSString*)zip_code LogisticsArea:(NSString*)logistics_area
                 LogisticsAddress:(NSString*)logistics_address IsDefault:(NSString *)is_default goods_id:(NSString *)goods_id;
// 省市区街道查询
- (void) API_areaList:(id)transdel AreaType:(NSString *)type AreaId:(NSString *)region_id;
// 删除
-(void)API_order_address_delete_func:(id)transdel ID:(NSString*)Id;
// 更新
-(void)API_order_address_update_func:(id)transdel ID:(NSString*)Id TrueName:(NSString*)true_name
                              Mobile:(NSString*)mobile Telephone:(NSString*)telephone
                             ZipCode:(NSString*)zip_code LogisticsArea:(NSString*)logistics_area
                    LogisticsAddress:(NSString*)logistics_address sDefault:(NSString *)is_default;
// 设置为常用
-(void)API_order_address_set_func:(id)transdel ID:(NSString*)Id;

// 修改配送物流快递类型
-(void)API_order_modifyDelivery_time_func:(id)transdel order_list_id:(NSString *)order_list_id lm_id:(NSString *)lm_id lm_time_id:(NSString *)lm_time_id IsTel:(BOOL)is_tel;

// 退货单号输入
- (void)API_order_InputExpress:(id)transdel sales_return_id:(NSString *)sales_return_id express_name:(NSString *)express_name express_num:(NSString *)express_num;
//购物车手动改变数量
- (void)API_cart_change_count:(id)transdel cart_id:(NSString *)cart_id num:(NSString *)num;


#pragma mark -
#pragma mark ---------------------------------------区域配送api部分
// 区域配送获得城市列表
- (void)API_RegionCityList:(id)transdel;
#pragma mark ------------------517 old process  暂时废弃，以new 为准
// 城市配送方式
- (void)API_RegionCityPattern:(id)transdel region_id:(NSString *)region_id;
// 城市对应区县
- (void)API_RegionCountry_StreetList:(id)transdel p_id:(NSString *)p_id;
// 区县对应街道
- (void)API_RegionStreet_SupermarketList:(id)transdel region_id:(NSString *)region_id street_id:(NSString *)street_id;
// 对应门店
- (void)API_RegionPickUpSuperMarketList:(id)transdel region_id:(NSString *)region_id page:(NSString *)page limit:(NSString *)limit;
#pragma mark ------------------517 new process--------------begin
- (void)API_RegionBuCode:(id)transdel region_id:(NSString *)region_id;
#pragma mark ------------------517 new process--------------end
// 我的优惠券列表
- (void)API_MyCouponList:(id)transdel Type:(int)type Page:(NSString *)page;

// PUSH
- (void)get_Push_Info:(id)transdel PushId:(NSString *)pushId SetType:(NSString *)type;

// 修改提货时间
- (void)get_PickUp_Time:(id)transdel ReginId:(NSString *)region_id;

#pragma mark ---------------------------------商品列表（公用）
- (void)buy_getGoodsList:(id)transdel type:(NSString *)type page_type:(NSString *)page_type bu_id:(NSString *)bu_id bu_brand_id:(NSString *)bu_brand_id bu_category_id:(NSString *)bu_category_id bu_goods_id:(NSString *)bu_goods_id dm_id:(NSString *)dm_id page:(NSString *)page limit:(NSString *)limit order:(NSString *)order tag_id:(NSString *)tag_id ApiTag:(int)tag key:(NSString *)key is_stock:(NSString *)is_stock;
-(void)get_DM_Info:(id)transdel DMId:(NSString*)dm_id;

#pragma mark ------------------------new search
- (void)getKeySearchGoodsList:(id)transdel type:(NSString *)type key:(NSString *)key category_code:(NSString *)category_code is_parent_category:(NSInteger)is_parent_category brand_name:(NSString *)brand_name  order:(NSString *)order page:(NSString *)page limit:(NSString *)limit;
- (void)getKeyWordsSearchList:(id)transdel keyWord:(NSString *)key;
- (void)getHotWordsSearchList:(id)transdel;
- (void)get_Key_Category_Screen_list:(id)transdel type:(NSString *)type bu_brand_id:(NSString *)bu_brand_id tag_id:(NSString *)tag_id key:(NSString *)key;
- (void)get_Key_Brand_Screen_list:(id)transdel category_code:(NSString *)category_code key:(NSString *)key is_parent_category:(NSInteger)is_parent_category;

#pragma mark ---------------
- (void)get_Category_Screen_list:(id)transdel type:(NSString *)type bu_brand_id:(NSString *)bu_brand_id tag_id:(NSString *)tag_id key:(NSString *)key;

#pragma mark - 积分卡绑定
-(void)get_Card_Binding:(id)transdel;

-(void)get_User_Card_Validation:(id)transdel IdNumber:(NSString *)id_no;

-(void)get_Binding_Card:(id)transdel Captcha:(NSInteger)Captcha Info:(NSString *)cardinfo;






#pragma -mark -------------------------api-tag
typedef enum
{
    t_API_PS_DELIVERY_STYLE = 10001,
    t_API_PS_PAYMENT_STYLE,
    t_API_PS_PAYMENT_STYLE_MONEY,
    t_API_PS_LOGISTIC_STYLE,
    t_API_PS_ORDER_COUPON_LIST,
    t_API_ADDRESS_LIST,
    t_API_ADD_ADDRESS,
    t_API_UPDATE_ADDRESS,
    t_API_DELETE_ADDRESS,
    t_API_SETDEFAULT_ADDRESS,
    t_API_SUBMIT_ORDER,
    T_API_ORDER_PAY_SUCCEED,
    T_API_ORDER_RETURN_REASON,
    T_API_ORDER_RETURN_METHOD,
    T_API_ORDER_RETURN_STORE,
    T_API_ORDER_RETURN_SUBMIT,
    T_API_CANCEL_RETURN_GOODS,
    t_API_ORDER_DETAIL_APP,
    t_API_ORDER_DETAIL_PDA,
    t_API_PS_GOODS_LIST,
    t_API_PS_MYORDER_LIST,
    t_API_PS_MODIFY_DELIVERY_TIME,
    t_API_PS_RETURN_ORDER_LIST,
    t_API_PS_RETURN_GOODS_LIST,
    t_API_PS_RETURN_ORDER,
    t_API_PS_CART_CHANGE_COUNT,
    t_API_PS_CART_UPDATE_GOODS_NUM,
    t_API_PS_REGION_LIST,
    t_API_PS_REGION_PATTERN,
    t_API_PS_COUNTRY_STREET_LIST,
    t_API_PS_STREET_SUPERMARKET_LIST,
    t_API_PU_SUPERMARKET_LIST,
    t_API_PS_REGION_BUCODE,
    t_API_PS_REGION_COUPON_LIST,
    t_API_PS_DM_LIST,
    t_API_PS_DM_INFO,
    t_API_PS_PUSH_INFO,
    t_API_PS_PICK_UP_TIME_INFO,
    
    t_API_SEARCH_GOODS_LIST,
    t_API_CATEGORY_SCREEN_LIST,
    
    t_API_SEARCH_KEY_GOODS_LIST,
    t_API_SEARCH_KEY_WORDS_LIST,
    t_API_SEARCH_HOT_WORDS_LIST,
    t_API_KEY_CATEGORY_SCREEN_LIST,
    t_API_KEY_BRAND_SCREEN_LIST,
    //积分绑定
    t_API_CARD_BINDING,
    t_API_CARD_VALIDATION,
    t_API_BIND_VIPCARD,
}EnumPSApiTag;

@end
