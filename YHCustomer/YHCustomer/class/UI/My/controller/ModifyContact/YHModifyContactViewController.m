//
//  YHModifyContactViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-21.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHModifyContactViewController.h"
#import "YHModifyPhoneContactViewController.h"
@interface YHModifyContactViewController ()

@end

@implementation YHModifyContactViewController
@synthesize mobile;
#pragma mark --------------------------初始化
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
#pragma mark - 生命周期
-(void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE111];
    [self viewDidLoad];
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
    [self.view removeFromSuperview];
    self.view = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[time invalidate];
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE111];
    //[time invalidate];
    //将验证码输入框中的验证码消失
   
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
    
    //自适应label的长宽和大小
    CGSize size = CGSizeMake(320, 2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    NSString *str_phoneNum = mobile;
    NSString * str_money = [NSString stringWithFormat:@"当前联系手机号:%@", str_phoneNum];
    size = [str_money sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, size.width, 20)];
    titleLabel.text = str_money;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [self.view addSubview:titleLabel];
    
    verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel.bottom + 20, [UIScreen mainScreen].bounds.size.width-170, 40)];
    verCodeField.background = [UIImage imageNamed:@"passwordBg.png"];
    verCodeField.placeholder = @"请输入验证码";
    verCodeField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter|| UIControlContentHorizontalAlignmentCenter;
    verCodeField.delegate = self;
    verCodeField.autoresizesSubviews = YES;
    verCodeField.borderStyle = UITextBorderStyleLine;
    verCodeField.layer.borderWidth = 1.0f;
    verCodeField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    verCodeField.keyboardType = UIKeyboardTypeNumberPad;
    verCodeField.returnKeyType = UIReturnKeyDone;
    verCodeField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:verCodeField];
    
    verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(verCodeField.right+5, titleLabel.bottom + 20, 126, 40)];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [verCodeBtn addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verCodeBtn];
    
    
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, verCodeBtn.bottom + 30, SCREEN_WIDTH - 40, 40)];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
   
    [self registerKeyBord];

}
-(void)registerKeyBord {
    NSArray * tempArray = [[NSArray alloc] initWithObjects:verCodeField,nil];
    keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];

}

-(void)nextBtn:(id)sender
{
    if (verCodeField.text.length == 0) {
        [[iToast makeText:@"请输入验证码"]show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *captcha = [NSString stringWithFormat:@"%@",verCodeField.text];
    //验证验证码
    [[NetTrans getInstance]user_validation:self captcha:captcha mobile:mobile];

    
//    //跳转
//    YHModifyPhoneContactViewController *pvc = [[YHModifyPhoneContactViewController alloc]init];
//    [self.navigationController pushViewController:pvc animated:YES];

    
}
#pragma mark - 验证码
-(void)VerificationCode:(id)sender
{
    NSString * str_num;
    isSucee  = YES;
    //  获取本地的用户名
//    str_num = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    str_num = [NSString stringWithFormat:@"%@",self.mobile];
    //加一个类型验证码发送的网络请求
    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"user_mobile"];
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
    [MBProgressHUD hideHUDForView:self.view  animated:YES];

    //当验证码发送短信成功的时候弹出提示信息
    if (t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        NSString *successStr = (NSString *)netTransObj;
        NSLog(@"netTransObj is %@",successStr);
        [self showAlert:successStr];
    }
    //验证码
    if (t_API_USER_VALIDATION_VERCODE_API == nTag) {
        //跳转
        YHModifyPhoneContactViewController *pvc = [[YHModifyPhoneContactViewController alloc]init];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view  animated:YES];

    [[iToast makeText:errMsg]show];
}
#pragma mark ------------------------- Button click event
-(void)BackButtonClickEvent:(id)sender
{
    [[YHAppDelegate appDelegate] hideTabBar:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [verCodeField resignFirstResponder];
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
