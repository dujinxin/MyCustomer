//
//  YHNewSetPwdViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  设置新密码

#import "YHNewSetPwdViewController.h"
#import "YHLoginViewController.h"
@interface YHNewSetPwdViewController ()
{
    UIScrollView *myScrollView;
    UITextField *pwdTextField;
    UITextField *cPwdTextField;
    UITextField *verCodeField;
    UIButton *verCodeBtn;
    UIButton *submitBtn;
    int  numTitle;
    NSTimer *time;
    BOOL isSucee;

}
@end

@implementation YHNewSetPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PublicMethod addNavBackground:self.view title:@"设置新密码"];
    [PublicMethod addBackViewWithTarget:self action:@selector(back:)];
    [self createUI];

}
#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
   
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE115];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
    [time invalidate];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[time invalidate];
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE115];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)createUI
{
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, originY+44, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.userInteractionEnabled = YES;
    [self.view addSubview:myScrollView];
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 40)];
    pwdTextField.placeholder = @"请设置一个新密码";
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.background = [UIImage imageNamed:@"passwordBg.png"];
    pwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwdTextField.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    pwdTextField.leftView = leftView;
    pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    pwdTextField.borderStyle = UITextBorderStyleLine;
    pwdTextField.layer.borderWidth = 1.0f;
    pwdTextField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTextField.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:pwdTextField];
    
    cPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, pwdTextField.bottom + 20, [UIScreen mainScreen].bounds.size.width-40, 40)];
    cPwdTextField.background = [UIImage imageNamed:@"passwordBg.png"];
    cPwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cPwdTextField.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    cPwdTextField.leftView = leftView1;
    cPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    cPwdTextField.borderStyle = UITextBorderStyleLine;
    cPwdTextField.layer.borderWidth = 1.0f;
    cPwdTextField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    cPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cPwdTextField.returnKeyType = UIReturnKeyNext;
    cPwdTextField.placeholder = @"重新输入新密码";
    cPwdTextField.delegate = self;
    cPwdTextField.secureTextEntry = YES;
//    cPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    cPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cPwdTextField.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:cPwdTextField];
    
    verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(20, cPwdTextField.bottom+20, [UIScreen mainScreen].bounds.size.width-170, 40)];
    verCodeField.background = [UIImage imageNamed:@"passwordBg.png"];
    verCodeField.placeholder = @"请输入验证码";
    verCodeField.delegate = self;
    verCodeField.autoresizesSubviews = YES;
    verCodeField.borderStyle = UITextBorderStyleLine;
    verCodeField.layer.borderWidth = 1.0f;
    verCodeField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    verCodeField.keyboardType = UIKeyboardTypeNumberPad;
    verCodeField.textAlignment = NSTextAlignmentCenter;
    [myScrollView addSubview:verCodeField];
    
    verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(verCodeField.right+5, cPwdTextField.bottom+20, 126, 40)];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [verCodeBtn addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:verCodeBtn];
    
    
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, verCodeBtn.bottom + 30, SCREEN_WIDTH - 40, 40)];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:confirmBtn];
    [self registerKeyBord];

}
-(BOOL)isValid
{
    if (pwdTextField.text.length == 0)
    {
        [[iToast makeText:@"请输入密码"] show];
        return NO;
    }
    else
    {
//        if (pwdTextField.text.length <6||pwdTextField.text.length>20)
//        {
//            [[iToast makeText:@"格式错误啦，密码格式为6-20位"] show];
//            return NO;
//        }
//        else
//        {
            if (![PublicMethod isVaildPassword:pwdTextField.text])
            {
                [[iToast makeText:@"密码应为6-20位的数字和字母组合"]show];
                return NO;
            }
            
//        }
        
    }
    if (cPwdTextField.text.length == 0) {
        [[iToast makeText:@"请再次输入密码"]show];
        return NO;
    }else {
        if (![pwdTextField.text isEqualToString:cPwdTextField.text]) {
            [[iToast makeText:@"您两次输入的密码不一致,请核对后重新输入。"]show];
            return NO;
        }
        
    
    
    }
    return YES;

}
-(void)confirmBtn:(id)sender
{
    
    //跳转到登录接界面

    if (![self isValid]) {
        return;
    }
    if (verCodeField.text.length == 0) {
        [[iToast makeText:@"验证码不能为空"]show];
    }
    else
    {
        if (verCodeField.text.length != 6)
        {
             [[iToast makeText:@"请输入6位数字的验证码"]show];
        }
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //[[NetTrans getInstance]user_forget_modify_password:self mobile:self.mobile captcha:verCodeField.text new_password:pwdTextField.text confirm_password:cPwdTextField.text];
    // NSLog(@"%@\n%@\n%@\n%@\n%@\n%@",self.mobile,self.type,self.user_name,verCodeField.text,pwdTextField.text,cPwdTextField.text);
   [[NetTrans getInstance]user_forget_modify_password:self mobile:self.mobile type:self.type user_name:self.user_name captcha:verCodeField.text new_password:pwdTextField.text confirm_password:cPwdTextField.text];
    
   
   
    
}
#pragma mark - KeyBordDelegate
-(void)registerKeyBord {
    NSArray * tempArray = [[NSArray alloc] initWithObjects:pwdTextField,cPwdTextField,verCodeField,nil];
    keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}
-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField
{
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pwdTextField resignFirstResponder];
    [cPwdTextField resignFirstResponder];
    [verCodeField resignFirstResponder];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];
    
    if (textField == cPwdTextField) {
        [myScrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    else if (textField == verCodeField) {
        [myScrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    else if (textField == pwdTextField)
    {
        [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
#pragma mark - 验证码
-(void)VerificationCode:(id)sender
{
   // NSString * str_num;
    if (![self isValid]) {
        return;
    }
    isSucee  = YES;
//  获取本地的用户名
    [[NetTrans getInstance] user_getVercode:self Mobile:self.mobile setType:@"retrieve"];

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
        [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [verCodeBtn setEnabled:YES];
    }
    else
    {
        [verCodeBtn setEnabled:NO];
        [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
        NSString * str_num = [NSString stringWithFormat:@"重新获取(%d)" , numTitle];
        NSLog(@"%@" , str_num);
        [verCodeBtn setTitle:str_num forState:UIControlStateNormal];
        verCodeBtn.titleLabel.text = str_num;
        numTitle--;
    }
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 获取短信验证码成功
    if (nTag == t_API_USER_PLATFORM_VERCODE_API) {
        NSString *successStr = (NSString *)netTransObj;
        [self showAlert:successStr];
    }
    if (t_API_USER_LOGIN_FORGET_MODIFY_PASSWORD == nTag)
    {
        //跳转到登录接界面
        NSString *successStr = (NSString *)netTransObj;
         //NSLog(@"%@\n%@\n%@\n%@\n%@\n%@",self.mobile,self.type,self.user_name,verCodeField.text,pwdTextField.text,cPwdTextField.text);
        [self showAlert:successStr];
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
