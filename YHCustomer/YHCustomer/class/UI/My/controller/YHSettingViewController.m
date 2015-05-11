//
//  YHSettingViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHSettingViewController.h"
#import "YHModifyPwdViewController.h"
#import "YHLoginViewController.h"
#import "YHAboutViewController.h"
#import "YHFadeBackListViewController.h"
#import "YHHelpViewController.h"
#import "VersionEntiy.h"

enum{
    ENUM_IMAGE_TAG = 100,
    ENUM_LABEL_TAG,
    ENUM_ARROW_TAG,
};

@interface YHSettingViewController ()

@end

@implementation YHSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"系统设置";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addTableView];
    [self addLogoutButton];
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

#pragma mark -----------------  add  UI
-(void)addTableView {
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 250) style:UITableViewStyleGrouped];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setBackgroundColor:[UIColor whiteColor]];
    [tableview setBackgroundView:nil];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableview.scrollEnabled  = NO;
    
    [self.view addSubview:tableview];
}

-(void)addLogoutButton {
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
    logoutBtn.frame = CGRectMake(10, 300, 300, 44);
    if (IOS_VERSION<7) {
        logoutBtn.frame = CGRectMake(18, 300, 284, 44);
    }
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [logoutBtn setTitle:@"退出当前用户" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn_selected"] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    _logoutBtn = logoutBtn;
}

#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
//            return 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //cell的image
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 20, 20)];
        imagev.tag = ENUM_IMAGE_TAG;
        [cell.contentView addSubview:imagev];
        
        //cell 的name
        UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(44, 11, cell.frame.size.width-130-60, 20)];
        labName.tag = ENUM_LABEL_TAG;
        labName.backgroundColor = [UIColor clearColor];
        labName.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:labName];
        
        //小箭头
        UIImageView *imgvDic = nil;
        if (IOS_VERSION >= 7) {
            imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-45, 10, 22, 22)];
        }else{
            imgvDic = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-65, 10, 22, 22)];
        }
        imgvDic.tag = ENUM_ARROW_TAG;
        [imgvDic setImage:[UIImage imageNamed:@"my_access.png"]];
        [cell.contentView addSubview:imgvDic];
         [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_one"]]];
    }
    switch (indexPath.section) {
        case 0:
        {
            UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
            [imagev setImage:[UIImage imageNamed:@"modify_psw"]];
            UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
            label.textColor = [UIColor blackColor];
            label.text = @"修改密码";
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
                    [imagev setImage:[UIImage imageNamed:@"about"]];
                    UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
                    label.textColor = [UIColor blackColor];
                    label.text = @"关于产品";
                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_top"]]];
                }
                    break;
//                case 1:
//                {
//                    UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
//                    [imagev setImage:[UIImage imageNamed:@"update"]];
//                    UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
//                    label.textColor = [UIColor blackColor];
//                    label.text = @"版本更新";
//                    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_two_bottom"]]];
//                }
//                    break;
                    
                default:
                    break;
            }

        }
            break;
        case 2:
        {
            UIImageView *imagev = (UIImageView*)[cell viewWithTag:ENUM_IMAGE_TAG];
            [imagev setImage:[UIImage imageNamed:@"help"]];
            UILabel *label = (UILabel*)[cell viewWithTag:ENUM_LABEL_TAG];
            label.textColor = [UIColor blackColor];
            label.text = @"帮助";
        }
            break;
        default:
            break;
        }
    return cell;
    
}

#pragma mark -------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            YHModifyPwdViewController *resetPwdVC = [[YHModifyPwdViewController alloc] init];
            [self.navigationController pushViewController:resetPwdVC animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    YHAboutViewController *aboutVC = [[YHAboutViewController alloc] init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
//                case 1:
//                {
//                    [[NetTrans getInstance] API_version_check:self AgentID:@"2" Type:@"consumer"];
//                }
//                    break;
                    
                default:
                    break;
            }
     
        }
            break;
        case 2:
        {
            YHHelpViewController *helpVC = [[YHHelpViewController alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;

        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else
        return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 1)];
    head.backgroundColor = [UIColor clearColor];
    return head;
}

#pragma mark ----------------  button action
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonAction:(UIButton *)button {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1)
    {
        [[NetTrans getInstance] user_loginOut:self];
    }
    
    // 强制更新
    if (isForceUpdate == YES && alertView.tag == 1002) {
        NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
    
    // 提示更新
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSURL *iTunesURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/yong-hui-wei-dian/id789250833?mt=8"];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_USER_PLATFORM_LOGIN_OUT_API == nTag)
    {
//        [self.navigationController popViewControllerAnimated:YES];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
        [[UserAccount instance] logout];
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];

    }
    if (t_API_VERSION == nTag)
    {
        VersionEntiy *version = (VersionEntiy *)netTransObj;
        NSString *verNum = version._version;
        if ([version.force_update integerValue] == 1&&verNum.integerValue > K_VERSION_CODE)
        { //强制更新bool
            isForceUpdate = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"永辉微店有新版啦！" message:[NSString stringWithFormat:@"\n%@",version.version_caption] delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上更新", nil];
            alert.tag = 1002;
            [alert show];
        }
        else
        {
            if (verNum.integerValue > K_VERSION_CODE)
            {
                //前往appstore下载
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"永辉微店有新版啦！" message:[NSString stringWithFormat:@"\n%@",version.version_caption] delegate:self cancelButtonTitle:@"一会再说" otherButtonTitles:@"马上更新", nil];
                alert.tag = 1001;
                [alert show];
            }
            else
            {
                [[iToast makeText:@"目前是最新版"] show];
            }
        }
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if(t_API_USER_PLATFORM_LOGIN_OUT_API == nTag)
    {
        [[iToast makeText:errMsg]show];
    }
}

@end
