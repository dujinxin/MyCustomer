//
//  YHMarketViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/12/5.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHMarketViewController.h"
#import "YHTipUpViewController.h"
#import "YHHelpUserWalletViewController.h"
#import "ZXingObjC.h"
#import "YHForgetPassViewController.h"
@interface YHMarketViewController ()
{
    YHCardPay * entity;
    YHCardOffline * entity_other;
    UILabel * lab_3_2;
    int numTitle;
    NSTimer * time;
    YHAlertView * elartViewOther;
}
@end

@implementation YHMarketViewController
@synthesize entityCard;
@synthesize forWard;
@synthesize isReflsh;



- (void)viewDidLoad
{
    isReflsh = YES;
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#eeeeee"];
    [super viewDidLoad];
    
//    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    self.navigationItem.title = @"门店支付";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
   
  
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PAGE105];
    if (forWard)
    {
        if (isReflsh)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NetTrans getInstance] API_YH_Card_Offline_Pay:self block:^(NSString *someThing) {
                if ([someThing isEqualToString:WEB_STATUS_4])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE105];
//     [[NetTrans getInstance] cancelRequestByUI:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------------------------- addUI
-(void)addUI
{
    /*
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 12)];
    view.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [self.view addSubview:view];
    NSString * str_1 = @"关于超市支付的简要提示，引导用户更好的理解和使用，文字由永辉提供！";
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH -40, 40)];
    messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.text = str_1;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 0;
    CGSize size ;
    if (IOS_VERSION >=7)
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
        
        CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
        size = rect.size;
    }
    else
    {
        size = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    }
    messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, size.height);
    [self.view addSubview:messageLabel];
    
    view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, CGRectGetMaxY(messageLabel.frame)+10);
    
    UIView * lin_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(messageLabel.frame)+10, SCREEN_WIDTH, 1)];
    lin_view.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
//    [self.view addSubview:lin_view];
    */
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(20,/* CGRectGetMaxY(lin_view.frame)+*/10, (SCREEN_WIDTH-40)/4+10, 20)];
    lab_2.text = @"钱包帐号：";
    lab_2.backgroundColor = [UIColor clearColor];
    lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab_2];
    
    UILabel * lab_2_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_2.frame)-5 ,/* CGRectGetMaxY(lin_view.frame)+*/10, (SCREEN_WIDTH-40)*3/4, 20)];
    lab_2_1.text = entity_other.card_no;
    lab_2_1.backgroundColor = [UIColor clearColor];
    lab_2_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_2_1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab_2_1];
    
    UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab_2.frame)+10, (SCREEN_WIDTH-40)/4+10, 20)];
    lab_3.text = @"钱包余额：";
    lab_3.backgroundColor = [UIColor clearColor];
    lab_3.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab_3];
    
    UILabel * lab_3_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_3.frame)-8 , CGRectGetMaxY(lab_2.frame)+10, (SCREEN_WIDTH-40)*3/4, 20)];
    NSString * str_te = [NSString stringWithFormat:@"%.2f" , [entity_other.total_amount floatValue]];
    NSString * str_3 = [NSString stringWithFormat:@"￥%@", str_te];
    lab_3_1.text = str_3;
    lab_3_1.backgroundColor = [UIColor clearColor];
    lab_3_1.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    lab_3_1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab_3_1];
    
    UIButton * btn_1  = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab_3.frame)+10, SCREEN_WIDTH-40, 40)];
    [btn_1 setTitle:@"生成支付码" forState:UIControlStateNormal];
    btn_1.layer.cornerRadius = 5;
    btn_1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5863"]];
    [btn_1 addTarget:self action:@selector(markCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_1];
    
    UILabel * lab_4 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn_1.frame)+20, (SCREEN_WIDTH-40)*3/5, 20)];
    lab_4.text = @"钱包余额不足，您可以：";
    lab_4.backgroundColor = [UIColor clearColor];
    lab_4.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab_4];
    
    UIButton * btn_4_1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_4.frame), CGRectGetMaxY(btn_1.frame)+10, (SCREEN_WIDTH-40)*2/5, 40)];
    [btn_4_1 setTitle:@"给钱包充值" forState:UIControlStateNormal];
    [btn_4_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    btn_4_1.layer.cornerRadius = 5;
//    btn_4_1.layer.borderColor = [PublicMethod colorWithHexValue1:@"#333333"].CGColor;
//    btn_4_1.layer.borderWidth = 0.5;
    btn_4_1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_4_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
//    [btn_4_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5863"]];
    [btn_4_1 addTarget:self action:@selector(tipUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_4_1];
    
    UILabel * lab_5 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(btn_4_1.frame)+20, (SCREEN_WIDTH-40)*3/5, 20)];
    lab_5.text = @"不会使用，您可以查看：";
    lab_5.backgroundColor = [UIColor clearColor];
    lab_5.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_5.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab_5];
    
    UIButton * btn_5_1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_5.frame), CGRectGetMaxY(btn_4_1.frame)+10, (SCREEN_WIDTH-40)*2/5, 40)];
    [btn_5_1 setTitle:@"钱包使用帮助" forState:UIControlStateNormal];
    btn_5_1.layer.cornerRadius = 5;
    [btn_5_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
//    btn_5_1.layer.borderColor = [PublicMethod colorWithHexValue1:@"#333333"].CGColor;
//    btn_5_1.layer.borderWidth = 0.5;
    btn_5_1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_5_1 setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    //    [btn_4_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5863"]];
    [btn_5_1 addTarget:self action:@selector(help:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_5_1];
}
#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    forWard = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)markCode:(id)sender
{
    NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入支付密码"];
    YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:nil delegate:self Left:NO button:nil isPaa:YES];
    elartView.tag = 1000;
    elartView.block = ^(NSString * str)
    {
        NSLog(@"%@" , str);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_Pay:self Pay_the_password:str block:^(NSString *someThing) {
            if ([someThing isEqualToString:WEB_STATUS_4])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
     
    };
    [elartView show];
}

-(void)sixTy
{
    NSArray * arr_T = [entity.countdown componentsSeparatedByString:@":"];
    NSString * str_H = [arr_T firstObject];
    NSString * str_S = [arr_T lastObject];
    int a_H = [str_H intValue];
    int a_S = [str_S intValue];
    if ([arr_T count] == 1)
    {
        numTitle = a_H;
    }
    else
    {
        numTitle = a_H*60+a_S;
    }
    
    time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnTitle:) userInfo:nil repeats:YES];
    [time fire];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(succShow) userInfo:nil repeats:NO];
    }
}

