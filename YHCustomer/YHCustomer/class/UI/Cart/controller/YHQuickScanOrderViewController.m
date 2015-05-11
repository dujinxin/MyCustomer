//
//  YHQuickScanOrderViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-23.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHQuickScanOrderViewController.h"
#import "AlixPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YHMyOrderViewController.h"
#import "YHCouponListViewController.h"
#import "YHPaySucceedViewController.h"
#import "YHOrderDetailViewController.h"
#import "YHForgetPassViewController.h"

@interface YHQuickScanOrderViewController ()
{
    BOOL isPay ;
    NSDictionary * myDic;
}
@end

@implementation YHQuickScanOrderViewController
@synthesize submitOrder;
@synthesize myCouponDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        submitOrder = [[OrderSubmitEntity alloc] init];
        self.navigationItem.title = @"PDA快速支付";
        self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        self.isFromMyOrder = NO;
        self.isFromOrderDetail = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    [self addUI];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    isPay = NO;
    [self setData];
}

-(void)addUI {
    UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 90)];
    bg1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg1];
    orderNum = [PublicMethod addLabel:CGRectMake(10, 10, 280, 10) setTitle:[NSString stringWithFormat:@"订单编号:%@",submitOrder.order_list_no] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    
    [bg1 addSubview:orderNum];
    buName = [PublicMethod addLabel:CGRectMake(10, orderNum.bottom + 10, 280, 10) setTitle:[NSString stringWithFormat:@"自提门店:%@",submitOrder.bu_name] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:buName];
    address = [PublicMethod addLabel:CGRectMake(10,buName.bottom + 10, 280, 10) setTitle:[NSString stringWithFormat:@"门店地址:%@",submitOrder.address] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:address];
    tel = [PublicMethod addLabel:CGRectMake(10,address.bottom + 10, 280, 10) setTitle:[NSString stringWithFormat:@"服务电话:%@",submitOrder.tel] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:tel];
    
    UIView *bg2 = [[UIView alloc]initWithFrame:CGRectMake(10, bg1.bottom, 300, 81)];
    bg2.backgroundColor = [PublicMethod colorWithHexValue:0xfff6c6 alpha:1.0];
    [self.view addSubview:bg2];
    UILabel *pay = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"需支付金额:"setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg2 addSubview:pay];
    payDeltail = [PublicMethod addLabel:CGRectMake(190, 10, 100, 15) setTitle:[NSString stringWithFormat:@"￥%@",submitOrder.total_amount] setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    //    payDeltail.text = @"￥200";
    payDeltail.textAlignment = NSTextAlignmentRight;
    [bg2 addSubview:payDeltail];
    UILabel *price = [PublicMethod addLabel:CGRectMake(10, pay.bottom + 10, 280, 12) setTitle:@"商品价格:" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
    [bg2 addSubview:price];
    priceDetail = [PublicMethod addLabel:CGRectMake(190, pay.bottom + 10, 100, 12) setTitle:[NSString stringWithFormat:@"￥%@",submitOrder.goods_amount] setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
    //    priceDetail.text = @"￥200";
    priceDetail.textAlignment = NSTextAlignmentRight;
    [bg2 addSubview:priceDetail];
    UILabel *coupon = [PublicMethod addLabel:CGRectMake(10,price.bottom + 10, 280, 12) setTitle:@"优惠券:" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
    [bg2 addSubview:coupon];
    couponDetail = [PublicMethod addLabel:CGRectMake(190,price.bottom + 10, 100, 12) setTitle:[NSString stringWithFormat:@"-￥%@",submitOrder.coupon_amount] setBackColor:[PublicMethod colorWithHexValue:0x00a1fd alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
    if (!submitOrder.coupon_amount) {
        couponDetail.text = @"-￥0.00";
    }
    couponDetail.textAlignment = NSTextAlignmentRight;
    [bg2 addSubview:couponDetail];
    
    UIView *bg3 = [[UIView alloc]initWithFrame:CGRectMake(10, bg2.bottom+10, 300, 40)];
    bg3.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(couponAction:)];
    [bg3 addGestureRecognizer:ges];
    bg3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg3];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"优惠券";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg3 addSubview:label];
    couponInfo = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 0, 125, 40)];
    couponInfo.backgroundColor = [UIColor clearColor];
    if ([submitOrder.coupon_num intValue]==0) {
        couponInfo.text = @"暂无优惠券";
    } else {
        couponInfo.text = [NSString stringWithFormat:@"有%@张优惠券可以使用",submitOrder.coupon_num];
    }
    couponInfo.font = [UIFont systemFontOfSize:12.0];
    couponInfo.textAlignment = NSTextAlignmentRight;
    couponInfo.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [bg3 addSubview:couponInfo];
    //箭头
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 14, 12, 12)];
    [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
    [bg3 addSubview:arrow];
    
    
    UIButton  *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(10, bg3.bottom+20, 300, 40);
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"pay_btn"] forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"pay_btn_selected"] forState:UIControlStateHighlighted];
    [payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
}

