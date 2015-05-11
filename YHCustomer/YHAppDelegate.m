//
//  YHAppDelegate.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHAppDelegate.h"
#import "YHMainViewController.h"
#import "YHCategoryViewController.h"
#import "YHNewCategoryViewController.h"
#import "YHPromotionViewController.h"
#import "YHMyViewController.h"
#import "YHCartViewController.h"
#import "YHCartLoginViewController.h"
#import "YHLoginViewController.h"
#import "AGViewDelegate.h"
#import "WXApi.h"
#import "VersionEntiy.h"
#import "AlixPay.h"
#import "ChuaiGuo.h"
#import "DmEntity.h"
#import "YHMyOrderViewController.h"
#import "YHPrommotionDetailController.h"
#import "YHGoodsDetailViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHPromotionListViewController.h"
#import "YHDMGoodsWallViewController.h"
#import "YHGoodsTabViewController.h"

BMKMapManager* _mapManager;

@implementation YHAppDelegate
@synthesize mytabBarController,viewDelegate;
@synthesize pushMsgInfo;
@synthesize hostReach = _hostReach;

+ (YHAppDelegate *)appDelegate {
	return (YHAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)hideTabBar:(BOOL)hidden{
    [mytabBarController hidesTabBar:hidden animated:YES];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
   AlixPayResult *result = [[AlixPay shared] handleOpenURL:url];
    
    if (result.statusCode) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AlixPayResult" object:[NSString stringWithFormat:@"%d",result.statusCode]];
    }

    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (NSArray *)getTabBarIconArray{
    NSDictionary *homeIconDic   = @{@"Normal": [UIImage imageNamed:@"guang"],@"Selected" : [UIImage imageNamed:@"guang_Select"],@"Title" : @"逛"};
    NSDictionary *shoppingIconDic = @{ @"Normal" : [UIImage imageNamed:@"buy"],@"Selected" : [UIImage imageNamed:@"buy_Select.png"],@"Title" : @"买" };
    NSDictionary *shakeIconDic = @{ @"Normal" : [UIImage imageNamed:@"my"],@"Selected" : [UIImage imageNamed:@"my_Select.png"],@"Title" : @"我的" };
    NSDictionary *likeIconDic = @{ @"Normal" : [UIImage imageNamed:@"message.png"],@"Selected" : [UIImage imageNamed:@"message_Select.png"],@"Title" : @"消息" };
    NSDictionary *myIconDic = @{ @"Normal" : [UIImage imageNamed:@"more.png"],@"Selected" : [UIImage imageNamed:@"more_Select.png"],@"Title" : @"更多" };
    
    NSArray *icons = @[homeIconDic,shoppingIconDic,shakeIconDic,likeIconDic,myIconDic];
    return icons;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    // 关于分享
    viewDelegate = [[AGViewDelegate alloc] init];
    // shareSDK官方网站上注册的应用
    [ShareSDK registerApp:@"7b13dc65eca"];
    // 导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK connectWeChatWithAppId:@"wxbceed00462510262"
                           wechatCls:[WXApi class]];
    // 揣果网
    [ChuaiGuo Begin:@"e33bb55224e643458fe7045a8bace411"];
    

    // 百度定位  要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
    
    //com.yonghui.YHCustomerHoc  a94HGMKNGRMQweprTAtXz8j0
    //com.yonghui.YHCustomer  tOXDkUf2qLf5BELAthuDEiln
	BOOL ret = [_mapManager start:@"tOXDkUf2qLf5BELAthuDEiln" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    //    /* 创建五个viewcontroller */
    YHMainViewController        *mainVC         = [[YHMainViewController alloc] init] ;
    YHNewCategoryViewController    *categoryVC     = [[YHNewCategoryViewController alloc] init];
//    YHCategoryViewController    *categoryVC     = [[YHCategoryViewController alloc] init];
//    YHPromotionViewController   *promotionVC    = [[YHPromotionViewController alloc] init];
    
    YHGoodsTabViewController *promotionV = [[YHGoodsTabViewController alloc] init];
    promotionV.navigationItem.title = @"促销商品";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"dm_home_goods" forKey:@"type"];
    [params setValue:@"0" forKey:@"bu_id"];
    [params setValue:@"default" forKey:@"order"];
    [params setValue:@"3" forKey:@"jump_type"];
    [promotionV setRequstParams:params];
    
    YHMyViewController          *myVC           = [[YHMyViewController alloc] init];
    YHCartViewController        *cartVC         = [[YHCartViewController alloc] init];
    /* 创建五个viewcontroller的导航条 */
    YHNavigationController      *mainVcNav      = mainVC.defaultNavigationController;
    YHNavigationController      *categoryNav    = categoryVC.defaultNavigationController;
//    YHNavigationController      *promotionNav   = promotionVC.defaultNavigationController;
    YHNavigationController      *promotionNav   = promotionV.defaultNavigationController;
    YHNavigationController      *myNav          = myVC.defaultNavigationController;
    YHNavigationController      *cartNav        = cartVC.defaultNavigationController;
    
    // 逛－三分页控制
    NSArray *_navControllers= @[mainVcNav,categoryNav,promotionNav,myNav,cartNav];
    /* 创建tabbar viewcontroller */
    mytabBarController = [[LeveyTabBarController alloc] initWithViewControllers:_navControllers imageArray:[self getTabBarIconArray]];
    mytabBarController.delegate = self;
    self.window.rootViewController = mytabBarController
    ;
    
    // 自动登录
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *remPwd = [userDefaults objectForKey:@"passWord"];
    NSString *remUser = [userDefaults objectForKey:@"userName"];
    
    // 非首次登陆 自动调用登陆接口
    if (remPwd && remUser)
    {
        [[NetTrans getInstance] user_login:self UserName:remUser Password:remPwd];
    }
    
    [MTA startWithAppkey:@"I1JEGNT13N8T"];
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    // [2]:注册APNS
    [self registerRemoteNotification];
    // [2-EXT]: 获取启动时收到的APN
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerRemoteNotification
{
    if (IOS_VERSION >=8) {
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
}

#pragma -mark ---------------------------------LeveyTabBarControllerDelegate
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}

- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    int index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index == 4) {
        if ([[UserAccount instance] isLogin]) {
            YHCartViewController *cart = [[YHCartViewController alloc] init];
            cart.callBack = ^(){
                [mytabBarController setSelectedIndex:selectTab];
            };
            YHNavigationController *nav = cart.defaultNavigationController;
            [mytabBarController presentModalViewController:nav animated:YES];
        }else{
            YHCartLoginViewController *cartLogin = [[YHCartLoginViewController alloc] init];
            cartLogin.loginSuccessBlock = ^(UserAccount *account){
                [mytabBarController dismissViewControllerAnimated:YES completion:^{
                
                }];
            };
            cartLogin.callBack = ^(){
                [mytabBarController setSelectedIndex:selectTab];
            };
            [mytabBarController presentModalViewController:cartLogin animated:YES];
        }
    }else{
           selectTab = index;
    }
    if (index == 3) {
       BOOL isLogin = [self checkLogin];
        if (isLogin == NO) {
            return NO ;
        }
    }
    return YES;
}

