//
//  YHNewEmailFindPwdViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHNewEmailFindPwdViewController.h"
#import "YHLoginViewController.h"
@interface YHNewEmailFindPwdViewController ()

@end

@implementation YHNewEmailFindPwdViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE116];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE116];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [PublicMethod addNavBackground:self.view title:@"邮箱找回密码"];
    [PublicMethod addBackViewWithTarget:self action:@selector(back:)];
//    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    [self createUI];

}
-(void)createUI
{
    
//    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 10)];
//    backView.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
//    [self.view addSubview:backView];

    UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, originY+44+20, SCREEN_WIDTH-20, 20)];
    messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    [self.view addSubview:messageLabel];
    //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
    messageLabel.backgroundColor = [UIColor clearColor];
    NSString *emailStr = [NSString stringWithFormat:@"%@",self.email];
    NSString * str_mess = [NSString stringWithFormat:@"您的邮箱：%@",emailStr];
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
    
    
    UILabel * messageLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(messageLabel.frame), SCREEN_WIDTH-20, 20)];
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
    
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(messageLabel_1.frame)+20, SCREEN_WIDTH-20, 40)];
    [btn setTitle:@"点击找回密码" forState:UIControlStateNormal];
    [btn setTitleColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
-(void)btnClick:(id)sender
{
    //发送邮件
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[NetTrans getInstance]user_forget_modify_password:self mobile:nil type:self.type user_name:self.user_name captcha:nil new_password:nil confirm_password:nil];
    
    


}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //发送邮件
    if (t_API_USER_LOGIN_FORGET_MODIFY_PASSWORD == nTag)
    {
        //跳转到登录接界面
       // NSString *successStr = (NSString *)netTransObj;
        [self showAlert:@"邮件发送成功!"];
        //[[iToast makeText:successStr]show];
        YHLoginViewController *loginViewCtrl = [[YHLoginViewController alloc]init];
        loginViewCtrl.loginBackBlock = ^{
            
        };
        
        loginViewCtrl.loginSuccessBlock = ^(UserAccount *account){
            [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:NO                           completion:^{
                
            }];
        };
        [self presentModalViewController:loginViewCtrl animated:YES];
        
    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[iToast makeText:errMsg]show];
}
-(void)back:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
