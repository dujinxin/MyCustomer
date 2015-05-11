//
//  YHGenderSettingViewController.m
//  YHCustomer
//
//  Created by kongbo on 13-12-17.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHGenderSettingViewController.h"
#import "RefleshManager.h"

@interface YHGenderSettingViewController ()

@end

@implementation YHGenderSettingViewController

#pragma mark --------------------------初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"选择性别";
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addTableView];
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
-(void)addTableView {
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    /* uitable view */
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height-NAVBAR_HEIGHT) style:UITableViewStyleGrouped];
    tableview.backgroundView = bgview;
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableview];
}

#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_info_one"]]];
    }
    switch (indexPath.section) {
        case 0:
        {
            
            cell.textLabel.text = @"男";
            //勾
            if ([self.gender isEqualToString:@"1"]) {
                UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 13, 20, 20)];
                if (IOS_VERSION<7) {
                    arrow.frame = CGRectMake(SCREEN_WIDTH-60, 13, 20, 20);
                }
                [arrow setImage:[UIImage imageNamed:@"gender_choose"]];
                [cell.contentView addSubview:arrow];
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"女";
             //勾
            if ([self.gender isEqualToString:@"2"]) {
                UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 13, 20, 20)];
                if (IOS_VERSION<7) {
                    arrow.frame = CGRectMake(SCREEN_WIDTH-60, 13, 20, 20);
                }
                [arrow setImage:[UIImage imageNamed:@"gender_choose"]];
                [cell.contentView addSubview:arrow];
            }
            
        }
            break;
        default:
            break;
    }
    return cell;
    
}

#pragma mark -------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            [[NetTrans getInstance] user_modifyPersonInfo:self UserName:nil Email:nil Mobile:nil Intro:nil TrueName:nil Gender:@"1" PhotoId:nil ShoppingWall:nil];
        }
            
            break;
        case 1:
        {
            [[NetTrans getInstance] user_modifyPersonInfo:self UserName:nil Email:nil Mobile:nil Intro:nil TrueName:nil Gender:@"2" PhotoId:nil ShoppingWall:nil];
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

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
 
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_USER_PLATFORM_MODIFYINFO_API == nTag)
        
    {
        [[RefleshManager sharedRefleshManager] setAccountManagerRefresh:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[iToast makeText:@"修改个人资料成功"]show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_USER_PLATFORM_MODIFYINFO_API == nTag)
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
