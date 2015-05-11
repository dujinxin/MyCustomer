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
#import "WeiboSDK.h"
#import "VersionEntiy.h"
#import "AlixPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ChuaiGuo.h"
#import "DmEntity.h"
#import "YHMyOrderViewController.h"
#import "YHPrommotionDetailController.h"
#import "YHGoodsDetailViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHPromotionListViewController.h"
#import "YHDMGoodsWallViewController.h"
#import "YHGoodsTabViewController.h"
#import "SYAppStart.h"


BMKMapManager * _mapManager;
@implementation YHAppDelegate
@synthesize mytabBarController,viewDelegate;
@synthesize pushMsgInfo;
@synthesize selectTab;
@synthesize cartViewCon;



+ (YHAppDelegate *)appDelegate {
	return (YHAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)hideTabBar:(BOOL)hidden{
    [mytabBarController hidesTabBar:hidden animated:YES];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if ([[url scheme]isEqualToString:@"yhms"]) {
        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
    }else{
        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
    }
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//   AlixPayResult *result = [[AlixPay shared] handleOpenURL:url];
//    if (result.statusCode) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"AlixPayResult" object:[NSString stringWithFormat:@"%d",result.statusCode]];
//    }
    
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AlixPayResult" object:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"AlixPayResult" object:[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]];
        }];
    }

    [ShareSDK handleOpenURL:url
          sourceApplication:sourceApplication
                 annotation:annotation
                 wxDelegate:self];

    return  YES;
}

- (NSArray *)getTabBarIconArray{
//    NSDictionary *homeIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"guang"],@"Normal",[UIImage imageNamed:@"guang_Select"],@"Selected",@"逛",@"Title", nil];
//    NSDictionary *shoppingIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"buy"],@"Normal",[UIImage imageNamed:@"buy_Select"],@"Selected",@"买",@"Title", nil];
//    NSDictionary *shakeIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"my"],@"Normal",[UIImage imageNamed:@"my_Select"],@"Selected",@"我的",@"Title", nil];
//    NSDictionary *likeIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"message.png"],@"Normal",[UIImage imageNamed:@"message_Select"],@"Selected",@"消息",@"Title", nil];
//    NSDictionary *myIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"more.png"],@"Normal",[UIImage imageNamed:@"more_Select"],@"Selected",@"更多",@"Title", nil];
    NSDictionary *homeIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"nav_main"],@"Normal",[UIImage imageNamed:@"nav_main_selected"],@"Selected",@"逛",@"Title", nil];
    NSDictionary *shoppingIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"nav_category"],@"Normal",[UIImage imageNamed:@"nav_category_selected"],@"Selected",@"买",@"Title", nil];
    NSDictionary *shakeIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"nav_pro"],@"Normal",[UIImage imageNamed:@"nav_pro_selected"],@"Selected",@"我的",@"Title", nil];
    NSDictionary *likeIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"nav_my"],@"Normal",[UIImage imageNamed:@"nav_my_selected"],@"Selected",@"消息",@"Title", nil];
    NSDictionary *myIconDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"nav_cart"],@"Normal",[UIImage imageNamed:@"nav_cart_selected"],@"Selected",@"更多",@"Title", nil];
    NSArray *icons = [NSArray arrayWithObjects: homeIconDic,shoppingIconDic,shakeIconDic,likeIconDic,myIconDic,nil];
    return icons;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        [[NetTrans getInstance]API_main_launch:self];
    });
    if (![defaults valueForKey:@"udid"]){
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            [[NetTrans getInstance]unique_identifier:self];
        });
    }

    
    NSLog(@"本地地址：%@", NSHomeDirectory());
    // 关于分享
    viewDelegate = [[AGViewDelegate alloc] init];
    // shareSDK官方网站上注册的应用
//    [ShareSDK registerApp:@"7b13dc65eca"];
    [ShareSDK registerApp:@"45fc498be608"];

    [WeiboSDK enableDebugMode:YES];
    // 导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK connectWeChatWithAppId:@"wxbceed00462510262"
                           wechatCls:[WXApi class]];
    //45fc498be608
    //92fffc522c2a6de708a57cec9388ea62
    //520063555
    //334067194b7b54899444832d7bc75373
    [ShareSDK connectSinaWeiboWithAppKey:@"520063555" appSecret:@"334067194b7b54899444832d7bc75373" redirectUri:@"http://www.weibo.com" weiboSDKCls:[WeiboSDK class]];
    
