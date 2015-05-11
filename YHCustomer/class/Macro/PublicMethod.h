//
//  PublicMethod.h
//  SuNingCustomer
//
//  Created by wangbob on 13-7-22.
//  Copyright (c) 2013年 SuNing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributedLabel.h"
#import "YHAlertView.h"
// 统计页面访问 次数 && 时长
#define PAGE1 @"首页"
#define PAGE2 @"促销活动页面（幻灯片页面）"
#define PAGE3 @"商品列表页面"
#define PAGE4 @"商品页面"
#define PAGE5 @"商品详情页面"
#define PAGE6 @"商品评论页面"
#define PAGE7 @"分类频道页面"
#define PAGE8 @"促销频道页面"
#define PAGE9 @"我的页面"
#define PAGE10 @"我的订单页面"
#define PAGE11 @"订单详情页面"
#define PAGE12 @"我的收藏页面"
#define PAGE13 @"我的积分卡页面"
#define PAGE14 @"我的优惠券页面"
#define PAGE15 @"购物车页面"
#define PAGE20 @"菜谱主页面"
#define PAGE30 @"摇一摇主页面"
//签到界面
#define PAGE100 @"签到界面"
//永辉钱包
#define PAGE101 @"永辉钱包主页面"
#define PAGE102 @"永辉钱包账户充值页面"
#define PAGE103 @"永辉钱包购买永辉卡页面"
#define PAGE104 @"永辉钱包转赠好友页面"
#define PAGE105 @"永辉钱包门店支付页面"
#define PAGE106 @"永辉钱包我的永辉卡页面"
#define PAGE107 @"永辉钱包转赠信息页面"
//抢购界面
#define PAGE108 @"固定抢购页面"
#define PAGE109 @"灵活抢购页面"
//积分卡界面
#define PAGE110 @"积分卡绑定页面"
#define PAGE111 @"修改联系人页面"
#define PAGE112 @"替换联系人页面"
#define PAGE113 @"绑定手机号页面"
#define PAGE114 @"忘记密码页面"
#define PAGE115 @"忘记密码设置密码页面"
#define PAGE116 @"忘记密码邮箱密码页面"


// 统计按钮点击次数
#define EVENT_ID1 @"event_id1"
#define EVENT_ID2 @"event_id2"
#define EVENT_ID3 @"event_id3"
#define EVENT_ID4 @"event_id4"
#define EVENT_ID5 @"event_id5"
#define EVENT_ID6 @"event_id6"
#define EVENT_ID7 @"event_id7"
#define EVENT_ID8 @"event_id8"
#define EVENT_ID9 @"event_id9"

#define EVENT_ID10 @"event_id10"
#define EVENT_ID11 @"event_id11"
#define EVENT_ID12 @"event_id12"
#define EVENT_ID13 @"event_id13"
#define EVENT_ID14 @"event_id14"
#define EVENT_ID15 @"event_id15"
#define EVENT_ID16 @"event_id16"
#define EVENT_ID17 @"event_id17"
#define EVENT_ID18 @"event_id18"
#define EVENT_ID19 @"event_id19"

#define EVENT_ID20 @"event_id20"
#define EVENT_ID21 @"event_id21"
#define EVENT_ID22 @"event_id22"
#define EVENT_ID23 @"event_id23"
#define EVENT_ID24 @"event_id24"
#define EVENT_ID25 @"event_id25"
#define EVENT_ID26 @"event_id26"
#define EVENT_ID27 @"event_id27"
#define EVENT_ID28 @"event_id28"
#define EVENT_ID29 @"event_id29"

#define EVENT_ID30 @"event_id30"
#define EVENT_ID31 @"event_id31"
#define EVENT_ID32 @"event_id32"
#define EVENT_ID33 @"event_id33"
#define EVENT_ID34 @"event_id34"
#define EVENT_ID35 @"event_id35"

#define EVENT_ID40 @"event_id40"
#define EVENT_ID41 @"event_id41"
#define EVENT_ID42 @"event_id42"
#define EVENT_ID43 @"event_id43"
#define EVENT_ID44 @"event_id44"
//摇一摇
#define EVENT_ID45 @"event_id45"//首页摇一摇入口按钮
#define EVENT_ID46 @"event_id46"//摇一摇界面分享按钮

#define EVENT_ID50 @"event_id50"//首页菜谱入口按钮

//签到入口以及签到按钮
#define EVENT_ID100 @"event_id100"
#define EVENT_ID101 @"event_id101"

//钱包入口（首页和我的界面）
#define EVENT_ID102 @"event_id102"
#define EVENT_ID103 @"event_id103"


// 统计漏斗事件

typedef void (^shareCallBackBlock) (id obj);
@interface PublicMethod : NSObject<YHAlertViewDelegate>

@property (nonatomic,copy)shareCallBackBlock block;

