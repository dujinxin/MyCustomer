//
//  YHNewForgetPwdViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHNewForgetPwdViewController.h"
#import "YHNewSetPwdViewController.h"
#import "YHNewEmailFindPwdViewController.h"
#import "YHBindStoreCardViewController.h"
#import "ForgetPasswordEntity.h"
@interface YHNewForgetPwdViewController ()
{
    UIButton *submitBtn;

}
@end

@implementation YHNewForgetPwdViewController
@synthesize _userName;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.view.backgroundColor = [UIColor clearColor];
//        // 背景颜色
//        UIView *bgView = [PublicMethod addBackView:CGRectMake(0, originY, 320, self.view.frame.size.height) setBackColor:[UIColor whiteColor]];
//        [self.view addSubview:bgView];
//        
//    }
//    return self;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE114];
    
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
    [MTA trackPageViewEnd:PAGE114];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNav];
    [self createInfoView];
    
}
-(void)createNav
{
    [PublicMethod addNavBackground:self.view title:@"忘记密码"];
    [PublicMethod addBackViewWithTarget:self action:@selector(back:)];
    
}
-(void)createInfoView
{
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(20, 70+originY, 280, 40)];
    _userName.delegate = self;
    _userName.background = [UIImage imageNamed:@"passwordBg.png"];
    _userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userName.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    _userName.leftView = leftView;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    _userName.placeholder = @"手机号/邮箱";
    _userName.borderStyle = UITextBorderStyleLine;
    _userName.layer.borderWidth = 1.0f;
    _userName.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    _userName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _userName.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_userName];
    
    
    submitBtn = [PublicMethod addButton:CGRectMake(20, _userName.bottom+20, 280, 40) title:@"确定" backGround:nil setTag:1000 setId:self selector:@selector(submitBtnClicked:) setFont:[UIFont systemFontOfSize:18] setTextColor:[PublicMethod colorWithHexValue:0xFF986D alpha:1.0f]];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
//    [submitBtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]] forState:UIControlStateNormal];
    //submitBtn.highlighted = YES;
    [self.view addSubview:submitBtn];


}
- (void)submitBtnClicked:(id)sender
{
//    YHNewSetPwdViewController *spv = [[YHNewSetPwdViewController alloc]init];
//    [self presentModalViewController:spv animated:YES];
    if (![self isValid]) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance]user_forget_password:self user_name:_userName.text];
    
}
- (BOOL)isPureNumandCharacters:(NSString *)text
{
    for(int i = 0; i < [text length]; ++i) {
        char a = [text characterAtIndex:i];
        if (a>='0'&&a<='9'){
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}
-(BOOL)isValid
{
    
   
    if([_userName.text length] == 0)
    {
        [[iToast makeText:@"用户名不能为空，请重新输入"] show];
        return NO;
    }
    
    //判断用户名是否全为数字
    if ([self isPureNumandCharacters:_userName.text])
    {
        if (![PublicMethod isMobileNumber:_userName.text])
        {
            [[iToast makeText:@"手机号码错误"] show];
            return NO;
        }
    }
    else
    {
        if(![PublicMethod validateEmail:_userName.text])
        {
            [[iToast makeText:@"邮箱格式错误"] show];
            return NO;
        }
        
    }
    
    
    return YES;

}
//返回
-(void)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];

}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //1代表用户名为手机，2代表用户名为邮箱
    if (t_API_USER_LOGIN_FORGET_PASSWORD == nTag) {
        
        ForgetPasswordEntity *entity = (ForgetPasswordEntity *)netTransObj;
        
        
        NSString *str = [NSString stringWithFormat:@"%@",entity.type];
        //1为手机号修改  2为邮箱修改
        if ([str isEqualToString:@"1"])
        {
            YHNewSetPwdViewController *spv = [[YHNewSetPwdViewController alloc]init];
            spv.loginSuccessBlock = _loginSuccessBlock;
            spv.user_name = _userName.text;
            spv.type = entity.type;
            spv.mobile = entity.mobile;
            NSLog(@"%@",entity.mobile);
            [self presentModalViewController:spv animated:YES];
        }
        else if([str isEqualToString:@"2"])
        {
            YHNewEmailFindPwdViewController *epv = [[YHNewEmailFindPwdViewController alloc]init];
            epv.loginSuccessBlock = _loginSuccessBlock;
            epv.user_name = _userName.text;
            epv.type = entity.type;
            epv.email = entity.email;
            [self presentModalViewController:epv animated:YES];
            
        }
    }
   
   
}
#pragma mark --------------------------UITextFieldDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userName resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[iToast makeText:errMsg]show];
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
