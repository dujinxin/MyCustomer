//
//  YHTipUpViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/11/18.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHTipUpViewController.h"
#import "YHPSPaymentStyleViewController.h"
#import "AlixPay.h"
#import "UPPayPlugin.h"
#import "YHCardViceViewController.h"
#import "YHForgetPassViewController.h"

@interface YHTipUpViewController ()
{
    YHCardRechargePay * card;
    UITextField*  myText_3;
    BOOL isHaveDian;
    NSString * TimeT;
    UIButton * btn_1;//在线支付
    UIButton * btn_2 ;// 永辉卡转账
    NSString * str_Stype;//区分充值方式的字段
    UIView * myViewRemate;
    UILabel * lab_text_2;
    
    YHCardVice * arr_Card;
    YHCardRecharge * entity;
    
    NSMutableArray * arr_Meth;
}
@end

@implementation YHTipUpViewController
@synthesize card_no;
@synthesize tap;
@synthesize entityBag;
@synthesize forWard;

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    [self addNavRightButton];
//    [self addUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    [[NetTrans getInstance] user_getPersonInfo:self setUserId:[UserAccount instance].user_id];
    self.navigationItem.title = @"账户充值";
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
   
        [MTA trackPageViewBegin:PAGE102];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self addUI];
//    [self.view setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"]];
//    TimeT = @"1";
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (forWard)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_Recharge:self block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
//     [[NetTrans getInstance] cancelRequestByUI:self];
        [MTA trackPageViewEnd:PAGE102];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [myText_3 resignFirstResponder];
    forWard = NO;
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

-(void)addNavRightButton
{
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];//0xeeeeee
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
}

-(void)addUI
{
    UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    myView.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [self.view addSubview:myView];
    
    UILabel * lab_CardName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 28)];
//    NSString * str_num_1 = [NSString stringWithFormat:@"钱包帐号    %@" , card_no];
    NSString * str_num_1 = [NSString stringWithFormat:@"钱包帐号：%@" , entity.card_no];
    lab_CardName.text = str_num_1;
    lab_CardName.font = [UIFont systemFontOfSize:15];
    lab_CardName.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
    [myView addSubview:lab_CardName];
//    UILabel * lab_CardState = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, [UIScreen mainScreen].bounds.size.width-20, 28)];
//    lab_CardState.text = @"状态：未激活";
//    lab_CardState.font = [UIFont systemFontOfSize:15];
//    lab_CardState.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
//    [myView addSubview:lab_CardState];
    UILabel * lab_CardBalance = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, [UIScreen mainScreen].bounds.size.width-20, 28)];
    lab_CardBalance.text = @"钱包余额：";
    lab_CardBalance.font = [UIFont systemFontOfSize:15];
    lab_CardBalance.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
    [myView addSubview:lab_CardBalance];
    UILabel * lab_CardBalance_Num = [[UILabel alloc] initWithFrame:CGRectMake(81, 28, [UIScreen mainScreen].bounds.size.width-130, 28)];
//    NSString * str_1 = [NSString stringWithFormat:@"￥%@" , card.balance];
    NSString * str_tem = [NSString stringWithFormat:@"%.2f" , [entity.balance floatValue]];
    NSString * str_1 = [NSString stringWithFormat:@"￥%@" , str_tem];
     lab_CardBalance_Num.font = [UIFont systemFontOfSize:15];
    lab_CardBalance_Num.text = str_1;
    lab_CardBalance_Num.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    [myView addSubview:lab_CardBalance_Num];
    
    /*
    UILabel * lab_CardBalance_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 56, [UIScreen mainScreen].bounds.size.width-20, 28)];
    lab_CardBalance_1.text = @"可充值";
    lab_CardBalance_1.font = [UIFont systemFontOfSize:15];
    lab_CardBalance_1.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
    [myView addSubview:lab_CardBalance_1];
    UILabel * lab_CardBalance_Num_1 = [[UILabel alloc] initWithFrame:CGRectMake(83, 56, [UIScreen mainScreen].bounds.size.width-130, 28)];
//    NSString * str_num = [NSString stringWithFormat:@"%.2f" , 5000-[tap floatValue]];
//    NSString * str_2 = [NSString stringWithFormat:@"￥%@" , card.ceiling];
     NSString * str_2 = [NSString stringWithFormat:@"￥%@" , @"4000.00"];
    lab_CardBalance_Num_1.text = str_2;
     lab_CardBalance_Num_1.font = [UIFont systemFontOfSize:15];
    lab_CardBalance_Num_1.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    [myView addSubview:lab_CardBalance_Num_1];
    */
    
    UIImageView * ima_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myView.frame) +10, SCREEN_WIDTH, 40)];