+(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage;
+(void) addBackButtonWithTarget:(UIViewController *)viewController action:(SEL)action;
+(void)addRightViewWithTarget:(UIViewController *)viewController title:(NSString *)title action:(SEL)action;
+(void) addBackViewWithTarget:(UIViewController *)viewController action:(SEL)action;

//网络提示修改

+(NSString *)changeStr:(NSString *)_str;

/**
 * 生成导航条背景
 */
+(void)addNavBackground:(UIView *)view title:(NSString *)title;
//生成纯色图片的方法
+ (UIImage *)imageWithColor:(UIColor *)color;
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

//保存图片
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

//检查邮箱格式
+(BOOL)validateEmail:(NSString*)email;
+ (BOOL) NSStringIsValidEmail:(NSString*)checkString;
+ (NSString *)documentFolderPath;

/***
 * @brief 手机号有效性检查
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
// 6到20位数字和字母组合的密码
+(BOOL)isVaildPassword:(NSString *)passwordNum;
/***
 * @brief 密码有效性检查
 */
+ (BOOL)isPassword:(NSString *)password;
/*加载状态*/
+(void)ShowWaitingView:(BOOL)isShow;

// 普通label
+ (UILabel *)addLabel:(CGRect)rect setTitle:(NSString *)title setBackColor:(UIColor *)color setFont:(UIFont *)font;

// 增加特殊label
+ (AttributedLabel *)addLabelAttribute:(CGRect)rect setTitle:(NSString *)title setBackColor:(UIColor *)color setFont:(UIFont *)font;

+ (UIImageView *)addImageView:(CGRect)rect setImage:(NSString *)imageString;
+ (UIView *)addBackView:(CGRect)rect setBackColor:(UIColor *)color;
+ (UIButton *)addButton:(CGRect)rect title:(NSString *)title backGround:(NSString *)imgString setTag:(NSInteger)tag setId:(id)_sel selector:(SEL)selector setFont:(UIFont *)font setTextColor:(UIColor *)color;
//通过十六进制和alpha生成颜色
+ (UIColor*)colorWithHexValue:(NSInteger)aHexValue
                        alpha:(CGFloat)aAlpha;

+ (UIColor *)colorWithHexValue1:(NSString *)hexColor;

// 通过字符串判断label高度
+ (CGFloat)getLabelHeight:(NSString *)labelString setLabelWidth:(CGFloat)labelwidth setFont:(UIFont *)font;

// 调用支付宝 订单参数＋支付方式

/***
 * @brief 身份证有效性检查
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

//输入的日期字符串形如：@"1992-05-21 13:08"
+(NSDate *)dateFromString:(NSString *)dateString;
+(NSDate *)dateFromStringOther:(NSString *)dateString;
// 传入时间－转换时间戳
+(NSString * )NSStringToNSDate: (NSString * )string;
+ (NSString * )NSStringToNSDateToSS: (NSString * )string;
//时间戳转换成时间格式
+ (NSString *)timeStampConvertToFullTime:(NSString *)stampTime;
// 传入时间date - 时间字符串2013年12月30日 19:30
+ (NSString *)nsdateConvertToTimeString:(NSDate *)inputDate;
// 字符串中是否包含汉字
+ (BOOL)isHasHanZiBool:(NSString *)inputStr;
// 传入数组转化成sectiong 热门a-z
+ (NSMutableArray *)convertToSectionArray:(NSArray *)originDataArray HotCityArray:(NSMutableArray *)hotCity;
//UILabel 大小计算
+(CGSize)getLabelSize:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

//微信分享
+ (void)showShareMainViewWithContent:(NSString *)content title:(NSString *)title url:(NSString *)url description:(NSString *)description shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)showShareMainViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)showCustomShareViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)showCustomShareListViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController  shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)showCustomShareListWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description block:(shareCallBackBlock)block VController:(UIViewController *)VController  shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
//分享
+ (void)showCustomShareListViewWithWxContent:(NSString *)WXcontent sinaWeiboContent:(NSString *)sinaWeiboContent title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description qrCodeSrc:(NSString *)qrCodesrc block:(shareCallBackBlock)block VController:(id)VController  shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)showCustomShareListViewWithWxContent:(NSString *)WXcontent sinaWeiboContent:(NSString *)sinaWeiboContent flat:(NSInteger)flat title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description qrCodeSrc:(NSString *)qrCodesrc block:(shareCallBackBlock)block VController:(id)VController  shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)showCustomShareListViewWithWxContent:(NSString *)WXcontent sinaWeiboContent:(NSString *)sinaWeiboContent flat:(NSInteger)flat title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description qrCodeSrc:(NSString *)qrCodesrc block:(shareCallBackBlock)block VController:(id)VController AlertViewController:(id)AlertViewController shareType:(ShareType)shareType, ...NS_REQUIRES_NIL_TERMINATION;
@end
