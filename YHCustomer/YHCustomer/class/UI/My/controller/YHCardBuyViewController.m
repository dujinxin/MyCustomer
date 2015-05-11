//
//  YHCardBuyViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/12/3.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHCardBuyViewController.h"
#import "CartAlertView.h"
#import "YHPSPaymentStyleViewController.h"
#import "YHCardBag.h"
#import "YHAlertView.h"
#import "AlixPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPayPlugin.h"
#import "YHForgetPassViewController.h"
@interface YHCardBuyViewController ()
{
    UIScrollView * myScrollView;
    NSMutableArray * PriceArr;
    NSString * arr_select;
    UIButton * goodsNumField;
    UILabel * lab_4;//合计总金额
    
    YHCardRechargePay * card;
    
    BOOL isCard;
}
@end

@implementation YHCardBuyViewController
@synthesize entityCard;
@synthesize forWard;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    self.navigationItem.title = @"购买永辉卡";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    [[NetTrans getInstance] API_YH_Card_List_Value:self block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PAGE103];
    isCard = NO;
    if (forWard)
    {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getData];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE103];
//     [[NetTrans getInstance] cancelRequestByUI:self];
    forWard = NO;
}
#pragma mark ----------------------------------      addUI
-(void)addUI
{
    
    if (myScrollView)
    {
        [myScrollView removeFromSuperview];
        myScrollView = nil;
    }

    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TURE_VIEW_HIGTH-50)];
    myScrollView.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    [self.view addSubview:myScrollView];
    NSInteger count = [PriceArr count];
    if (count > 0)
    {
        arr_select = @"1000";
    }
    else
    {
        arr_select = @"-1";
    }
    
    [self drawFootView];
    
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
    lab_1.text = @"请选择您要购买的永辉卡：";
    lab_1.backgroundColor = [UIColor clearColor];
    lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_1.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:lab_1];
    
    UIView * backG = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    backG.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [myScrollView addSubview:backG];
 

    for (int i = 0 ; i < count; i++)
    {
        YHCardDenomination * entity = [PriceArr objectAtIndex:i];
        int b = i%3;
         int c = i/3;
        float btn_len = (SCREEN_WIDTH-60)/3;
        float btn_hig = 40.0;
        float length = 10+b*(btn_len +20);
        float higth = CGRectGetMaxY(lab_1.frame)+20+(btn_hig + 20)*c ;
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(length, higth, btn_len, btn_hig)];
        NSString * btn_T = entity.the_cards_name;
        btn.tag = 1000+i;
        NSString * title = [NSString stringWithFormat:@"￥%@元" , btn_T];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.borderColor = [PublicMethod colorWithHexValue1:@"#eeeeee"].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        [btn setTitleColor:[PublicMethod colorWithHexValue1:@"#333333"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(upBackColoer:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:btn];
        
        backG.frame = CGRectMake(0, 40, SCREEN_WIDTH, CGRectGetMaxY(btn.frame)-30);
    }
    if (count > 0)
    {
        [self UpBtnColor:arr_select cancelBtn:@""];
    }
     float a = CGRectGetMaxY(backG.frame)+10;
    [self addRestUI:a];
}

-(void)addRestUI:(CGFloat)a
{
    UIView * backG = [[UIView alloc] initWithFrame:CGRectMake(0, a, SCREEN_WIDTH, 60)];
    backG.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [myScrollView addSubview:backG];
    
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, a+20, SCREEN_WIDTH-20, 20)];
    lab_2.text = @"购买数量:";
    lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_2.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:lab_2];
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    [minus setBackgroundImage:[UIImage imageNamed:@"ps_cut"] forState:UIControlStateNormal];
    [minus setBackgroundImage:[UIImage imageNamed:@"ps_cut_Select"] forState:UIControlStateHighlighted];
