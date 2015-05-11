//
//  YHConfirmOrderViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-14.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  确认订单

#import "YHConfirmOrderViewController.h"
#import "YHMyOrderViewController.h"
#import "AlixPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YHPSPaymentStyleViewController.h"
#import "YHPaySucceedViewController.h"
#import "YHModifyPickTimeViewController.h"
#import "YHPickUpTimeViewContorller.h"
#import "YHPSDeliveryDoorViewController.h"
#import "YHOrderDetailViewController.h"
#import "PSEntity.h"
#import "YHForgetPassViewController.h"
@interface YHConfirmOrderViewController ()
{
    UILabel *priceDetail;
    UILabel *payMethod;
    BOOL isPay;
    NSDictionary * myDic;
}
@end

@implementation YHConfirmOrderViewController
@synthesize orderTableView;
@synthesize orderEntity;
@synthesize coupon_id;
@synthesize isFromMyOrder = _isFromMyOrder;
@synthesize isFromOrderDetail = _isFromOrderDetail;
@synthesize order_list_id = _order_list_id;
@synthesize order_list_no = _order_list_no;
@synthesize order_type = _order_type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        orderEntity = [[OrderSubmitEntity alloc] init];
        self.model = FetchPS;
        self.isFromMyOrder = NO;
        self.isFromOrderDetail = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isPay = NO;
    if (_isFromOrderDetail || _isFromMyOrder) {
        
        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
        self.navigationItem.title = @"订单支付";
        
//        [[PSNetTrans getInstance] my_orderDetail:self order_list_id:self.order_list_id];

    }else{
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 30, 30);
        backBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        backBtn.titleLabel.numberOfLines = 2;
        [backBtn setTitle:@"订单详情" forState:UIControlStateNormal];
        [backBtn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"order_detail_btn"] forState:UIControlStateNormal];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"order_detail_btn_selected"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
//        if (IOS_VERSION >= 7) {
//            negativeSpacer.width = -15;
//        }else{
//            negativeSpacer.width = -5;
//        }
        NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer,leftBarItem, nil];
        self.navigationItem.leftBarButtonItems =barItems;
        self.navigationItem.title = @"订单提交成功";
        
        self.total_amount = orderEntity.total_amount;
    }
    
    
    // 添加tableview
    UITableView *tmpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-originY-44) style:UITableViewStylePlain];
    tmpTable.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    tmpTable.scrollEnabled = NO;
    tmpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView = tmpTable;
    [self.view addSubview:tmpTable];
    
    //修改购物车数量
    [[NetTrans getInstance]getCartGoodsNum:self];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    isPay = NO;
//    [MTA trackCustomKeyValueEvent:EVENT_ID42 props:nil];
    [self.orderTableView reloadData];
}

- (void)back:(id)sender{
    if (_isFromMyOrder || _isFromOrderDetail) {
        MyOrderEntity *entity = [[MyOrderEntity alloc]init];
        entity.order_list_id = orderEntity.order_list_id;
//        entity.pay_method = orderEntity.pay_method;
        entity.delivery_id = orderEntity.delivery_id;
        entity.region_id = [UserAccount instance].region_id;
        entity.order_type = @"1";
        if (_block) {
            self.block(entity);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        MyOrderEntity *entity = [[MyOrderEntity alloc]init];
        entity.order_list_id = orderEntity.order_list_id;
        entity.pay_method = orderEntity.pay_method;
        entity.delivery_id = orderEntity.delivery_id;
        entity.region_id = [UserAccount instance].region_id;
        entity.order_type = @"1";
        YHOrderDetailViewController *orderDetail = [[YHOrderDetailViewController alloc] init];
        [orderDetail setOrderListId:entity];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
    
}

/*我得订单*/
-  (void)myOrder:(id)sender
{
    YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrder animated:YES
     ];
}

/*支付方式*/
- (void)payAction:(NSString *)type{
    [MTA trackCustomKeyValueEvent:EVENT_ID27 props:nil];
    isPay = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_Bank_Pay:self OrderList:orderEntity.order_list_id PayType:orderEntity.pay_method Pwd:@"0"];
}

