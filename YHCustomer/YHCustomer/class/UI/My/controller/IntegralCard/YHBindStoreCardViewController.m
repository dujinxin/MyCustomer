//
//  YHBindStoreCardViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-3-19.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHBindStoreCardViewController.h"
#import "RefleshManager.h"
@interface YHBindStoreCardViewController ()
{
    UIScrollView *myScrollView;
    UITextField *mobileTextField;
    UITextField *cardTextField;
    UITextField *verCodeField;
    UIButton *verCodeBtn;
    UIButton *submitBtn;
    int  numTitle;
    NSTimer *time;
    BOOL isSucee;


}
@end

@implementation YHBindStoreCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"绑定门店积分卡";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    [self createUI];
}
-(void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    //    [MTA trackPageViewBegin:PAGE13];

    [MTA trackPageViewBegin:PAGE110];
    
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
    [time invalidate];
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE110];
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
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.userInteractionEnabled = YES;
    [self.view addSubview:myScrollView];
    
    mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 40)];
    mobileTextField.placeholder = @"请输入开卡手机号";
    mobileTextField.delegate = self;
//    pwdTextField.secureTextEntry = YES;
    mobileTextField.background = [UIImage imageNamed:@"passwordBg.png"];
    mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mobileTextField.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    mobileTextField.leftView = leftView;
    mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    mobileTextField.borderStyle = UITextBorderStyleLine;
    mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    mobileTextField.layer.borderWidth = 1.0f;
    mobileTextField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileTextField.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:mobileTextField];
    
    cardTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, mobileTextField.bottom + 10, [UIScreen mainScreen].bounds.size.width-40, 40)];
    cardTextField.background = [UIImage imageNamed:@"passwordBg.png"];
    cardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cardTextField.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    cardTextField.leftView = leftView1;
    cardTextField.leftViewMode = UITextFieldViewModeAlways;
    cardTextField.borderStyle = UITextBorderStyleLine;
    cardTextField.layer.borderWidth = 1.0f;
    cardTextField.layer.borderColor = [[PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f] CGColor];
    cardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cardTextField.returnKeyType = UIReturnKeyNext;
    cardTextField.placeholder = @"请输入门店积分卡号";
    cardTextField.delegate = self;
    cardTextField.keyboardType = UIKeyboardTypeNumberPad;
    cardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cardTextField.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:cardTextField];
    
    verCodeField = [[UITextField alloc] initWithFrame:CGRectMake(20, cardTextField.bottom+10, [UIScreen mainScreen].bounds.size.width-170, 40)];
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
    
    verCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(verCodeField.right+5, cardTextField.bottom+10, 126, 40)];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [verCodeBtn addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:verCodeBtn];
    
    
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, verCodeBtn.bottom + 15, SCREEN_WIDTH - 40, 40)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [confirmBtn addTarget:self action:@selector(confirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:confirmBtn];
    [self registerKeyBord];
    
    UIScrollView * textScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,confirmBtn.bottom+10 , SCREEN_WIDTH, SCREEN_HEIGHT -(confirmBtn.bottom+10))];
    textScrollView.backgroundColor = [UIColor whiteColor];
    textScrollView.showsVerticalScrollIndicator = NO;
    if (!iPhone5) {
        [textScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT -(confirmBtn.bottom+10) + 40)];
    }
    textScrollView.userInteractionEnabled = YES;

    [myScrollView addSubview:textScrollView];
    
    
    
   NSString *originStr = @"积分卡绑定规则：\n1、绑定的门店积分卡包括永辉超市所有门店的实体积分卡/会员卡。\n2、通过门店积分卡绑定操作，您可以合并您名下的所有积分；绑卡后，您所持有的线下积分卡仍可继续使用。\n3、开卡手机号是您办理会员卡时留存填写的手机号码。如果开卡手机号已停用，您可持会员卡和身份证件到任意永辉超市门店服务台进行更改，再完成积分卡绑定。\n4、若您账户内的联系手机号和办理门店积分卡填写的手机号码一致，在24小时内会有客服人员联系您进行身份的确认并帮您绑定积分卡。";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:originStr];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12] range:NSMakeRange(0, originStr.length)];
    CGSize size = CGSizeMake(280, 2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    NSString * str_Text = [NSString stringWithFormat:@"%@" , originStr];
    size = [str_Text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,10, SCREEN_WIDTH - 40, size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.text = originStr;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
//    CGSize size1 ;
//    if (IOS_VERSION >=7) {
//        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//        
//        NSDictionary *attributes = [NSDictionary dictionaryWithObject:titleLabel.font forKey:NSFontAttributeName];
//        
//        CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabel.frame.size.width, 9999) options:option attributes:attributes context:nil];
//        size1 = rect.size;
//    }else{
//        size1 = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(titleLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
//    }
//    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, size1.height);
    
    [textScrollView addSubview:titleLabel];
    
}
-(BOOL)isValid
{
    if (mobileTextField.text.length == 0)
    {
        [[iToast makeText:@"请输入手机号"] show];
        return NO;
    }
    else
    {
        if (![PublicMethod isMobileNumber:mobileTextField.text])
        {
            [[iToast makeText:@"手机号必须是11位以1开头的纯数字"]show];
            return NO;
        }
    
    }
    if (cardTextField.text.length == 0)
    {
        [[iToast makeText:@"请输入积分卡号"]show];
        return NO;
    }
    else
    {
        if (cardTextField.text.length != 13) {
            [[iToast makeText:@"请输入正确的积分卡号"]show];
            return NO;
        }
    
    }
    
    return YES;
}
-(void)confirmBtn:(id)sender
{
    if (![self isValid]) {
        return;
    }
    if(verCodeField.text.length == 0)
    {
        [[iToast makeText:@"请输入验证码"]show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *mobile = [NSString stringWithFormat:@"%@",mobileTextField.text];
    NSString *captcha = [NSString stringWithFormat:@"%@",verCodeField.text];
    NSString *card_no = [NSString stringWithFormat:@"%@",cardTextField.text];
//    [[NetTrans getInstance]user_member_bindCard:self mobile:mobile captcha:captcha card_no:card_no];
    [[NetTrans getInstance]API_YH_My_Card_Binding:self captcha:captcha card_no:card_no mobile:mobile];
    
}
#pragma mark - KeyBordDelegate
-(void)registerKeyBord {
    NSArray * tempArray = [[NSArray alloc] initWithObjects:mobileTextField,cardTextField,verCodeField,nil];
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
    [mobileTextField resignFirstResponder];
    [cardTextField resignFirstResponder];
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
    
    if (textField == cardTextField) {
        [myScrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    else if (textField == verCodeField) {
        [myScrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    else if (textField == mobileTextField)
    {
        [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
#pragma mark - 验证码
-(void)VerificationCode:(id)sender
{
    //验证码的输入的手机待定
    if (![self isValid])
    {
        return;
    }
    NSString * str_num;
    isSucee  = YES;
    //  获取输入的手机号
    str_num = [NSString stringWithFormat:@"%@",mobileTextField.text];
    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"card_bind"];
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
    //发送验证码
    if (t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        NSString *successStr = (NSString *)netTransObj;
        [self showAlert:successStr];
    }
    if (t_API_YH_MY_CARD_BINDING == nTag)
    {
        [[RefleshManager sharedRefleshManager]setBindCardRefresh:YES];
        NSString *successStr = (NSString *)netTransObj;
        [self showAlert:successStr];

        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [[iToast makeText:errMsg]show];
}
-(void)back:(id)sender
{
 
    [self.navigationController popViewControllerAnimated:YES];
    
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