//    minus.frame = CGRectMake(55, a+20, 30, 30);
    minus.frame = CGRectMake(SCREEN_WIDTH-170, a+15, 30, 30);
    [minus addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:minus];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    [plus setBackgroundImage:[UIImage imageNamed:@"ps_plus"] forState:UIControlStateNormal];
    [plus setBackgroundImage:[UIImage imageNamed:@"ps_plus_Select"] forState:UIControlStateHighlighted];
//    plus.frame = CGRectMake(55+130, a+20, 30, 30);
    plus.frame = CGRectMake(SCREEN_WIDTH-40, a+15, 30, 30);
    [plus addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:plus];
    
//    goodsNumField = [[UIButton alloc]initWithFrame:CGRectMake(105, a+15, 60, 40)];
    goodsNumField = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, a+10, 60, 40)];
    goodsNumField.layer.borderWidth = 1;
    [goodsNumField setTitle:@"1" forState:UIControlStateNormal];
    [goodsNumField setTitleColor:[PublicMethod colorWithHexValue1:@"#000000"] forState:UIControlStateNormal];
    goodsNumField.layer.borderColor = [PublicMethod colorWithHexValue:0xbfbfbf alpha:1.0].CGColor;
    //    goodsNumField..textAlignment = NSTextAlignmentCenter;
    goodsNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumField.backgroundColor = [UIColor whiteColor];
    //    _goodsNumField.keyboardType = UIKeyboardTypeNumberPad;
    //    _goodsNumField.delegate = self;
    [goodsNumField addTarget:self action:@selector(AlertView:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:goodsNumField];
    
    UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(goodsNumField.frame)+15, SCREEN_WIDTH-20, 20)];
    lab_3.text = @"提示：\n1.只支持在相应购入永辉卡城市的对应门店开具购卡发票 \n2.通过电子永辉卡支付的订单不能开具发票 \n3.单次购买电子永辉卡的金额不能超过10000元";
   lab_3.backgroundColor = [UIColor clearColor];
    lab_3.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_3.font = [UIFont systemFontOfSize:10];
    lab_3.textAlignment = NSTextAlignmentLeft;
    lab_3.numberOfLines = 0;
    CGSize size ;
    if (IOS_VERSION >=7) {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:lab_3.font forKey:NSFontAttributeName];
        
        CGRect rect = [lab_3.text boundingRectWithSize:CGSizeMake(lab_3.frame.size.width, 99999) options:option attributes:attributes context:nil];
        size = rect.size;
    }else{
        size = [lab_3.text sizeWithFont:lab_3.font constrainedToSize:CGSizeMake(lab_3.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    }
    lab_3.frame = CGRectMake(lab_3.frame.origin.x, lab_3.frame.origin.y, lab_3.frame.size.width, size.height);
    [myScrollView addSubview:lab_3];
    
//     float aa =  [[[PriceArr objectAtIndex:([arr_select intValue]-1000)] objectAtIndex:0] intValue]*([goodsNumField.titleLabel.text intValue]);
//    lab_4 = [[UILabel alloc] initWithFrame:CGRectMake(55, CGRectGetMaxY(goodsNumField.frame)+15, SCREEN_WIDTH-56, 20)];
//    NSString * str_4 = [NSString stringWithFormat:@"￥%.2f" , aa];
//    lab_4.text = str_4;
//    lab_4.textColor = [PublicMethod colorWithHexValue1:@"#FC5864"];
//    lab_4.font = [UIFont systemFontOfSize:15];
//    [myScrollView addSubview:lab_4];
    
    UIButton * btn_2_2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_4.frame)+20, [UIScreen mainScreen].bounds.size.width-20, 40)];
    [btn_2_2 setTitle:@"立刻购买" forState:UIControlStateNormal];
    [btn_2_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [btn_2_2 addTarget:self action:@selector(activation:) forControlEvents:UIControlEventTouchUpInside];
//    [myScrollView addSubview:btn_2_2];
    
    if (CGRectGetMaxY(lab_3.frame) > TURE_VIEW_HIGTH-50)
    {
        [myScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(lab_3.frame))];
    }
}

