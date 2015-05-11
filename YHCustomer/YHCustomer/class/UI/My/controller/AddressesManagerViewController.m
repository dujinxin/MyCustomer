//
//  AddressesManagerViewController.m
//  THCustomer
//
//  Created by ioswang on 13-9-28.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "AddressesManagerViewController.h"
#import "AddNewAddressViewController.h"

enum{
    TAG_ORDER_ADDRESS_NAME = 100,
    TAG_ORDER_ADDRESS_MOBILE,
    TAG_ORDER_ADDRESS_ADDRESS,
    TAG_ORDER_ADDRESS_SETDEFAULT,
    TAG_ORDER_ADDRESS_EDIT,
};

@interface AddressesManagerViewController ()

@end

@implementation AddressesManagerViewController
@synthesize _tableView;
@synthesize _arrAddress;
@synthesize _indexPath;
@synthesize fromMore;
@synthesize addressDefaultCallBack;
@synthesize entityID;
#pragma mark-----------------------释放资源
-(void)dealloc{
    
    [_tableView release];
    [_arrAddress release];
    [_indexPath release];
    if (addressDefaultCallBack) {
        addressDefaultCallBack = nil;
    }
    //取消网络请求
//    [[NetTrans getInstance] cancelRequestByUI:self];
    [super dealloc];
}

#pragma mark----------------------初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(IOS_VERSION>=7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        
        NSMutableArray *addressArr = [[NSMutableArray alloc] init];
        self._arrAddress = addressArr;
        [addressArr release];
        if (fromMore) {
            self.navigationItem.title = @"收货地址管理";
        }else{
            self.navigationItem.title = @"选择收货地址";
        }
    }
    return self;
}
#pragma mark --------------------------声明周期

