//
//  YHRootViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  公共controller

#import "YHRootViewController.h"

@interface YHRootViewController ()

@end

@implementation YHRootViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
     self.isVisible = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
     self.isVisible = NO;
}

/*右侧按键*/
- (void)setRightBarButton:(id)trans Action:(SEL)action SetImage:(NSString *)imgString SelectImg:(NSString *)imgHight{
    [self setRightBarButton:trans Action:action SetImage:imgString SelectImg:imgHight title:nil];
}
- (void)setRightBarButton:(id)trans Action:(SEL)action SetImage:(NSString *)imgString SelectImg:(NSString *)imgHight title:(NSString *)title{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:imgString] forState:UIControlStateNormal];
    if (!imgString) {
        rightBtn.frame = CGRectMake(0, 0, 52, 44);
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn setTitleColor:[PublicMethod colorWithHexValue:0xe70012 alpha:1.0] forState:UIControlStateNormal];
    }
//    [rightBtn setBackgroundImage:[UIImage imageNamed:imgString] forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:imgHight] forState:UIControlStateHighlighted];
    [rightBtn addTarget:trans action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
//    if (IOS_VERSION >= 7) {
//        negativeSpacer.width = -15;
//    }else{
//        negativeSpacer.width = -5;
//    }
    if (title) {
        if (IOS_VERSION >= 7) {
            negativeSpacer.width = -15;
        }else{
            negativeSpacer.width = -5;
        }
    }
    NSMutableArray *buttonArray= [NSMutableArray arrayWithObjects:negativeSpacer,rightBarItem, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
}

- (void)setNavigationTitle:(NSString *)title{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
}

- (void)showAlert:(NSString *)message{
    [self showAlert:nil Message:message];
}

- (void)showAlert:(id)target Message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message
                                                   delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)showAlert:(id)target newMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message
                                                   delegate:target cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)showNotice:(NSString *)string
{
    [[iToast makeText:string] show];
}

- (BOOL)checkNetreachability{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