-(void)drawFootView
{
     NSLog(@"%f" , TURE_VIEW_HIGTH);
    UIView* footView =[[UIView alloc] initWithFrame:CGRectMake(0, TURE_VIEW_HIGTH-50, SCREEN_WIDTH, 50)];
    footView.backgroundColor =[PublicMethod colorWithHexValue:0x434343 alpha:1];
    [self.view addSubview:footView];
    
    NSLog(@"%f" , TURE_VIEW_HIGTH);
    
    UILabel * priceInfo_1 =[[UILabel alloc] initWithFrame:CGRectMake(10, TURE_VIEW_HIGTH-39, 150, 24)];
    priceInfo_1.backgroundColor=[UIColor clearColor];
    priceInfo_1.textColor =[UIColor whiteColor];
    priceInfo_1.text =@"已选择可转账金额";
    priceInfo_1.font =[UIFont boldSystemFontOfSize:15.0];
    //    self.totalAmount = priceInfo;
//    [footView addSubview:priceInfo_1];
    
    lab_4 = [[UILabel alloc] initWithFrame:CGRectMake(10, TURE_VIEW_HIGTH-45, 200, 40)];
    lab_4.textColor =[PublicMethod colorWithHexValue1:@"#FFFFFF"];
    lab_4.backgroundColor = [UIColor clearColor];
    float aa = 0.0;
    if (PriceArr.count > 0)
    {
         aa =  [[[PriceArr objectAtIndex:([arr_select intValue]-1000)] the_cards_name] intValue]*([goodsNumField.titleLabel.text intValue]);
    }
    NSString * str_4 = [NSString stringWithFormat:@"￥%.2f" , aa];
    lab_4.text = str_4;
    lab_4.font =[UIFont boldSystemFontOfSize:20.0];
//    lab_4.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab_4];
    //提交
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame =CGRectMake(220, TURE_VIEW_HIGTH-50, 100, 50);
    //    sendButton.backgroundColor = [PublicMethod colorWithHexValue:0xFC7F4A alpha:1];
    sendButton.backgroundColor= RGBCOLOR(255, 126, 0);
    [sendButton setTitle:@"立即购买" forState:UIControlStateNormal];
    sendButton.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(activation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}


#pragma mark  =========================== btnClick
-(void)activation:(id)sender
{
    if ([arr_select isEqualToString:@"-1"])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有选择永辉卡金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIActionSheet * sheetView = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"银联支付" ,@"支付宝支付"/*,@"永辉钱包支付"*/, nil];
        [sheetView showInView:self.view];
    }
   
}
#pragma mark -----------------------------------action
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            isCard = NO;
            NSString * str = [[PriceArr objectAtIndex:([arr_select integerValue]-1000)] the_cards_id];
            [[NetTrans getInstance] API_YH_Card_Buy:self Selling_card_id:str Num:goodsNumField.titleLabel.text Pay_method:@"100" Password:@"0" block:^(NSString *someThing) {
                if ([someThing isEqualToString:WEB_STATUS_4])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
        }
            break;
        case 1:
        {
            isCard = NO;
            NSString * str = [[PriceArr objectAtIndex:([arr_select integerValue]-1000)] the_cards_id];
            [[NetTrans getInstance] API_YH_Card_Buy:self Selling_card_id:str Num:goodsNumField.titleLabel.text Pay_method:@"200" Password:@"0" block:^(NSString *someThing) {
                if ([someThing isEqualToString:WEB_STATUS_4])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
        }
            break;
            /*
            case 2:
        {
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(viewA) userInfo:nil repeats:NO];
//            NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
//            YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:lab_4.text delegate:self Left:NO button:nil isPaa:YES];
//            elartView.tag = 1000;
//            elartView.block = ^(NSString * str)
//            {
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                [[NetTrans getInstance] API_YH_Card_Buy:self Selling_card_id:str1 Num:goodsNumField.titleLabel.text Pay_method:@"250" Password:str];
//            };
//            [elartView show];
        }
            break;
             */
        default:
            break;
    }
}

-(void)viewA
{
    
    NSString * str1 = [[PriceArr objectAtIndex:([arr_select integerValue]-1000)] the_cards_id];
    NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:lab_4.text delegate:self Left:NO button:nil isPaa:YES];
    elartView.tag = 1000;
    elartView.block = ^(NSString * str)
    {
        isCard = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_Buy:self Selling_card_id:str1 Num:goodsNumField.titleLabel.text Pay_method:@"250" Password:str block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    };
    [elartView show];
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
                NSString * str1 = [[PriceArr objectAtIndex:([arr_select integerValue]-1000)] the_cards_id];
                NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
                YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:lab_4.text delegate:self Left:NO button:nil isPaa:YES];
                elartView.tag = 1000;
                elartView.block = ^(NSString * str)
                {
                    isCard = YES;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetTrans getInstance] API_YH_Card_Buy:self Selling_card_id:str1 Num:goodsNumField.titleLabel.text Pay_method:@"250" Password:str block:^(NSString *someThing) {
                        if ([someThing isEqualToString:WEB_STATUS_4])
                        {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        }
                    }];
                };
                [elartView show];
            }
                break;
            case 2:
            {
                //                [[iToast makeText:@"忘记密码"] show];
                YHForgetPassViewController * forgetPass = [[YHForgetPassViewController alloc] init];
                forgetPass.entityCard = entityCard;
                [self.navigationController pushViewController:forgetPass animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}
#pragma mark ----------------------------------------------- YHAlertView协议实现
- (void)didPresentYhAlertView:(YHAlertView *)alertView
{
    if (alertView.tag == 1000)
    {
        [alertView.textFiled becomeFirstResponder];
        alertView.center = CGPointMake(alertView.centerX, alertView.centerY-70);
    }
}
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)upBackColoer:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    NSString * str = [NSString stringWithFormat:@"%ld" , (long)btn.tag];
    [self UpBtnColor:str cancelBtn:arr_select];
    arr_select = str;
}

