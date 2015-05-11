//
//  YHForgetPwdViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-12.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  忘记密码界面

#import "YHForgetPwdViewController.h"
#import "YHResetPwdViewController.h"

@interface YHForgetPwdViewController ()

@end

@implementation YHForgetPwdViewController
@synthesize mobileField,verField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        // 背景颜色
        UIView *bgView = [PublicMethod addBackView:CGRectMake(0, originY, 320, self.view.frame.size.height) setBackColor:[UIColor whiteColor]];
        [self.view addSubview:bgView];
        [self addNavView];
        [self addInfoView];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark ------------- add UI
-(void)addNavView {
    [PublicMethod addNavBackground:self.view title:@"忘记密码"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(7, originY + 7, 30, 30);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_Select"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[PublicMethod colorWithHexValue:0xFF986D alpha:1.0f] forState:UIControlStateSelected];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addInfoView {
    UITextField *numberField = [[UITextField alloc] initWithFrame:CGRectMake(20, 70+originY, 280, 40)];
    numberField.delegate = self;
    numberField.background = [UIImage imageNamed:@"passwordBg.png"];
    numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberField.textAlignment = NSTextAlignmentCenter;
    numberField.placeholder = @"请输入手机号码";
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField = numberField;
    [self.view addSubview:numberField];
    
    // 获取验证码@"login.png"
    UIButton *verCodeBtn = [PublicMethod addButton:CGRectMake(20, numberField.bottom+15, 140, 40) title:nil backGround:nil setTag:100 setId:self selector:@selector(getVerCodeBtnClicked:) setFont:nil setTextColor:nil];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
//    [verCodeBtn setBackgroundImage:[UIImage imageNamed:@"vercode_btn"] forState:UIControlStateNormal];
//    [verCodeBtn setBackgroundImage:[UIImage imageNamed:@"vercode_btn_selected"] forState:UIControlStateHighlighted];
    verCodeBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:verCodeBtn];
    //CGRectMake(20, numberField.bottom+15, 140, 40)
    UITextField *verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(170, numberField.bottom+15, 130, 40)];
    verCodeField.delegate = self;
    //verCodeField.borderStyle = UITextBorderStyleRoundedRect;
    verCodeField.background = [UIImage imageNamed:@"verCodebg.png"];
    verField = verCodeField;
    [self.view addSubview:verCodeField];
    verCodeField.placeholder = @"请输入验证码";
    verCodeField.keyboardType = UIKeyboardTypeNumberPad;
    verCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    verCodeField.textAlignment = NSTextAlignmentCenter;
    verCodeField.font = [UIFont systemFontOfSize:16];
    // 提交
    UIButton *submitBtn = [PublicMethod addButton:CGRectMake(20, verCodeField.bottom+20, 280, 40) title:@"提  交" backGround:nil setTag:1000 setId:self selector:@selector(submitBtnClicked:) setFont:[UIFont systemFontOfSize:18] setTextColor:[PublicMethod colorWithHexValue:0xFF986D alpha:1.0f]];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
    submitBtn.highlighted = YES;
//    [submitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
//    [submitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    [self.view addSubview:submitBtn];
}

#pragma UITextFieldDelegate

//888186
- (void)back{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)getVerCodeBtnClicked:(id)sender{
    if(mobileField.text.length == 0){
        [[iToast makeText:@"手机不能为空"] show];
        return;
    }
    if (![PublicMethod isMobileNumber:mobileField.text]) {
        [[iToast makeText:@"手机号码错误"] show];
        return;
    }
    //获取验证码
    [[NetTrans getInstance] user_getVercode:self Mobile:mobileField.text setType:@"retrieve"];
}

- (void)submitBtnClicked:(id)sender{
    if ([self isValid]) {
        //忘记密码接口提交
        [[NetTrans getInstance] user_findBackPassword:self Mobile:mobileField.text Captcha:verField.text];
    }
}

- (BOOL)isValid{
    if(mobileField.text.length == 0){
        [[iToast makeText:@"手机不能为空"] show];
        return NO;
    }else if(verField.text.length != 6){
        [[iToast makeText:@"请输入 6 位数字验证码"] show];
        return NO;
    }
    if (![PublicMethod isMobileNumber:mobileField.text]) {
        [[iToast makeText:@"手机号码错误"] show];
        return NO;
    }
    return YES;
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
    if (nTag == t_API_USER_PLATFORM_VERCODE_API) {
        NSString *successStr = (NSString *)netTransObj;
        NSLog(@"netTransObj is %@",successStr);
        [self showAlert:successStr];
    }
    if (nTag == t_API_USER_PLATFORM_FINDBACK_PWD_API) {
        YHResetPwdViewController *resetPwd = [[YHResetPwdViewController alloc] init];
        resetPwd.loginSuccessBlock = _loginSuccessBlock;
        [self presentModalViewController:resetPwd animated:YES];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
     [[iToast makeText:errMsg]show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}            // called when 'return' key pressed. return NO to ignore.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
