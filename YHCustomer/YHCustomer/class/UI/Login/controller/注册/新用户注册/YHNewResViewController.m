//
//  YHNewResViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-3-26.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHNewResViewController.h"
#import "YHPoliceViewController.h"

@interface YHNewResViewController ()

@end

@implementation YHNewResViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    [self addNavView];
    [self addInfoView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    [PublicMethod addNavBackground:self.view title:@"新用户注册"];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(265, originY, 55, 44);
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"nav_login_btn"] forState:UIControlStateNormal];
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"nav_login_btn_selected"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(buttonClickWithTag:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 105;
    
    [PublicMethod addBackViewWithTarget:self action:@selector(back:)];
}

-(void)addInfoView {
    infoView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, originY+44, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (!iPhone5) {
        [infoView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60)];
    }
    infoView.backgroundColor = [UIColor clearColor];
    infoView.userInteractionEnabled = YES;
    infoView.showsVerticalScrollIndicator = NO;
    _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(20,10, 280, 40)];
    _mobileField.frame = CGRectMake(20,20+5, 280, 40);
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mobileField.delegate = self;
    _mobileField.returnKeyType = UIReturnKeyNext;
    _mobileField.background = [UIImage imageNamed:@"passwordBg.png"];
    UIImageView *mobileLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
    mobileLeftView.contentMode = UIViewContentModeCenter;
    [mobileLeftView setImage:[UIImage imageNamed:@"mobile"]];
    _mobileField.leftView = mobileLeftView;
    _mobileField.placeholder = @"请输入手机号码";
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    [infoView addSubview:_mobileField];
    
    
    _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(20, _mobileField.bottom+15, 280, 40)];
    _passWordField.delegate = self;
    _passWordField.secureTextEntry = YES;
    _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordField.returnKeyType = UIReturnKeyNext;
    _passWordField.background = [UIImage imageNamed:@"passwordBg.png"];
    UIImageView *pswLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
    pswLeftView.contentMode = UIViewContentModeCenter;
    [pswLeftView setImage:[UIImage imageNamed:@"reg_psw"]];
    _passWordField.leftView = pswLeftView;
    _passWordField.leftViewMode = UITextFieldViewModeAlways;
    _passWordField.placeholder = @"请设置一个密码";
    
    [infoView addSubview:_passWordField];
    
    _recommenNumField = [[UITextField alloc] initWithFrame:CGRectMake(20,_passWordField.bottom+15, 280, 40)];
    _recommenNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _recommenNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _recommenNumField.delegate = self;
    _recommenNumField.returnKeyType = UIReturnKeyNext;
    _recommenNumField.background = [UIImage imageNamed:@"passwordBg.png"];
    UIImageView *recLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
    recLeftView.contentMode = UIViewContentModeCenter;
    [recLeftView setImage:[UIImage imageNamed:@"mobile"]];
    _recommenNumField.leftView = recLeftView;
    _recommenNumField.placeholder = @"请输入推荐人手机号码(非必填)";
    _recommenNumField.leftViewMode = UITextFieldViewModeAlways;
    _recommenNumField.keyboardType = UIKeyboardTypeNumberPad;
    [infoView addSubview:_recommenNumField];
    
    //CGRectMake(145,_recommenNumField.bottom+15, 150, 41)
    verCodeBtn = [PublicMethod addButton:CGRectMake(150,_recommenNumField.bottom+15, 150, 41) title:@"获取验证码" backGround:nil setTag:101 setId:self selector:@selector(buttonClickWithTag:) setFont:[UIFont systemFontOfSize:16] setTextColor:[UIColor whiteColor]];
    [verCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [verCodeBtn setBackgroundImage:[UIImage imageNamed:@"vercode_btn"] forState:UIControlStateNormal];
//    [verCodeBtn setBackgroundImage:[UIImage imageNamed:@"vercode_btn_selected"] forState:UIControlStateHighlighted];
    [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
    verCodeBtn.highlighted = YES;
    [infoView addSubview:verCodeBtn];
    
    _verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(20, _recommenNumField.bottom+15, 117, 41)];
    _verCodeField.autoresizesSubviews = YES;
    _verCodeField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter|| UIControlContentHorizontalAlignmentCenter;
    _verCodeField.placeholder = @" 请输入验证码";
    _verCodeField.borderStyle = UITextBorderStyleNone;
    _verCodeField.delegate = self;
    _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _verCodeField.font = [UIFont systemFontOfSize:16];
    _verCodeField.textAlignment = NSTextAlignmentCenter;
    [_verCodeField setBackground:[UIImage imageNamed:@"verCodebg.png"]];
    [infoView addSubview:_verCodeField];
    //@"bind_ignore.png"
    registerBtn = [PublicMethod addButton:CGRectMake(20, verCodeBtn.bottom+15, 280, 45) title:@"立即注册" backGround:nil setTag:102 setId:self selector:@selector(buttonClickWithTag:) setFont:[UIFont systemFontOfSize:22] setTextColor:[UIColor whiteColor]];

    registerBtn.autoresizingMask = YES;
    [registerBtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xff3540 alpha:1.0f]] forState:UIControlStateHighlighted];
    [infoView addSubview:registerBtn];
    
    UIButton *agreeArgBtn = [PublicMethod addButton:CGRectMake(45, registerBtn.bottom+15+2, 16, 16) title:@"" backGround:@"agree_register.png" setTag:106 setId:self selector:@selector(agreeAction:) setFont:nil setTextColor:nil];
    [infoView addSubview:agreeArgBtn];
    
    UILabel *argLabel = [PublicMethod addLabel:CGRectMake(50+20, registerBtn.bottom+15, 80, 20) setTitle:@"已阅读并同意" setBackColor:[UIColor darkGrayColor] setFont:[UIFont systemFontOfSize:13]];
    [infoView addSubview:argLabel];
    
    instructionBtn = [PublicMethod addButton:CGRectMake(120+20,registerBtn.bottom+15, 150, 20) title:@"使用条款和隐私政策" backGround:nil setTag:109 setId:self selector:@selector(buttonClickWithTag:) setFont:[UIFont italicSystemFontOfSize:13] setTextColor:RGBCOLOR(255, 150, 0)];
    instructionBtn.autoresizesSubviews = YES;
    [infoView addSubview:instructionBtn];
    
    [self.view addSubview:infoView];
    
    [self registerKeyBord];
}