//    [self addImage_DottedLine:ima_1];
    [ima_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"]];
    [self.view addSubview:ima_1];
    
    UILabel * lab_sty = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(myView.frame)+16, [UIScreen mainScreen].bounds.size.width-20, 28)];
    lab_sty.text = @"充值方式：";
    lab_sty.font = [UIFont systemFontOfSize:15];
    lab_sty.textColor = [PublicMethod colorWithHexValue1:@"#000000"];;
    [self.view addSubview:lab_sty];

    btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(83, CGRectGetMaxY(myView.frame)+16,(SCREEN_WIDTH-103)/2, 28)];
    NSString * str_Btn1 = [[arr_Meth firstObject] name];
    [btn_1 setTitle:str_Btn1 forState:UIControlStateNormal];
    btn_1.titleLabel.font = [UIFont systemFontOfSize:14];
    btn_1.layer.borderColor = LIGHT_GRAY_COLOR.CGColor;
    btn_1.layer.borderWidth = 0.5;
    btn_1.tag = 1;
    [btn_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.view addSubview:btn_1];
    
    btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn_1.frame)+10, CGRectGetMaxY(myView.frame)+16,(SCREEN_WIDTH-103)/2, 28)];
    NSString * str_Btn2 = [[arr_Meth lastObject] name];
    [btn_2 setTitle:str_Btn2 forState:UIControlStateNormal];
    btn_2.titleLabel.font = [UIFont systemFontOfSize:14];
    btn_2.layer.borderColor = LIGHT_GRAY_COLOR.CGColor;
    btn_2.layer.borderWidth = 0.5;
    btn_2.tag = 2;
 
    [btn_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_2 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.view addSubview:btn_2];
    
}

-(void)addImage_DottedLine:(UIImageView *)ima_V
{
    UIGraphicsBeginImageContext(ima_V.frame.size);   //开始画线
    [ima_V.image drawInRect:CGRectMake(0, 0, ima_V.frame.size.width, ima_V.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {10,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor redColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, 310.0, 0.0);
    CGContextStrokePath(line);
    ima_V.image = UIGraphicsGetImageFromCurrentImageContext();
}
#pragma mark -------------------- btn click
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myText_3 resignFirstResponder];
}
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 1:
        {
            str_Stype = @"1";
            [self reFlashBtn];
        }
            break;
        case 2:
        {
            str_Stype = @"2";
            [self reFlashBtn];
        }
            break;
        default:
            break;
    }
}
-(void)activation:(id)sender
{
    
            if ([str_Stype isEqualToString:@"1"])
            {
                if ([entity.type isEqualToString:@"0"])
                {
                    [myText_3 resignFirstResponder];
                    if ([myText_3.text floatValue] > 5000.00)
                    {
                        [self showAlert:@"亲，充值金额不能超过充值上限！"];
                    }
                    else if ([myText_3.text floatValue] < 50.0)
                    {
                        [self showAlert:@"亲，充值金额不能低于50元！"];
                    }
                    else
                    {
                    //            YHCardRechargeTapeViewController * rechargeTape = [[YHCardRechargeTapeViewController alloc] init];
                    //            rechargeTape.boolIsCardBuy = NO;
                    //            rechargeTape.block = ^(NSString * str)
                    //            {
                    //                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //                NSString * str_num = [NSString stringWithFormat:@"%.2f" , [myText_3.text floatValue]];
                    //                [[NetTrans getInstance] API_YHCard_Recharge_pay:self Card_no:card_no Money:str_num Pay_method:str];
                    //            };
                    //            [myText_3 resignFirstResponder];
                    //            [self.navigationController pushViewController:rechargeTape animated:YES];
                    
                        UIActionSheet * sheetView = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"银联支付" ,@"支付宝支付", nil];
                        [sheetView showInView:self.view];
                    }
                }
                else if ([entity.type isEqualToString:@"1"])
                {
                    [[iToast makeText:@"亲！抱歉，您不能进行充值操作哦！"] show];
                }
            }
            else if([str_Stype isEqualToString:@"2"])
            {
                
                if ([[lab_text_2.text substringFromIndex:1] floatValue] <= 0)
                {
                    [self showAlert:@"您未选择充值的永辉卡"];
                }
                else
                {
                    NSString * str_num = [NSString stringWithFormat:@"%.2f" , [myText_3.text floatValue]];
                    if ([str_num floatValue] > 10000)
                    {
                        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买金额不能大于10000元" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [view show];
                    }
                    else
                    {
                        NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入支付密码"];
                        YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:lab_text_2.text delegate:self Left:NO button:nil isPaa:YES];
                        elartView.tag = 0;
                        elartView.block = ^(NSString * str)
                        {
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [[NetTrans getInstance] API_YH_Card_Transfer_Pay:self Card_no:arr_Card.card_no Pay_the_password:str block:^(NSString *someThing) {
                                if ([someThing isEqualToString:WEB_STATUS_4])
                                {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }
                            }];
                        };
                        [elartView show];
                    }
                    
                    //           [elartView.textFiled becomeFirstResponder];
                }
            }
}

