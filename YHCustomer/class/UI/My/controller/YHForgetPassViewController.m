//
//  YHForgetPassViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/12/5.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHForgetPassViewController.h"

@interface YHForgetPassViewController ()

@end

@implementation YHForgetPassViewController
@synthesize entityCard;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    self.navigationItem.title = @"忘记密码";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (entityCard)
    {
        [self addUI];
    }
    else
    {
        //               积分卡绑定页面
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] API_YH_Card_ISOpen:self block:^(NSString *someThing) {
            if ([someThing isEqualToString:@"-1"])
            {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//     [[NetTrans getInstance] cancelRequestByUI:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -------------------------------- addUI
-(void)addUI
{
//    UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, , SCREEN_WIDTH-20, 40)];
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 10)];
    backView.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    [self.view addSubview:backView];
    
    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 20)];
    messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
      [self.view addSubview:messageLabel];
    //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
    messageLabel.backgroundColor = [UIColor clearColor];
    NSString * str_mess = [NSString stringWithFormat:@"您的邮箱：%@" , [entityCard email]];
    messageLabel.text = str_mess;
    messageLabel.font = [UIFont systemFontOfSize:17];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 0;
    CGSize size ;
    if (IOS_VERSION >=7)
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
        
        CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
        size = rect.size;
    }else{
        size = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    }
    messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, size.height);
  
    
    UILabel * messageLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(messageLabel.frame)+10, SCREEN_WIDTH-20, 20)];
    messageLabel_1.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
    messageLabel_1.backgroundColor = [UIColor clearColor];
    messageLabel_1.text = @"找回密码信息会以邮件形式发至您的邮箱，请按邮件提示操作找回密码。";
    messageLabel_1.font = [UIFont systemFontOfSize:12];
    messageLabel_1.textAlignment = NSTextAlignmentLeft;
    messageLabel_1.numberOfLines = 0;
    messageLabel_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
    CGSize size1 ;
    if (IOS_VERSION >=7) {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
        
        CGRect rect = [messageLabel_1.text boundingRectWithSize:CGSizeMake(messageLabel_1.frame.size.width, 99999) options:option attributes:attributes context:nil];
        size1 = rect.size;
    }else{
        size1 = [messageLabel_1.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel_1.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    }
    messageLabel_1.frame = CGRectMake(messageLabel_1.frame.origin.x, messageLabel_1.frame.origin.y, messageLabel_1.frame.size.width, size1.height);
    [self.view addSubview:messageLabel_1];
    [backView setFrame:CGRectMake(0, 10, SCREEN_WIDTH, CGRectGetMaxY(messageLabel_1.frame)-10)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(messageLabel_1.frame)+20, SCREEN_WIDTH-20, 40)];
    [btn setTitle:@"点击找回密码" forState:UIControlStateNormal];
    [btn setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
//    btn.layer.borderColor = [PublicMethod colorWithHexValue1:@"#cccccc"].CGColor;
//    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(fildPass:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fildPass:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_YH_Card_Forgot_Password:self block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}


#pragma mark ------------------- ---------------------- 网络请求回掉
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_YH_CARD_FORGOT_PASSWORD == nTag)
    {
        [[iToast makeText:@"邮件已成功发送！"] show];
    }
    else  if (t_API_YH_CARD_ISOPEN == nTag)
    {
        entityCard = (YHCardBag *)netTransObj;
        [self addUI];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_YH_CARD_FORGOT_PASSWORD == nTag)
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
    else if (t_API_YH_CARD_ISOPEN == nTag)
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
            [self.navigationController popViewControllerAnimated:YES];
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
