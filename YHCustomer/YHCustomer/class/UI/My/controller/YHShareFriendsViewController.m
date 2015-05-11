//
//  YHShareFriendsViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/12/4.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHShareFriendsViewController.h"
#import "YHCardBuyViewController.h"
#import "YHForgetPassViewController.h"
#import "YHCardBag.h"


@interface YHShareFriendsViewController ()
{
    NSMutableArray * arr_Data;
    CGFloat H;
    UITextField * numField;
    YHAlertView * myAlertView;
    NSDictionary * dicMy;
    BOOL isPerSon;
    YHCardVice * arr_Selected;
    int pages;
    
    NSMutableArray * arr_Add;
    BOOL _reloadingOther;
    UITableView * myTableView;
}
@end

@implementation YHShareFriendsViewController
@synthesize entityCard;
@synthesize refreshFooterOtherView;
@synthesize forWard;

- (void)viewDidLoad
{
    [super viewDidLoad];
    pages = 1;
    arr_Add = [[NSMutableArray alloc] init];
    arr_Data = [[NSMutableArray alloc] init];
    isPerSon = NO;//判断是否是从联系人信息界面返回的
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    self.navigationItem.title = @"永辉卡转赠";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
//    self.navigationItem.rightBarButtonItem = BARBUTTON(@"填充数据", @selector(getData));
   
    
    // Do any additional setup after loading the view.
}

-(void)addUI
{
    if (myTableView)
    {
        [myTableView removeFromSuperview];
        myTableView = nil;
    }
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TURE_VIEW_HIGTH)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    if ([arr_Data count] == 0)
    {
        myTableView.scrollEnabled = NO;
    }
    else
    {
        myTableView.scrollEnabled = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isPerSon)
    {
        if (forWard)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self getData];
        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getData) userInfo:nil repeats:NO];
        }
    }
    isPerSon = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE104];
//     [[NetTrans getInstance] cancelRequestByUI:self];
}

-(void)upNaT
{
    NSString * str_num ;
    if ([arr_Data count] == 0)
    {
        str_num = @"0";
    }
    else
    {
        str_num = [(YHCardVice *)[arr_Data lastObject] total];
        if ([str_num intValue] > 10)
        {
           
        }
    }
        NSString * str = [NSString stringWithFormat:@"永辉卡转赠（共%@张）" , str_num];
        NSMutableAttributedString * str_s = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = NSMakeRange(5, [str length]-5);
        NSRange range2 = NSMakeRange(0, 5);
        UIFont *font1 = [UIFont systemFontOfSize:12];
        UIFont *font2 = [UIFont boldSystemFontOfSize:20];
        [str_s addAttribute:NSFontAttributeName value:font1 range:range1];
        [str_s addAttribute:NSFontAttributeName value:font2 range:range2];
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        lab.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = lab;
        
        lab.attributedText = str_s;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE104];
     [self upNaT];
    if (isPerSon)
    {
        UIView * view_temp = [self cumView];
        myAlertView = [[YHAlertView alloc] initWithOtherTitle:@"请填写转赠信息" customView:view_temp delegate:self buttonTitles:@[@"取消", @"提交转赠"]];
        [myAlertView setLine];
        [myAlertView show];
        [self putLable];
        
        
    }
}