- (BOOL)checkLogin{
    if (![[UserAccount instance] isLogin]) {
        YHLoginViewController *loginViewCtrl = [[YHLoginViewController alloc] init];
        // 登陆成功或者失败 callBack
        loginViewCtrl.loginBackBlock = ^{
            
        };
        loginViewCtrl.loginSuccessBlock = ^(UserAccount *account){
            [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES                           completion:^{
                NSLog(@"login success!!!");
            }];
        };
        
        [mytabBarController presentModalViewController:loginViewCtrl animated:YES];
        return NO;
    }
    return YES;
}

// 改变购物车数量
- (void)changeCartNum:(NSString *)cartNum{
    NSString *strNum = [NSString stringWithFormat:@"%@",cartNum];
    if ([strNum intValue] == 0) {
        mytabBarController.tabBar.numButton.hidden = YES;
        return;
    }else{
        mytabBarController.tabBar.numButton.hidden = NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"cartNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [mytabBarController.tabBar.numButton setTitle:strNum forState:UIControlStateNormal];
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (t_API_VERSION == nTag) {
        VersionEntiy *version = (VersionEntiy *)netTransObj;
        NSString *verNum = version._version;
        if ([version.force_update integerValue] == 1&&verNum.integerValue > K_VERSION_CODE) { //强制更新bool
            isForceUpdate = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                // something
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"监测到您目前用的版本不是新版本,需强制更新" delegate:self cancelButtonTitle:nil otherButtonTitles:@"前往", nil];
                alert.tag = 1002;
                [alert show];
            });

        }else{
            if (verNum.integerValue > K_VERSION_CODE) {
                //前往appstore下载
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"监测到您目前用的版本不是新版本" delegate:self cancelButtonTitle:@"暂时忽略" otherButtonTitles:@"前往", nil];
                alert.tag = 1001;
                [alert show];
                });
            }
        }
    }
    if (nTag == t_API_USER_LOGIN_API){
        [[NetTrans getInstance] getCartGoodsNum:self];
    }
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
    if (nTag == t_API_PS_PUSH_INFO) {
        [self receivePushNotificationMsg:(DmEntity *)netTransObj];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 强制更新
    if (isForceUpdate == YES && alertView.tag == 1002) {
        NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
    
    // 提示更新
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
    // 推送消息
    if (alertView.tag ==1003 && buttonIndex == 1) {
        [[PSNetTrans getInstance] get_Push_Info:self PushId:[self.pushMsgInfo objectForKey:@"push_id"] SetType:[self.pushMsgInfo objectForKey:@"type"]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // [EXT] 重新上线  个推每次启动后台时候都会上传  appid && appkey && appsecret
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];

     if (selectTab == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MY_PROMOTION_REFRESH_FOCUS object:nil];
    }
    //监测版本
    [[NetTrans getInstance] API_version_check:self AgentID:@"2" Type:@"consumer"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma -mark
#pragma -geTui---------------------------------API相关
// 获得deviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    // 上传token
    [self setDeviceToken:hexToken];
}

// [3-EXT]:如果APNS注册失败，通知个推服务器
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error:%@", error);

    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
}

/* 通知页面跳转类型：1 首页，2 促销页 ， 3 促销栏目首页， 4 商品分类页 ，5 商品页面 ， 6 标签商品列表页
 */
- (void)receivePushNotificationMsg:(DmEntity *)dmEntity{
 
    NSString *type = [self.pushMsgInfo objectForKey:@"type"];
    UINavigationController *contro = [mytabBarController.viewControllers objectAtIndex:selectTab];
    
    if([type isEqualToString:@"3"]){
        // 促销商品页面
        [self dmJumpLogic:dmEntity];
        
    }else if ([type isEqualToString:@"4"]){
        // 品类下的商品列表页面
        
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        if (![dmEntity.name isEqualToString:@"<null>"]) {
            vc.navigationItem.title = dmEntity.name;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"category" forKey:@"type"];
        [dic setValue:dmEntity.type forKey:@"bu_category_id"];
        [dic setValue:@"default" forKey:@"order"];
        [dic setValue:@"1" forKey:@"jump_type"];
        [vc setRequstParams:dic];
        [contro pushViewController:vc animated:YES];
        
//        YHWebGoodListViewController *goodList = [[YHWebGoodListViewController alloc] init];
//        [goodList setParamerWihtType:@"5" Id:dmEntity.type];
//        if (![dmEntity.name isEqualToString:@"<null>"]) {
//            goodList.navigationItem.title = dmEntity.name;
//        }
//        [contro pushViewController:goodList animated:YES];
        
    }else if ([type isEqualToString:@"5"]){
        // 商品详情页面
        YHGoodsDetailViewController *goodsDetail = [[YHGoodsDetailViewController alloc] init];
        NSString *url = [NSString stringWithFormat:GOODS_DETAIL,dmEntity.type,[UserAccount instance].session_id,[UserAccount instance].region_id];
        [goodsDetail setMainGoodsUrl:url goodsID:dmEntity.type];
        [contro pushViewController:goodsDetail animated:YES];
    }else if ([type isEqualToString:@"6"]){
        // 指定商品tag_id页面
        
        
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        vc.navigationItem.title = dmEntity.name;
   
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"home_tag_goods" forKey:@"type"];
        [dic setValue:@"0" forKey:@"bu_id"];
        [dic setValue:dmEntity.type forKey:@"tag_id"];
        [dic setValue:@"default" forKey:@"order"];
        [dic setValue:@"3" forKey:@"jump_type"];
        [vc setRequstParams:dic];
        [contro pushViewController:vc animated:YES];
        
//        YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//        if (![dmEntity.name isEqualToString:@"<null>"]) {
//            proVC.navigationItem.title = dmEntity.name;
//        }
//        [proVC setParamerWihtType:@"7" Id:@"" tag:[dmEntity.type intValue]];
//        [contro pushViewController:proVC animated:YES];
    }
}

