//
//  MACROS_P.h
//  BaseCode
//
//  Created by liuyao on 13-7-17.
//  Copyright (c) 2013年 iosteam. All rights reserved.
//  配置
#define OUTTIME 10

#define NAVBAR_HEIGHT 44.0f
#define kTabBarHeight 49.0f

/*版本号*/
#define K_VERSION_CODE      16

#define VERSION           @"2.2.0"


/*获取设备版本（ios版本*/
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy年MM月dd日 HH:mm")
#define kDEFAULT_DATE_TIME_FORMAT_STOREPICK (@"yyyy-MM-dd HH:mm")
#define kDEFAULT_DATE_TIME_FORMAT_STOREPICK_SS (@"yyyy-MM-dd HH:mm:ss")



/* 网络返回状态 */
#define WEB_STATUS_1        @"1"
#define WEB_STATUS_0        @"0"
#define WEB_STATUS_2        @"2"
#define WEB_STATUS_3        @"10000"

//这个是后台没有任何返回值（即错误的时候）
#define WEB_STATUS_4         @"-1"

/* iphone 5设备检测 */
#define ScreenSize (iPhone5 ? CGSizeMake(320, 548) : CGSizeMake(320, 460))
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/* 导航条左右按钮 */
#define BARBUTTON(TITLE, SELECTOR) [UIBarButtonItem rightBarButtonItemWithTitle:TITLE target:self action:SELECTOR forControlEvents:UIControlEventTouchUpInside]

#define BACKBARBUTTON(TITLE, SELECTOR) [UIBarButtonItem backBarButtonItemWithTitle:TITLE target:self action:SELECTOR forControlEvents:UIControlEventTouchUpInside]

/*定义颜色*/
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
// 定义浅灰色
#define LIGHT_GRAY_COLOR [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f]

/*屏幕宽高*/
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/*导航栏按钮宽高*/
#define NAV_BACK_WIDTH 12.5
#define NAV_BACK_HEIGTH 20

/*在push界面界面的高度*/
#define TURE_VIEW_HIGTH  (([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) ? ([UIScreen mainScreen].bounds.size.height-64):([UIScreen mainScreen].bounds.size.height-64))

/*消息通知宏定义*/
#define MY_PROMOTION_REFRESH_FOCUS  @"MY_PROMOTION_REFRESH_FOCUS"

/*区域配送－城市*/
#define CITY_FIRST_LETTER	@"定热ABCDEFGHIJKLMNOPQRSTUVWXYZ"

#define FIRST_LAUNCH_APP @"First_Launch_App"
#define FIRST_CHOOSE_CITY @"First_Choose_City"
#define FIRST_ENTER_APP @"First_Enter_App"

typedef NS_ENUM(NSInteger, TimeStype)
{
    One_Stype = 0,//抢购明天开始
    Two_Stype ,//抢购今天开始，但是没有开始
    Three_Stype,//抢购开始了，还没有结束
    Four_Stype,//初始化或者没有抢购
} ;
typedef enum {
    LogOut_Usual,
    LogOut_Passive_Present,
    LogOut_Passive_Push
}LogOutType;

typedef enum{
    STORE_TYPE_URAL = 0,
    STORE_TYPE_JS = 3
}STORE_TYPE;

typedef enum{
    AlixPayType_Faster = 0,  // 快捷支付
    AlixPayType_Web          // web支付
} PayType;

#pragma mark - More/ReFresh
typedef enum
{
    Load_InitStyle,           // 初始化
	Load_MoreStyle,           // 加载更多
	Load_RefrshStyle          // 下拉刷新
} WallLoadStyle;

// 我的订单
typedef NS_ENUM (NSInteger,MyOrderType)
{
    UnPay=1,
    HasPay,
    Finish,
    getAlready,
} ;

// tableview是搜索还是列表状态
typedef enum{
    TABLEVIEW_SEARCH = 1,
    TABLEVIEW_LIST,
}TableViewStyle;

// 定位两种状态
typedef enum{
    Location_START = 1,
    Location_SUCESS,
    Location_FAIL,
    Location_NOEXSIT,
}LocationStyle;

typedef enum{
    GOODS_COMMENT_LIST,       // 商品评论
    PROMOTION_COMMENT_LIST    // 促销评论
}CommentType;

typedef enum{
    GOODS_DETAIL_SHARE,       // 商品详情
    DM_DETAIL_SHARE           // 促销详情
}DetailTypeForShare;

typedef NS_ENUM(NSInteger, SubType)  {
    StoreType = 0, //门店
    BrandType = 1, //品牌
    CategoryType = 2, //品类
    SHOPPE = 3,
} ;

typedef NS_ENUM(NSInteger, CollectType)  {
    DmType = 0,
    GoodsType = 1,
    MenuType = 2,
};