#pragma -
#pragma mark ---------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if (self.model == DeliverPS_PayOffline) {
                return 263;
            } else if (self.model == FetchPS) {
                return 293-10+[PublicMethod getLabelHeight:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setLabelWidth:300 setFont:[UIFont systemFontOfSize:12]];
            } else  {
                return 272-10;
            }
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
        default:
            return 50;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model != DeliverPS_PayOffline)
    {
        if (indexPath.row == 1) {
            YHPSPaymentStyleViewController *payVC = [[YHPSPaymentStyleViewController alloc]init];
            
            if ([orderEntity.pay_method isEqualToString:@"100"])
            {
                payVC.paystyle = @"银联支付";
            }
            else if ([orderEntity.pay_method isEqualToString:@"200"])
            {
                payVC.paystyle = @"支付宝支付";
            }
            else if ([orderEntity.pay_method isEqualToString:@"250"])
            {
                payVC.paystyle = @"永辉钱包支付";
            }
            //517 立即购。。
            if (self.transaction_type.integerValue == 1) {
                payVC.goods_id = self.goods_id;
                payVC.total = self.total;
            }
            
            payVC.fromConfirmOrder = YES;
            payVC.order_list_no = orderEntity.order_list_no;
            __unsafe_unretained YHConfirmOrderViewController *vc = self;
            payVC.chooseBlock = ^(NSString *pay_method,id object, NSInteger number){
                orderEntity.pay_method = pay_method;
                ModifyPayMethod * entity = (ModifyPayMethod *)object;
                if ([entity.status isEqualToString: WEB_STATUS_1]){
                    priceDetail.text = [NSString stringWithFormat:@"￥%@",entity.total_amount];
                    vc.total_amount = entity.total_amount;
                    if (entity.msg.length != 0)
                    {
                        [self showAlert:entity.msg];
                    }
                }
                else if ([entity.status isEqualToString: WEB_STATUS_2]){
                    //不用做任何修改
                }
                [vc->orderTableView reloadData];
                
            };
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }
}