-(void)registerKeyBord {
    NSArray * tempArray = [[NSArray alloc] initWithObjects:_mobileField,_passWordField,_recommenNumField,_verCodeField,nil];
        keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _mobileField) {
        [_passWordField becomeFirstResponder];
    }
    if (textField == _passWordField) {
        [_verCodeField becomeFirstResponder];
    }
    if (textField == _verCodeField) {
        [textField resignFirstResponder];
    }
    if (textField == _recommenNumField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];
    if (textField == _passWordField) {
        [infoView setContentOffset:CGPointMake(0, 73) animated:YES];
        
    } else if (textField == _verCodeField) {
        [infoView setContentOffset:CGPointMake(0, 165) animated:YES];
    } else if (textField == _mobileField) {
        [infoView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (textField == _recommenNumField) {
        [infoView setContentOffset:CGPointMake(0, 125) animated:YES];
    }
}

-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField {
    [infoView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark --------------- button action
- (void)buttonClickWithTag:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            
            break;
        case 101:
            if (![self isValidVerCode]) {
                return;
            }
            // 获取验证码
            [[NetTrans getInstance] user_getVercode:self Mobile:_mobileField.text setType:@"register"];
            break;
        case 102:
            
            if (![self isValid]) {
                return;
            }
            // 注册
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NetTrans getInstance] user_register:self Mobile:_mobileField.text passWordCode:_passWordField.text Captcha:_verCodeField.text Id:nil recommend_mobile:_recommenNumField.text];
            
            break;
        case 103:{
            
        }
            break;
        case 104:{
            
        }
            
            break;
        case 105:{
            YHLoginViewController *loginViewCtrl = [[YHLoginViewController alloc] init];
            // 登陆成功或者失败 callBack
            loginViewCtrl.loginBackBlock = ^{
                
            };
            
            loginViewCtrl.loginSuccessBlock = ^(UserAccount *account){
                [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES                           completion:^{
                    
                }];
            };
            
            [self presentModalViewController:loginViewCtrl animated:YES];
        }
        case 106:{
            btn.selected = !btn.selected;
            if (btn.selected) {
                //                [btn setBackgroundImage:[UIImage imageNamed:@"agreeArg.png"] forState:UIControlStateNormal];
            }else{
                //                [btn setBackgroundImage:[UIImage imageNamed:@"agreeBg.png"] forState:UIControlStateNormal];
            }
        }
            break;
        case 107:{

            
        }
            break;
        case 108:{
     
        }
            break;
        case 109:{
            YHPoliceViewController *plice = [[YHPoliceViewController alloc] init];
            [self presentModalViewController:plice animated:YES];
            
        }
            break;
        default:
            break;
    }
}

