//
//  YHMyViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  我的

#import "YHMyViewController.h"
#import "YHAccountManagerViewController.h"
#import "YHSettingViewController.h"
#import "YHAppDelegate.h"
#import "YHVipCardViewController.h"
#import "YHMyCouponViewController.h"
#import "YHMyOrderViewController.h"
#import "YHMyCollectViewController.h"
#import "YHCollectViewController.h"
#import "ZbarViewController.h"
#import "UITableViewCell+Addition.h"
#import "AddressesManagerViewController.h"
#import "YHCustomerServiceViewController.h"
#import "YHPSCityListViewController.h"
#import "MyPickerView.h"
#import "YHCardOpenViewController.h"
#import "YHFixedToSnapUpViewController.h"
#import "YHCardBag.h"
#import "YHStarPostCardViewController.h"

enum{
    ENUM_IMAGE_TAG = 100,
    ENUM_LABEL_TAG,
    ENUM_ARROW_TAG,
};

@interface YHMyViewController ()
{
    NSInteger showNum;

}
@end

@implementation YHMyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"我的";
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    [self addTableView];
    [self addNavRightButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    //是否显示星级包邮卡
    [[NetTrans getInstance]API_YH_Star_Post_Card_Show:self];
//    showNum = 0;
    [[NetTrans getInstance] user_getPersonInfo:self setUserId:[UserAccount instance].user_id];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:NO animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE9];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE9];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ------------------------- add UI
-(void)addNavRightButton {
    // 设置导航条右侧按钮
    [self setRightBarButton:self Action:@selector(setting:) SetImage:@"right_setting_normal" SelectImg:@"right_setting_pressed"];
//    [self setRightBarButton:self Action:@selector(setting:) SetImage:@"my_setting.png" SelectImg:@"my_setting_selected.png"];
}

-(void)addTableView
{
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenSize.height)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    /* uitable view */
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, ScreenSize.height - NAVBAR_HEIGHT-kTabBarHeight) style:UITableViewStyleGrouped];
    tableview.backgroundView = bgview;
    [tableview setDelegate:self];
    [tableview setDataSource:self];
//    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
//    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    tableview.showsVerticalScrollIndicator = NO;
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableview];
    self._tableView = tableview;
}

