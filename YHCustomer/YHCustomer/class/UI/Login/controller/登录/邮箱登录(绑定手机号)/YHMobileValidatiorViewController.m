//
//  YHMobileValidatiorViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-12.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHMobileValidatiorViewController.h"

@interface YHMobileValidatiorViewController ()
{
    UITextField *_mobileField;
    UITextField *_verCodeField;
    UIButton *_verCodeBtn;
    UIButton *_confirmBtn;
    int numTitle;
    NSTimer *time;
    BOOL isSucee;
    UIScrollView *bgView;

}
@end

@implementation YHMobileValidatiorViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE113];

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
    [MTA trackPageViewEnd:PAGE113];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNav];
    [self createView];

}
-(void)createNav
{
    [PublicMethod addNavBackground:self.view  title:@"手机号验证"];
    [PublicMethod addBackViewWithTarget:self action:@selector(back:)];
}
-(void)createView
{
    bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, originY+44, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.userInteractionEnabled = YES;
    bgView.showsVerticalScrollIndicator = NO;
    bgView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    [self.view addSubview:bgView];
    NSString *titleStr = @"请输入手机号进行验证";
    CGSize size = CGSizeMake(320, 2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    size = [titleStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
   UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, size.width, 24)];
    titleLabel.text = titleStr;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:titleLabel];
    UIButton *structBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    structBtn.frame = CGRectMake(titleLabel.right+3, 16, 12, 12);
    structBtn.layer.borderColor = [UIColor redColor].CGColor;
    structBtn.layer.borderWidth = 1.0f;
    structBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
    [structBtn setTitle:@"?" forState:UIControlStateNormal];
    [structBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [structBtn addTarget:self action:@selector(structClick:) forControlEvents:UIControlEventTouchUpInside];
    structBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    structBtn.layer.cornerRadius = 6;
    [bgView addSubview:structBtn];
    
    _mobileField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + 20, SCREEN_WIDTH - titleLabel.left * 2, 40)];
    _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mobileField.delegate = self;
    _mobileField.background = [UIImage imageNamed:@"passwordBg.png"];
    UIImageView *mobileLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
    mobileLeftView.contentMode = UIViewContentModeCenter;
    [mobileLeftView setImage:[UIImage imageNamed:@"mobile"]];
    _mobileField.leftView = mobileLeftView;
    _mobileField.placeholder = @"请输入手机号码";
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:_mobileField];

    _verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(_mobileField.left , _mobileField.bottom + 10, 158 , 40)];
//    UIImageView *verCodeLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 26)];
//    verCodeLeftView.contentMode = UIViewContentModeCenter;
//    _verCodeField.leftView = verCodeLeftView;
//    _verCodeField.leftViewMode = UITextFieldViewModeAlways;
    _verCodeField.placeholder = @"请输入验证码";
    _verCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verCodeField.background = [UIImage imageNamed:@"passwordBg.png"];
    _verCodeField.delegate = self;
    _verCodeField.autoresizesSubviews = YES;
    _verCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _verCodeField.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_verCodeField];
    
    _verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verCodeField.right+5, _mobileField.bottom + 11, 126, 40)];
    [_verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [_verCodeBtn addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_verCodeBtn];
    
     _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.left,_verCodeBtn.bottom + 20,SCREEN_WIDTH - 20,40)];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [_confirmBtn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_confirmBtn];
    
    
    [self registerKeyBord];
}
-(void)registerKeyBord
{
    NSArray * tempArray = [[NSArray alloc] initWithObjects:_mobileField,_verCodeField,nil];
    keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _mobileField)
    {
        [_verCodeField becomeFirstResponder];
    }

    if (textField == _verCodeField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];
    if (textField == _verCodeField) {
        [bgView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
}
-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField {
    
    [bgView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)structClick:(id)sender
{
    //说明按钮
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"随意了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
//    [alert show];
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"您的账号未绑定手机号,手机号用于接收物流状态等信息,避免错过提货、收货时间";
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    YHAlertView *alertView = [[YHAlertView alloc]initWithMessage:lab.text delegate:self];
    
    [alertView show];
    

}
-(void)confirmClick:(id)sender
{
    if (![self isVaild])
    {
        return;
    }
    //确认按钮
    if (_verCodeField.text.length == 0) {
        [[iToast makeText:@"请输入验证码"]show];
        return;
    }
    else
    {
        if (_verCodeField.text.length != 6) {
            [[iToast makeText:@"请输入6位数字的验证码"]show];
            return;
        }
    
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *mobile = [NSString stringWithFormat:@"%@",_mobileField.text];
    NSString *captcha = [NSString stringWithFormat:@"%@",_verCodeField.text];
    
    [[NetTrans getInstance]user_login_bindMobile:self mobile:mobile captcha:captcha];

}
-(BOOL)isVaild
{

    if (_mobileField.text.length == 0)
    {
        [[iToast makeText:@"请输入手机号"]show];
        return NO;
    }
    else
    {
        if (![PublicMethod isMobileNumber:_mobileField.text])
        {
            [[iToast makeText:@"手机号必须是11位以1开头的纯数字"]show];
             return NO;
        }
    
    }
    
    return YES;
}
-(void)VerificationCode:(id)sender
{
    if (![self isVaild])
    {
        return;
    }
    NSString * str_num;
    isSucee  = YES;
   
    str_num = [NSString stringWithFormat:@"%@",_mobileField.text];
    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"bind_mobile"];
   
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
        [_verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [_verCodeBtn setEnabled:YES];
    }
    else
    {
        [_verCodeBtn setEnabled:NO];
        [_verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
        NSString * str_num = [NSString stringWithFormat:@"重新获取(%d)" , numTitle];
        NSLog(@"%@" , str_num);
        [_verCodeBtn setTitle:str_num forState:UIControlStateNormal];
        _verCodeBtn.titleLabel.text = str_num;
        numTitle--;
      
    }
}
//返回的是弹出还是推出呢
-(void)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [[NetTrans getInstance] user_loginOut:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        NSString *successStr = (NSString *)netTransObj;
        NSLog(@"netTransObj is %@",successStr);
        [self showAlert:successStr];
    }
    
    //走绑定手机号的接口
    if (t_API_BIND_MOBILE_API == nTag) {
        //走登录接口
       [[NSUserDefaults standardUserDefaults]setObject:_mobileField.text forKey:@"mobile"];
        [UserAccount instance].mobile = _mobileField.text;
        [[UserAccount instance] saveAccount];
        _loginSuccessBlock(nil);
    }
    if(t_API_USER_PLATFORM_LOGIN_OUT_API == nTag)
    {
        //        [self.navigationController popViewControllerAnimated:YES];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logout];
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
    }

}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[iToast makeText:errMsg]show];
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