-(void)loadView
{
    [super loadView];
    [self addNavigationBackButton];
    [self addResetView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //获取地址列表
    [self loadDataFromServer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
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

#pragma mark --------------------------添加UI
-(void)setNavTitle:(NSString *)title {
    self.navigationItem.title = title;
}
-(void)addNavigationBackButton
{
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"新增", @selector(addNewAddressButtonClickEvent:));
}
- (void)addResetView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenSize.height-NAVBAR_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundView:nil];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    tableView.delegate = self;
    tableView.dataSource = self;
    self._tableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
}
#pragma mark --------------------------button Action
-(void)BackButtonClickEvent:(id)sender
{

    for (OrderAddressEntity *entity in self._arrAddress) {
        if ([entity.ID isEqualToString:entityID]) {
            addressDefaultCallBack(entity,self._arrAddress);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    if (!fromMore) {
        addressDefaultCallBack(nil,self._arrAddress);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 * brief 添加地址按钮事件处理
 */
-(void)addNewAddressButtonClickEvent:(id)sender
{
    AddNewAddressViewController *addVC = [[AddNewAddressViewController alloc]init];
    addVC._isNewOrEdit= YES;
    [self.navigationController pushViewController:addVC animated:YES];
    [addVC release];
}

/*
 * brief 设置默认地址
 */
-(void)setDefaultButtonClickEventHandler:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSInteger row = [[btn titleForState:UIControlStateSelected] integerValue];
    OrderAddressEntity *entity = (OrderAddressEntity*)[self._arrAddress objectAtIndex:row ];
    [[PSNetTrans getInstance] API_order_address_set_func:self ID:entity.ID];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dic = [entity convertAddressEntityToDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"address"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    if (addressDefaultCallBack) {
         addressDefaultCallBack(entity,self._arrAddress);
    }
}
/*
 * brief 点击编辑按钮
 */
-(void)editButtonClickEventHandler:(id)sender
{
    UIButton *btn = (UIButton*)sender;

    OrderAddressEntity *entity = (OrderAddressEntity*)[self._arrAddress objectAtIndex:btn.tag];
    AddNewAddressViewController *adnVC = [[AddNewAddressViewController alloc]init];
    adnVC._isNewOrEdit = NO;
    adnVC.addressEntity = entity;
    [self.navigationController pushViewController:adnVC animated:YES];
    [adnVC release];
}

#pragma mark --------------------------UITableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._arrAddress.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[UIColor clearColor];
        
        UIView *bgCell = [PublicMethod addBackView:CGRectMake(0, 0, 320, 95) setBackColor:[UIColor whiteColor]];
        [cell.contentView addSubview:bgCell];
        CGFloat originX = 0.f;
        if (fromMore) {
            originX = 35.f;
        }
        
        UIImageView *img = [PublicMethod addImageView:CGRectMake(10, 32, 25, 25) setImage:@"yes-2.png"];
        img.tag = 1000;
        [cell.contentView addSubview:img];
        
        if (fromMore) {
            img.hidden = YES;
        }
        
        //名字
        UILabel *labName = [[UILabel alloc]initWithFrame:CGRectMake(45- originX, 18, 80, 20)];
        labName.tag = TAG_ORDER_ADDRESS_NAME;
        labName.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:labName];
        [labName release];
        
        //电话号码
        UILabel *labMobile = [[UILabel alloc]initWithFrame:CGRectMake(120-originX, 18, 200, 20)];
        labMobile.tag = TAG_ORDER_ADDRESS_MOBILE;
        labMobile.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:labMobile];
        [labMobile release];
        
        //地址
        UILabel *labAddress = [[UILabel alloc]initWithFrame:CGRectMake(45-originX, 35, 175+originX, 60)];
        labAddress.tag =TAG_ORDER_ADDRESS_ADDRESS;
        labAddress.lineBreakMode = UILineBreakModeWordWrap;
        labAddress.numberOfLines = 3;
        labAddress.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:labAddress];
        [labAddress release];
        
        //设为默认和编辑按钮
        UIButton *btnSign = [[UIButton alloc]initWithFrame:CGRectMake(230, 15, 80, 30)];
        btnSign.tag =TAG_ORDER_ADDRESS_SETDEFAULT;
        btnSign.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
        [btnSign setTitle:@"设为常用" forState:UIControlStateNormal];
        [btnSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSign.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnSign addTarget:self action:@selector(setDefaultButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnSign];
        [btnSign release];
        
        UIButton *btnEdit = [[UIButton alloc]initWithFrame:CGRectMake(230, 55, 80, 30)];
        btnEdit.tag =indexPath.row;
        [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [btnEdit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnEdit.layer.borderColor = [UIColor blueColor].CGColor;
        btnEdit.layer.borderWidth = 1.f;
        btnEdit.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnEdit addTarget:self action:@selector(editButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnEdit];
        [btnEdit release];
        
    }
    //获取列表元素，并赋值
    OrderAddressEntity *entity = (OrderAddressEntity*)[self._arrAddress objectAtIndex:indexPath.row];
    UILabel *labName = (UILabel*)[cell.contentView viewWithTag:TAG_ORDER_ADDRESS_NAME];
    UILabel *labMobile = (UILabel*)[cell.contentView viewWithTag:TAG_ORDER_ADDRESS_MOBILE];
    UILabel *labAddress = (UILabel*)[cell.contentView viewWithTag:TAG_ORDER_ADDRESS_ADDRESS];
    UIButton *btnSign = (UIButton*)[cell.contentView viewWithTag:TAG_ORDER_ADDRESS_SETDEFAULT];
    UIButton *btnEdit = (UIButton*)[cell.contentView viewWithTag:TAG_ORDER_ADDRESS_EDIT];
    
    
    labName.text = nil;
    labMobile.text = nil;
    labAddress.text = nil;
    [btnSign setTitle:nil forState:UIControlStateSelected];
    [btnEdit setTitle:nil forState:UIControlStateSelected];
    
    labName.text = entity.true_name;
    if (entity.mobile.length > 0) {
        labMobile.text = entity.mobile;
    }else{
        labMobile.text = entity.telephone;
    }
    labAddress.text = [NSString stringWithFormat:@"%@\n%@",entity.logistics_area_name,entity.logistics_address];
    
    //参数通过button的selected的title传递
    [btnSign setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateSelected];
    [btnEdit setTitle:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forState:UIControlStateSelected];
    

    if ([self.entityID isEqualToString:entity.ID]) {
        UIImageView *titleImg = (UIImageView *)[cell.contentView viewWithTag:1000];
        titleImg.image = [UIImage imageNamed:@"yes-1.png"];

    } else {
        UIImageView *titleImg = (UIImageView *)[cell.contentView viewWithTag:1000];
        titleImg.image = [UIImage imageNamed:@"yes-2.png"];
    }
    
    if (entity.is_default) {
        [btnSign setTitle:@"常用" forState:UIControlStateNormal];
        btnSign.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
        btnSign.enabled = NO;
    }else{
        [btnSign setTitle:@"设为常用" forState:UIControlStateNormal];
        [btnSign setBackgroundColor:[UIColor lightGrayColor]];
        btnSign.enabled = YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cellArray = [tableView visibleCells];

    for (UITableViewCell *allCell in cellArray) {
        UIImageView *cellImg = (UIImageView *)[allCell viewWithTag:1000];
        cellImg.image = [UIImage imageNamed:@"yes-2.png"];
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImage = (UIImageView *)[cell viewWithTag:1000];
    selectImage.image = [UIImage imageNamed:@"yes-1.png"];
    //保存当前选择的cell的indexpath
    self._indexPath = indexPath;
    // 返回选中地址
    OrderAddressEntity *entity = (OrderAddressEntity*)[self._arrAddress objectAtIndex:indexPath.row];
    if (fromMore) {
        return;
    }
    //更新库存门店等信息
    [self restoreDeliveryInfo:entity];
    //先取消
    if (entity.bu_code.integerValue != [[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"] integerValue]) {
//        [self showAlert:@"库存可能不足"];
    }
    addressDefaultCallBack(entity,self._arrAddress);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    OrderAddressEntity *entity = (OrderAddressEntity*)[self._arrAddress objectAtIndex:indexPath.row];
    //    if (entity.is_default) {
    //        entity.is_default = NO;
    //    }
}
/*
 * brief 设置tableview为选择模式
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark --------------------------更新view
-(void)restoreDeliveryInfo:(OrderAddressEntity *)addressEntity{
    //        [self showAlert:@"库存可能不足"];
    //保存配送信息
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.city_code forKey:@"region_id"];
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.city_name forKey:@"region_name"];
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.area_code forKey:@"country_id"];
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.street_code forKey:@"street_id"];
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.area_name forKey:@"country_name"];
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.street_name forKey:@"street_name"];
    [[NSUserDefaults standardUserDefaults] setObject:addressEntity.bu_code forKey:@"bu_code"];
    //        [[NSUserDefaults standardUserDefaults] setObject:[[array lastObject] objectForKey:@"type"] forKey:@"bu_type"];//实体店，虚拟店
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"psStyle"];
    //清除自提信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_address"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
}
-(void)updateViewController:(NSMutableArray*)arr
{
    if (arr != nil)
    {
        [self._arrAddress removeAllObjects];
        [self._arrAddress addObjectsFromArray:arr];
        [self._tableView reloadData];
    }else{
        [[iToast makeText:@"数据为空!"] show];
    }
}
/*
 * brief 获取地址列表的函数
 */
-(void)loadDataFromServer
{
    [[PSNetTrans getInstance] API_order_address_list_func:self goods_id:self.goods_id];
}
#pragma mark --------------------------Request Delegate

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag;
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_SETDEFAULT_ADDRESS == nTag)
    {
        [[iToast makeText:@"设置默认地址成功"] show];
        //设置默认地址成功后刷新列表
        [self loadDataFromServer];
    }
    else if (t_API_ADDRESS_LIST == nTag)
    {
        NSMutableArray * arrData = (NSMutableArray *)netTransObj;
        [self updateViewController:arrData];
    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (t_API_ORDER_ADDRESS_LIST == nTag)
    {
        [[iToast makeText:errMsg] show];
    }
    else if (t_API_ORDER_ADDRESS_SET == nTag)
    {
        [[iToast makeText:errMsg] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    else if (nTag == t_API_ADDRESS_LIST)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
    }
    else if (nTag == t_API_SETDEFAULT_ADDRESS)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
    }

}
@end
