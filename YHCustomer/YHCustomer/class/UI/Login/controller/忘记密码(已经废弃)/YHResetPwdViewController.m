//
//  YHResetPwdViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  重设密码界面

#import "YHResetPwdViewController.h"
#import "BUIView.h"//这个是在弹窗中调用了这个类的方法

@interface YHResetPwdViewController ()

@end

@implementation YHResetPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.navigationItem.title = @"重设密码";
        self.view.backgroundColor = [UIColor clearColor];
        UIView *bgView = [PublicMethod addBackView:CGRectMake(0, originY, 320, SCREEN_HEIGHT) setBackColor:[UIColor whiteColor]];
        [self.view addSubview:bgView];
        [self addNavView];
        [self addFieldAndButton];
    }
    return self;
}
- (void)loadView
{
    [super loadView];
//    UIView *bgView = [PublicMethod addBackView:CGRectMake(0, originY, 320, SCREEN_HEIGHT) setBackColor:[UIColor whiteColor]];
//    [self.view addSubview:bgView];
//    [self addNavView];
//    [self addFieldAndButton];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
#pragma mark ------------------  add UI
-(void)addNavView {
    [PublicMethod addNavBackground:self.view title:@"重设密码"];
    [PublicMethod addBackViewWithTarget:self action:@selector(dismissSelf)];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, originY, 55, 44);
//    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_Select"] forState:UIControlStateHighlighted];
//    [backBtn setTitleColor:[PublicMethod colorWithHexValue:0xFF986D alpha:1.0f] forState:UIControlStateSelected];
//    [self.view addSubview:backBtn];
//    [backBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(7, originY +7, 30, 30);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_Select"] forState:UIControlStateHighlighted];
//    [backBtn setTitleColor:[PublicMethod colorWithHexValue:0xFF986D alpha:1.0f] forState:UIControlStateSelected];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addFieldAndButton {
    //密码输入框
    CGRect inputRect = CGRectMake(160 - 276/2, 55+originY , 276, 42);
    _passwordField = [[UITextField alloc] initWithFrame:inputRect];
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.textAlignment = UITextAlignmentCenter;
    _passwordField.delegate = self;
    _passwordField.secureTextEntry = YES;
    _passwordField.background = [UIImage imageNamed:@"passwordBg.png"];
    [self.view addSubview:_passwordField];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.frame = CGRectMake(160-276/2.0, _passwordField.bottom + 15, 276, 42);
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    [_commitBtn addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
}
#pragma mark ----------------------------- private密码验证
-(BOOL)isValid{
    NSString *password = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([password length] == 0){
        [[iToast makeText:@"密码不能为空"] show];
        return NO;
    }
    
    //密码正则判断
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9]{6,30}$" options:NSRegularExpressionCaseInsensitive error:nil];
    if (regex != nil) {
        NSUInteger numberOfMatch = [regex numberOfMatchesInString:password options:0 range:NSMakeRange(0, [password length])];
        if (numberOfMatch == 0) {
            [[iToast  makeText:@"格式错误啦，密码格式为6-20位"] show];
            return NO;
        }
    }
    return  YES;
}


#pragma mark ----------------------------- 用户操作
- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)commitButtonClicked:(id)sender{
    [self.view endEditing:YES];
    /**  检查输入新密码的有效性 **/
    if (![self isValid]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定修改密码吗？"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert showWithCompletionHandler:^(NSInteger buttonIndex){
        if (buttonIndex == 1) {
            //确认修改提交服务器
            [[NetTrans getInstance] user_resetPassword:self :_passwordField.text];
        }
    }];
}

#pragma mark --------------  net delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
    if (nTag == t_API_USER_PLATFORM_RESET_PASSWORD_API) {
        [[iToast makeText:@"修改密码成功"] show];
        _loginSuccessBlock(nil);
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    [[iToast makeText:@"修改密码失败"] show];
}

#pragma mark ------------- UITextField delegate键盘收起
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
@end