-(void)minusAction
{
    if ([goodsNumField.titleLabel.text intValue] - 1<= 0)
    {
        [[iToast makeText:@"不能小于1"] show];
        return;
    }
     float a =  [[[PriceArr objectAtIndex:([arr_select intValue]-1000)] the_cards_name] intValue]*([goodsNumField.titleLabel.text intValue]-1);
    NSString *num =  [NSString stringWithFormat:@"%d",[goodsNumField.titleLabel.text intValue] - 1];
    [goodsNumField setTitle:num forState:UIControlStateNormal];
    lab_4.text = [NSString stringWithFormat:@"￥%.2f" , a];
}

-(void)plusAction
{
    float a =  [[[PriceArr objectAtIndex:([arr_select intValue]-1000)] the_cards_name] intValue]*([goodsNumField.titleLabel.text intValue] +1);
    if (a > 10000)
    {
        [[iToast makeText:@"购卡总金额不能大于10000"] show];
        return;
    }
    NSString *num =  [NSString stringWithFormat:@"%d",[goodsNumField.titleLabel.text intValue] +1];
    [goodsNumField setTitle:num forState:UIControlStateNormal];
    lab_4.text = [NSString stringWithFormat:@"￥%.2f" , a];
}

-(void)AlertView:(id)sender
{
    NSString * str = [[PriceArr objectAtIndex:([arr_select intValue]-1000)] the_cards_name];
    CartAlertView *alert = [[CartAlertView alloc]initCard:str];
    alert.goodsNumField.text = goodsNumField.titleLabel.text;
    [alert setOnButtonTouchUpInside:^(NSString *goodsNum)
     {
        NSLog(@"goodsNum = %@",goodsNum);
        [goodsNumField setTitle:goodsNum forState:UIControlStateNormal];
        float a =  [[[PriceArr objectAtIndex:([arr_select intValue]-1000)] the_cards_name] intValue]*[goodsNum intValue];
        lab_4.text = [NSString stringWithFormat:@"￥%.2f" , a];
    }];
    [alert show];
}