#pragma mark -
#pragma mark ---------------------------------------------------------UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.model) {
        case DeliverPS_PayOffline:
            return 1;
            break;
        case DeliverPS_PayOnline:
            return 3;
            break;
        case FetchPS:
            return 3;
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    
    switch (indexPath.row) {
        case 0:
        {
            UIView *yellowBG = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 59)];
            yellowBG.backgroundColor = [PublicMethod colorWithHexValue:0xfff6c6 alpha:1.0];
            UILabel *title = [PublicMethod addLabel:CGRectMake(10, 0, 280, 59) setTitle:@"订单已生成，祝你购物愉快!" setBackColor:[UIColor clearColor] setFont:[UIFont systemFontOfSize:14]];
            if (self.model == DeliverPS_PayOnline) {
                title.text = @"订单已生成，请尽快完成付款，否则我们可能无法准时为您送货；24小时内未付款，订单会被自动取消！祝您购物愉快！";
            } else if (self.model == FetchPS) {
                title.text = @"订单已生成，请尽快完成付款，否则我们可能无法准时为您备货；24小时内未付款，订单会被自动取消！祝您购物愉快！";
            } else {
                title.frame = CGRectMake(10, 13.5, 280, 12);
                yellowBG.frame = CGRectMake(10, 10, 300, 39);
            }
            title.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            title.lineBreakMode = NSLineBreakByWordWrapping;
            title.numberOfLines = 0;
            [yellowBG addSubview:title];
            [cell.contentView addSubview:yellowBG];
            
            UIView *infoBG1 = [[UIView alloc]initWithFrame:CGRectMake(10, yellowBG.bottom+10, 300, 76)];
            infoBG1.backgroundColor = [UIColor whiteColor];
            UILabel *orderNum = [PublicMethod addLabel:CGRectMake(10, 10, 300, 12) setTitle:[NSString stringWithFormat:@"订单编号:%@",orderEntity.order_list_no] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:orderNum];
            UILabel *goodsNum = [PublicMethod addLabel:CGRectMake(10, orderNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"商品数:%@件",orderEntity.goods_count] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:goodsNum];
            UILabel *price = [PublicMethod addLabel:CGRectMake(10, goodsNum.bottom+10, 80, 12) setTitle:[NSString stringWithFormat:@"需支付金额:"] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:price];
            priceDetail = [PublicMethod addLabel:CGRectMake(price.right-5, goodsNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"￥%@",self.total_amount] setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:priceDetail];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, price.bottom+9, 300, 2)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
            [infoBG1 addSubview:line];
            [cell.contentView addSubview:infoBG1];
            
            UIView *infoBG2 = [[UIView alloc]initWithFrame:CGRectMake(10, infoBG1.bottom+1, 300, 98)];
            infoBG2.backgroundColor = [UIColor whiteColor];
            UILabel *psWay = [PublicMethod addLabel:CGRectMake(10, 10, 300, 12) setTitle:[NSString stringWithFormat:@"配送方式:%@",orderEntity.delivery_name] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG2 addSubview:psWay];
            UILabel *deliverWay = [PublicMethod addLabel:CGRectMake(10, orderNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"送货方式:%@",orderEntity.lm_title] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG2 addSubview:deliverWay];
            deliverTime = [PublicMethod addLabel:CGRectMake(10, goodsNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"送货时间:%@",orderEntity.lm_time_title] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG2 addSubview:deliverTime];
            payMethod = [PublicMethod addLabel:CGRectMake(10, deliverTime.bottom +10, 300, 12) setTitle:[NSString stringWithFormat:@"支付方式:%@",@"银联"] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            if ([orderEntity.pay_method isEqualToString:@"100"]) {
                payMethod.text = @"支付方式:银联";
            } else if ([orderEntity.pay_method isEqualToString:@"200"]) {
                payMethod.text = @"支付方式:支付宝";
            }else if ([orderEntity.pay_method isEqualToString:@"250"]) {
                payMethod.text = @"支付方式:永辉钱包";
            }
            [infoBG2 addSubview:payMethod];
            
            [cell.contentView addSubview:infoBG2];
        
            if (self.model == FetchPS) {
                infoBG2.frame = CGRectMake(10, infoBG1.bottom+1, 300, 118+[PublicMethod getLabelHeight:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setLabelWidth:300 setFont:[UIFont systemFontOfSize:12]]);
                deliverWay.text = [NSString stringWithFormat:@"自提门店:%@",orderEntity.bu_name];
                deliverTime.text = [NSString stringWithFormat:@"自提时间:%@",orderEntity.pick_up_time];
                [infoBG2 addSubview:deliverWay];
                UILabel *deliverAdd = [PublicMethod addLabel:CGRectMake(10, deliverTime.bottom+10, 280, 12) setTitle:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
                deliverAdd.height = [PublicMethod getLabelHeight:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setLabelWidth:280 setFont:[UIFont systemFontOfSize:12]];
                deliverAdd.numberOfLines = 0;
                deliverAdd.lineBreakMode = UILineBreakModeWordWrap;
                [infoBG2 addSubview:deliverAdd];
                payMethod.frame = CGRectMake(10, deliverAdd.bottom + 10, 300, 12);
            } else {
                UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, payMethod.bottom+9, 300, 1)];
                line2.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
                [infoBG2 addSubview:line2];
            }
            
            if (self.model == DeliverPS_PayOffline) {
                UIView *infoBG3 = [[UIView alloc]initWithFrame:CGRectMake(10, infoBG2.bottom, 300, 32)];
                infoBG3.backgroundColor = [UIColor whiteColor];
                UILabel *payWay = [PublicMethod addLabel:CGRectMake(10, 10, 300, 12) setTitle:[NSString stringWithFormat:@"支付方式:"] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
                if ([orderEntity.pay_method isEqualToString:@"100"]) {
                    payWay.text = @"支付方式:银联支付";
                } else if ([orderEntity.pay_method isEqualToString:@"200"]) {
                    payWay.text = @"支付方式:支付宝支付";
                }else if ([orderEntity.pay_method isEqualToString:@"250"]) {
                    payWay.text = @"支付方式:永辉钱包支付";
                }
                payWay.textAlignment = NSTextAlignmentRight;
                [infoBG3 addSubview:payWay];
                [cell.contentView addSubview:infoBG3];
            }
        }
            break;
        case 1:
        {
            [self addCellPayMethodView:cell];
        }
            break;
        case 2:
        {
            [self addCellPayBtn:cell];
        }
            break;
        default:
            break;
    }
    
    return cell;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123 && buttonIndex == 1) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    if (alertView.tag == 1002) {
        YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
        [self.navigationController pushViewController:myOrder animated:YES];
    }
    if (alertView.tag == 1005 && buttonIndex == 0) {
        [self gotoSucceess];
    }
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    __unsafe_unretained YHConfirmOrderViewController * cvc = self;
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_BUY_PLATFORM_ORDERPAY == nTag)
    { //支付时候如果遇到订单过期
        if (isPay == NO)
        {
            if ([status isEqualToString:@"2"])
            { // 自提订单失效
                [self showAlert:errMsg];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                YHModifyPickTimeViewController *modifyTime = [[YHModifyPickTimeViewController alloc] init];
//                modifyTime.order_list_id = orderEntity.order_list_id;
//                modifyTime.pickTimeBlock = ^(NSString *pickTime){
//                    
//                    if (pickTime)
//                    {
//                        deliverTime.text = [NSString stringWithFormat:@"自提时间:%@",pickTime];
//                    }
//                    
//                };
                YHPickUpTimeViewContorller *modifyTime = [[YHPickUpTimeViewContorller alloc] init];
                modifyTime.order_list_id = orderEntity.order_list_id;
                modifyTime.isFromConfirmOrder = YES;
                modifyTime.pickTimeBlock = ^(NSString *pickTime){
                    
                    if (pickTime)
                    {
                        deliverTime.text = [NSString stringWithFormat:@"自提时间:%@",pickTime];
                    }
                    
                };
                [self.navigationController pushViewController:modifyTime animated:YES];
            }
            else if([status isEqualToString:@"3"])
            {// 配送订单失效
                [self showAlert:errMsg];
                YHPSDeliveryDoorViewController *delivery = [[YHPSDeliveryDoorViewController alloc] init];
                delivery.fromPayment = YES;
                delivery.goods_id = _goods_id;
                delivery.order_list_id = orderEntity.order_list_id;
                delivery.deliveryTimeBlock = ^(PSModel model,NSString * deliveryTime,NSString * orderListId){
                    [[PSNetTrans getInstance] my_orderDetail:cvc order_list_id:orderListId];
                };
                [self.navigationController pushViewController:delivery animated:YES];
            }
            else  if ([status isEqualToString:WEB_STATUS_3])
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
                [[iToast makeText:errMsg] show];
            }
        }
        else
        {
            if ([status isEqualToString:@"2"])
            { // 自提订单失效
                [self showAlert:errMsg];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                YHModifyPickTimeViewController *modifyTime = [[YHModifyPickTimeViewController alloc] init];
                modifyTime.order_list_id = orderEntity.order_list_id;
                modifyTime.pickTimeBlock = ^(NSString *pickTime){
                    
                    if (pickTime)
                    {
                        deliverTime.text = [NSString stringWithFormat:@"自提时间:%@",pickTime];
                    }
                    
                };
                [self.navigationController pushViewController:modifyTime animated:YES];
            }
            else if([status isEqualToString:@"3"])
            {// 配送订单失效
                [self showAlert:errMsg];
                YHPSDeliveryDoorViewController *delivery = [[YHPSDeliveryDoorViewController alloc] init];
                delivery.fromPayment = YES;
                delivery.goods_id = _goods_id;
                delivery.order_list_id = orderEntity.order_list_id;
                delivery.deliveryTimeBlock = ^(PSModel model,NSString * deliveryTime,NSString * orderListId){
                    [[PSNetTrans getInstance] my_orderDetail:cvc order_list_id:orderListId];
                };
                [self.navigationController pushViewController:delivery animated:YES];
            }
              else  if ([status isEqualToString:WEB_STATUS_3])
            {
                YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
                [[YHAppDelegate appDelegate] changeCartNum:@"0"];
                [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
                [[UserAccount instance] logoutPassive];
                [delegate LoginPassive];
            }
            else if([status isEqualToString:@"4"])
            {
                //            NSString * str1 = [NSString stringWithFormat:@"%d" , 1002];
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:errMsg
//                                                               delegate:self
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//                alert.tag = 1002;
//                [alert show];
                YHAlertView * other  = [[YHAlertView alloc] initWithTitle:nil message:errMsg delegate:self Left:NO button:@[@"重试" , @"忘记密码"] isPaa:NO];
                other.tag = 1;
                [other show];
            }
            else
            {
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
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_BUY_PLATFORM_ORDERPAY)
    {
        if (isPay == NO)
        {
            NSDictionary *payDic = (NSDictionary *)netTransObj;
            myDic = payDic;
            
            NSNumber *pay_method1 = [payDic objectForKey:@"pay_method"];
            NSString *pay_method = [NSString stringWithFormat:@"%@" , pay_method1];
            if ([pay_method isEqualToString:@"100"])
            {
                NSString *sn = [payDic objectForKey:@"pay_str"];
                [UPPayPlugin startPay:sn mode:CHINA_UNIONPAY_MODE viewController:self delegate:self];
            }
            else if ([pay_method isEqualToString:@"200"])
            {
//                AlixPay * alixpay = [AlixPay shared];
//                int ret = [alixpay pay:[payDic objectForKey:@"pay_str"] applicationScheme:@"YHCustomer"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlixPayResult:) name:@"AlixPayResult" object:nil];
                
                //将商品信息拼接成字符串
                NSString *orderSpec = [payDic objectForKey:@"pay_str"];
                NSLog(@"orderSpec = %@",orderSpec);
                
                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//                id<DataSigner> signer = CreateRSADataSigner(privateKey);
//                NSString *signedString = [signer signString:orderSpec];
                
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
//                NSString *orderString = nil;
//                if (signedString != nil) {
//                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                                   orderSpec, signedString, @"RSA"];
                
//                    [[AlipaySDK defaultService] payOrder:[payDic objectForKey:@"pay_str"] fromScheme:@"YHCustomer" callback:^(NSDictionary *resultDic) {
//                        NSLog(@"reslut = %@",resultDic);
//                        NSLog(@"str = %@",[resultDic objectForKey:@"memo"]);
//                    }];
//                }
                
//                if (ret == kSPErrorAlipayClientNotInstalled) {
                    [[AlipaySDK defaultService] payOrder:[payDic objectForKey:@"pay_str"] fromScheme:@"YHCustomer" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        NSLog(@"str = %@",[resultDic objectForKey:@"memo"]);
//                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {//用户取消
//                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                      message:@"用户取消"
//                                     delegate:self
//                            cancelButtonTitle:@"确定"
//                            otherButtonTitles:nil];
//                            alert.tag = 1002;
//                            [alert show];
//                        }
                    }];
//                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                              message:@"您还没有安装支付宝快捷支付，请先安装。"
//                             delegate:self
//                    cancelButtonTitle:nil
//                    otherButtonTitles:@"取消",@"确定",nil];
//                    [alertView setTag:123];
//                    [alertView show];
//                }else if (ret == kSPErrorSignError) {
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
                    //                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //                [[NetTrans getInstance] API_YH_Card_Pay:self Pay_the_password:str];
                    isPay = YES;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetTrans getInstance] API_Bank_Pay:self OrderList:orderEntity.order_list_id PayType:pay_method Pwd:str];
                };
                [elartView show];
                /*
                 YHCardPayViewController * payView = [[YHCardPayViewController alloc] init];
                 payView.order_list_id =orderEntity.order_list_id;
                 payView.pay_method = [NSString stringWithFormat:@"%@" , pay_method];
                 payView.total_amount = [payDic objectForKey:@"total_amount"];
                 payView.card_pay_amount = [payDic objectForKey:@"card_pay_amount"];
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
    }
    else if(nTag == t_API_CART_TOTAL_API)
    {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
    else if (nTag == t_API_ORDER_DETAIL_APP )
    {
        orderEntity = (OrderSubmitEntity *) netTransObj;
        self.total_amount = orderEntity.total_amount;
        if ([orderEntity.delivery_id isEqualToString:@"1"]) {
            self.model = FetchPS;
        }else{
            self.model = DeliverPS_PayOnline;
        }
//        //517 立即购。。
//        if (self.transaction_type.integerValue == 1) {
//            NSDictionary * dict = [orderEntity.orderArray lastObject];
//            self.goods_id = [dict objectForKey:@"bu_goods_id"];
//        }
        [self.orderTableView reloadData];
    }

}
- (void)didPresentYhAlertView:(YHAlertView *)alertView
{
    if (alertView.tag == 1000 )
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
                    [[NetTrans getInstance] API_Bank_Pay:self OrderList:orderEntity.order_list_id PayType:pay_method Pwd:str];
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
        [self pushPaySucceedVC];
    } else if ([result isEqualToString:@"fail"]) {
        [resultString appendString:@"支付失败"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    } else if ([result isEqualToString:@"cancel"]) {
        [resultString appendString:@"用户取消"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    }
}

#pragma mark ------------- cell
-(void)addCellPayMethodView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"修改支付方式";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 20, 20)];
    [arrow setImage:[UIImage imageNamed:@"cart_myOrderAccess"]];
    [bg addSubview:arrow];
}

-(void)addCellPayBtn :(UITableViewCell *) cell{
    UIButton *pay=[UIButton buttonWithType:UIButtonTypeCustom];
    pay.frame =CGRectMake(10, 0, 300, 40);
    [pay setBackgroundImage:[UIImage imageNamed:@"pay_btn"] forState:UIControlStateNormal];
    [pay setBackgroundImage:[UIImage imageNamed:@"pay_btn_selected"] forState:UIControlStateHighlighted];
//    [pay setTitle:@"立即支付" forState:UIControlStateNormal];
    pay.titleLabel.font =[UIFont systemFontOfSize:18.0];
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pay addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:pay];
}

#pragma mark ------------
-(void)pushPaySucceedVC
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertview.tag = 1005;
    [alertview show];
}

- (void)gotoSucceess
{
    YHPaySucceedViewController *conVC = [[YHPaySucceedViewController alloc]init];
    if (self.model == Fetch) {
        conVC.model = FetchPS;
    } else {
        if ([self.orderEntity.pay_method isEqualToString:@"100"] || [self.orderEntity.pay_method isEqualToString:@"200"] ||[self.orderEntity.pay_method isEqualToString:@"250"] ) {
            conVC.model = DeliverPS_PayOnline;
        } else {
            conVC.model = DeliverPS_PayOffline;
        }
    }
    
    conVC.order_list_id = orderEntity.order_list_id;
    [self.navigationController pushViewController:conVC animated:YES];
}

- (void)AlixPayResult:(NSNotification *)notification {
    NSString *resultCode =  [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlixPayResult" object:nil];
    if ([resultCode isEqualToString:@"9000"]) {//支付成功
        [self pushPaySucceedVC];
    } else if ([resultCode isEqualToString:@"6001"]) {//用户取消
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"用户取消"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    } else if ([resultCode isEqualToString:@"4006"]) {//支付失败
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"支付失败"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    }
}


@end
