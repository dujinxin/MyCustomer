//
//  YHPSPaymentStyleViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-3-26.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  支付方式

#import "YHPSPaymentStyleViewController.h"
#import "PSEntity.h"

@interface YHPSPaymentStyleViewController (){

    SEL             _back;
    NSMutableArray  *dataArray;
}
@property (nonatomic, strong)    NSMutableArray  *dataArray;

@end

@implementation YHPSPaymentStyleViewController
@synthesize dataArray;
@synthesize paymentDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _back = @selector(back:);
        dataArray = [[NSMutableArray alloc] init];
        paymentDic = [[NSDictionary alloc] init];
        _fromNewOrder = NO;
        _fromConfirmOrder = NO;
    }
    return self;
}


- (void)addRefreshTableHeaderView{

}

- (void)addGetMoreFootView{

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[PSNetTrans getInstance] ps_PayMentStyle:self Type:@"1"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addRefreshTableHeaderView];
    [self addGetMoreFootView];

    self.navigationItem.title = @"选择支付方式";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回",_back);
    self._tableView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
    self._tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
   
    self.paymentDic = [[NSUserDefaults standardUserDefaults]  objectForKey:@"paymentStyle"];
    
}

- (void)back:(id)senxder{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)headerViewLabel{
    UIView *headBg = [PublicMethod addBackView:CGRectMake(0, 0, 320, 60) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    UILabel *headerLabel = [PublicMethod addLabel:CGRectMake(0, 20, 320, 40) setTitle:@"  选择支付方式" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:18]];
    headerLabel.backgroundColor = [UIColor whiteColor];
    [headBg addSubview:headerLabel];
    return headBg;
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic =[self.dataArray objectAtIndex:indexPath.row] ;
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"paymentStyle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_fromNewOrder)
    {
        if (self.model == Fetch) {
            [[PSNetTrans getInstance] ps_getCouponList:self payMethod:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"id"] lm_idForPs:nil goods_id:self.goods_id total:self.total];
        }else{
            [[PSNetTrans getInstance] ps_getCouponList:self payMethod:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"id"] lm_idForPs:self.lm_id goods_id:self.goods_id total:self.total];
        }
        
        _payMethod = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    }else{
        
        [[PSNetTrans getInstance] ps_PayMentStyle:self pay_method:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"id"] order_list_no:self.order_list_no];
        _payMethod = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    }
//    if (_fromConfirmOrder) {
//        
//    }
    
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.contentView removeAllSubviews];
    
    UIImageView *icon = [PublicMethod addImageView:CGRectMake(10, 17, 22, 22) setImage:@"yes-2.png"];
    if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"] isEqualToString:self.paystyle]) {
        [icon setImage:[UIImage imageNamed:@"yes-1"]];
    }
        icon.tag = 100;
        [cell.contentView addSubview:icon];

    UILabel *name = [PublicMethod addLabel:CGRectMake(40, 19, 200, 20) setTitle:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"]setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    name.tag = 101;
    [cell.contentView addSubview:name];
//    目前仅支持付现金；自提请选择其他在线支付方式
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"name"] isEqualToString:@"货到付款"]) {
        UILabel *description = [PublicMethod addLabel:CGRectMake(40, 30, 280, 18) setTitle:@"目前仅支持付现金\n 自提请选择其他在线支付方式" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:description];
    }
    
    UIView *seperateLine = [PublicMethod addBackView:CGRectMake(0, 0, 320, 1) setBackColor:[UIColor lightGrayColor]];
    seperateLine.alpha = .2f;
    [cell.contentView addSubview:seperateLine];

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_PS_PAYMENT_STYLE)
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
    }
    else if (nTag == t_API_PS_ORDER_COUPON_LIST)
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
    }
     [[iToast makeText:errMsg]show];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_PS_PAYMENT_STYLE) {
        self._tableView.tableHeaderView = [self headerViewLabel];
        self.dataArray = (NSMutableArray *)netTransObj;
        [self._tableView reloadData];
    }else if(nTag == t_API_PS_ORDER_COUPON_LIST){
        NSMutableArray * array = (NSMutableArray *)netTransObj;
        self.couponNumber = array.count;
        
        _chooseBlock (_payMethod,nil,self.couponNumber);
        [self back:nil];
    }else if (nTag == t_API_PS_PAYMENT_STYLE_MONEY){
        NSMutableArray * array = (NSMutableArray *)netTransObj;
        ModifyPayMethod * entity = [array firstObject];
        _chooseBlock (_payMethod,entity,self.couponNumber);
        [self back:nil];
    }
}
@end
