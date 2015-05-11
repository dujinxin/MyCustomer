//
//  YHCardOpenViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/12/1.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#define FONE  ([UIFont systemFontOfSize:15])
#define COLO ([PublicMethod colorWithHexValue1:@"#666666"])

#import "YHCardOpenViewController.h"
#import "YHTipUpViewController.h"
#import "YHCardBuyViewController.h"
#import "YHShareFriendsViewController.h"
#import "YHMarketViewController.h"
#import "YHMyYh_CardViewController.h"
#import "YHHelpUserWalletViewController.h"
#import "YHChangePassViewController.h"
#import "YHForgetPassViewController.h"
#import "YHTransactionRecordsViewController.h"
#import "YHCardBag.h"
@interface YHCardOpenViewController ()
{
    NSArray * dataArr;
    NSInteger NUM;
    YHCardBag * entity;
    
    //注册需要
    UIScrollView * myScrollView;
    UITextField * myText_1;
    UITextField * myText_2;
    UITextField * myText_3;
    UITextField * myText_4;
    UIButton * myBut_1;
    int numTitle;
    NSTimer *time;
    BOOL isSucee;
    UIWebView * myWebView;
    UIButton * myBut_2;
}
@end

@implementation YHCardOpenViewController
{
    UITableView * myTableView;
}

@synthesize entityCard;
@synthesize forWard;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray * arr_temp_1 = @[@"我的账户" , @"查看您的账户详细信息"];
    NSArray * arr_temp_2 = @[@"转赠信息" , @"查看您的转赠好友记录"];
    NSArray * arr_temp_3 = @[@"修改密码" , @"修改您的钱包支付密码"];
    NSArray * arr_temp_4 = @[@"忘记密码" , @"忘记钱包支付密码时使用"];
    NSArray * arr_temp_5 = @[@"使用帮助" , @"查看如何使用永辉卡"];
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@""];
    dataArr = @[arr_temp_1 , arr_temp_2 , arr_temp_3 , arr_temp_4 , arr_temp_5];
    self.navigationItem.title = @"永辉钱包";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE101];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (forWard)
    {
//        [self presentViewController:self animated:YES completion:<#^(void)completion#>];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_ISOpen:self block:^(NSString *someThing) {
            if ([someThing isEqualToString:@"-1"])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
//        [NetTrans getInstance].netWorkBlock = ^(NSString * str)
//        {
//            if ([str isEqualToString:@"-1"])
//            {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            }
//        };
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE101];
    [time invalidate];
//    [[NetTrans getInstance] cancelRequestByUI:self];
    forWard = NO;
}

#pragma mark --------------------     UITableView delegate and dataS
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view_Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    view_Header.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    NSArray * arr = @[@"账户充值" , @"购买永辉卡" , @"转赠好友" , @"门店支付"];
    NSArray * arr_ims = @[@"icon_永辉钱包_钱包充值.png" , @"icon_永辉钱包_购买永辉卡.png", @"icon_永辉钱包_永辉卡转赠.png" , @"icon_永辉钱包_超市支付.png"];
    CGFloat a_w = SCREEN_WIDTH/4-3/4;
    CGFloat sp = (a_w-30)/2;
    for (int i = 0 ; i < 4; i++)
    {
        NSString * name_btn = [arr objectAtIndex:i];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(i*a_w+sp, 5, 30, 30)];
//        [btn setBackgroundColor:[UIColor blueColor]];
        NSString* ima_str = [arr_ims objectAtIndex:i];
        img.image = [UIImage imageNamed:ima_str];
        [view_Header addSubview:img];
