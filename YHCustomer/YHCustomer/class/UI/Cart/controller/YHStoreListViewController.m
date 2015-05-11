//
//  YHStoreListViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  门店列表

#import "YHStoreListViewController.h"

@interface YHStoreListViewController ()

@end

@implementation YHStoreListViewController
@synthesize storeArray;
@synthesize store;
@synthesize buname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        storeArray = [NSMutableArray arrayWithObjects:@"永辉金祥店",@"永辉汇达店",@"永辉福新店",@"永辉福湾店",@"永辉新天宇店",@"永辉大儒世家店",@"永辉江南水都店",@"永辉黎明店", nil];
        storeArray = [[NSMutableArray alloc] init];
//        listEntity = [[BuListEntity alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NetTrans getInstance] getBuList:self Page:@"1" Limit:@"10"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"门店列表";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BuListEntity *listEntity = [storeArray objectAtIndex:indexPath.row];
    _storeBlock(listEntity);
    [self back:nil];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return storeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    [cell.contentView removeAllSubviews];
    
    BuListEntity *listEntity = [storeArray objectAtIndex:indexPath.row];
    if ([listEntity.bu_id isEqualToString:store.bu_id] || [self.buname isEqualToString:listEntity.bu_name]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@",listEntity.bu_name];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 300, 20)];
    address.text = [NSString stringWithFormat:@"地址:%@",listEntity.address];
    address.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:address];

    return cell;
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    
    
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_BUY_PLATFORM_BU_LIST) {
        self.storeArray = (NSMutableArray *)netTransObj;
        [self._tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
