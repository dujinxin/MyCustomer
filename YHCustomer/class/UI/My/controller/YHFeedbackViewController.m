//
//  YHFeedbackViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-19.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHFeedbackViewController.h"
#import "UIPlaceHolderTextView.h"
#import "UIView+Addition.h"

@interface YHFeedbackViewController ()

@end

@implementation YHFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"意见反馈";
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addTextAndButton];
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
- (void)addTextAndButton
{
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    UIPlaceHolderTextView *message = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 10, 300, 150)];
    if (IOS_VERSION<7) {
        message.frame = CGRectMake(18, 18, 284, 150);
    }
    message.font = [UIFont systemFontOfSize:13];
    message.returnKeyType = UIReturnKeyDone;
    message.delegate = self;
    message.layer.borderColor = [UIColor lightGrayColor].CGColor;
    message.layer.borderWidth =0.5;
    message.layer.cornerRadius =2.0;;
    message.placeholder = @"请输入对产品的意见和建议";
    message.backgroundColor = [UIColor clearColor];

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(message.right-60, message.bottom-15, 50, 10)];
    [image setImage:[UIImage imageNamed:@"less140"]];
    [self.view addSubview:image];
    [self.view addSubview:message];

    
    //提交button
    commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 180, 300, 44)];
    if (IOS_VERSION<7) {
        commitBtn.frame = CGRectMake(18, 180, 284, 44);
    }
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateDisabled];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    commitBtn.enabled = NO;
    [commitBtn addTarget:self action:@selector(onCommitButtonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCommitButtonClickHandle:(id)sender
{
    [self.view endEditing:YES];
    if (feedBackText.length == 0) {
        [[iToast makeText:@"请输入意见或建议"] show];
        return;
    } else if (feedBackText.length>140) {
        [[iToast makeText:@"字数超过140"] show];
        return;
    }
    [[NetTrans getInstance] API_user_feed_back:self Content:feedBackText];
}

#pragma mark --------------------------------UITextView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    commitBtn.enabled = YES;
    if (textView.text) {
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        feedBackText = [textView.text stringByTrimmingCharactersInSet:whitespace];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text) {
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        feedBackText = [textView.text stringByTrimmingCharactersInSet:whitespace];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (t_API_USER_FEED_BACK == nTag)
    {
        [[iToast makeText:@"提交成功,感谢您的意见"] show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if (t_API_USER_FEED_BACK == nTag)
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
        [[iToast makeText:@"提交失败,非常抱歉"] show];
    }
}

@end
