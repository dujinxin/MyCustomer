//
//  YHModifyPwdViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-17.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHModifyPwdViewController.h"

@interface YHModifyPwdViewController ()
{
    UITextField * Oldtextfiled;
    UITextField * Nowtextfiled;
    UITextField * Confirmtextfiled;

}
@end

@implementation YHModifyPwdViewController


#pragma mark --------------------------初始化

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"修改密码";
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addBGBtn];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addResetView];
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

#pragma mark ------------------------- add UI
/**
 * 添加背景button，点击键盘消失
 */
- (void)addBGBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.view.frame;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(hideKeyboardBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 * 隐藏键盘
 */
- (void)hideKeyboardBtnClickHandle:(id)sender
{
    [self.view endEditing:YES];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)addResetView
{
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, -23, self.view.frame.size.width-20, 180) style:UITableViewStyleGrouped];
    if (IOS_VERSION<7) {
        tableView.frame = CGRectMake(10, 10, self.view.frame.size.width-20, 180);
    }
    [tableView setBackgroundView:bgview];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.userInteractionEnabled = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    //提交button
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"bind_ignore.png"] forState:UIControlStateNormal];
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"bind_ignore.png"] forState:UIControlStateDisabled];
    
    if (IOS_VERSION >= 7) {
        nextBtn.frame = CGRectMake(10, 184, 300, 44);
    }else{
        nextBtn.frame = CGRectMake(18, 184, 284, 44);
    }
    
    [nextBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]] forState:UIControlStateNormal];
   //    [nextBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateDisabled];
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
   // nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(changePasswordButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    //_resetBtn = nextBtn;
    [self.view addSubview:nextBtn];
}

/**
 *  修改密码按钮设置
 */
- (void)changePasswordButtonClickEventHandler:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([self isValid]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[NetTrans getInstance] user_modifyPassWord:self OldPwd:self._oldPassword NewPassword:self._nowPassword ConfirmPassWord:self._nowPassword];
    }


}




#pragma mark --------------------------Private Method
/**
 * 判断输入用户名和密码是否符合格式
 */

-(BOOL)isValid{
    
    self._oldPassword = [Oldtextfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self._nowPassword = [Nowtextfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self._comfirmPassWord = [Confirmtextfiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self._oldPassword.length==0) {
        [[iToast makeText:@"当前密码不能为空"]show];
        return NO;
    }
    if (self._nowPassword.length==0) {
        [[iToast makeText:@"新密码不能为空"]show];
        return NO;
    }else{
    
        if (![PublicMethod isVaildPassword:self._nowPassword])
        {
            [[iToast makeText:@"密码应为6-20位的数字和字母组合"]show];
            return NO;
        }
    
    }
    if (self._comfirmPassWord.length==0) {
        [[iToast makeText:@"重复新密码不能为空"]show];
        return NO;
    }else{
    
        if (![self._nowPassword isEqualToString:self._comfirmPassWord]) {
            [[iToast makeText:@"您两次输入的密码不一致，请核对后重新输入。"] show];
            return NO;
            
        }
    
    }

    return  YES;
}

#pragma mark --------------------------UITableView Delegate & DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //UITableViewCell *cell = cell = [[[UITableViewCell alloc]init]autorelease];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch ([indexPath section]) {
        case 0:
        {
            switch ([indexPath row])
            {
                case 0:
                {
                    //输入新密码
                    UILabel *passwordLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
                    passwordLeftLbl.text = @"旧密码";
                    passwordLeftLbl.textColor = [UIColor blackColor];
                    
                    UITextField *passwordTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 280, 40)];
                    passwordTxtField.secureTextEntry = YES;
                    //  passwordTxtField.keyboardType = UIKeyboardTypeNumberPad;
                    passwordTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
                    passwordTxtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    passwordTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    passwordTxtField.returnKeyType = UIReturnKeyDone;
                    passwordTxtField.placeholder = @"请输入当前密码";
                    passwordTxtField.delegate = self;
                    passwordTxtField.tag = E_TextField_OldPassWord;
                    passwordTxtField.leftView = passwordLeftLbl;
//                    passwordTxtField.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:passwordTxtField];
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_top"]]];
                    Oldtextfiled = passwordTxtField;

                }
                    break;
                case 1:
                {
                    //确认新密码
                    UILabel *passwordLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
                    passwordLeftLbl.text = @"新密码";
                    passwordLeftLbl.textColor = [UIColor blackColor];
                    
                    UITextField *passwordTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 280, 40)];
                    passwordTxtField.secureTextEntry = YES;
                    //  passwordTxtField.keyboardType = UIKeyboardTypeNumberPad;
                    passwordTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
                    passwordTxtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    passwordTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    passwordTxtField.returnKeyType = UIReturnKeyDone;
                    passwordTxtField.placeholder = @"请输入新密码";
                    passwordTxtField.delegate = self;
                    passwordTxtField.tag = E_TextField_PassWord;
                    passwordTxtField.leftView = passwordLeftLbl;
//                    passwordTxtField.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:passwordTxtField];
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_mid"]]];
                    Nowtextfiled = passwordTxtField;
                }
                    break;
                case 2:
                {
                    
                    //再次输入密码
                    UILabel *comfirmPasswordLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
                    comfirmPasswordLeftLbl.text = @"确认密码";
                    comfirmPasswordLeftLbl.textColor = [UIColor blackColor];
                    
                    UITextField *comfirmPasswordTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 280, 40)];
                    comfirmPasswordTxtField.secureTextEntry = YES;
                    // comfirmPasswordTxtField.keyboardType = UIKeyboardTypeNumberPad;
                    comfirmPasswordTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
                    comfirmPasswordTxtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    comfirmPasswordTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    comfirmPasswordTxtField.leftView = comfirmPasswordLeftLbl;
                    comfirmPasswordTxtField.returnKeyType = UIReturnKeyDone;
                    comfirmPasswordTxtField.placeholder = @"请输入确认密码";
                    comfirmPasswordTxtField.delegate = self;
                    comfirmPasswordTxtField.tag = E_TextField_ComfirmPassWord;
//                    comfirmPasswordTxtField.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:comfirmPasswordTxtField];
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_bottom"]]];
                    Confirmtextfiled = comfirmPasswordTxtField;
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField == Oldtextfiled)
//    {
//        [Oldtextfiled resignFirstResponder];
//    }
//    else if(textField == Nowtextfiled)
//    {
//     [Nowtextfiled resignFirstResponder];
//    
//    }
//    else if(textField == Confirmtextfiled)
//    {
//        [Confirmtextfiled resignFirstResponder];
//        
//    }
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_USER_PLATFORM_MODIFYINFO_API == nTag)
    {
        [[iToast makeText:@"修改密码成功"] show];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"passWord"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (t_API_USER_PLATFORM_MODIFYINFO_API == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else
        {
            [[iToast makeText:errMsg] show];
        }
    }
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