#pragma mark ------------------------- UITableView Delegate
//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
//section的view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 4;
        case 3:
            return 3 + showNum;
        case 4:
            return 2;
        case 5:
            return 1;
        case 6:
            return 1;
        case 7:
            return 1;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mycell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycelli"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //cell的image
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 20, 20)];
        imagev.tag = ENUM_IMAGE_TAG;
        [cell.contentView addSubview:imagev];
        
        //cell 的name
        UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(44, 11, cell.frame.size.width-130-60, 20)];
        labName.tag = ENUM_LABEL_TAG;
        labName.backgroundColor = [UIColor clearColor];
        labName.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:labName];
        
        //小箭头
        UIImageView *imgvDic = nil;
        if (IOS_VERSION >= 7) {
            imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45, 10, 22, 22)];
        }else{
            imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-65, 10, 22, 22)];
        }
        imgvDic.tag = ENUM_ARROW_TAG;
        [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
        [cell.contentView addSubview:imgvDic];
    }
    
    switch (indexPath.section)
    {
        case 0://个人资料
        {
            UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
            imagev.frame = CGRectMake(11, 10, 50, 50);
            UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
//            [imagev setImage:[UIImage imageNamed:@"my_myorder.png"]];
            [imagev setImageWithURL:[NSURL URLWithString:self._userInfoEntity.photo_url] placeholderImage:[UIImage imageNamed:@"header_default"]];
  
            if ([[cell.contentView subviews]count] == 4) {
                UIView *label = [[cell.contentView subviews]objectAtIndex:3];
                [label removeFromSuperview];
            }
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(imagev.right +10, 10, 100, 50)];
            name.font = [UIFont systemFontOfSize:15];
            name.backgroundColor = [UIColor clearColor];
            name.text = self._userInfoEntity.user_name;
            [cell.contentView addSubview:name];
            
            label.textColor = [UIColor blackColor];
            label.text = @"个人资料设置";
            label.font = [UIFont systemFontOfSize:15];
            label.frame = CGRectMake(SCREEN_WIDTH-145, 10, 90, 50);
            if (IOS_VERSION == 6) {
                label.frame = CGRectMake(SCREEN_WIDTH-155, 10, 90, 50);
            }
            UIImageView *arrow = (UIImageView*)[cell viewWithTag:ENUM_ARROW_TAG];
            if (IOS_VERSION >= 7) {
                arrow.frame = CGRectMake(cell.frame.size.width-45, 24, 22, 22);
            }else{
                if (IOS_VERSION == 6) {
                    arrow.frame = CGRectMake(cell.frame.size.width-65, 24, 22, 22);
                }else{
                
                    arrow.frame = CGRectMake(cell.frame.size.width-45, 24, 22, 22);
                }
                
            }
            [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_bg"]]];
        }
            break;
        case 1://手机快捷支付
        {
            UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
            UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
            [imagev setImage:[UIImage imageNamed:@"my_quick_pay"]];
            label.textColor = [UIColor blackColor];
            label.text = @"手机快速支付";
            [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_one"]]];
        }
            break;
        case 2:
        {
            UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
            UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
            switch (indexPath.row) {
                case 0://我的订单
                {
                    [imagev setImage:[UIImage imageNamed:@"my_order"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"我的订单";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_top"]]];
                    
                }
                    break;
                case 1://我的永辉卡
                {
                    //                    设置前面的卡图片
                    [imagev setImage:[UIImage imageNamed:@"icon_永辉钱包.png"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"永辉钱包";
                    //                    设置cell的背景图片
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
                }
                    break;
                case 2://我的收藏
                {
                    [imagev setImage:[UIImage imageNamed:@"my_collect"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"我的收藏";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
                }
                    break;
                case 3:{
                    [imagev setImage:[UIImage imageNamed:@"ps_address_manger.png"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"收货地址管理";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
            UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
            switch (indexPath.row) {
                case 0://我的积分卡
                {
                    [imagev setImage:[UIImage imageNamed:@"my_vip_card"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"我的积分卡";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_top"]]];
                }
                    break;
//                case 1://积分卡绑定
//                {
//                    //                    设置前面的卡图片
//                    [imagev setImage:[UIImage imageNamed:@"icon_tiedcard"]];
//                    label.textColor = [UIColor blackColor];
//                    label.text = @"积分卡绑定";
//                    //                    设置cell的背景图片
//                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
//                }
//                    break;
            
                case 1://我的优惠券
                {
                    [imagev setImage:[UIImage imageNamed:@"my_dicount"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"我的优惠券";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
                }
                    break;
                    
                case 2:{//客户服务
                    [imagev setImage:[UIImage imageNamed:@"my_customer_service.png"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"客户服务";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
                }
                    break;
                case 3://星级包邮卡
                {
                    [imagev setImage:[UIImage imageNamed:@"star_card"]];
                    label.textColor = [UIColor blackColor];
                    label.text = @"星级包邮卡";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
   
        default:
            break;
    }
    
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    } else
    return 44.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    __weak GJGLAlertView *alertDeliveryView =[GJGLAlertView shareInstance];
//    [alertDeliveryView setAlertViewBlock:^(NSString *companyName,NSString *order_no){
//    } CancelBlock:^{
//        if(alertDeliveryView){
//            [alertDeliveryView removeFromSuperview];
//        }
//    }];
//    [self.view addSubview:alertDeliveryView];
//    return;
    
   
    switch (indexPath.section)
    {
        case 0://个人资料
        {
             [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            [MTA trackCustomKeyValueEvent :EVENT_ID9 props:nil];
            YHAccountManagerViewController *accounManagerVC = [[YHAccountManagerViewController alloc]init];
            [accounManagerVC setUserInfoEntity:self._userInfoEntity];
            [self.navigationController pushViewController:accounManagerVC animated:YES];
        }
            break;
        case 1://手机快速支付
        {
             [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            [MTA trackCustomKeyValueEvent :EVENT_ID10 props:nil];
            ZbarViewController *zbar = [[ZbarViewController alloc] init];
            zbar.saoType = Sao_Pay;
            [self.navigationController pushViewController:zbar animated:YES];

        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0://我的订单
                {
                    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                    YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
                    [self.navigationController pushViewController:myOrder animated:YES];
                }
                    break;
                case 1://我的永辉卡
                {
                    //               积分卡绑定页面
                    YHCardOpenViewController * openView = [[YHCardOpenViewController alloc] init];
                    openView.forWard = YES;
                    [self.navigationController pushViewController:openView animated:YES];
                    [MTA trackCustomKeyValueEvent:EVENT_ID103 props:nil];
//                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    [[NetTrans getInstance] API_YH_Card_ISOpen:self];
                }
                    break;
                case 2://我的收藏
                {
                    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                    YHMyCollectViewController *collectVC = [[YHMyCollectViewController alloc] init];
                    [self.navigationController pushViewController:collectVC animated:YES];
                }
                    break;
                case 3://地址管理
                {
                    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
                    AddressesManagerViewController *collectVC = [[AddressesManagerViewController alloc] init];
                    collectVC.fromMore = YES;
                    [collectVC setNavTitle:@"收货地址管理"];
                    [self.navigationController pushViewController:collectVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
            switch (indexPath.row) {
                case 0://我的积分卡
                {
                    YHVipCardViewController *vipVC = [[YHVipCardViewController alloc] init];
                    vipVC.isForword = YES;
                    [self.navigationController pushViewController:vipVC animated:YES];
                }
                    break;
//                case 1://积分卡绑定
//                {
//                    //               积分卡绑定页面
//                    YHVipCardBindViewController *VCBind = [[YHVipCardBindViewController alloc]init];
//                    [self.navigationController pushViewController:VCBind animated:YES];
//                   
//                }
//                    break;
              
                case 1://我的优惠券
                {
                    YHMyCouponViewController *couponVC = [[YHMyCouponViewController alloc]init];
                    [self.navigationController pushViewController:couponVC animated:YES];
                }
                    break;
                    
                case 2:{// 客户服务
                    YHCustomerServiceViewController *customerService = [[YHCustomerServiceViewController alloc] init];
                    [self.navigationController pushViewController:customerService animated:YES];
                }
                    break;
                case 3://星级包邮卡
                {
                    YHStarPostCardViewController *StarCard = [[YHStarPostCardViewController alloc]init];
                    [self.navigationController pushViewController:StarCard animated:YES];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
}

#pragma mark ------------------------- 二维码相关
//扫二维码
-(void)picnumbtnClickEvent:(id)sender
{
    [self gotoQR];
}

-(void)gotoQR
{
//    ZbarViewController *zbarVC = [[ZbarViewController alloc]init];
//    [self.navigationController pushViewController:zbarVC animated:YES];
//    [zbarVC release];
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_YH_STAR_POST_CARD_SHOW)
    {
        //NSString *success = (NSString *)netTransObj;
        //[self showAlert:success];
        showNum = 1;
        
    }
    if(t_API_USER_PLATFORM_PERSONINFO_API == nTag)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self updateUserInfo:netTransObj];
    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if (nTag == t_API_YH_STAR_POST_CARD_SHOW)
    {
        if ([status isEqualToString:WEB_STATUS_0])
        {
            showNum = 0;
        }
        else
        {
            [iToast makeText:errMsg];
            
        }
        
    }
    if ([status isEqualToString:WEB_STATUS_3])
    {
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
    }
    if(t_API_USER_PLATFORM_PERSONINFO_API == nTag)
    {
            [[iToast makeText:errMsg]show];
            [self._tableView reloadData];
    }
    
}

#pragma mark -----------------  private
-(void)updateUserInfo:(id)entity
{
    if (entity) {
        self._userInfoEntity = (UserInfoEntity*)entity;
        [self._tableView reloadData];
    }
}

#pragma mark ---------------  button action
-(void)setting:(id)sender{
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [MTA trackCustomKeyValueEvent :EVENT_ID8 props:nil];
    YHSettingViewController *settingVC = [[YHSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
