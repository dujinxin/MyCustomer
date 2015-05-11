//
//  YHModifyNameViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHModifyNameViewController.h"
#import "YHAppDelegate.h"
#import "RefleshManager.h"
#import "YHAccountManagerViewController.h"

@interface YHModifyNameViewController ()

@end

@implementation YHModifyNameViewController

@synthesize _strNewName;
@synthesize _oldName;
@synthesize _commitBtn;

#pragma mark --------------------------初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(IOS_VERSION>=7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.navigationItem.title = @"修改昵称";
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addNameFieldEditView];
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

#pragma mark ------------------------- add UI
-(void)addNameFieldEditView
{
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    //输入新密码
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 40)];
    view.backgroundColor = [UIColor clearColor];
    
    CALayer *layer = [view layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = 3.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    
    UITextField *passwordTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, self.view.frame.size.width-40-20, 40)];
    //passwordTxtField.secureTextEntry = YES;
    passwordTxtField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTxtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTxtField.returnKeyType = UIReturnKeyDone;
    passwordTxtField.placeholder = self._oldName;
    passwordTxtField.delegate = self;
    passwordTxtField.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:passwordTxtField];

    [self.view addSubview:view];

    
    
    //提交button
    self._commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self._commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self._commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
//    [self._commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    [self._commitBtn setBackgroundImage:[PublicMethod imageWithColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]] forState:UIControlStateNormal];

    self._commitBtn.frame = CGRectMake(20, 80, 280, 44);
    [self._commitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    self._commitBtn.enabled = NO;
    [self._commitBtn addTarget:self action:@selector(changeNameButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self._commitBtn];
    
}
#pragma mark ------------------------- Button click event
-(void)BackButtonClickEvent:(id)sender
{
    [[YHAppDelegate appDelegate] hideTabBar:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeNameButtonClickEventHandler:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
//    [self.view endEditing:YES];
    if (self._strNewName.length == 0) {
        [[iToast makeText:@"请输入昵称"] show];
        return;
//        _commitBtn.enabled = NO;
    }else if(self._strNewName.length > 15){
        [[iToast makeText:@"字符个数不能大于15"] show];
        return;
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetTrans getInstance] user_modifyPersonInfo:self UserName:self._strNewName Email:nil Mobile:nil Intro:nil TrueName:nil Gender:nil PhotoId:nil ShoppingWall:nil];
    }
}
#pragma mark --------------------------UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    _commitBtn.enabled = YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self._strNewName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
#pragma mark --------------------------from super view data
-(void)setOriName:(NSString*)name
{
    self._oldName = name;
}
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(t_API_USER_PLATFORM_MODIFYINFO_API == nTag)
    {
        [[RefleshManager sharedRefleshManager] setAccountManagerRefresh:YES];
        [[iToast makeText:@"修改个人资料成功"]show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(t_API_USER_PLATFORM_MODIFYINFO_API == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3]) {
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
