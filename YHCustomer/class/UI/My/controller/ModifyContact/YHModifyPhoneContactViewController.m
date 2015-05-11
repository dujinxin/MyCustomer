//
//  YHModifyPhoneContactViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-21.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHModifyPhoneContactViewController.h"
#import "YHAccountManagerViewController.h"
#import "RefleshManager.h"
@interface YHModifyPhoneContactViewController ()
{
    UIScrollView *myScrollView;
    UITextField *mobileField;//mobile
    UITextField *verCodeField;
    UIButton *verCodeBtn;
    int  numTitle;
    NSTimer *time;
    BOOL isSucee;

}
@end

@implementation YHModifyPhoneContactViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(IOS_VERSION>=7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"修改联系方式";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
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
    [MTA trackPageViewBegin:PAGE112];
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
    [MTA trackPageViewEnd:PAGE112];
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

    mobileField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 40)];
    mobileField.placeholder = @"请输入新的手机号";
    mobileField.delegate = self;
    mobileField.background = [UIImage imageNamed:@"passwordBg.png"];
    mobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mobileField.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    mobileField.leftView = leftView;
    mobileField.leftViewMode = UITextFieldViewModeAlways;
    mobileField.borderStyle = UITextBorderStyleLine;
    mobileField.layer.borderWidth = 1.0f;
    mobileField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:mobileField];
    
    
    verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(20, mobileField.bottom+30, [UIScreen mainScreen].bounds.size.width-170, 40)];
    verCodeField.background = [UIImage imageNamed:@"passwordBg.png"];
    verCodeField.placeholder = @"请输入验证码";
    verCodeField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter|| UIControlContentHorizontalAlignmentCenter;
    verCodeField.delegate = self;
    verCodeField.autoresizesSubviews = YES;
    verCodeField.borderStyle = UITextBorderStyleLine;
    verCodeField.layer.borderWidth = 1.0f;
    verCodeField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    verCodeField.keyboardType = UIKeyboardTypeNumberPad;
    verCodeField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verCodeField];
    
    verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(verCodeField.right+5, mobileField.bottom+30, 126, 40)];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [verCodeBtn addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verCodeBtn];
    
    
    
    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, verCodeBtn.bottom + 40, SCREEN_WIDTH - 40, 40)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [completeBtn addTarget:self action:@selector(completeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
    
    [self registerKeyBord];

    
}
-(void)registerKeyBord {
    NSArray * tempArray = [[NSArray alloc] initWithObjects:mobileField,verCodeField,nil];
    keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];
    
}

-(void)completeBtn:(id)sender
{
    if (mobileField.text.length == 0) {
        [[iToast makeText:@"请输入手机号"]show];
        return;
    }
    if (![PublicMethod isMobileNumber:mobileField.text]) {
        [[iToast makeText:@"手机号必须是11位以1开头的纯数字"]show];
        return;
    }
    if (verCodeField.text.length == 0) {
        [[iToast makeText:@"请输入验证码"]show];
        return;
    }
    if (verCodeField.text.length != 6) {
        [[iToast makeText:@"请输入6位数字的验证码"]show];
        return;
    }
    NSString *mobile = [NSString stringWithFormat:@"%@",mobileField.text];
    NSString *captcha = [NSString stringWithFormat:@"%@",verCodeField.text];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance]user_modify_contact:self mobile:mobile captcha:captcha];
    
}
#pragma mark - 验证码
-(void)VerificationCode:(id)sender
{
    if (mobileField.text.length == 0) {
        [[iToast makeText:@"请输入手机号"]show];
        return;
    }
    if (![PublicMethod isMobileNumber:mobileField.text]) {
        [[iToast makeText:@"手机号必须是11位以1开头的纯数字"]show];
        return;
    }
    NSString * str_num;
    isSucee  = YES;
    //  获取本地的用户名
    str_num = [NSString stringWithFormat:@"%@",mobileField.text];
    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"update_mobile"];
    //    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"register"];
    //    [NSThread detachNewThreadSelector:@selector(sixTy) toTarget:self withObject:nil];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //当验证码发送短信成功的时候弹出提示信息
    if (t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        NSString *successStr = (NSString *)netTransObj;
        NSLog(@"netTransObj is %@",successStr);
        [self showAlert:successStr];
    }
    if (t_API_MODIFY_CONTACT_API == nTag)
    {
        //[[NSUserDefaults standardUserDefaults]setObject:userLoginInfo.mobile forKey:@"mobile"];
        //修改联系人之后，将修改的联系人保存到本地，也就是更新本地的联系人
        [[NSUserDefaults standardUserDefaults]setObject:mobileField.text forKey:@"mobile"];
        [[RefleshManager sharedRefleshManager] setAccountManagerRefresh:YES];
        [[iToast makeText:@"修改联系方式成功"]show];
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[iToast makeText:errMsg]show];
}
-(void)BackButtonClickEvent:(id)sender
{
    [[YHAppDelegate appDelegate] hideTabBar:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [verCodeField resignFirstResponder];
    [mobileField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
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
