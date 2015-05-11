//
//  YHBindVipCardViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-17.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHBindVipCardViewController.h"

@interface YHBindVipCardViewController ()

@end

@implementation YHBindVipCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"完善资料";
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addDownView];
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
-(void)addDownView
{
    //密码输入框
    CGRect inputRect = CGRectMake(160 - 276/2, 35 , 276, 42);
    cardField = [[UITextField alloc] initWithFrame:inputRect];
    cardField.autocorrectionType = UITextAutocorrectionTypeNo;
    cardField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cardField.placeholder = @"请输入该积分卡对应的证件号码";
    
    cardField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cardField.returnKeyType = UIReturnKeyDone;
    cardField.textAlignment = UITextAlignmentCenter;
    cardField.delegate = self;
    cardField.background = [UIImage imageNamed:@"passwordBg.png"];
    [self.view addSubview:cardField];
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(160-276/2.0, cardField.bottom + 15, 276, 42);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    [commitBtn addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------------  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --------------------  button action
-(void)commitButtonClicked:(UIButton *)button
{
    [self.view endEditing:YES];
    
    if (cardField.text.length == 0) {
        [self showNotice:@"请输入身份证号"];
        return;
    }
    
    [[NetTrans getInstance] user_bindMemberCard:self CardNumber:cardField.text ];
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_USER_PLATFORM_BINDCARD_API == nTag)
        
    {
        [[iToast makeText:(NSString *)netTransObj]show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if(t_API_USER_PLATFORM_BINDCARD_API == nTag)
        
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
}

@end
