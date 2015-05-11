//
//  YHSpeedEntryViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-1-4.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHSpeedEntryViewController.h"
#import "YHSignInViewController.h"
#import "YHShakeViewController.h"
#import "ZbarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YHVipCardViewController.h"
#import "YHMyCollectViewController.h"
#import "YHCollectViewController.h"
#import "YHCardOpenViewController.h"
#import "YHMyCouponViewController.h"
#import "DmEntity.h"
#import "YHPrommotionDetailController.h"
#import "YHPromotionListViewController.h"
#import "YHDMGoodsWallViewController.h"
#import "YHMenuViewController.h"

@interface YHSpeedEntryViewController ()

@end

@implementation YHSpeedEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIConfing
- (void)addNavigationView{
    self.navigationItem.title = @"更多服务";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetTrans getInstance] API_speed_entry:self type:@"2"];
    });
}
- (void)initSpeedEntryView:(NSArray *)array{
    
    for (int i = 0; i < array.count ; i ++) {
        NSDictionary * dict = [array objectAtIndex:i];
        UIButton *dmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dmBtn.tag = 100 + [[dict objectForKey:@"id"] integerValue];
        dmBtn.frame = CGRectMake(SCREEN_WIDTH /4 * (i%4),  64 *(i/4), SCREEN_WIDTH /4, 64);
        [dmBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [dmBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [dmBtn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        [dmBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [dmBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(25, 8, 30, 30)];
        //        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d",i +1]];
        [image setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]]];
        //        image.userInteractionEnabled = YES;
        [dmBtn addSubview:image];
        UILabel * xline = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, 80, 1)];
        xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        [dmBtn addSubview:xline];
        UILabel * yline = [[UILabel alloc]initWithFrame:CGRectMake(79, 0, 1, 64)];
        yline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        [dmBtn addSubview:yline];
        
        [dmBtn setBackgroundImage:[UIImage imageNamed:@"icon_pressed.png"] forState:UIControlStateHighlighted];
        [dmBtn setBackgroundImage:[UIImage imageNamed:@"icon_normal.png"] forState:UIControlStateNormal];
        [dmBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dmBtn];
    }
}
#pragma mark - Event
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonAction:(UIButton *)button {
    
    switch (button.tag) {
        case 101:// 签到
        {
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHSignInViewController *collectVC = [[YHSignInViewController alloc] init];
            if ([[YHAppDelegate appDelegate] checkLogin])
            {
                [self.navigationController pushViewController:collectVC animated:YES];
                [MTA trackCustomKeyValueEvent:EVENT_ID100 props:nil];
            }
        }
            break;
        case 102:// 摇一摇
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID45 props:nil];
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHShakeViewController * svc = [[YHShakeViewController alloc]init ];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 103://DM
        {
            
            [MTA trackCustomKeyValueEvent:EVENT_ID16 props:nil];
            
            if (_DmArray.count > 0) {
                DmEntity *entity = (DmEntity *)[_DmArray objectAtIndex:0];
                if ([entity.home_show_id isEqualToString:@"0"]) {
                    [[iToast makeText:@"未设置DM"] show];
                    return;
                }
                
                [[PSNetTrans getInstance]get_DM_Info:self DMId:entity.home_show_id];
                
            }
        }
            break;
        case 104:// 扫描
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID20 props:nil];
            if (IOS_VERSION >= 7) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相机功能未开启，请去(设置>隐私>相机)开启一下吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }else if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusAuthorized){
                    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                    ZbarViewController *zbar = [[ZbarViewController alloc] init];
                    if ([[UserAccount instance] isLogin]){
                        zbar.saoType = Sao_Pay;
                        [self.navigationController pushViewController:zbar animated:YES];
                    }else{
                        zbar.saoType = Sao_Goods;
                        [self.navigationController pushViewController:zbar animated:YES];
                    }
                }
            }else{
                [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                ZbarViewController *zbar = [[ZbarViewController alloc] init];
                if ([[UserAccount instance] isLogin]){
                    zbar.saoType = Sao_Pay;
                    [self.navigationController pushViewController:zbar animated:YES];
                }else{
                    zbar.saoType = Sao_Goods;
                    [self.navigationController pushViewController:zbar animated:YES];
                }
            }
            
            
        }
            break;
        case 105:// 积分卡
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID17 props:nil];
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHVipCardViewController *vipVC = [[YHVipCardViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
        }
            break;
        case 106://我的收藏
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID18 props:nil];
            
            NSDictionary* kvs=[NSDictionary dictionaryWithObject:@"collect" forKey:@"Key"];
            [MTA trackCustomKeyValueEvent:@"click" props:kvs];
            
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHMyCollectViewController *collectVC = [[YHMyCollectViewController alloc] init];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
            break;
        case 107:// 永辉钱包
        {
            
            if ([[YHAppDelegate appDelegate] checkLogin])
            {
                //                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [MTA trackCustomKeyValueEvent:EVENT_ID102 props:nil];
                YHCardOpenViewController * openView = [[YHCardOpenViewController alloc] init];
                openView.forWard = YES;
                [self.navigationController pushViewController:openView animated:YES];
            }
        }
            break;
        case 108:// 优惠券
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID19 props:nil];
            
            if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
                return;
            }
            
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            YHMyCouponViewController *couponVC = [[YHMyCouponViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case 109:// 更多
        {
            YHSpeedEntryViewController * svc = [[YHSpeedEntryViewController alloc]init ];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 110:// 菜谱
        {
            [MTA trackCustomKeyValueEvent:EVENT_ID50 props:nil];
            YHMenuViewController *fiv = [[YHMenuViewController alloc]init];
            [self.navigationController pushViewController:fiv animated:NO];
        }
            break;
        default:
            break;
    }
}
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    NSLog(@"nTag == %d" , nTag);
    
    if(t_API_MAIN_HOTGOODS == nTag)
    {
        
    } else if (t_API_SPEED_ENTRY == nTag){
        [self initSpeedEntryView:(NSMutableArray *)netTransObj];
    } else if (t_API_DM_MAIN_TOP == nTag) {
        
    } else if (t_API_PS_DM_INFO == nTag) {
        NSMutableArray *dataArray = (NSMutableArray *)netTransObj;
        DmEntity *entity = [dataArray objectAtIndex:0];
        
        [self dmJumpLogic:entity];
    }
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [[iToast makeText:errMsg] show];
}
#pragma mark ----------------  改版促销跳转逻辑
-(void)dmJumpLogic:(DmEntity *)entity {
    
    if ([entity.connect_goods isEqualToString:@"0"]) {//0为不关联商品促销
        
        YHPrommotionDetailController *promotionDetail = [[YHPrommotionDetailController alloc] init];
        [promotionDetail setDMId:entity.dm_id];
        [self.navigationController pushViewController:promotionDetail animated:YES];
        
    } else if ([entity.connect_goods isEqualToString:@"1"] || [entity.connect_goods isEqualToString:@"2"]) {//1为关联商品促销  2是促销关联的标签商品
        
        if ([entity.page_type isEqualToString:@"0"]) {//0为列表模式
            
            YHPromotionListViewController * listVC = [[YHPromotionListViewController alloc]init];
            listVC.dmEntity = entity;
            [self.navigationController pushViewController:listVC animated:YES];
            
        } else {//1为瀑布流模式
            
            YHDMGoodsWallViewController *goodWall = [[YHDMGoodsWallViewController alloc] init];
            goodWall.dm_Entity = entity;
            [self.navigationController pushViewController:goodWall animated:YES];
            
        }
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