typedef enum{
    StoreListFromGuang,
    SToreLIstFromBuy,
}StoreListFromWhere;

typedef enum{
    E_Login_UserName = 1,
    E_Login_UserPassWord,
    E_Card_CardNum,
    E_Card_Mobile,
    E_TextField_Login_UserName = 1,
    E_TextField_Login_UserPassWord,
    E_TextField_Reg_Tel,
    E_TextField_Reg_Captcha,
    E_TextField_Reg_NickName,
    E_TextField_PassWord,
    E_TextField_ComfirmPassWord,
    E_TextField_OldPassWord,
    E_TextField_Address,
    E_TextField_UserName,
    E_TextField_Mobile,
} enumTextFieldType;

typedef enum{
    Fetch,
    Deliver,
}PSModel;

typedef enum{
    FetchPS,
    DeliverPS_PayOnline,
    DeliverPS_PayOffline,
}OrderPSModel;

#pragma mark - 扫描
typedef enum
{
    Sao_Pay,
    Sao_Goods
}SaoType;

#ifdef PRODUCTION
/* 生产环境 */
#define BASE_URL @"http://app.yonghui.cn:8081/"
#define CHINA_UNIONPAY_MODE @"00"

#define kAppId           @"q18AEnLYfpAyuH9fhIQr73"
#define kAppKey          @"U9MPBdOeOe98FnIB5joQ16"
#define kAppSecret       @"j3KrrYcihE9lBfQyJIqJY5"

#else

/* 测试环境 */
#define BASE_URL @"http://newtest.app.yonghui.cn:8081/" //永辉

//#define BASE_URL  @"http://app.cloud360.com.cn/" //e-future

#define CHINA_UNIONPAY_MODE @"01"

/* 开发环境 */
//#define BASE_URL @"http://test.app.yonghui.cn/"
//#define CHINA_UNIONPAY_MODE @"01"

/* 体验环境 */
//#define BASE_URL @"http://newtest.app.yonghui.cn:8082/"
//#define CHINA_UNIONPAY_MODE @"01"

// 测试-development
#define kAppId           @"fkHg2NGHo66HbLmAVzrlWA"
#define kAppKey          @"TkANjN9MwI76ehMVHax896"
#define kAppSecret       @"3NRsdfnZ2w76lFM8ptBit3"

#endif

//会员卡详情
#define VIP_CARD_DETAIL_URL  BASE_URL@"v2/page/card_detail?user_id=%@&session_id=%@"  //(user_id 用户ID)
//帮助
#define HELP_URL BASE_URL@"v1/page/help?type=2&session_id=%@"
// 关于产品
#define ABOUT_URL BASE_URL@"page/page/newabout?version=%@&type=consumer&agent_id=2&session_id=%@"
//// 优惠券列表- 已经改原生了
//#define COUPON_LIST_URL BASE_URL@"v1/page/coupon?session_id=%@"
// 优惠券详情
#define COUPON_DETAIL_URL BASE_URL@"v2/page/coupon_detail?id=%@&session_id=%@&region_id=%@"
// 促销详情
#define PROMOTION_DETAIL_URL BASE_URL@"v2/page/dm_detail?dm_id=%@&session_id=%@&region_id=%@"
// 商品列表
#define GOODS_LIST BASE_URL@"v2/page/sku_list?type=%@&%@=%@&session_id=%@&region_id=%@"
#define GOODS_LIST_WITH_TYPE BASE_URL@"v2/page/sku_list?type=%@&tag_id=%@&session_id=%@&region_id=%@"
#define CATEGORY_GOODS_LIST_WITH_TYPE BASE_URL@"v2/page/sku_list?type=%@&bu_category_id=%@&session_id=%@&region_id=%@"
#define BAND_GOODS_LIST_WITH_TYPE BASE_URL@"v2/page/sku_list?type=%@&bu_brand_id=%@&session_id=%@&region_id=%@"
// 商品详情
#define GOODS_DETAIL BASE_URL@"v3/page/goods_info?bu_goods_id=%@&&session_id=%@&region_id=%@&bu_code=%@"
// 订单详情
#define ORDER_DETAIL BASE_URL@"v2/page/order_detail?order_list_id=%@&session_id=%@&region_id=%@"
// 配送详情
#define DEVELIY_DETAIL BASE_URL@"v2/page/order_delivery_info?session_id=%@&order_list_id=%@&region_id=%@"
// 配送政策
#define DEVELIY_INFO BASE_URL@"v1/page/service_info?type=%@&session_id=%@&region_id=%@"

/* 控制log输出 */
#ifdef SHOWLOG
#define NSLog(fmt, ...) NSLog(fmt,##__VA_ARGS__);
#else
#define NSLog(fmt, ...)
#endif

