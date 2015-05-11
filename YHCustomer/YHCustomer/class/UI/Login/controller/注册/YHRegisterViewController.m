//
//  YHRegisterViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-12.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRegisterViewController.h"
#import "YHAppDelegate.h"
#import "YHOldResViewController.h"
#import "YHNewResViewController.h"

@interface YHRegisterViewController ()

@end

@implementation YHRegisterViewController

#pragma mark -----------------  初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
  
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    [PublicMethod addNavBackground:self.view title:@"注册"];
    [PublicMethod addBackViewWithTarget:self action:@selector(back:)];
    [self addView];
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
-(void)addView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, originY+44, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    [self.view addSubview:bgView];
    
    UIButton *upBgView = [[UIButton alloc]initWithFrame:CGRectMake(10, 20+44+10, SCREEN_WIDTH-20, 101)];
    upBgView.backgroundColor = [UIColor redColor];
    upBgView.tag = 100;
    [upBgView setBackgroundImage:[UIImage imageNamed:@"old_user_register"] forState:UIControlStateNormal];
    [upBgView setBackgroundImage:[UIImage imageNamed:@"old_user_register_select"] forState:UIControlStateHighlighted];
    [upBgView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBgView];
    
    UIButton *downBgView = [[UIButton alloc]initWithFrame:CGRectMake(10, upBgView.bottom+10, SCREEN_WIDTH-20, 102)];
    downBgView.tag = 101;
    [downBgView setBackgroundImage:[UIImage imageNamed:@"new_user_reg"] forState:UIControlStateNormal];
    [downBgView setBackgroundImage:[UIImage imageNamed:@"new_user_reg_selected"] forState:UIControlStateHighlighted];
    downBgView.backgroundColor = [UIColor redColor];
    [downBgView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, downBgView.bottom+20, SCREEN_WIDTH-20, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"现在加入永辉微店，消费享双倍积分";
    label.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark -------------------------按钮事件处理
-(void)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
//        [self dismissModalViewControllerAnimated:YES];
        YHOldResViewController *oldVC = [[YHOldResViewController alloc]init];
        [self presentModalViewController:oldVC animated:YES];
    } else {
        YHNewResViewController *newVC = [[YHNewResViewController alloc]init];
        [self presentModalViewController:newVC animated:YES];
    }
}

-(void)back:(id)sender {
   [self dismissModalViewControllerAnimated:YES];
}


@end