#pragma mark -----------------------------------action
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * str_num = [NSString stringWithFormat:@"%.2f" , [myText_3.text floatValue]];
  
        switch (buttonIndex)
        {
            case 0:
                //            [[iToast makeText:@"银联支付"] show];
                //            [[NetTrans getInstance] API_YHCard_Recharge_pay:self Card_no:card_no Money:str_num Pay_method:@"100"];
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetTrans getInstance] API_YH_Card_Recharge_Pay:self Money:str_num Pay_method:@"100" block:^(NSString *someThing) {
                    if ([someThing isEqualToString:WEB_STATUS_4])
                    {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                }];
            }
                
                break;
            case 1:
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetTrans getInstance] API_YH_Card_Recharge_Pay:self Money:str_num Pay_method:@"200" block:^(NSString *someThing) {
                    if ([someThing isEqualToString:WEB_STATUS_4])
                    {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                }];
            }
                //            [[iToast makeText:@"支付宝支付"] show];
                //            [[NetTrans getInstance] API_YHCard_Recharge_pay:self Card_no:card_no Money:str_num Pay_method:@"200"];
               
                break;
            default:
                break;
        }
   
}


-(void)CardYHSel:(id)sender
{
    YHCardViceViewController * ViceCard = [[YHCardViceViewController alloc] init];
    if (arr_Card)
    {
        ViceCard.entityCard = arr_Card;
    }
    ViceCard.forWard = YES;
    ViceCard.block = ^(id someThing)
    {
        arr_Card = (YHCardVice *)someThing;
        NSString * str_P = [NSString stringWithFormat:@"%.2f" , [arr_Card.card_amount floatValue]];
        NSString * str = [NSString stringWithFormat:@"￥%@" , str_P];
        [lab_text_2 setText:str];
        //输入密码后进行请求
    };
    [self.navigationController pushViewController:ViceCard animated:YES];
}
#pragma mark ----------------------------------------------- YHAlertView协议实现
- (void)didPresentYhAlertView:(YHAlertView *)alertView
{
    if (alertView.tag == 0)
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
                YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:lab_text_2.text delegate:self Left:NO button:nil isPaa:YES];
                elartView.tag = 0;
                elartView.block = ^(NSString * str)
                {
                    NSLog(@"%@" , str);
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetTrans getInstance] API_YH_Card_Transfer_Pay:self Card_no:arr_Card.card_no Pay_the_password:str block:^(NSString *someThing) {
                        if ([someThing isEqualToString:WEB_STATUS_4])
                        {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        }
                    }];