-(void)putLable
{
    if (dicMy)
    {
        NSString * str_1 = [dicMy objectForKey:@"lastName"];
        NSString * str_2  = [dicMy objectForKey:@"firstName"];
        NSArray * arr = [dicMy objectForKey:@"phones"];
        NSString * str_O = [NSString stringWithFormat:@"%@%@" , str_1 , str_2];
        if ([str_O isEqualToString:@"  "] || str_O== nil || !str_O)
        {
            NSString * str_P = [arr firstObject];
            if ([str_P isEqualToString:@""] || str_P== nil || !str_P)
            {
                numField.text = @"";
            }
            else
            {
                NSUInteger len = [str_P length];
                NSMutableString * str_Q =[[NSMutableString alloc] init];
                for (int i = 0 ; i < len; i++)
                {
                    unichar single=[str_P characterAtIndex:i];//当前输入的字符
                    if (single >='0' && single<='9')
                    {
                        NSRange range = NSMakeRange(i, 1);
                        NSString * str_T = [str_P substringWithRange:range];
                        NSLog(@"str_T = %@" , str_T);
                        [str_Q appendString:str_T];
                        NSLog(@"str_Q = %@" , str_Q);
                    }
                }
                NSMutableString * str_T = [self getPhoneNum:str_Q];
                NSString * str_A = [NSString stringWithFormat:@"%@" , str_T];
                numField.text = str_A;
            }
        }
        else
        {
            NSString * str_P = [arr firstObject];
            if ([str_P isEqualToString:@""] || str_P== nil || !str_P)
            {
                numField.text = @"";
            }
            else
            {
                NSUInteger len = [str_P length];
                NSMutableString * str_Q =[[NSMutableString alloc] init];
                for (int i = 0 ; i < len; i++)
                {
                    unichar single=[str_P characterAtIndex:i];//当前输入的字符
                    if (single >='0' && single<='9')
                    {
                        NSRange range = NSMakeRange(i, 1);
                        NSString * str_T = [str_P substringWithRange:range];
                        NSLog(@"str_T = %@" , str_T);
                        [str_Q appendString:str_T];
                        NSLog(@"str_Q = %@" , str_Q);
                    }
                }
                NSMutableString * str_T = [self getPhoneNum:str_Q];
                NSString * str_A = [NSString stringWithFormat:@"%@ %@" , str_O , str_T];
                numField.text = str_A;
            }
        }
    }
}
-(NSMutableString *)getPhoneNum:(NSMutableString *)_phone
{
    NSUInteger legth = [_phone length];
    NSRange range = NSMakeRange(legth-11, 11);
    NSMutableString * str_1 = (NSMutableString *)[_phone substringWithRange:range];
    return str_1;
}

-(void)getData
{
    NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
    [[NetTrans getInstance] API_YH_Card_List_Share:self pages:str_num block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
//    arr_Data = [[NSMutableArray alloc] init];
//    for (int i = 0 ; i< 14; i ++ )
//    {
//      long long  int  a = 24243252355532213;
//        NSString *str_1 = [NSString stringWithFormat:@"%lld" , a+1];
//        float b = 100.00;
//        NSString * str_2 = [NSString stringWithFormat:@"%.2f" , b+50*i];
//        NSString * str_3 = @"4893-13-21";
//        NSString * str_4 = [NSString stringWithFormat:@"%d" , i];
//        NSArray * arr = @[str_1 , str_2 , str_3 , str_4];
//        [arr_Data addObject:arr];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)cumView
{
    UIView * Cview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 90)];
    UIImageView * ima_1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-80, 40)];
    ima_1.layer.borderColor = [PublicMethod colorWithHexValue1:@"#cccccc"].CGColor;
    ima_1.layer.borderWidth = 0.5;
    [Cview addSubview:ima_1];
    
    numField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-90,30)];
    numField.keyboardType = UIKeyboardTypeNumberPad;
    numField.font = [UIFont systemFontOfSize:15];
    numField.textAlignment = NSTextAlignmentCenter;
    numField.placeholder = @"请输入朋友的手机号";
    numField.delegate = self;
    [Cview addSubview:numField];
    
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(ima_1.frame)+10,  SCREEN_WIDTH/2-40, 30)];
    lab_1.text = @"您也可以";
    lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    lab_1.font = [UIFont systemFontOfSize:15];
    [Cview addSubview:lab_1];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_1.frame), CGRectGetMaxY(ima_1.frame)+10, SCREEN_WIDTH/2-40, 30)];
    btn.layer.borderColor = [PublicMethod colorWithHexValue1:@"#cccccc"].CGColor;
    btn.layer.borderWidth = 0.5;
    [btn setTitle:@"从通讯录中选择" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [btn setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getPerson) forControlEvents:UIControlEventTouchUpInside];
    [Cview addSubview:btn];
    return Cview;
}