#pragma mark --------------------------------------------------- 更新选择的面额的btn颜色

-(void)UpBtnColor:(NSString *)str_1 cancelBtn:(NSString *)str_2
{
    if (!str_2 || [str_2 isEqualToString:@""]||str_2 == nil)
    {
         int a = [str_1 intValue];
        UIButton * btn_1 = (UIButton *)[myScrollView viewWithTag:a];
        NSLog(@"%@" ,[myScrollView viewWithTag:a])
//        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"FC5860"]];
        btn_1.backgroundColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
        btn_1.titleLabel.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        [btn_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    else if ([str_1 isEqualToString:str_2])
    {
        int a = [str_1 intValue];
        UIButton * btn_1 = (UIButton *)[myScrollView viewWithTag:a];
         btn_1.titleLabel.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        [btn_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    else
    {
        [goodsNumField setTitle:@"1" forState:UIControlStateNormal];
        int a = [str_1 intValue];
        int b = [str_2 intValue];
        UIButton * btn_1 = (UIButton *)[myScrollView viewWithTag:a];
        UIButton * btn_2 = (UIButton *)[myScrollView viewWithTag:b];
        
        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        btn_1.titleLabel.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        [btn_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
        [btn_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"]];
        btn_2.titleLabel.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        [btn_2 setTitleColor:[PublicMethod colorWithHexValue1:@"#000000"] forState:UIControlStateNormal];
        
    }
    float aa = [[[PriceArr objectAtIndex:[str_1 intValue]-1000] the_cards_name] intValue]*1;
    lab_4.text = [NSString stringWithFormat:@"￥%.2f" ,  aa];
}
#pragma mark ------------------- ---------------------- 网络请求回掉

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_LIST_CARDS_VALUE == nTag)
    {
        PriceArr = (NSMutableArray *)netTransObj;
        [self addUI];
    }
    else if (t_API_YH_CARD_BUY == nTag)
    {
        card = (YHCardRechargePay *)netTransObj;
        if (!isCard)
        {
            NSString * str_num = [NSString stringWithFormat:@"%d" , [card.pay_method intValue]];
            if ([str_num isEqualToString:@"100"])
            {
                NSString *sn = card.pay_str;
                [UPPayPlugin startPay:sn mode:CHINA_UNIONPAY_MODE viewController:self delegate:self];
            }
            else if ([str_num isEqualToString:@"200"])
            {
//                AlixPay * alixpay = [AlixPay shared];
//                int ret = [alixpay pay:card.pay_str applicationScheme:@"YHCustomer"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlixPayResult:) name:@"AlixPayResult" object:nil];
                [[AlipaySDK defaultService] payOrder:card.pay_str fromScheme:@"YHCustomer" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    NSLog(@"str = %@",[resultDic objectForKey:@"memo"]);}];
//                if (ret == kSPErrorAlipayClientNotInstalled)
//                {
//                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                         message:@"您还没有安装支付宝快捷支付，请先安装。"
//                                                                        delegate:self
//                                                               cancelButtonTitle:nil
//                                                               otherButtonTitles:@"取消",@"确定",nil];
//                    [alertView setTag:123];
//                    [alertView show];
//                }
            }
        }
        else
        {
            [self addUI];
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:card.message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            view.tag = 100;
            [view show];
//            [[iToast makeText:card.message] show];
        }
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_REGISTER == nTag)
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
            [[iToast makeText:errMsg] show];
            [self getData];
            [self addUI];
        }
    }
    else if (t_API_YH_CARD_BUY == nTag)
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
            [[iToast makeText:errMsg] show];
        }
        else if ([status isEqualToString:@"4"])
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
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertview.tag = 1005;
    [alertview show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 1005:
            [self addUI];
            break;
        case 1002:
            
            break;
            case 100:
        {
            if (buttonIndex == 0)
            {
                [self getData];
                [self addUI];
            }
        }
        default:
            break;
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