- (void)payAction:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"支付宝",@"中国银联",@"永辉卡", nil];
    [actionSheet showInView:[YHAppDelegate appDelegate].mytabBarController.view];
}

#pragma mark--------------------------------------------------- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.numberOfButtons-1)
        return;
    
    if (buttonIndex == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_Bank_Pay:self OrderList:submitOrder.order_list_id PayType:@"200" Pwd:@"0"];
        
    }
    else if (buttonIndex == 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_Bank_Pay:self OrderList:submitOrder.order_list_id PayType:@"100" Pwd:@"0"];
    }
    else if (buttonIndex == 2) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_Bank_Pay:self OrderList:submitOrder.order_list_id PayType:@"250" Pwd:@"0"];
    }
}

- (void)back:(id)sender{
//    MyOrderEntity *entity = [[MyOrderEntity alloc]init];
//    entity.order_list_id = submitOrder.order_list_id;
//    entity.pay_method = submitOrder.pay_method;
//    entity.delivery_id = submitOrder.delivery_id;
//    
//    YHOrderDetailViewController *orderDetail = [[YHOrderDetailViewController alloc] init];
//    [orderDetail setOrderListId:entity];
//    [self.navigationController pushViewController:orderDetail animated:YES];
    if (_isFromMyOrder || _isFromOrderDetail) {
        MyOrderEntity *entity = [[MyOrderEntity alloc]init];
        entity.order_list_id = submitOrder.order_list_id;
        entity.pay_method = submitOrder.pay_method;
        entity.delivery_id = submitOrder.delivery_id;
        entity.region_id = [UserAccount instance].region_id;
        entity.order_list_no = submitOrder.order_list_no;
        entity.order_type = @"2";
    
        if (_block) {
            self.block(entity);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_BUY_PLATFORM_ORDERPAY)
    {
        if (isPay == NO)
        {
            if ([status isEqualToString:WEB_STATUS_3])
            {
                YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
                [[YHAppDelegate appDelegate] changeCartNum:@"0"];
                [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
                [[UserAccount instance] logoutPassive];
                [delegate LoginPassive];
                return;
            }
            else
            {
                [[iToast makeText:errMsg]show];
            }
        }
        else
        {
            if ([status isEqualToString:WEB_STATUS_3])
            {
                YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
                [[YHAppDelegate appDelegate] changeCartNum:@"0"];
                [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
                [[UserAccount instance] logoutPassive];
                [delegate LoginPassive];
            }
            else if ([status isEqualToString:@"4"])
            {
                YHAlertView * other  = [[YHAlertView alloc] initWithTitle:nil message:errMsg delegate:self Left:NO button:@[@"重试" , @"忘记密码"] isPaa:NO];
                other.tag = 1;
                [other show];
            }
            else
            {
                //            NSString * str1 = [NSString stringWithFormat:@"%d" , 1002];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:errMsg
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                alert.tag = 1002;
                [alert show];
            }
        }
       
    }
    else if (nTag == t_API_SCAN_CODE)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
        else
        {
              [[iToast makeText:errMsg]show];
        }
    }
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_BUY_PLATFORM_ORDERPAY)
    {
        NSDictionary *payDic = (NSDictionary *)netTransObj;
        myDic = payDic;
        NSNumber *pay_method1 = [payDic objectForKey:@"pay_method"];
        NSString * pay_method = [NSString stringWithFormat:@"%@" , pay_method1];
        if (isPay == NO)
        {
            if ([pay_method isEqualToString:@"100"])
            {
                NSString *sn = [payDic objectForKey:@"pay_str"];
                [UPPayPlugin startPay:sn mode:CHINA_UNIONPAY_MODE viewController:self delegate:self];
            }
            else if ([pay_method isEqualToString:@"200"])
            {
//                AlixPay * alixpay = [AlixPay shared];
//                int ret = [alixpay pay:[payDic objectForKey:@"pay_str"] applicationScheme:@"YHCustomer"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPaySucceedVC) name:@"AlixPayResultSucceed" object:nil];
                [[AlipaySDK defaultService] payOrder:[payDic objectForKey:@"pay_str"] fromScheme:@"YHCustomer" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    NSLog(@"str = %@",[resultDic objectForKey:@"memo"]);}];
//                if (ret == kSPErrorAlipayClientNotInstalled) {
//                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                         message:@"您还没有安装支付宝快捷支付，请先安装。"
//                                                                        delegate:self
//                                                               cancelButtonTitle:nil
//                                                               otherButtonTitles:@"取消",@"确定",nil];
//                    [alertView setTag:123];
//                    [alertView show];
//                }
//                else if (ret == kSPErrorSignError) {
//                    NSLog(@"签名错误！");
//                }
            }
            else if ([pay_method isEqualToString:@"250"])
            {
                NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入支付密码"];
                NSString * str = [payDic objectForKey:@"total_amount"];
                NSString * str1 = [NSString stringWithFormat:@"￥%@" , str];
                YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:str1 delegate:self Left:NO button:nil isPaa:YES];
                elartView.tag = 1000;
                elartView.block = ^(NSString * str)
                {
                    NSLog(@"%@" , str);
                    isPay = YES;
                    //                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //                [[NetTrans getInstance] API_YH_Card_Pay:self Pay_the_password:str];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetTrans getInstance] API_Bank_Pay:self OrderList:submitOrder.order_list_id PayType:pay_method Pwd:str];
                };
                [elartView show];
                /*
                 YHCardPayViewController * payView = [[YHCardPayViewController alloc] init];
                 payView.pay_method = [payDic objectForKey:@"pay_method"];
                 payView.total_amount = [payDic objectForKey:@"total_amount"];
                 payView.card_pay_amount = [payDic objectForKey:@"card_pay_amount"];
                 payView.order_list_id = submitOrder.order_list_id;
                 payView.block = ^(NSString * str , NSString * str1)
                 {
                 if ([str isEqualToString:@"1005"])
                 {
                 [self pushPaySucceedVC];
                 }
                 else if ([str isEqualToString:@"1002"])
                 {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                 message:str1
                 delegate:self
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
                 alert.tag = 1002;
                 [alert show];
                 }
                 };
                 [self.navigationController pushViewController:payView animated:YES];
                 */
            }
        }
        else
        {
            NSDictionary * dic = (NSDictionary *)netTransObj;
            NSLog(@"dic = %@" , [dic objectForKey:@"message"]);
            [self pushPaySucceedVC];
        }
        
    } else if (nTag == t_API_SCAN_CODE) {
        submitOrder = (OrderSubmitEntity *) netTransObj;
        if (!myCouponDic) {
            self.couponList = submitOrder.couponList;
        }
        [self setData];
    }else if (nTag == t_API_ORDER_DETAIL_PDA){
        submitOrder = (OrderSubmitEntity *)netTransObj;
        if (!myCouponDic) {
            self.couponList = submitOrder.couponList;
        }
        [self setData];
    }
}
- (void)didPresentYhAlertView:(YHAlertView *)alertView
{
    if (alertView.tag == 1000)
    {
        [alertView.textFiled becomeFirstResponder];
        
        alertView.center = CGPointMake(alertView.centerX, alertView.centerY-80);
    }
    
}
-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        switch (buttonIndex)
        {
            case 1:
            {
                //                [[iToast makeText:@"重试"] show];
                NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入支付密码"];
                NSString * str = [myDic objectForKey:@"total_amount"];
                NSString * str1 = [NSString stringWithFormat:@"￥%@" , str];
                YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:str1 delegate:self Left:NO button:nil isPaa:YES];
                elartView.tag = 1000;
                NSNumber *pay_method1 = [myDic objectForKey:@"pay_method"];
                NSString * pay_method = [NSString stringWithFormat:@"%@" , pay_method1];
                elartView.block = ^(NSString * str)
                {
                    NSLog(@"%@" , str);
                    //                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //                [[NetTrans getInstance] API_YH_Card_Pay:self Pay_the_password:str];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetTrans getInstance] API_Bank_Pay:self OrderList:submitOrder.order_list_id PayType:pay_method Pwd:str];
                };
                [elartView show];
            }
                break;
            case 2:
            {
                //                [[iToast makeText:@"忘记密码"] show];
                YHForgetPassViewController * forgetPass = [[YHForgetPassViewController alloc] init];
                forgetPass.entityCard = nil;
                [self.navigationController pushViewController:forgetPass animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------  UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString*)result{
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:@""];
    if ([result isEqualToString:@"success"]) {
        [resultString appendString:@"支付成功"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];

    } else if ([result isEqualToString:@"fail"]) {
        [resultString appendString:@"支付失败"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1003;
        [alert show];
    } else if ([result isEqualToString:@"cancel"]) {
        [resultString appendString:@"用户取消"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1003;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 123 && buttonIndex == 1) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    if (alertView.tag == 1002){
        [self pushPaySucceedVC];
    }
    if (alertView.tag == 1003) {
        YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
        [self.navigationController pushViewController:myOrder animated:YES];
    }
}

#pragma mark ---------  couponAction 
-(void)couponAction:(id)sender {
    YHCouponListViewController *coupon = [[YHCouponListViewController alloc] init];
    coupon.selectDictionary = myCouponDic;
    coupon.dataArray = self.couponList;
    coupon.successCallBlock = ^(NSDictionary *dic){
        myCouponDic = dic;
        NSString *couponID = [dic objectForKey:@"id"];
         couponName = [dic objectForKey:@"title"];
        if (couponID) {
            [[NetTrans getInstance]API_ScanQuick:self Order_List_No:submitOrder.order_list_no coupon_id:couponID];
        } else {
            if ([submitOrder.coupon_num intValue]==0) {
                couponInfo.text = @"暂无优惠券";
            } else {
                couponInfo.text = [NSString stringWithFormat:@"有%@张优惠券可以使用",submitOrder.coupon_num];
            }
            [[NetTrans getInstance]API_ScanQuick:self Order_List_No:submitOrder.order_list_no coupon_id:nil];
        }
    };
    [self.navigationController pushViewController:coupon animated:YES];
}

#pragma mark ------------
-(void)pushPaySucceedVC {
    YHPaySucceedViewController *conVC = [[YHPaySucceedViewController alloc]init];
    conVC.model = FetchPS;
    conVC.order_list_id = submitOrder.order_list_id;
    [self.navigationController pushViewController:conVC animated:YES];
}

#pragma mark -------------
-(void)setData {
    orderNum.text = [NSString stringWithFormat:@"订单编号:%@",submitOrder.order_list_no];
    buName.text = [NSString stringWithFormat:@"自提门店:%@",submitOrder.bu_name];
    address.text = [NSString stringWithFormat:@"门店地址:%@",submitOrder.address];
    tel.text = [NSString stringWithFormat:@"服务电话:%@",submitOrder.tel];
    payDeltail.text = [NSString stringWithFormat:@"￥%@",submitOrder.total_amount];
    priceDetail.text = [NSString stringWithFormat:@"￥%@",submitOrder.goods_amount];
    if (!submitOrder.coupon_amount) {
        couponDetail.text = @"-￥0.00";
    } else {
        couponDetail.text = [NSString stringWithFormat:@"-￥%@",submitOrder.coupon_amount];
    }
    
    if (couponName) {
        couponInfo.text = couponName;
    } else {
        if ([submitOrder.coupon_num intValue]==0) {
            couponInfo.text = @"暂无优惠券";
        } else {
            couponInfo.text = [NSString stringWithFormat:@"有%@张优惠券可以使用",submitOrder.coupon_num];
        }
    }
}
@end