#pragma mark ------------------------------------------UITableViewDelegate and DataS
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_Data count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float higth = 0.0;
    UIView * head_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, higth)];
    head_view.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    if ([arr_Data count] == 0)
    {
        UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        lab_1.text = @"亲，您还没有可供转赠的电子永辉卡！";
        lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
        lab_1.font = [UIFont systemFontOfSize:15];
        [head_view addSubview:lab_1];
        
        UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_1.frame)+20, SCREEN_WIDTH-20, 20)];
        lab_2.text = @"您可以";
        lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
        lab_2.font = [UIFont systemFontOfSize:15];
        [head_view addSubview:lab_2];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, CGRectGetMaxY(lab_1.frame)+15, 150, 30)];
        [btn setTitle:@"立即购买永辉卡" forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
//        btn.layer.borderColor = [PublicMethod colorWithHexValue1:@"#333333"].CGColor;
//        btn.layer.borderWidth = 0.5;
//        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [btn addTarget:self action:@selector(cardBuy:) forControlEvents:UIControlEventTouchUpInside];
        [head_view addSubview:btn];
        higth = CGRectGetMaxY(btn.frame);
        H = higth+10;
        [head_view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, higth+10)];

    }
    return head_view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([arr_Data count] == 0)
    {
        return 85;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHCardVice * entity = [arr_Data objectAtIndex:indexPath.row];
    NSString * strCell = [NSString stringWithFormat:@"CELL%@" , entity.card_no];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    cell.backgroundColor = [PublicMethod colorWithHexValue1:@"#F5F5F5"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 90)];
    back.layer.cornerRadius = 8;
    back.clipsToBounds = YES;
    back.layer.masksToBounds = YES;
    [cell addSubview:back];
    
    UIImageView * view_img_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 60)];
    view_img_1.backgroundColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    //        view_img_1.layer.cornerRadius =8;
    [back addSubview:view_img_1];
    
    UIImageView * view_img_2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 71,19 )];
    view_img_2.backgroundColor = [UIColor clearColor];
    view_img_2.image = [UIImage imageNamed:@"icon_永辉钱包_永辉超市log加文字.png"];
    [back addSubview:view_img_2];
    
    //        UIImageView * ima_view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
    //        ima_view.image = [UIImage imageNamed:@"二维码.png"];
    //        [cell.contentView addSubview:ima_view];
    
    
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view_img_2.frame), 10, SCREEN_WIDTH-111, 20)];
    lab_1.backgroundColor = [UIColor clearColor];
    lab_1.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    lab_1.text = entity.card_no;
    lab_1.textAlignment = NSTextAlignmentRight;
    lab_1.font = [UIFont systemFontOfSize:15];
    [back addSubview:lab_1];
    
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH/2, 20)];
    lab_2.text = @"缤纷购物，精彩生活";
    lab_2.font = [UIFont systemFontOfSize:15];
    lab_2.backgroundColor = [UIColor clearColor];
    lab_2.textColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [back addSubview:lab_2];
    
    UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 35, SCREEN_WIDTH/2-30, 25)];
    NSString * str_t = [NSString stringWithFormat:@"￥%@" , entity.card_amount];
    lab_3.text =str_t;
    lab_3.backgroundColor = [UIColor clearColor];
    lab_3.textAlignment = NSTextAlignmentRight;
    lab_3.font = [UIFont systemFontOfSize:20];
    lab_3.textColor = [PublicMethod colorWithHexValue1:@"#FFF6B9"];
    [back addSubview:lab_3];
    
    
    UIImageView * im_B = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view_img_1.frame), SCREEN_WIDTH-20, 30)];
    im_B.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFF6B9"];
    //        im_B.layer.cornerRadius = 8;
    [back addSubview:im_B];
    
    UILabel * lab_E = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view_img_1.frame)+5, SCREEN_WIDTH-40, 14)];
    lab_E.text = @"Enjoy shopping Wonderful life";
    lab_E.font = [UIFont systemFontOfSize:12];
    lab_E.backgroundColor = [UIColor clearColor];
    lab_E.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    [back addSubview:lab_E];
    
    UILabel * lab_T = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_E.frame)-4, SCREEN_WIDTH-40, 10)];
    lab_T.text = entity.validity_date;
    lab_T.font = [UIFont systemFontOfSize:9];
    lab_T.textAlignment = NSTextAlignmentRight;
    lab_T.backgroundColor = [UIColor clearColor];
    lab_T.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
    [back addSubview:lab_T];
    
    UIView * view_S = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20 , 90)];
    view_S.tag = 100;
    view_S.layer.cornerRadius = 8;
    [cell addSubview:view_S];
    
    UIImageView * im_v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    im_v.tag = 101;
    [cell addSubview:im_v];
    [im_v setCenter:view_S.center];
    
    if ([arr_Selected.card_no isEqualToString:entity.card_no])
    {
        view_S.backgroundColor = [UIColor blackColor];
        view_S.alpha = 0.5;
        im_v.image = [UIImage imageNamed:@"agreeArg"];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    arr_Selected = [arr_Data objectAtIndex:indexPath.row];
    [tableView reloadData];
    UIView * view_temp = [self cumView];
     myAlertView = [[YHAlertView alloc] initWithOtherTitle:@"请填写转赠信息" customView:view_temp delegate:self buttonTitles:@[@"取消", @"提交转赠"]];
//    myAlertView.lineIn.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
    [myAlertView setLine];
    [myAlertView show];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    myAlertView.center = CGPointMake(myAlertView.centerX, myAlertView.centerY-70);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   myAlertView.center = CGPointMake(myAlertView.centerX, myAlertView.centerY+70);
}