//        [btn setBackgroundImage: forState:UIControlStateNormal];
//        btn.titleLabel.text = name_btn;
//          [btn setBackgroundImage:[UIImage imageNamed:@"ios-标题栏按钮正常.png"] forState:UIControlStateHighlighted];
//        [btn setTitle:name_btn forState:UIControlStateNormal];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(60, -20, 0, -20)];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*a_w + (i-1)*1, 0, a_w, 64)];
        btn.tag = 1000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        btn.titleLabel.textColor = [UIColor blackColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view_Header addSubview:btn];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(i*a_w, 40, a_w, 14)];
        lab.text = name_btn;
        lab.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
        lab.textAlignment =NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        [view_Header addSubview:lab];
        
        UIImageView * im_im = [[UIImageView alloc] initWithFrame:CGRectMake(i*a_w, 0, 1, 64)];
        im_im.backgroundColor =[PublicMethod colorWithHexValue1:@"#EEEEEE"];
        [view_Header addSubview:im_im];
    }
    
    UIImageView * ima = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 10)];
    ima.backgroundColor =[PublicMethod colorWithHexValue1:@"#EEEEEE"];
    [view_Header addSubview:ima];
    return view_Header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 74.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellStr = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellStr];
    }
    cell.alpha = 1;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
    view.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [cell addSubview:view];
    NSArray * arr = [dataArr objectAtIndex:indexPath.row];
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-30, 20)];
    lab_1.text = [arr objectAtIndex:0];
    lab_1.font = [UIFont systemFontOfSize:15];
    [cell addSubview:lab_1];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-30, 15)];
    lab_2.text = [arr objectAtIndex:1];
    lab_2.font = [UIFont systemFontOfSize:12];
    lab_2.textColor = [PublicMethod colorWithHexValue1:@"#666666"];
    [cell addSubview:lab_2];
    
    UIImageView * ima = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    ima.backgroundColor =[PublicMethod colorWithHexValue1:@"#CDCDCD"];
    [cell addSubview:ima];
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
     cell.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            YHMyYh_CardViewController * yhCard = [[YHMyYh_CardViewController alloc] init];
            yhCard.Forward = YES;
            [self.navigationController pushViewController:yhCard animated:YES];
        }
            break;
        case 1:
        {
            YHTransactionRecordsViewController * extfInfo = [[YHTransactionRecordsViewController alloc] init];
            extfInfo.forWard = YES;
            [self.navigationController pushViewController:extfInfo animated:YES];
        }
            break;
        case 2:
        {
            YHChangePassViewController * changePass = [[YHChangePassViewController alloc] init];
            [self.navigationController pushViewController:changePass animated:YES];
        }
            break;
        case 3:
        {
            YHForgetPassViewController * forgetPass = [[YHForgetPassViewController alloc] init];
            forgetPass.entityCard = entityCard;
            [self.navigationController pushViewController:forgetPass animated:YES];
        }
            break;
        case 4:
        {
            YHHelpUserWalletViewController * helpUser = [[YHHelpUserWalletViewController alloc] init];
            [self.navigationController pushViewController:helpUser animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark --------------------------------- addUI

-(void)addUI
{
    myTableView = [[UITableView alloc] init];
    myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, TURE_VIEW_HIGTH);
    myTableView.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    //    self._tableView.rowHeight = 80;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled = NO;
    
    [self.view addSubview:myTableView];
//    [self addRefreshTableFooterView];
}

#pragma mark          -----------------------------      按钮事件
-(void)btnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    NUM = btn.tag;
    switch (btn.tag)
    {
        case 1000:
        {
            YHTipUpViewController * tipUp = [[YHTipUpViewController alloc] init];
            tipUp.entityBag = entityCard;
            tipUp.forWard = YES;
            [self.navigationController pushViewController:tipUp animated:YES];
        }
            break;
        case 1001:
        {
            YHCardBuyViewController * cardBuy = [[YHCardBuyViewController alloc] init];
            cardBuy.forWard = YES;
            cardBuy.entityCard = entityCard;
            [self.navigationController pushViewController:cardBuy animated:YES];
        }
            break;
        case 1002:
        {
            YHShareFriendsViewController * shareFriends = [[YHShareFriendsViewController alloc] init];
            shareFriends.forWard = YES;
            shareFriends.entityCard = entityCard;
            [self.navigationController pushViewController:shareFriends animated:YES];
        }
            break;
        case 1003:
        {
            YHMarketViewController * marketView = [[YHMarketViewController alloc] init];
            marketView.forWard = YES;
            marketView.entityCard = entityCard;
            [self.navigationController pushViewController:marketView animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------------------------------------------------/去掉headView的黏性

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 95;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}



#pragma mark ------------------------------------------注册界面
#pragma mark --------------------------------- addUIResgister

-(void)addUIResgister
{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TURE_VIEW_HIGTH)];
    myScrollView.showsVerticalScrollIndicator = NO;
    [myScrollView setBackgroundColor:[PublicMethod colorWithHexValue1:@"@EEEEEE"]];
    [self.view addSubview:myScrollView];
    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    lab_1.textColor =[PublicMethod colorWithHexValue1:@"#000000"];
    lab_1.text = @"  欢迎使用永辉钱包服务，请设置开通信息，谢谢";
    lab_1.font = [UIFont systemFontOfSize:13];
    lab_1.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [myScrollView addSubview:lab_1];
    
    UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_1.frame) + 10 , SCREEN_WIDTH-20, 40)];
    lab_2.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    lab_2.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    lab_2.layer.borderWidth = 0.5;
    //    lab_2.font = FONE;
    [myScrollView addSubview:lab_2];
    
    myText_1 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab_1.frame) + 20, SCREEN_WIDTH-40, 20)];
    myText_1.delegate = self;
    myText_1.font = FONE;
    myText_1.text = @"";
    myText_1.secureTextEntry = YES;
    myText_1.keyboardType = UIKeyboardTypeNumberPad;
    myText_1.placeholder = @"请您输入6位数密码";
    [myScrollView addSubview:myText_1];
    
    UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_2.frame) + 10 , SCREEN_WIDTH-20, 40)];
    lab_3.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    lab_3.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    lab_3.layer.borderWidth = 0.5;
    [myScrollView addSubview:lab_3];
    
    myText_2 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab_2.frame) + 20, SCREEN_WIDTH-40, 20)];
    myText_2.delegate = self;
    myText_2.font = FONE;
    myText_2.text = @"";
    myText_2.secureTextEntry = YES;
    myText_2.keyboardType = UIKeyboardTypeNumberPad;
    myText_2.placeholder = @"重复输入6位数密码";
    [myScrollView addSubview:myText_2];
    
    UIImageView * ima_1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_3.frame) + 10, SCREEN_WIDTH-20, 1)];
    [self addImage_DottedLine:ima_1];
    //    [myScrollView addSubview:ima_1];
    
    UILabel * lab_4 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_3.frame) + 10 , SCREEN_WIDTH-20, 40)];
    lab_4.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    lab_4.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    lab_4.layer.borderWidth = 0.5;
    [myScrollView addSubview:lab_4];
    
    myText_3 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab_3.frame) + 20, SCREEN_WIDTH-40, 20)];
    myText_3.delegate = self;
    myText_3.font = FONE;
    myText_3.text = @"";
    //    myText_3.keyboardType = UIKeyboardTypeNumberPad;
    myText_3.placeholder = @"请设置常用邮箱（用于忘记密码）";
    [myScrollView addSubview:myText_3];
    
    UIImageView * ima_2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_4.frame) + 10, SCREEN_WIDTH-20, 1)];
    [self addImage_DottedLine:ima_2];
    //    [myScrollView addSubview:ima_2];
    
    UIImageView * my_img_3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab_4.frame)+10, [UIScreen mainScreen].bounds.size.width-151, 40)];
    my_img_3.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    my_img_3.layer.borderWidth = 1;
    my_img_3.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    [myScrollView addSubview:my_img_3];
    
    myText_4 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lab_4.frame)+20, [UIScreen mainScreen].bounds.size.width-170, 20)];
    myText_4.placeholder = @"请输入验证码";
    myText_4.delegate = self;
    myText_4.autoresizesSubviews = YES;
    myText_4.text = @"";
    myText_4.keyboardType = UIKeyboardTypeNumberPad;
    myText_4.textAlignment = NSTextAlignmentLeft;
    myText_4.font = FONE;
    [myScrollView addSubview:myText_4];
    
    myBut_1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(my_img_3.frame)+5, CGRectGetMaxY(lab_4.frame)+10, 126, 40)];
    [myBut_1 setTitle:@"获取验证码" forState:UIControlStateNormal];
    myBut_1.titleLabel.font = FONE;
    [myBut_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [myBut_1 addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:myBut_1];
    
    myBut_2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(myBut_1.frame)+10, SCREEN_WIDTH-20, 40)];
    [myBut_2 setTitle:@"提交并开通服务" forState:UIControlStateNormal];
    myBut_2.titleLabel.font = [UIFont systemFontOfSize:18];
    [myBut_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [myBut_2 addTarget:self action:@selector(openYHCard) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:myBut_2];
    [self registerKeyBord];
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myBut_2.frame)+10, SCREEN_WIDTH , TURE_VIEW_HIGTH - (CGRectGetMaxY(myBut_2.frame)+10))];
    //    NSURL * url = [[NSURL alloc] initWithString:@"http://www.baidu.com"];
    myWebView.scalesPageToFit = YES;
    myWebView.delegate = self;
    NSString * str_44 = [NSString stringWithFormat:@"%@%@" , BASE_URL , API_YHCARD_NET];
    //    myWebView.delegate = self;
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:str_44]];
    [myWebView loadRequest:req];
    [myScrollView addSubview:myWebView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat heigt = webView.scrollView.contentSize.height;
    NSLog(@"%f" , heigt);
    [myWebView setFrame:CGRectMake(0, CGRectGetMaxY(myBut_2.frame)+10, SCREEN_WIDTH , heigt)];
    [myScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(myWebView.frame)+10)];
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


