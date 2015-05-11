//
//  YHCustomerServiceViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-4-24.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHCustomerServiceViewController.h"
#import "YHPSDeliveryArgumentViewController.h"
#import "YHPSReturnViewController.h"
#import "YHGoodsReturnViewController.h"
#import "YHFadeBackListViewController.h"

@interface YHCustomerServiceViewController ()

@end

@implementation YHCustomerServiceViewController

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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"客户服务";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"", @selector(back:));
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    
    self._tableView.backgroundColor = [UIColor clearColor];
    self._tableView.backgroundView = nil;
    self._tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self._tableView.tableHeaderView = [self tableViewHeaderView];
    
}

/* 添加下拉view */
- (void)addRefreshTableHeaderView{
    
}

/*加载更多view*/
- (void)addGetMoreFootView{
    
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            YHPSReturnViewController *tuihuo = [[YHPSReturnViewController alloc] init];
            [self.navigationController pushViewController:tuihuo animated:YES];
            
        }
            break;
        case 1:
        {
            YHPSDeliveryArgumentViewController *deliveryArgument = [[YHPSDeliveryArgumentViewController alloc] init];
            [deliveryArgument setUrlType:@"1"];
            [self.navigationController pushViewController:deliveryArgument animated:YES];
            
        }
            break;
        case 4:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"客服工作时间 : 每日 7:00-21:00" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-100-9333", nil];
            [sheet showInView:self.view];
        }
            break;
        case 3:{
            
            YHFadeBackListViewController *feedbackV = [[YHFadeBackListViewController alloc] init];
            [self.navigationController pushViewController:feedbackV animated:YES];
        }
            break;
        case 2:{
            YHPSDeliveryArgumentViewController *deliveryArgument = [[YHPSDeliveryArgumentViewController alloc] init];
            [deliveryArgument setUrlType:@"2"];
            [self.navigationController pushViewController:deliveryArgument animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    [cell.contentView removeAllSubviews];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgCell = [PublicMethod addBackView:CGRectMake(0, 0, 320, 40) setBackColor:[UIColor whiteColor]];
    [cell.contentView addSubview:bgCell];
    
    UIImageView *accessImg = [PublicMethod addImageView:CGRectMake(295, 9, 22, 22) setImage:@"my_access.png"];
    
    UILabel *title = [PublicMethod addLabel:CGRectMake(10, 10, 200, 20) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:15]];
    
    switch (indexPath.section) {
        case 0:{
            title.text = @"退货服务";
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:accessImg];
            
        }
            break;
        case 1:
        {
            title.text = @"购物指南";
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:accessImg];
            
        }
            break;
        case 4:{
            title.text = @"服务电话";
            UILabel *telephone = [PublicMethod addLabel:CGRectMake(200, 10, 100, 20) setTitle:@"4001009333" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
            telephone.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:telephone];
        }
            break;
            
        case 3:{
            title.text = @"意见反馈";
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:accessImg];
        }
            break;
        case 2:{
            title.text = @"售后保障";
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:accessImg];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma -mark
#pragma - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001009333"]];//打电话
    }
}


- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