-(void)btnTitle:(id)sender
{
    if (numTitle == 0)
    {
        [time invalidate];
        time = nil;
        [elartViewOther dismiss];
        
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您刚生成的支付条码已过期请重新生成！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        view.tag = 100;
        [view show];
//        [self showAlert:@"您刚生成的支付条码已过期请重新生成！"];
    }
    else
    {
        
        NSString * str_M = [NSString stringWithFormat:@"%.2d分",numTitle/60];
        NSString * str_S = [NSString stringWithFormat:@"%.2d秒" ,numTitle%60];
        NSString * str_num = [NSString stringWithFormat:@"%@%@" , str_M , str_S];
        NSLog(@"%@" , str_num);
        lab_3_2.text = str_num;
        //        NSLog(@"%@" , btn_1.titleLabel.text);
        numTitle--;
        //        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    }
}
-(void)tipUp:(id)sender
{
    YHTipUpViewController * tipUp = [[YHTipUpViewController alloc] init];
    tipUp.forWard = YES;
    forWard = YES;
    isReflsh = YES;
    [self.navigationController pushViewController:tipUp animated:YES];
}

-(void)help:(id)sender
{
    YHHelpUserWalletViewController * helpUser = [[YHHelpUserWalletViewController alloc] init];
    forWard = NO;
    [self.navigationController pushViewController:helpUser animated:YES];
}

-(void)succShow
{
    [[NetTrans getInstance] API_YH_Card_Offline_Pay:self block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [time invalidate];
    if (alertView == elartViewOther)
    {
        if (buttonIndex == 0)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(succShow) userInfo:nil repeats:NO];
        }
    }
    if (alertView.tag == 3)
    {
        switch (buttonIndex)
        {
            case 1:
            {
                NSMutableAttributedString * str_1 = [[NSMutableAttributedString alloc] initWithString:@"请输入支付密码"];
                YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str_1 message:nil delegate:self Left:NO button:nil isPaa:YES];
                elartView.tag = 1;
                
                elartView.block = ^(NSString * str)
                {
                    NSLog(@"%@" , str);
//                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    [[NetTrans getInstance] API_YH_Card_Examples:self CardNo:arr_Selected.card_no GavingMobile:str_Num Pay_the_password:str];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[NetTrans getInstance] API_YH_Card_Pay:self Pay_the_password:str block:^(NSString *someThing) {
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

- (void)didPresentYhAlertView:(YHAlertView *)alertView
{
    if (alertView.tag == 1000||alertView.tag == 1)
    {
        [alertView.textFiled becomeFirstResponder];
        
            alertView.center = CGPointMake(alertView.centerX, alertView.centerY-70);
    }
   
}

#pragma mark ------------------------------- getView

-(UIView *)getCum
{
    UIView * view_Back = [[UIView alloc] init];
    UIImageView * ima_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 260, 100)];
//    ima_1.backgroundColor = [UIColor blueColor];
//    ima_1.layer.borderColor = [UIColor blueColor].CGColor;
//    ima_1.layer.borderWidth = 1;;
//    ima_1.image = [UIImage imageNamed:@"logo_qr_code"];
//    [ima_1 setImageWithURL:[NSURL URLWithString:entity.barcode_url]];
    NSError *error = nil;
    BOOL isExist;
    if ([entity.barcode_num isEqualToString:@""]||!entity.barcode_num||entity.barcode_num == nil)
    {
        isExist = NO;
    }
    else
    {
        isExist = YES;
    }
    ZXBitMatrix* result;
    if (isExist)
    {
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        result = [writer encode:entity.barcode_num
                                      format:kBarcodeFormatCode128
                                       width:100
                                      height:38
                                       error:&error];
        if (result) {
            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
            NSLog(@"%@",image);
            UIImage *imag=[UIImage imageWithCGImage:image];
            ima_1.image=imag;
            // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        } else {
            NSString *errorMessage = [error localizedDescription];
            [[iToast makeText:errorMessage] show];
            ima_1.image = [UIImage imageNamed:@"icon_表情微笑.png"];
        }
    }
    else
    {
        [ima_1 setImageWithURL:[NSURL URLWithString:entity.barcode_url] placeholderImage:[UIImage imageNamed:@"icon_表情微笑.png"]];
    }
    [view_Back addSubview:ima_1];
    
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(ima_1.frame)+5, SCREEN_WIDTH-80, 20)];
    if (isExist)
    {
        NSUInteger a = [entity.barcode_num length];
        NSString * str_B = @"";
        NSString * KONG = @"  ";
        NSInteger b = a/4;
        if (a%4 != 0)
        {
            b= b+1;
        }
        for (int i = 0 ; i < b ; i++)
        {
            if (i == b-1)
            {
                NSRange range = NSMakeRange(4*i, a - 4*i);
                NSString * str_T = [entity.barcode_num substringWithRange:range];
                 str_B = [str_B stringByAppendingString:str_T];
                NSLog(@"%@" , str_B);
            }
            else
            {
                NSRange range = NSMakeRange(4*i, 4);
                NSString * str_T = [entity.barcode_num substringWithRange:range];
                NSString * str_TE = [NSString stringWithFormat:@"%@%@" , str_T , KONG];
                str_B = [str_B stringByAppendingString:str_TE];
                NSLog(@"%@" , str_B);
            }
        }
        lab_1.text = str_B;
    }
    else
    {
        lab_1.text = @"抱歉，没有得到条形码码源！";
    }
    
    lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_1.font = [UIFont systemFontOfSize:15];
    lab_1.textAlignment = NSTextAlignmentCenter;
    [view_Back addSubview:lab_1];
    
    UIImageView * ima_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_1.frame)+5, SCREEN_WIDTH-60, 1)];
    [self addImage_DottedLine:ima_2];
    [view_Back addSubview:ima_2];
    
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(ima_2.frame)+10, SCREEN_WIDTH/2-80/2, 20)];
    lab_2.text = @"可支付金额";
    lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_2.font = [UIFont systemFontOfSize:15];