#pragma mark ----------------------------警告框

-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSString * str = [NSString stringWithFormat:@"%d" , buttonIndex];
    [numField resignFirstResponder];
    if (alertView == myAlertView)
    {
        //    [[iToast makeText:str] show];
        switch (buttonIndex)
        {
            case 0:
                
                break;
            case 1:
            {
                NSString * str_Num;
                if ([numField.text isEqualToString:@""])
                {
//                    [self showAlert:@"您未填写电话号码！"];
                    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话号码填写错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }
                else
                {
                    NSArray * arr = [numField.text componentsSeparatedByString:@" "];
                    str_Num = [arr lastObject];
                    BOOL isYse = [PublicMethod isMobileNumber:str_Num];
                    if (isYse)
                    {
                        NSString * str_0_0 = arr_Selected.card_amount;
                        NSString * str_1 = [NSString stringWithFormat:@"您将转赠￥%@永辉卡给朋友：\n%@ " , str_0_0 , numField.text];
                        NSRange rang_1 = [str_1 rangeOfString:str_0_0];
                        NSRange rang_2 = [str_1 rangeOfString:numField.text];
                        rang_1 = NSMakeRange(rang_1.location-1, rang_1.length+1);
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str_1];
                        UIColor *redC = [PublicMethod colorWithHexValue1:@"#FC5860"];
                        [str addAttribute:NSForegroundColorAttributeName value:redC range:rang_1];
                        [str addAttribute:NSForegroundColorAttributeName value:redC range:rang_2];
                        //                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
                        YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str message:@"请输入支付密码" delegate:self Left:YES button:nil isPaa:YES];
                        elartView.tag = 1;
                        
                        elartView.block = ^(NSString * str)
                        {
                            NSLog(@"%@" , str);
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            [[NetTrans getInstance] API_YH_Card_Examples:self CardNo:arr_Selected.card_no GavingMobile:str_Num Pay_the_password:str block:^(NSString *someThing) {
                                if ([someThing isEqualToString:WEB_STATUS_4])
                                {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                }
                            }];
                            
                        };
                        [elartView show];

                    }
                    else
                    {
                        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话号码填写错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [view show];
                        //                [[iToast makeText:@""] show];
                    }
                }
                
            }
                break;
            default:
                break;
        }

    }
    if (alertView.tag == 3)
    {
        switch (buttonIndex)
        {
            case 1:
            {
//                [[iToast makeText:@"重试"] show];
                NSArray * arr = [numField.text componentsSeparatedByString:@" "];
                NSString * str_Num = [arr lastObject];
                BOOL isYse = [PublicMethod isMobileNumber:str_Num];
                if (isYse)
                {
                    NSString * str_0_0 = arr_Selected.card_amount ;
                    NSString * str_1 = [NSString stringWithFormat:@"您将转赠￥%@永辉卡给朋友：\n%@ " , str_0_0 , numField.text];
                    NSRange rang_1 = [str_1 rangeOfString:str_0_0];
                    NSRange rang_2 = [str_1 rangeOfString:numField.text];
                    rang_1 = NSMakeRange(rang_1.location-1, rang_1.length+1);
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str_1];
                    UIColor *redC = [PublicMethod colorWithHexValue1:@"#FC5860"];
                    [str addAttribute:NSForegroundColorAttributeName value:redC range:rang_1];
                    [str addAttribute:NSForegroundColorAttributeName value:redC range:rang_2];
                    //                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
                    
                    YHAlertView * elartView = [[YHAlertView alloc] initWithTitle:str message:@"请输入支付密码" delegate:self Left:YES button:nil isPaa:YES];
                    elartView.tag = 1;
                    
                    elartView.block = ^(NSString * str)
                    {
                        NSLog(@"%@" , str);
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [[NetTrans getInstance] API_YH_Card_Examples:self CardNo:arr_Selected.card_no GavingMobile:str_Num Pay_the_password:str block:^(NSString *someThing) {
                            if ([someThing isEqualToString:WEB_STATUS_4])
                            {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            }
                        }];
//                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                        [[NetTrans getInstance] API_YH_Card_Examples:self CardNo:entityCard.card_no GavingMobile:str_Num Pay_the_password:str];
                    };
                    [elartView show];
                }
            }
                break;
            case 2:
            {
//                [[iToast makeText:@"忘记密码"] show];
                YHForgetPassViewController * forgetPass = [[YHForgetPassViewController alloc] init];
                isPerSon = NO;
                forgetPass.entityCard = entityCard;
                [self.navigationController pushViewController:forgetPass animated:YES];
            }
                break;
            default:
                break;
        }

        }
}