#pragma mark -------------------------------------  验证码按钮60秒倒计时
-(void)VerificationCode:(id)sender
{
    NSString * str_num;
    isSucee  = YES;
    str_num = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    NSLog(@"str_num = %@",str_num);
    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"activation"];
    //    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"register"];
    //    [NSThread detachNewThreadSelector:@selector(sixTy) toTarget:self withObject:nil];
    [self sixTy];
}

-(void)sixTy
{
    numTitle = 60;
    time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnTitle:) userInfo:nil repeats:YES];
    [time fire];
}
-(void)btnTitle:(id)sender
{
    if (isSucee == NO)
    {
        [time invalidate];
        return;
    }
    if (numTitle == 0)
    {
        [time invalidate];
        [myBut_1 setTitle:@"获取验证码" forState:UIControlStateNormal];
        [myBut_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [myBut_1 setEnabled:YES];
    }
    else
    {
        [myBut_1 setEnabled:NO];
        [myBut_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
        NSString * str_num = [NSString stringWithFormat:@"重新获取(%d)" , numTitle];
        NSLog(@"%@" , str_num);
        [myBut_1 setTitle:str_num forState:UIControlStateNormal];
        myBut_1.titleLabel.text = str_num;
        //        NSLog(@"%@" , btn_1.titleLabel.text);
        numTitle--;
        //        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    }
}
#pragma mark ---------------------------------     开通永辉卡钱包

-(void)openYHCard
{
    if ([self validateTure])
    {
        if ([myText_4.text isEqualToString:@""])
        {
            [self showAlert:@"验证码未填写"];
        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NetTrans getInstance] API_YH_Card_Activation:self Pwd:myText_1.text PwdAgain:myText_2.text email:myText_3.text Captcha:myText_4.text block:^(NSString *someThing) {
                if ([someThing isEqualToString:WEB_STATUS_4])
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            }];
            
        }
    }
}
#define mark -------------------------------------------- UITextFiledDelegate

-(void)registerKeyBord
{
    NSArray * tempArray = [[NSArray alloc] initWithObjects:myText_1,myText_2,myText_3, myText_4,nil];
    keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];
    
    if (textField == myText_2) {
        [myScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(myText_1.frame)) animated:YES];
    } else if (textField == myText_3) {
        [myScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(myText_2.frame)+10) animated:YES];
    } else if (textField == myText_4) {
        [myScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(myText_3.frame)+10) animated:YES];
    }
    else if (textField == myText_1)
    {
        [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == myText_1 || textField == myText_2)
    {
        NSString * strValue = [textField.text stringByAppendingString:string];
        if ([strValue floatValue] > 999999)
        {
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            [self showAlert:@"亲，密码为6位数字哦！"];
            return NO;
        }
    }
    return YES;
}
-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField
{
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myText_1 resignFirstResponder];
    [myText_2 resignFirstResponder];
    [myText_3 resignFirstResponder];
    [myText_4 resignFirstResponder];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark --------------------------------- 检验密码书写是否正确
