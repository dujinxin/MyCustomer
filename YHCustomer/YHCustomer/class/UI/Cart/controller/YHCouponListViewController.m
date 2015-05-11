//
//  YHCouponListViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-2-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  优惠券列表

#import "YHCouponListViewController.h"

@interface YHCouponListViewController ()

@end

@implementation YHCouponListViewController
@synthesize dataArray;
@synthesize selectIndexPath;
@synthesize selectDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"优惠券";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    
    self._tableView.frame = CGRectMake(0, 0, 320, ScreenSize.height-NAVBAR_HEIGHT);
    self._tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self._tableView.tableHeaderView = [self addTableViewHeaderView];
    
    [self.refreshHeaderView removeFromSuperview];
    self.refreshHeaderView = nil;
}

- (UILabel *)addTableViewHeaderView{
    UILabel *headerView = [PublicMethod addLabel:CGRectMake(13, 15, 292, 27) setTitle:@"每笔订单最多使用一张优惠券" setBackColor:[PublicMethod colorWithHexValue:0x858584 alpha:1] setFont:[UIFont systemFontOfSize:15]];
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.backgroundColor = [PublicMethod colorWithHexValue:0xfff7d1 alpha:1.0f];
    return headerView;
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 119.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *cellarray = [tableView visibleCells];
    
    for (UITableViewCell *cell in cellarray) {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
    }
    
    //  如果再次选中此优惠券
    if ([self.selectIndexPath isEqual:indexPath]) {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
        _successCallBlock(nil);
    }else{
        [cell addSubview:[PublicMethod addImageView:CGRectMake(15, 20, 290, 92) setImage:@"cat_coupon_Select.png"]];
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        _successCallBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 290, 92)];
    bgImg.image = [UIImage imageNamed:@"cart_yonghui_CoupoonBg.png"];
    [cell.contentView addSubview:bgImg];
    
    UIImageView *bgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 67, 67)];
    bgLogo.image = [UIImage imageNamed:@"cart_yonghui_logo.png"];
    [bgImg addSubview:bgLogo];
    
    UILabel *titleName = [PublicMethod addLabel:CGRectMake(100, 14, 160, 40) setTitle:[dic objectForKey:@"title"] setBackColor:[UIColor redColor] setFont:[UIFont systemFontOfSize:18]];
    titleName.numberOfLines =0;
    [bgImg addSubview:titleName];
    
    UILabel *description = [PublicMethod addLabel:CGRectMake(100, 44, 190, 50) setTitle:[NSString stringWithFormat:@"有效日期: %@-%@",[dic objectForKey:@"start_time"],[dic objectForKey:@"end_time"]] setBackColor:[UIColor lightGrayColor] setFont:[UIFont systemFontOfSize:14]];
    [bgImg addSubview:description];
    
    if ([self.selectDictionary isEqual:dic]) {
        self.selectIndexPath = indexPath;
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 290, 92)];
        bgImg.image = [UIImage imageNamed:@"cat_coupon_Select.png"];
        [cell.contentView addSubview:bgImg];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