//    [ShareSDK ssoEnabled:NO];
    // 揣果网
    [ChuaiGuo Begin:@"e33bb55224e643458fe7045a8bace411"];
    
    // 百度定位  要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    //com.yonghui.YHCustomerHoc  a94HGMKNGRMQweprTAtXz8j0
    //com.yonghui.YHCustomer  tOXDkUf2qLf5BELAthuDEiln
    //rMQmvZ51Dypgt7ZlHrjQoGOh

    BOOL ret = [_mapManager start:@"rMQmvZ51Dypgt7ZlHrjQoGOh" generalDelegate:self];

    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    //    /* 创建五个viewcontroller */
    YHMainViewController        *mainVC         = [[YHMainViewController alloc] init] ;
    YHNewCategoryViewController    *categoryVC     = [[YHNewCategoryViewController alloc] init];
    YHGoodsTabViewController *promotionV = [[YHGoodsTabViewController alloc] init];
    promotionV.navigationItem.title = @"促销商品";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"home_dm" forKey:@"type"];
    [params setValue:@"0" forKey:@"bu_id"];
    [params setValue:@"default" forKey:@"order"];
    [params setValue:@"3" forKey:@"jump_type"];
    [promotionV setRequstParams:params];
    YHMyViewController          *myVC           = [[YHMyViewController alloc] init];
    YHCartViewController        *cartVC         = [[YHCartViewController alloc] init];
    /* 创建五个viewcontroller的导航条 */
    YHNavigationController      *mainVcNav      = mainVC.defaultNavigationController;
    YHNavigationController      *categoryNav    = categoryVC.defaultNavigationController;
    YHNavigationController      *promotionNav   = promotionV.defaultNavigationController;
    YHNavigationController      *myNav          = myVC.defaultNavigationController;
    YHNavigationController      *cartNav        = cartVC.defaultNavigationController;
    
    // 逛－三分页控制
    NSArray *_navControllers= [NSArray arrayWithObjects:mainVcNav,categoryNav,promotionNav,myNav,cartNav, nil];
    /* 创建tabbar viewcontroller */
    mytabBarController = [[LeveyTabBarController alloc] initWithViewControllers:_navControllers imageArray:[self getTabBarIconArray]];
    mytabBarController.delegate = self;
    