//-(void)Show
//{
//    NSArray * arr = [numField.text componentsSeparatedByString:@"："];
//   NSString *  str_Num = [arr lastObject];
//
//}
#pragma mark ----------------------------------------------- YHAlertView协议实现
- (void)didPresentYhAlertView:(YHAlertView *)alertView
{
    if (alertView.tag == 1)
    {
        [alertView.textFiled becomeFirstResponder];

            alertView.center = CGPointMake(alertView.centerX, alertView.centerY-80);
    }
}
#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    forWard = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getPerson
{
    [myAlertView dismiss];
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    isPerSon = YES;
    forWard = NO;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}
-(void)cardBuy:(id)sender
{
    YHCardBuyViewController * cardBuy = [[YHCardBuyViewController alloc] init];
    cardBuy.forWard = YES;
    forWard = NO;
    isPerSon = NO;
    [self.navigationController pushViewController:cardBuy animated:YES];
}
#pragma mark ------------------------------------       上拉加载，下啦刷新

#pragma mark ----------YHBaseViewController method

/*加载更多接口请求*/
-(void)getMoreData
{
//    [self removeFooterView];
    pages ++;
    NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_YH_Card_List_Share:self pages:str_num block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
     [self testFinishedLoadData];
}


#pragma mark -------- peoplePickerNavigationController
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //获得选中Vcard相应信息
    /*
     ABMutableMultiValueRef address=ABRecordCopyValue(person, kABPersonAddressProperty);
     ABMutableMultiValueRef birthday=ABRecordCopyValue(person, kABPersonBirthdayProperty);
     ABMutableMultiValueRef creationDate=ABRecordCopyValue(person, kABPersonCreationDateProperty);
     ABMutableMultiValueRef date=ABRecordCopyValue(person, kABPersonDateProperty);
     ABMutableMultiValueRef department=ABRecordCopyValue(person, kABPersonDepartmentProperty);
     ABMutableMultiValueRef email=ABRecordCopyValue(person, kABPersonEmailProperty);
     ABMutableMultiValueRef firstNamePhonetic=ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
     
     ABMutableMultiValueRef instantMessage=ABRecordCopyValue(person, kABPersonInstantMessageProperty);
     ABMutableMultiValueRef jobTitle=ABRecordCopyValue(person, kABPersonJobTitleProperty);
     ABMutableMultiValueRef kind=ABRecordCopyValue(person, kABPersonKindProperty);
     ABMutableMultiValueRef lastNamePhonetic=ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
     ABMutableMultiValueRef middleNamePhonetic=ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
     ABMutableMultiValueRef middleName=ABRecordCopyValue(person, kABPersonMiddleNameProperty);
     ABMutableMultiValueRef modificationDate=ABRecordCopyValue(person, kABPersonModificationDateProperty);
     ABMutableMultiValueRef nickname=ABRecordCopyValue(person, kABPersonNicknameProperty);
     ABMutableMultiValueRef note=ABRecordCopyValue(person, kABPersonNoteProperty);
     ABMutableMultiValueRef organization=ABRecordCopyValue(person, kABPersonOrganizationProperty);
     ABMutableMultiValueRef phone=ABRecordCopyValue(person, kABPersonPhoneProperty);
     ABMutableMultiValueRef prefix=ABRecordCopyValue(person, kABPersonPrefixProperty);
     ABMutableMultiValueRef relatedNames=ABRecordCopyValue(person, kABPersonRelatedNamesProperty);
     ABMutableMultiValueRef socialProfile=ABRecordCopyValue(person, kABPersonSocialProfileProperty);
     ABMutableMultiValueRef personSuffix=ABRecordCopyValue(person, kABPersonSuffixProperty);
     ABMutableMultiValueRef _URL=ABRecordCopyValue(person, kABPersonURLProperty);
     */
    NSString* firstName=(__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString* lastName=(__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
    {
        
        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        
        [phones addObject:aPhone];
        
    }
    NSDictionary*dic=@{@"firstName": firstName,@"lastName":lastName,@"phones":phones};
    dicMy = dic;
    NSLog(@"%@" , dic);
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicke
{
    dicMy = nil;
    [peoplePicke dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person;
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //获得选中Vcard相应信息
    /*
     ABMutableMultiValueRef address=ABRecordCopyValue(person, kABPersonAddressProperty);
     ABMutableMultiValueRef birthday=ABRecordCopyValue(person, kABPersonBirthdayProperty);
     ABMutableMultiValueRef creationDate=ABRecordCopyValue(person, kABPersonCreationDateProperty);
     ABMutableMultiValueRef date=ABRecordCopyValue(person, kABPersonDateProperty);
     ABMutableMultiValueRef department=ABRecordCopyValue(person, kABPersonDepartmentProperty);
     ABMutableMultiValueRef email=ABRecordCopyValue(person, kABPersonEmailProperty);
     ABMutableMultiValueRef firstNamePhonetic=ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
     
     ABMutableMultiValueRef instantMessage=ABRecordCopyValue(person, kABPersonInstantMessageProperty);
     ABMutableMultiValueRef jobTitle=ABRecordCopyValue(person, kABPersonJobTitleProperty);
     ABMutableMultiValueRef kind=ABRecordCopyValue(person, kABPersonKindProperty);
     ABMutableMultiValueRef lastNamePhonetic=ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
     ABMutableMultiValueRef middleNamePhonetic=ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
     ABMutableMultiValueRef middleName=ABRecordCopyValue(person, kABPersonMiddleNameProperty);
     ABMutableMultiValueRef modificationDate=ABRecordCopyValue(person, kABPersonModificationDateProperty);
     ABMutableMultiValueRef nickname=ABRecordCopyValue(person, kABPersonNicknameProperty);
     ABMutableMultiValueRef note=ABRecordCopyValue(person, kABPersonNoteProperty);
     ABMutableMultiValueRef organization=ABRecordCopyValue(person, kABPersonOrganizationProperty);
     ABMutableMultiValueRef phone=ABRecordCopyValue(person, kABPersonPhoneProperty);
     ABMutableMultiValueRef prefix=ABRecordCopyValue(person, kABPersonPrefixProperty);
     ABMutableMultiValueRef relatedNames=ABRecordCopyValue(person, kABPersonRelatedNamesProperty);
     ABMutableMultiValueRef socialProfile=ABRecordCopyValue(person, kABPersonSocialProfileProperty);
     ABMutableMultiValueRef personSuffix=ABRecordCopyValue(person, kABPersonSuffixProperty);
     ABMutableMultiValueRef _URL=ABRecordCopyValue(person, kABPersonURLProperty);
     */
    NSString* firstName=(__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString* lastName=(__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
    {
        
        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        
        [phones addObject:aPhone];
        
    }
    NSDictionary*dic=@{@"firstName": firstName,@"lastName":lastName,@"phones":phones};
    dicMy = dic;
    NSLog(@"%@" , dic);
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------------------- ---------------------- 网络请求回掉

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_SHARE == nTag)
    {
        arr_Add = (NSMutableArray *)netTransObj;
        if (pages > 1)
        {
            if ([arr_Add count] == 0)
            {
                [[iToast makeText:@"已加载全部数据"] show];
                pages--;
            }
            else
            {
                [arr_Data addObjectsFromArray:arr_Add];
                
            }
        }
        if (pages == 1)
        {
            [arr_Data removeAllObjects];
            [arr_Data addObjectsFromArray:arr_Add];
            [self addUI];
        }
        [self upNaT];
     [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];

        [myTableView reloadData];
    }
    else if (t_API_YH_CARD_EXAMPLES == nTag)
    {
        NSString * str = (NSString *)netTransObj;
        pages = 1;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [arr_Data removeAllObjects];
        [self getData];
        [[iToast makeText:str] show];
    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_SHARE == nTag)
    {
        if (pages>1)
        {
            pages--;
        }
        else if(pages == 1)
        {
            [self addUI];
            [self upNaT];
        }
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
    else if (t_API_YH_CARD_EXAMPLES == nTag)
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
        else if([status isEqualToString:@"4"])
        {
            YHAlertView * other  = [[YHAlertView alloc] initWithTitle:nil message:errMsg delegate:self Left:NO button:@[@"重试" , @"忘记密码"] isPaa:NO];
            other.tag = 3;
            [other show];
        }
        else
        {
             [[iToast makeText:errMsg] show];
//            YHAlertView * other  = [[YHAlertView alloc] initWithTitle:nil message:errMsg delegate:self Left:NO button:@[@"重试" , @"忘记密码"] isPaa:NO];
//            other.tag = 3;
//            [other show];
            
        }
    }
}
-(void)setFooterView
{
//    UIEdgeInsets test = self._tableView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(myTableView.contentSize.height, myTableView.frame.size.height);
    NSLog(@"self._tableView.contentSize.height = %f" ,myTableView.contentSize.height );
    NSLog(@"self._tableView.frame.size.height = %f" , myTableView.frame.size.height);
    NSLog(@"height = %f" , height);
//    height = self._tableView.contentSize.height;
    if (refreshFooterOtherView && [refreshFooterOtherView superview]) {
        // reset position
        refreshFooterOtherView.frame = CGRectMake(0.0f,
                                              height,
                                              myTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        refreshFooterOtherView = [[EGORefreshTableFooterOtherView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         myTableView.frame.size.width, self.view.bounds.size.height)];
        refreshFooterOtherView.delegate = self;
        [myTableView addSubview:refreshFooterOtherView];
    }
    
    if (refreshFooterOtherView) {
        [refreshFooterOtherView refreshLastOtherUpdatedDate];
    }
    NSString * str_num = [(YHCardVice *)[arr_Data lastObject] total];;
    if ([str_num intValue] == [arr_Data count])
    {
        if (refreshFooterOtherView)
        {
            [refreshFooterOtherView removeFromSuperview];
            [[refreshFooterOtherView superview] removeFromSuperview];
            refreshFooterOtherView = nil;
        }
    }
}
#pragma mark ------------------------------- 上拉加载
-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

- (void)finishReloadingData
{
    _reloadingOther = NO;
    if (refreshFooterOtherView)
    {
        [refreshFooterOtherView egoRefreshOtherScrollViewDataSourceDidFinishedLoading:myTableView];
//        [refreshFooterOtherView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (refreshFooterOtherView) {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidScroll:myTableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (refreshFooterOtherView) {
        if (scrollView.contentOffset.y > 0)
        {
            [refreshFooterOtherView egoRefreshOtherScrollViewDidEndDragging:myTableView];
        }
//        [refreshFooterOtherView egoRefreshOtherScrollViewDidEndDragging:myTableView];
    }
}

#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerOtherRefresh:(EGORefreshPos)aRefreshPos{
    
    [self beginToReloadData:aRefreshPos];
    
}
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloadingOther = YES;
 if(aRefreshPos == EGORefreshOtherFooter){
        // pull up to load more data
        [self performSelector:@selector(getMoreData) withObject:nil afterDelay:1];
    }
    // overide, the actual loading data operation is done in the subclass
}

- (BOOL)egoRefreshTableDataSourceIsOtherLoading:(UIView *)view{
    
    return _reloadingOther; // should return if data source model is reloading
    
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastOtherUpdated:(UIView *)view{
    
    return [NSDate date]; // should return date data source was last changed
    
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