-(void)agreeAction:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag%2 == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"not_agree_register"] forState:UIControlStateNormal];
        registerBtn.enabled = NO;
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"agree_register"] forState:UIControlStateNormal];
        registerBtn.enabled = YES;
    }
    button.tag ++;
}

-(void)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
//验证码输入前校验
-(BOOL)isValidVerCode
{
    if(_mobileField.text.length == 0)
    {
        [[iToast makeText:@"请输入手机号"] show];
        return NO;
    }
    else
    {
    
        if (![PublicMethod isMobileNumber:_mobileField.text]) {
            [[iToast makeText:@"手机号必须是11位以1开头的纯数字"] show];
            return NO;
        }
    
    }
    if (_passWordField.text.length == 0)
    {
        [[iToast makeText:@"请输入密码"] show];
        return NO;
    }
    else
    {
        if (![PublicMethod isVaildPassword:_passWordField.text])
        {
            [[iToast makeText:@"密码应为6-20位的数字和字母组合"]show];
            return NO;
        }
    }
    if (_recommenNumField.text.length > 0) {
        if (![PublicMethod isMobileNumber:_recommenNumField.text]) {
            [[iToast makeText:@"手机号必须是11位以1开头的纯数字"] show];
            return NO;
        }
    }
    return YES;

}
// 注册之前校验参数
- (BOOL)isValid{

    if(_mobileField.text.length == 0){
        [[iToast makeText:@"请输入手机号"] show];
        return NO;
    }
    else
    {
        if (![PublicMethod isMobileNumber:_mobileField.text]) {
            [[iToast makeText:@"手机号必须是11位以1开头的纯数字"] show];
            return NO;
        }
    
    }
    
    if (_passWordField.text.length == 0)
    {
        [[iToast makeText:@"请输入密码"] show];
        return NO;
    }
    else
    {
        if (![PublicMethod isVaildPassword:_passWordField.text])
        {
            [[iToast makeText:@"密码应为6-20位的数字和字母组合"]show];
            return NO;
        }
    }
    if (_recommenNumField.text.length > 0) {
        if (![PublicMethod isMobileNumber:_recommenNumField.text]) {
            [[iToast makeText:@"手机号必须是11位以1开头的纯数字"] show];
            return NO;
        }
    }
    if(_verCodeField.text.length != 6){
        [[iToast makeText:@"请输入 6 位数字验证码"] show];
        return NO;
    }
    return YES;
}



#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    // 注册成功
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if (nTag == t_API_USER_PLATFORM_REGISTER_API) {
        [[NetTrans getInstance] user_login:self UserName:_mobileField.text Password:_passWordField.text];
    }
    
    if (nTag == t_API_USER_LOGIN_API) {
        [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES completion:^{
        }];
        [[NSUserDefaults standardUserDefaults] setObject:_mobileField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:_passWordField.text forKey:@"passWord"];
        /*登录成功后调用获取购物车数量接口*/
        [[NetTrans getInstance] getCartGoodsNum:self];
    }
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
    // 获取短信验证码成功
    if (nTag == t_API_USER_PLATFORM_VERCODE_API) {
        NSString *successStr = (NSString *)netTransObj;
        NSLog(@"netTransObj is %@",successStr);
        [self showAlert:successStr];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    // 注册成功
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
   
    if (nTag == t_API_CART_TOTAL_API)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
    }
    [[iToast makeText:errMsg]show];
}


@end