//    self.window.rootViewController = mytabBarController;
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [bgImage setHidden:YES];
    //        [self.window setRootViewController:mytabBarController];
    //    });
    
    
    [MTA startWithAppkey:@"I1JEGNT13N8T"];
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    // [2]:注册APNS
    [self registerRemoteNotification];
    // [2-EXT]: 获取启动时收到的APN
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    BOOL isFirstLaunchApp = [defaults boolForKey:FIRST_LAUNCH_APP];
    if (!isFirstLaunchApp) {
        [defaults setBool:YES forKey:FIRST_LAUNCH_APP];
        [self showIntroWithCrossDissolve];
//        if( [[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone ){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的消息功能未开启，请去(设置>通知>永辉微店)开启一下吧！" delegate:self cancelButtonTit''le:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
    }else{
        if ([defaults objectForKey:@"imageData"] && [defaults floatForKey:@"show_time"] != 0) {
            UIImage * image = [[UIImage alloc]initWithData:[defaults objectForKey:@"imageData"]];
            [SYAppStart show:image];
            CGFloat time = [defaults floatForKey:@"show_time"];
            [self performSelector:@selector(hideLaunchImage) withObject:nil afterDelay:time];
            self.window.userInteractionEnabled = NO;
        }
        self.window.rootViewController = mytabBarController;
    }
    [defaults synchronize];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)initSetup:(UIView *)bg{

}
- (void)hideLaunchImage{
    [SYAppStart hide:YES];
    self.window.userInteractionEnabled = YES;
   
}
- (void)registerRemoteNotification
{
    if (IOS_VERSION >=8)
    {
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

#pragma -mark ---------------------------------LeveyTabBarControllerDelegate
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}
//选中标签栏上的按钮的方法
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    TipTab = index;
    //选中购物车
    if (index == 4)
    {
        [MTA trackCustomKeyValueEvent:EVENT_ID6 props:nil];
        if ([[UserAccount instance] isLogin])
        {
            cartViewCon = [[YHCartViewController alloc] init];
            //             __weak typeof(self) weakSelf = self;
            __block YHAppDelegate *weakSelf = self;
            cartViewCon.callBack = ^(){
                //                __weak typeof(self) weakSelf = self;
                //                __block YHAppDelegate *weakSelf = self
                [weakSelf.mytabBarController setSelectedIndex:weakSelf.selectTab];
            };
            YHNavigationController *nav = cartViewCon.defaultNavigationController;
            [mytabBarController presentModalViewController:nav animated:YES];
        }
        else
        {
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
    }
    else
    {
        
        if (index == 3)
        {
            BOOL isLogin = [self checkLogin];
            if (isLogin == NO)
            {
                return NO ;
            }
            else
            {
                selectTab = index;
                NSLog(@"selectTab1 = %lu",(unsigned long)selectTab);
            }
        }
        else
        {
            selectTab = index;
            NSLog(@"selectTab2 = %lu",(unsigned long)selectTab);

        }
    }
    return YES;
}

- (BOOL)checkLogin
{
    if (![[UserAccount instance] isLogin]) {
        YHLoginViewController *loginViewCtrl = [[YHLoginViewController alloc] init];
        loginViewCtrl.logOutType = LogOut_Usual;
        // 登陆成功或者失败 callBack
        loginViewCtrl.loginBackBlock = ^(){
            NSLog(@"返回");
        };
        //登录界面消失
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

-(void)LoginPassive
{
    selectTab = 0;
    if (TipTab < 4)
    {
        YHLoginViewController *loginViewCtrl = [[YHLoginViewController alloc] init];
        // 登陆成功或者失败 callBack
        loginViewCtrl.logOutType = LogOut_Passive_Present;
        loginViewCtrl.loginBackBlock = ^(){
            UINavigationController * view_na = (UINavigationController *)[[mytabBarController viewControllers] objectAtIndex:TipTab];
            [view_na popToRootViewControllerAnimated:NO];
        };
        loginViewCtrl.loginSuccessBlock = ^(UserAccount *account){
            [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES                           completion:^{
                NSLog(@"login success!!!");
            }];
        };
        [mytabBarController presentModalViewController:loginViewCtrl animated:YES];
    }
    else
    {
        YHLoginViewController *loginViewCtrl = [[YHLoginViewController alloc] init];
        // 登陆成功或者失败 callBack
        loginViewCtrl.logOutType = LogOut_Passive_Push;
        loginViewCtrl.loginBackBlock = ^(){
            [cartViewCon.navigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
        };
        loginViewCtrl.loginSuccessBlock = ^(UserAccount *account){
            [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES                           completion:^{
                NSLog(@"login success!!!");
            }];
        };
        
        [cartViewCon.navigationController pushViewController:loginViewCtrl animated:YES];
    }
}



// 改变购物车数量
- (void)changeCartNum:(NSString *)cartNum
{
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
//    if (t_API_VERSION == nTag)
//    {
//        VersionEntiy *version = (VersionEntiy *)netTransObj;
//        NSString *verNum = version._version;
//        if ([version.force_update integerValue] == 1&&verNum.integerValue > K_VERSION_CODE) { //强制更新bool
//            isForceUpdate = YES;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // something
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"永辉微店有新版啦！" message:[NSString stringWithFormat:@"\n%@",version.version_caption] delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上更新", nil];
//                alert.tag = 1002;
//                [alert show];
//            });
//
//        }else{
//
//        }
//    }
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
    if (nTag == t_API_MAIN_LAUNCH)
    {
        NSMutableArray * array = (NSMutableArray *)netTransObj;
        if (array.count != 0) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * dict = [array lastObject];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"photo"]]];
            CGFloat show_time = [[dict objectForKey:@"show_time"]floatValue];
            [defaults setObject:data forKey:@"imageData"];
            [defaults setFloat:show_time forKey:@"show_time"];
            [defaults synchronize];
            
        }else{
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"imageData"];
            [defaults removeObjectForKey:@"show_time"];
            [defaults synchronize];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    // 强制更新
//    if (isForceUpdate == YES && alertView.tag == 1002) {
//        NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
//        [[UIApplication sharedApplication] openURL:iTunesURL];
//    }
//    
//    // 提示更新
//    if (alertView.tag == 1001) {
//        if (buttonIndex == 1) {
//            NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
//            [[UIApplication sharedApplication] openURL:iTunesURL];
//        }
//    }
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
//    //监测版本--会不停地调用，不停地弹出提示框
//    [[NetTrans getInstance] API_version_check:self AgentID:@"2" Type:@"consumer"];
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
    NSLog(@"%@", error);

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
        NSString *url = [NSString stringWithFormat:GOODS_DETAIL,dmEntity.type,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
        [goodsDetail setMainGoodsUrl:url goodsID:dmEntity.type];
        [contro pushViewController:goodsDetail animated:YES];
    }else if ([type isEqualToString:@"6"]){
        // 指定商品tag_id页面
        
        
        YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
        vc.navigationItem.title = dmEntity.name;
   
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"tag" forKey:@"type"];
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

#pragma mark - GuideView
- (void)showIntroWithCrossDissolve {
//    [intro showInView:self.window animateDuration:0.0];
    GuideView * guide = [[GuideView alloc]initWithFrame:self.window.bounds];
    guide.delegate = self;
    [self.window addSubview:guide];
    [self.window addSubview:guide.pageControl];
}
- (void)guideViewDidFinish{
    self.window.rootViewController = mytabBarController;
}
@end