//    lab_2.textAlignment = NSTextAlignmentCenter;
    [view_Back addSubview:lab_2];
    
    UILabel * lab_2_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_2.frame), CGRectGetMaxY(ima_2.frame)+10, SCREEN_WIDTH/2-80/2, 20)];
    NSString * str = [NSString stringWithFormat:@"￥%@" , entity.amount_available];
    lab_2_1.text = str;
    lab_2_1.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    lab_2_1.font = [UIFont systemFontOfSize:15];
    //    lab_2.textAlignment = NSTextAlignmentCenter;
    [view_Back addSubview:lab_2_1];
    
    UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_2_1.frame)+10, SCREEN_WIDTH/2-80/2, 20)];
    lab_3.text = @"有效期倒计时";
    lab_3.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_3.font = [UIFont systemFontOfSize:15];
    //    lab_2.textAlignment = NSTextAlignmentCenter;
    [view_Back addSubview:lab_3];
    
    lab_3_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_3.frame), CGRectGetMaxY(lab_2_1.frame)+10, SCREEN_WIDTH/2-80/2, 20)];
    lab_3_2.text = @"29分49秒";
    lab_3_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_3_2.font = [UIFont systemFontOfSize:15];
    //    lab_2.textAlignment = NSTextAlignmentCenter;
    float a = CGRectGetMaxY(lab_3_2.frame);
    [view_Back setFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, a)];
    [view_Back addSubview:lab_3_2];
    
    return view_Back;
}
-(void)addImage_DottedLine:(UIImageView *)ima_V
{
    UIGraphicsBeginImageContext(ima_V.frame.size);   //开始画线
    [ima_V.image drawInRect:CGRectMake(0, 0, ima_V.frame.size.width, ima_V.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengths[] = {2,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [PublicMethod colorWithHexValue1:@"#666666"].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
    CGContextAddLineToPoint(line, 310.0, 0.0);
    CGContextStrokePath(line);
    ima_V.image = UIGraphicsGetImageFromCurrentImageContext();
}
#pragma mark ------------------- ---------------------- 网络请求回掉
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (t_API_YH_CARD_PAY == nTag)
    {
        entity = (YHCardPay *)netTransObj;
        UIView * view_temp =  [self getCum];
        elartViewOther = [[YHAlertView alloc] initWithOOTitle:@"给收银员扫一扫完成支付" message:@"提示：为了更加安全，请在支付完成后关闭本界面！" customView:view_temp delegate:self upButtonTitle:@"X"];
        [elartViewOther show];
        [self sixTy];
    }
    else if(t_API_YH_CARD_OFFLINE_INFO == nTag)
    {
        entity_other = (YHCardOffline *)netTransObj;
        NSArray * arr = [self.view subviews];
        for (UIView * view in arr)
        {
            [view removeFromSuperview];
        }
        [self addUI];
    }
        
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_PAY == nTag)
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
            other.tag = 3;
            [other show];
        }
        else if([status isEqualToString:WEB_STATUS_0])
        {
            [[iToast makeText:errMsg] show];
        }
    }
    else if (t_API_YH_CARD_OFFLINE_INFO == nTag)
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
