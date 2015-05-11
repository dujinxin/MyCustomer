//
//  YHAppDelegate.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"
#import "AGViewDelegate.h"
#import "GexinSdk.h"
#import "BMapKit.h"
#import "Reachability.h"
#import "YHCartViewController.h"
#import "GuideView.h"
typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;



@interface YHAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,LeveyTabBarControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,GexinSdkDelegate,BMKGeneralDelegate,GuideViewDelegate>{
    BOOL isForceUpdate;
    NSUInteger  selectTab;
    NSUInteger  TipTab;
    NSTimer * launchTimer;
    UIImageView *bgImage;
//    BMKMapManager * _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeveyTabBarController *mytabBarController;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;
@property (nonatomic, strong) NSDictionary *pushMsgInfo;
@property (nonatomic , strong)YHCartViewController * cartViewCon;
// gexin
@property (strong, nonatomic) GexinSdk *gexinPusher;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (nonatomic, strong) Reachability * hostReach;
@property (nonatomic, assign) NSUInteger selectTab;
+ (YHAppDelegate *)appDelegate;
- (BOOL)checkLogin;
- (void)hideTabBar:(BOOL)hidden;
- (void)changeCartNum:(NSString *)cartNum;

-(void)LoginPassive;
// gexin
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;

@end