-(BOOL)validateTure
{
    if ([myText_1.text isEqualToString:@""]||[myText_2.text isEqualToString:@""]||[myText_3.text isEqualToString:@""])
    {
        [self showAlert:@"您有未填项，请完善信息！"];
        return NO;
    }
    else
    {
        if ([myText_1.text length] < 6)
        {
            [self showAlert:@"密码必须为6位有效数字"];
            return NO;
        }
        else
        {
            if (![myText_1.text isEqualToString:myText_2.text])
            {
                [self showAlert:@"两次填写密码不相同"];
                return NO;
            }
            else
            {
                if ([myText_3.text isEqualToString:@""])
                {
                    [self showAlert:@"邮箱信息未填写"];
                    return NO;
                }
                else if (![PublicMethod validateEmail:myText_3.text])
                {
                    [self showAlert:@"邮箱格式错误"];
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark ----------------------------------------    网络请求回掉
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_ISOPEN == nTag)
        {
            entity = (YHCardBag *)netTransObj;
            if ([entity.type isEqualToString:@"0"])
            {
                [self addUI];
            }
            else if ([entity.type isEqualToString:@"1"])
            {
                [self addUIResgister];
            }
        }
    else if(t_API_YH_CARD_REGISTER == nTag)
    {
        entity = (YHCardBag *)netTransObj;
        NSArray * arr = [self.view subviews];
        for (UIView * subView in arr)
        {
            [subView removeFromSuperview];
        }
        [self addUI];
    }
    else if (t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        //[[iToast makeText:@"短信发送成功！"] show];
        // NSString *successStr = (NSString *)netTransObj;
        //[self showAlert:successStr];
        NSString *successStr = (NSString *)netTransObj;
        [self showAlert:successStr];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([status isEqualToString:WEB_STATUS_3])
    {
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
    }
    if (t_API_YH_CARD_ISOPEN == nTag)
    {
      if([status isEqualToString:WEB_STATUS_0])
        {
            [[iToast makeText:errMsg] show];
        }
    }
    else if (t_API_YH_CARD_REGISTER)
    {
        if ([status isEqualToString:WEB_STATUS_0])
        {
              [[iToast makeText:errMsg] show];
        }
    }
    else if (t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        [[iToast makeText:errMsg] show];
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