//                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    [[NetTrans getInstance] API_YH_Card_Transfer_Pay:self Card_no:entity.card_no Pay_the_password:str];
                };
                [elartView show];
            }
                break;
            case 2:
            {
//                [[iToast makeText:@"忘记密码"] show];
                YHForgetPassViewController * forgetPass = [[YHForgetPassViewController alloc] init];
                forgetPass.entityCard = entityBag;
                [self.navigationController pushViewController:forgetPass animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}
#pragma mark ----------------------------------------------- 请求协议实现

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   if(t_API_YH_CARD_RECHARGE_PAY == nTag)
    {
        card = (YHCardRechargePay *)netTransObj;
        //支付类型 100为银联  200为支付宝  card.pay_str为支付串
        NSString * str_num = [NSString stringWithFormat:@"%d" , [card.pay_method intValue]];
        if ([str_num isEqualToString:@"100"])
        {
            NSString *sn = card.pay_str;
            [UPPayPlugin startPay:sn mode:CHINA_UNIONPAY_MODE viewController:self delegate:self];
        }
        else if ([str_num isEqualToString:@"200"])
        {//200为支付宝
            AlixPay * alixpay = [AlixPay shared];
            int ret = [alixpay pay:card.pay_str applicationScheme:@"YHCustomer"];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlixPayResult:) name:@"AlixPayResult" object:nil];
            //没有安装支付宝
            if (ret == kSPErrorAlipayClientNotInstalled)
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"取消",@"确定",nil];
                [alertView setTag:123];
                [alertView show];
            }
        }
    }
    else if (nTag == t_API_YH_CARD_RECHARGE)
    {
        entity = (YHCardRecharge *)netTransObj;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_CArd_Methods:self block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
    else if (nTag == t_API_YH_CARD_METHODS)
    {
        arr_Meth = (NSMutableArray *)netTransObj;
        NSArray * myarr = [self.view subviews];
        for (UIView * view in myarr)
        {
            [view removeFromSuperview];
        }
        [self addUI];
        if(!str_Stype)
        {
            str_Stype = [[arr_Meth firstObject] str_ID];
        }
        else
        {
            arr_Card = nil;
        }
        [self reFlashBtn];
    }
    else if (nTag == t_API_YH_CARD_CARD_TRANSFER_PAY)
    {
        lab_text_2.text = @"￥0.00";
//        [[iToast makeText:@"支付成功"] show];
         [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(succShow) userInfo:nil repeats:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[NetTrans getInstance] API_YH_Card_Recharge:self];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_YHCARD_RECHARGE == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else
        {
            [[iToast makeText:errMsg]show];
        }
    }
    else if (t_API_YH_CARD_RECHARGE_PAY == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else
        {
            [[iToast makeText:errMsg]show];
        }
    }
    else if (t_API_YH_CARD_RECHARGE == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else
        {
            [[iToast makeText:errMsg]show];
        }
    }
    else if (nTag == t_API_YH_CARD_CARD_TRANSFER_PAY)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else if([status isEqualToString:WEB_STATUS_0])
        {
            [[iToast makeText:errMsg]show];
        }
        else if([status isEqualToString:@"4"])
        {
            YHAlertView * other  = [[YHAlertView alloc] initWithTitle:nil message:errMsg delegate:self Left:NO button:@[@"重试" , @"忘记密码"] isPaa:NO];
            other.tag = 1;
            [other show];
        }
    }
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
    } else if ([result isEqualToString:@"cancel"])
    {
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
- (void)AlixPayResult:(NSNotification *)notification {
    NSString *resultCode =  [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlixPayResult" object:nil];
    if ([resultCode isEqualToString:@"9000"])
    {//支付成功
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
-(void)pushPaySucceedVC
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //定时器延时3秒
    [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(succShow) userInfo:nil repeats:NO];
}

-(void)succShow
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertview.tag = 1005;
    [alertview show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 1005:
        {
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NetTrans getInstance] API_YH_Card_Recharge:self block:^(NSString *someThing) {
                if ([someThing isEqualToString:WEB_STATUS_4])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
        }
           
            break;
            case 1002:
            
            break;
        default:
            break;
    }
}

//检测充值输入的格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"textFiled = %@" , textField.text);
    NSLog(@"string = %@" , string);
    if ([textField.text rangeOfString:@"."].location==NSNotFound)
    {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0)
            {
                if(single == '.')
                {
                    [self showAlert:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0')
                {
                    [self showAlert:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self showAlert:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= 2)
                    {
                        return YES;
                    }
                    else
                    {
                        [self showAlert:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    
                    NSString * strValue = [textField.text stringByAppendingString:string];
                    NSString * str_tem = [NSString stringWithFormat:@"%.2f" , [entity.balance floatValue]];
                    if ([strValue floatValue] >(5000 - [str_tem floatValue]))
                    {
                         [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        [self showAlert:@"亲，充值金额不能超过充值上限"];
                         return NO;
                    }
                    return YES;
                }
            }
        }
        else
        {//输入的数据格式不正确
            [self showAlert:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        
      
    }
    else
    {
        return YES;
    }
  
}
#pragma mark ----------------------------------------------------------   自身方法
//刷洗充值方式的btn背景色
-(void)reFlashBtn
{
    if ([str_Stype isEqualToString:@"1"])
    {
        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [btn_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#CCCCCC"]];
    }
    else if ([str_Stype isEqualToString:@"2"])
    {
        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#CCCCCC"]];
        [btn_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    }
    [self addRemainView];
    if (arr_Card)
    {
        NSString * str_P = [NSString stringWithFormat:@"%.2f" , [arr_Card.card_amount floatValue]];
        NSString * str = [NSString stringWithFormat:@"￥%@" , str_P];
        [lab_text_2 setText:str];
    }
}

-(void)addRemainView
{
    if (myViewRemate)
    {
        [myViewRemate removeFromSuperview];
        myViewRemate = nil;
    }
    myViewRemate = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn_1.frame)+16, SCREEN_WIDTH, 78)];
    [self.view addSubview:myViewRemate];
    
    if ([str_Stype isEqualToString:@"1"])
    {
        UILabel * lab_text_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 28)];
        lab_text_1.text = @"充值金额：";
        lab_text_1.font = [UIFont systemFontOfSize:15];
        lab_text_1.backgroundColor = [UIColor clearColor];
        lab_text_1.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        [myViewRemate addSubview:lab_text_1];
        
        UILabel * lab_text_22 = [[UILabel alloc] initWithFrame:CGRectMake(75, 6, 20, 28)];
        lab_text_22.text = @"￥";
        lab_text_22.backgroundColor = [UIColor clearColor];
        lab_text_22.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
        [myViewRemate addSubview:lab_text_22];
        
        UIImageView * my_img_3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_text_22.frame), 0, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(lab_text_22.frame)-10, 40)];
        my_img_3.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        my_img_3.layer.borderWidth = 1;
        my_img_3.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
        [myViewRemate addSubview:my_img_3];
        
        myText_3 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_text_22.frame)+10, 10, [UIScreen mainScreen].bounds.size.width-CGRectGetMaxX(lab_text_22.frame)-30, 20)];
        myText_3.placeholder = @"请输入充值金额(≥50元)";
        myText_3.keyboardType = UIKeyboardTypeNumberPad;
        myText_3.delegate = self;
        [myViewRemate addSubview:myText_3];
    }
    else if ([str_Stype isEqualToString:@"2"])
    {
        [myText_3 resignFirstResponder];
        UIImageView * im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [im setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"]];
        [myViewRemate addSubview:im];
        
        UILabel * lab_text_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 148, 28)];
        lab_text_1.text = @"已选择可转账金额：";
        lab_text_1.font = [UIFont systemFontOfSize:15];
        lab_text_1.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        [myViewRemate addSubview:lab_text_1];
        
        lab_text_2 = [[UILabel alloc] initWithFrame:CGRectMake(138, 6, 500.00, 28)];
        lab_text_2.text = @"￥0.00";
        lab_text_2.font = [UIFont systemFontOfSize:15];
        lab_text_2.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
        [myViewRemate addSubview:lab_text_2];
        
        UIButton * btn_1_1 = [[UIButton alloc] initWithFrame:CGRectMake(220, 6, 90, 28)];
        [btn_1_1 setTitle:@"选择永辉卡" forState:UIControlStateNormal];
        btn_1_1.titleLabel.font= [UIFont systemFontOfSize:12];
        [btn_1_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btn_1_1.layer.borderColor = LIGHT_GRAY_COLOR.CGColor;
//        btn_1_1.layer.borderWidth = 0.5;
        [btn_1_1 addTarget:self action:@selector(CardYHSel:) forControlEvents:UIControlEventTouchUpInside];
        [myViewRemate addSubview:btn_1_1];
        
        UIImageView *imgvDic = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn_1_1.frame)-18, 8, 22, 22)];
        [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
        [myViewRemate addSubview:imgvDic];
    }
    
    UIButton * btn_2_2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(myText_3.frame)+20, [UIScreen mainScreen].bounds.size.width-20, 40)];
    [btn_2_2 setTitle:@"充值" forState:UIControlStateNormal];
    [btn_2_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    btn_2_2.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn_2_2 addTarget:self action:@selector(activation:) forControlEvents:UIControlEventTouchUpInside];
    [myViewRemate addSubview:btn_2_2];
   
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btn_2_2.frame)+10, SCREEN_WIDTH -20, 40)];
//    messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.text = @"提示：\n1.只支持在相应购入永辉卡城市的对应门店开具购卡发票\n2.通过电子永辉卡支付的订单不能开具发票\n3.账户总余额不能超过5000元";
    messageLabel.font = [UIFont systemFontOfSize:10];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    CGSize size ;
    if (IOS_VERSION >=7) {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
        
        CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
        size = rect.size;
    }else{
        size = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    }
    messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, size.height);
    [myViewRemate addSubview:messageLabel];

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