#pragma mark ----------------  改版促销跳转逻辑
-(void)dmJumpLogic:(DmEntity *)entity {
    UINavigationController *contro = [mytabBarController.viewControllers objectAtIndex:selectTab];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];

    if ([entity.connect_goods isEqualToString:@"0"]) {//0为不关联商品促销
        
        YHPrommotionDetailController *promotionDetail = [[YHPrommotionDetailController alloc] init];
        [promotionDetail setDMId:entity.dm_id];
        [contro pushViewController:promotionDetail animated:YES];
        
    } else if ([entity.connect_goods isEqualToString:@"1"] || [entity.connect_goods isEqualToString:@"2"]) {//1为关联商品促销  2是促销关联的标签商品
        
        if ([entity.page_type isEqualToString:@"0"]) {//0为列表模式
            
            YHPromotionListViewController *listVC = [[YHPromotionListViewController alloc]init];
            listVC.dmEntity = entity;
            [contro pushViewController:listVC animated:YES];
            
        } else {//1为网格模式
            
            YHDMGoodsWallViewController *goodWall = [[YHDMGoodsWallViewController alloc] init];
            goodWall.dm_Entity = entity;
            [contro pushViewController:goodWall animated:YES];
            
        }
        
    }
    
}

// 将注册信息上传给个推服务器
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        _clientId = nil;
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {

        } else {
            _sdkStatus = SdkStatusStarting;
        }
    }
}

// [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        _sdkStatus = SdkStatusStoped;
        _clientId = nil;
    }
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
        
    }
    return YES;
}

// 设置devicetoken
- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    [_gexinPusher registerDeviceToken:aToken];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = clientId;
}

// [4]: 收到个推消息 － 透传内容
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    self.pushMsgInfo = [payloadMsg  objectFromJSONString];
//        NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
//        [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNum - 1;
    if ([[self.pushMsgInfo objectForKey:@"type"] isEqualToString:@"1"]) {
        // 首页
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];

    }else if ([[self.pushMsgInfo objectForKey:@"type"] isEqualToString:@"2"]){
        // 促销首页
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:2];
    }
    else{

        UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:[self.pushMsgInfo objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"忽略",@"前往", nil];
        pushAlert.delegate = self;
        pushAlert.tag = 1003;
        [pushAlert show];
    }
  }
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"record %@",record);
}

@end
