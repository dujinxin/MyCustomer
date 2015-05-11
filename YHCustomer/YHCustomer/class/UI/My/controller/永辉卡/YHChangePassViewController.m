//
//  YHChangePassViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/11/18.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHChangePassViewController.h"

@interface YHChangePassViewController ()
{
    UITextField * myText_1;
    UITextField * myText_2;
    UITextField * myText_3;
    UITextField * myText_4;
    UIButton * btn_1;
    UIScrollView * myScrollView;
    float originY;
    int numTitle;
    NSTimer *time;
    BOOL isSucee;
}
@end

@implementation YHChangePassViewController
@synthesize card_no;
@synthesize entityCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.view.backgroundColor = [UIColor whiteColor];
        // Custom initialization
        if (IOS_VERSION >= 7) {
            originY = 20;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}
#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    [self addNavRightButton];
    [self addUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    [[NetTrans getInstance] user_getPersonInfo:self setUserId:[UserAccount instance].user_id];
    self.navigationItem.title = @"修改支付密码";
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [[NetTrans getInstance] API_Sign_Info:self];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
    //    [MTA trackPageViewBegin:PAGE16];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
//     [[NetTrans getInstance] cancelRequestByUI:self];
    //    [MTA trackPageViewEnd:PAGE16];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [time invalidate];
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

#pragma mark ----------------------- addUI
-(void)addNavRightButton
{
    self.view.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];//0xeeeeee
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
}
-(void)addUI
{
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (!iPhone5) {
        [myScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+60)];
    }
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.userInteractionEnabled = YES;
    [self.view addSubview:myScrollView];
    
    UIImageView * my_img_1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 40)];
    my_img_1.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    my_img_1.layer.borderWidth = 1;
    my_img_1.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    [myScrollView addSubview:my_img_1];
    
    myText_1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 20)];
    myText_1.placeholder = @"请输入旧密码";
    myText_1.delegate = self;
    myText_1.secureTextEntry = YES;
     myText_1.keyboardType = UIKeyboardTypeNumberPad;
    myText_1.clearButtonMode = UITextFieldViewModeWhileEditing;
    myText_1.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:myText_1];
    
    UIImageView * my_img_2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(my_img_1.frame)+10, [UIScreen mainScreen].bounds.size.width-20, 40)];
    my_img_2.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    my_img_2.layer.borderWidth = 1;
    my_img_2.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    [myScrollView addSubview:my_img_2];
    
    myText_2 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(my_img_1.frame)+20, [UIScreen mainScreen].bounds.size.width-40, 20)];
    myText_2.placeholder = @"请输入新密码";
    myText_2.delegate = self;
    myText_2.secureTextEntry = YES;
     myText_2.keyboardType = UIKeyboardTypeNumberPad;
    myText_2.clearButtonMode = UITextFieldViewModeWhileEditing;
    myText_2.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:myText_2];
    
    UIImageView * my_img_4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(my_img_2.frame)+10, [UIScreen mainScreen].bounds.size.width-20, 40)];
    my_img_4.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    my_img_4.layer.borderWidth = 1;
    my_img_4.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    [myScrollView addSubview:my_img_4];
    
    myText_4 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(my_img_2.frame)+20, [UIScreen mainScreen].bounds.size.width-40, 20)];
    myText_4.placeholder = @"请重复新密码";
    myText_4.delegate = self;
    myText_4.secureTextEntry = YES;
     myText_4.keyboardType = UIKeyboardTypeNumberPad;
    myText_4.clearButtonMode = UITextFieldViewModeWhileEditing;
    myText_4.returnKeyType = UIReturnKeyNext;
    [myScrollView addSubview:myText_4];
    
    UIImageView * my_img_3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(my_img_4.frame)+10, [UIScreen mainScreen].bounds.size.width-151, 40)];
    my_img_3.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    my_img_3.layer.borderWidth = 1;
    my_img_3.layer.borderColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"].CGColor;
    [myScrollView addSubview:my_img_3];
    
    myText_3 = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(my_img_4.frame)+20, [UIScreen mainScreen].bounds.size.width-170, 20)];
    myText_3.placeholder = @"请输入验证码";
    myText_3.delegate = self;
    myText_3.autoresizesSubviews = YES;
    myText_3.keyboardType = UIKeyboardTypeNumberPad;
    myText_3.textAlignment = NSTextAlignmentCenter;
    [myScrollView addSubview:myText_3];
    
    btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(my_img_3.frame)+5, CGRectGetMaxY(my_img_4.frame)+10, 126, 40)];
    [btn_1 setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [btn_1 addTarget:self action:@selector(VerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btn_1];
    
    UIButton * btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(my_img_3.frame)+20, [UIScreen mainScreen].bounds.size.width-20, 40)];
    [btn_2 setTitle:@"保存" forState:UIControlStateNormal];
    [btn_2 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    [btn_2 addTarget:self action:@selector(activation:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:btn_2];
    [self registerKeyBord];
}

#pragma mark      -------------------------     btn click

-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)isVaild
{
    
    if (myText_1.text.length == 0)
    {
        [[iToast makeText:@"请输入原密码"]show];
        return NO;
    }
    else
    {
        //亲，密码只能为6位数字哦！
        if (myText_1.text.length != 6)
        {
            [[iToast makeText:@"亲，密码只能为6位数字哦！"]show];
            return NO;
            
        }
    }
    if (myText_2.text.length == 0)
    {
        [[iToast makeText:@"请输入新密码"]show];
        return NO;
    }
    else
    {
        //亲，密码只能为6位数字哦！
        if (myText_2.text.length != 6)
        {
            [[iToast makeText:@"亲，密码只能为6位数字哦！"]show];
            return NO;
            
        }
    }
    if (myText_4.text.length == 0)
    {
        [[iToast makeText:@"请重复输入新密码"]show];
        return NO;
    }
    else
    {
        //亲，密码只能为6位数字哦！
        if (![myText_4.text isEqualToString:myText_2.text])
        {
            [[iToast makeText:@"新密码和重复输入的新密码不一致！"]show];
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
    //mobile
    str_num = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    [[NetTrans getInstance] user_getVercode:self Mobile:str_num setType:@"pay_password"];
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
        [btn_1 setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [btn_1 setEnabled:YES];
    }
    else
    {
        [btn_1 setEnabled:NO];
        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
        NSString * str_num = [NSString stringWithFormat:@"重新获取(%d)" , numTitle];
        NSLog(@"%@" , str_num);
        [btn_1 setTitle:str_num forState:UIControlStateNormal];
        btn_1.titleLabel.text = str_num;
//        NSLog(@"%@" , btn_1.titleLabel.text);
        numTitle--;
//        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    }
}

-(void)activation:(id)sender
{


    if (![self isVaild]) {
        return;
    }
    if (myText_3.text.length == 0)
    {
        [[iToast makeText:@"请输入验证码"]show];
        return;
    }
    else
    {
        if (myText_3.text.length != 6)
        {
            [[iToast makeText:@"请输入6位数字的验证码"]show];
            return;
            
        }
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_YH_Card_Update_Pwd:self OldPwd:myText_1.text Pwd:myText_2.text PwdAgain:myText_4.text Captcha:myText_3.text block:^(NSString *someThing)
     {
         if ([someThing isEqualToString:WEB_STATUS_4])
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
     }];

    
}

#pragma mark ------------ delegate
-(void)registerKeyBord {
    NSArray * tempArray = [[NSArray alloc] initWithObjects:myText_1,myText_2,myText_4, myText_3,nil];
    keyBoard =[[KeyBoardTopBar alloc] initWithArray:tempArray];
    
   	[keyBoard  setAllowShowPreAndNext:YES];
    keyBoard.delegate = self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [keyBoard ShowBar:textField];
    
    if (textField == myText_2) {
        [myScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(myText_1.frame)) animated:YES];
    } else if (textField == myText_3) {
        [myScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(myText_4.frame)+10) animated:YES];
    } else if (textField == myText_4) {
        [myScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(myText_2.frame)+10) animated:YES];
    }
    else if (textField == myText_1)
    {
        [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString * strValue = [textField.text stringByAppendingString:string];
//    if ([strValue floatValue] > 999999)
//    {
//        [textField.text stringByReplacingCharactersInRange:range withString:@""];
//        [self showAlert:@"亲，密码为6位数字哦！"];
//        return NO;
//    }
//    return YES;
//}
-(void)keyBoardTopBarConfirmClicked:(UITextField *)textField
{
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myText_1 resignFirstResponder];
    [myText_2 resignFirstResponder];
    [myText_3 resignFirstResponder];
    [myText_4 resignFirstResponder];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_YH_CARD_UPDATE_PWD == nTag)
    {
        NSString *successStr = (NSString *)netTransObj;
        [self.navigationController popViewControllerAnimated:YES];
        [[iToast makeText:successStr] show];
    }
    else if (t_API_USER_PLATFORM_VERCODE_API == nTag)//发送验证码成功
    {
        isSucee = YES;

        //提示验证码发送成功
        NSString *successStr = (NSString *)netTransObj;
        [self showAlert:successStr];

    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_YH_CARD_UPDATE_PWD == nTag)
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
            [[iToast makeText:errMsg]show];
        }
    }
    else if(t_API_USER_PLATFORM_VERCODE_API == nTag)
    {
        isSucee = NO;
        [btn_1 setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn_1 setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
        [btn_1 setEnabled:YES];
        [[iToast makeText:errMsg]show];
    }
    
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
