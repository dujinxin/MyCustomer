//
//  YHCartLoginViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-18.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHCartLoginViewController.h"

@interface YHCartLoginViewController ()

@end

@implementation YHCartLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, originY, 52, 44);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close.png"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"cart_Close_Select.png"] forState:UIControlStateHighlighted];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];

    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [PublicMethod addNavBackground:self.view title:@"购物车"];
    [self.view addSubview:backBtn];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13.5, 100, 293, 269)];
    imageView.image = [UIImage imageNamed:@"cart_loginBg.png"];
    [self.view addSubview:imageView];
    
	// Do any additional setup after loading the view.
    UIButton *cartBtnLogin = [PublicMethod addButton:CGRectMake(60, ScreenSize.height -80, 196, 51) title:@"立即登录" backGround:@"cart_login.png" setTag:1000 setId:self selector:@selector(loginAction:) setFont:[UIFont systemFontOfSize:17] setTextColor:[UIColor blackColor]];
    [cartBtnLogin setBackgroundImage:[UIImage imageNamed:@"cart_login_Select.png"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:cartBtnLogin];
}


- (void)back:(id)sender{
    _callBack();
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

- (void)loginAction:(id)sender{
    YHLoginViewController *login = [[YHLoginViewController alloc] init];
    login.loginSuccessBlock = _loginSuccessBlock;
    login.logOutType = LogOut_Usual;
    [self presentModalViewController:login animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
