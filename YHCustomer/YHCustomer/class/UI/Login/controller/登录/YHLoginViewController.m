//
//  YHLoginViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-12.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHLoginViewController.h"
#import "YHRegisterViewController.h"
#import "YHForgetPwdViewController.h"
#import "UITableViewCell+Addition.h"
#import "YHMobileValidatiorViewController.h"
#import "YHNewForgetPwdViewController.h"
@interface YHLoginViewController ()

@end

@implementation YHLoginViewController
@synthesize _PassWord;
@synthesize _UserName;
@synthesize loginTableView;
@synthesize logOutType;

#pragma mark --------------------------初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
//        [self addBGBtn];
//        [self addNavForgetPasswordButton];
//        [self addLoginView];
    }
    return self;
}
#pragma mark --------------------------生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self addBGBtn];
    [self addNavForgetPasswordButton];
    [self addLoginView];
    /*获取自动登录信息*/
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *remPwd = [userDefaults objectForKey:@"passWord"];
    NSString *remUser = [userDefaults objectForKey:@"userName"];
    if (remUser )
    {
        self._UserName= [NSString stringWithFormat:@"%@",remUser];
    }
    if (remPwd)
    {
        self._PassWord= [NSString stringWithFormat:@"%@",remPwd];
    }
    [loginTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (logOutType == LogOut_Passive_Push)
    {
        [self.navigationController.navigationBar setHidden:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (logOutType != LogOut_Usual)
    {
        //[[iToast makeText:@"登录定牌已过期，请重新登录"] show];
    }
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
#pragma mark --------------------------添加UI
/**
 * 添加背景button，点击键盘消失
 */
- (void)addBGBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = self.view.frame;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(hideKeyboardBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 * 添加登陆页面背景view
 */
- (void)addLoginBgView{
    UIView *bgView = [PublicMethod addBackView:CGRectMake(0, originY, 320, self.view.frame.size.height) setBackColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
}

- (void)back:(id)sender
{
    [[YHAppDelegate appDelegate].mytabBarController dismissViewControllerAnimated:YES completion:^{
        if (logOutType != LogOut_Usual)
        {
            _loginBackBlock();
        }
//        _loginBackBlock();
    }];
}

/**
 * 添加忘记密码button
 */
-(void)addNavForgetPasswordButton
{
    [PublicMethod addNavBackground:self.view title:@"登录"];
    [PublicMethod addBackButtonWithTarget:self action:@selector(back:)];
    /*注册新账户入口*/
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(265, originY, 55, 44);
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [registerBtn setBackgroundImage:[UIImage imageNamed:@"nav_register_btn"] forState:UIControlStateNormal];
//    [registerBtn setBackgroundImage:[UIImage imageNamed:@"nav_register_btn_selected"] forState:UIControlStateHighlighted];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[PublicMethod colorWithHexValue:0xFF986D alpha:1.0f] forState:UIControlStateSelected];
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(registerBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 * 登录界面
 */
- (void)addLoginView
{
    /*登录信息Table*/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if (IOS_VERSION >= 7)
    {
        tableView.frame = CGRectMake(0, NAVBAR_HEIGHT+40, self.view.frame.size.width, 120);
        
    }else{
        tableView.frame = CGRectMake(0, NAVBAR_HEIGHT+30, self.view.frame.size.width,120);
    }
    [tableView setBackgroundView:nil];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.loginTableView = tableView;
    
    /*登录按钮*/
    UIButton *loginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbtn.frame = CGRectMake(20, tableView.bottom, 280, 40);
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [loginbtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
//    [loginbtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    //[loginbtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
    [loginbtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]] forState:UIControlStateNormal];
    [loginbtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xff3540 alpha:1.0f]] forState:UIControlStateHighlighted];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginbtn];
    [loginbtn addTarget:self action:@selector(onLoginBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    /*忘记密码*/
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(220, 255, 90, 30);
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [forgetBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetPasswordBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(forgetBtn.left-7, forgetBtn.top+7, 15, 15)];
    [image setImage:[UIImage imageNamed:@"plaint"]];
    [self.view addSubview:image];
}
#pragma mark --------------------------User Action
/**
 * 登录
 */
- (void)onLoginBtnClickHandle:(id)sender
{
    
    if (![self isValid])
    {
        return;
    }
    /*登录*/
//    NSLog(@"%@",_UserName);
//    NSLog(@"%@",_PassWord);
    [[NetTrans getInstance] user_login:self UserName:_UserName Password:_PassWord];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/**
 * 注册新用户入口
 */
- (void)registerBtnClickHandle:(id)sender
{
    YHRegisterViewController *registerController = [[YHRegisterViewController alloc] init];
    registerController.loginSuccessBlock = _loginSuccessBlock;
    [self presentModalViewController:registerController animated:YES];
}

/*
 * 忘记密码
 */
- (void)forgetPasswordBtnClickHandle:(id)sender
{
//    YHForgetPwdViewController *forgetPwd =[[YHForgetPwdViewController alloc] init];
//    forgetPwd.loginSuccessBlock = _loginSuccessBlock;
//    [self presentModalViewController:forgetPwd animated:YES];
    //手机号验证的人口（待定）
//    YHMobileValidatiorViewController *mobileVC = [[YHMobileValidatiorViewController alloc]init];
//    [self presentModalViewController:mobileVC animated:YES];
    //忘记密码修改
    
    YHNewForgetPwdViewController *forgetPwd = [[YHNewForgetPwdViewController alloc]init];
    forgetPwd.loginSuccessBlock = _loginSuccessBlock;
    [self presentModalViewController:forgetPwd animated:YES];
}

/**
 * 隐藏键盘
 */
- (void)hideKeyboardBtnClickHandle:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark --------------------------Private Method
/**
 * 判断输入用户名和密码是否符合格式
 */
-(BOOL)isValid{
    self._UserName = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self._PassWord = [self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self._UserName length] == 0)
    {
        [[iToast makeText:@"用户名不能为空，请重新输入"] show];
        return NO;
    }
    else
    {
        //判断用户名是否全为数字
        if ([self isPureNumandCharacters:self._UserName])
        {
            if (![PublicMethod isMobileNumber:self._UserName])
            {
                [[iToast makeText:@"手机号必须是11位以1开头的纯数字"] show];
                return NO;
            }
        }
        else
        {
            if(![PublicMethod validateEmail:self._UserName])
            {
                [[iToast makeText:@"邮箱地址格式输入有误，请重新输入"] show];
                return NO;
            }
            
        }
    
    }
    if([self._PassWord length] == 0){
        [[iToast makeText:@"请输入密码"] show];
        return NO;
    }
    
    //密码正则判断
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9]{6,20}$" options:NSRegularExpressionCaseInsensitive error:nil];
    if (regex != nil) {
        NSUInteger numberOfMatch = [regex numberOfMatchesInString:self._PassWord options:0 range:NSMakeRange(0, [self._PassWord length])];
        if (numberOfMatch == 0) {
            [[iToast  makeText:@"格式错误啦，密码格式为6-20位"] show];
            return NO;
        }
    }
    return  YES;
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
#pragma mark --------------------------UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    switch ([indexPath section]) {
        case 0:
        {
            switch ([indexPath row])
            {
                case 0:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280, 44)];
                    nameField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
                    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    nameField.returnKeyType = UIReturnKeyDone;
                    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    nameField.delegate = self;
                    nameField.text = _UserName;
                    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
                    leftView.contentMode = UIViewContentModeCenter;
                    [leftView setImage:[UIImage imageNamed:@"mobile"]];
                    nameField.leftView = leftView;
                    nameField.leftViewMode = UITextFieldViewModeAlways;
                    nameField.placeholder = @"手机号/邮箱";
                    nameField.background = [UIImage imageNamed:@"passwordBg.png"];
                    [cell addSubview:nameField];
                    self.nameField = nameField;
                }
                    break;
                case 1:
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UITextField *passWordField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280, 44)];
                    passWordField.secureTextEntry = YES;
                    passWordField.autocorrectionType = UITextAutocorrectionTypeNo;
                    passWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    passWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    passWordField.returnKeyType = UIReturnKeyDone;
                    passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    passWordField.delegate = self;
                    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
                    leftView.contentMode = UIViewContentModeCenter;
                    [leftView setImage:[UIImage imageNamed:@"psw"]];
                    passWordField.leftView = leftView;
                    passWordField.leftViewMode = UITextFieldViewModeAlways;
                    passWordField.placeholder = @"请输入密码";
                    passWordField.background = [UIImage imageNamed:@"passwordBg.png"];
                    passWordField.text = _PassWord;
                    [cell addSubview:passWordField];
                    self.pwdField = passWordField;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark --------------------------UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
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
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
    }
    [[iToast makeText:errMsg]show];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == t_API_USER_LOGIN_API ||nTag == t_API_USER_PLATFORM_THIRDPART_LOGIN_API){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UserAccount *userLoginInfo = (UserAccount *)netTransObj;
        //将用户名那个和密码存入本地
        [[NSUserDefaults standardUserDefaults] setObject:_PassWord forKey:@"passWord"];
        [[NSUserDefaults standardUserDefaults] setObject:_UserName forKey:@"userName"];
        [[NetTrans getInstance] getCartGoodsNum:self];
        NSLog(@"userLoginInfo.mobile == %@",userLoginInfo.mobile);
        if (![userLoginInfo.mobile isEqualToString:@""]) {
          
            //如果用户的手机号不为空
            [[NSUserDefaults standardUserDefaults]setObject:userLoginInfo.mobile forKey:@"mobile"];
            NSLog(@"%@",userLoginInfo);
            
            _loginSuccessBlock(userLoginInfo);


        }
        else
        {
            //当网络请求下的用户信息中的手机号为空的时候，跳转到绑定手机号界面
            YHMobileValidatiorViewController *mobileVC = [[YHMobileValidatiorViewController alloc]init];
            mobileVC.loginSuccessBlock = _loginSuccessBlock;
            [self presentModalViewController:mobileVC animated:YES];
        
        }

        
    }
    if (nTag == t_API_CART_TOTAL_API) {
        NSString *totalNum = (NSString *)netTransObj;
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
    
}
@end
