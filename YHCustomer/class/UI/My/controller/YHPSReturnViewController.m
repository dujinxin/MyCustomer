//
//  YHPSReturnViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-4-30.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  退货/退款-服务

#import "YHPSReturnViewController.h"
#import "YHApplyReturnGoodsViewController.h"
#import "YHApplyReturnGoodsViewDeliveredController.h"
#import "YHReturnOrderDetailAlreadyViewController.h"
#import "YHReturnOrderDetailViewController.h"
#import "YHOrderDetailViewController.h"
#import "OrderEntity.h"
#import "GoodsView.h"
#import "GJGLAlertView.h"
#import "YHReturnCell.h"
#import "NetTrans.h"

#define kDefaultFireIntervalNormal 1.f

@interface YHPSReturnViewController ()
{

}
@end

@implementation YHPSReturnViewController
@synthesize orderListArray,myOrderType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        orderListArray = [[NSMutableArray alloc] init];
        myOrderType = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"退货服务";
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    [self setupSegmentedControl];
    [self addTableView];
    [self addRefreshTableFooterView];
    
    // 暂无订单img
    resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    resultImage.image = [UIImage imageNamed:@"cart_No_Result.png"];
    [self.view addSubview: resultImage];
    resultImage.hidden = YES;
    // 首次请求数据
    [self initRequestUnpay];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -
#pragma mark ---------------------------------------------------添加UI
// 添加tableview
- (void)addTableView
{
    CGFloat floatY = 39.f;
    self._tableView.frame = CGRectMake(0, floatY, SCREEN_WIDTH, ScreenSize.height- NAVBAR_HEIGHT - floatY);
    self._tableView.backgroundView = nil;
    self._tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self._tableView.showsVerticalScrollIndicator = NO;
    self._tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
}

- (void)setupSegmentedControl
{
    buttonBackgroundImage = [UIImage imageNamed:@"unselected_indicator_front.png"];
    buttonSelectImage = [UIImage imageNamed:@"selected_indicator_front.png"];
    
    // 全部订单
    readyPay = [UIButton buttonWithType:UIButtonTypeCustom];
    readyPay.frame = CGRectMake(0, 8, 80, 30);
    [readyPay setBackgroundImage: buttonSelectImage forState:UIControlStateNormal];
    [readyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateHighlighted];
    readyPay.tag = 1001;
    [readyPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [readyPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readyPay setTitle:@"申请退货" forState:UIControlStateNormal];
    readyPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    
    // 待付款
    alreadyPay = [UIButton buttonWithType:UIButtonTypeCustom];
    alreadyPay.frame = CGRectMake(80, 8, 80, 30);
    [alreadyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [alreadyPay setBackgroundImage:buttonSelectImage forState:UIControlStateHighlighted];
    alreadyPay.tag = 1002;
    [alreadyPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [alreadyPay setTitle:@"退货中" forState:UIControlStateNormal];
    alreadyPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [alreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // 待收获
    finishPay = [UIButton buttonWithType:UIButtonTypeCustom];
    finishPay.frame = CGRectMake(160, 8, 80, 30);
    [finishPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [finishPay setBackgroundImage:buttonSelectImage forState:UIControlStateHighlighted];
    finishPay.tag = 1003;
    [finishPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [finishPay setTitle:@"退货完成" forState:UIControlStateNormal];
    finishPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [finishPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // 已收获
    getAlreadyPay = [UIButton buttonWithType:UIButtonTypeCustom];
    getAlreadyPay.frame = CGRectMake(240, 8, 80+2, 30);
    [getAlreadyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [getAlreadyPay setBackgroundImage:buttonSelectImage forState:UIControlStateHighlighted];
    getAlreadyPay.tag = 1004;
    [getAlreadyPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [getAlreadyPay setTitle:@"退货取消" forState:UIControlStateNormal];
    getAlreadyPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [getAlreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    UIView *headBg = [PublicMethod addBackView:CGRectMake(0, 0, 320, 40) setBackColor:[PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0]];
    UIView *bgLine = [PublicMethod addBackView:CGRectMake(0, 29+9.5, 320, 1) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    
    [headBg addSubview:bgLine];
    [headBg addSubview:readyPay];
    [headBg addSubview:alreadyPay];
    [headBg addSubview:finishPay];
    [headBg addSubview:getAlreadyPay];
    [self.view addSubview:headBg];
}

// 按钮切换
- (void)buttonClickWithSytle:(id)sender
{
    [self.orderListArray removeAllObjects];
    UIButton *button = (UIButton *)sender;
    NSInteger orderTypeTag = button.tag - 1000;
    
    [self resetButtonBackGround];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (button == readyPay) {
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
    }else if(button == alreadyPay){
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
    }else if (button == getAlreadyPay){
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
    }
    else{
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 选择状态 在切换过程中根据 button.tag － 1000 ＝ 1.2.3.4分别代表四种切换状态
    self.myOrderType = orderTypeTag;
    countPage = 1;
    [self requestWithParamers:myOrderType WithCountPage:countPage];
}

/* reset 未支付／已支付／已完成 */
- (void)resetButtonBackGround
{
    [readyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [alreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [finishPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [getAlreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [readyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [alreadyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [finishPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [getAlreadyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
}

/* 首次请求待支付数据 */
- (void)initRequestUnpay
{
    // init requestData
    requestStyle = Load_InitStyle ;
    countPage = 1;
    [self requestWithParamers:myOrderType WithCountPage:countPage];
}

/* 下拉刷新 */
- (void)reloadTableViewDataSource{
    NSLog(@"开始加载");
  
        _moreloading = YES;
        [self.orderListArray removeAllObjects];
        self.dataState = EGOOHasMore;
        countPage = 1;
        requestStyle=  Load_RefrshStyle;
        [self requestWithParamers:myOrderType WithCountPage:countPage];
    
}

/* 加载更多 */
- (void)loadMoreTableViewDataSource
{
    NSLog(@"开始加载加载更多");
    _reloading = YES;
    requestStyle =Load_MoreStyle;
    [self requestWithParamers:myOrderType WithCountPage:++countPage];
}

/* 请求接口方法 */
- (void)requestWithParamers:(MyOrderType)orderType WithCountPage:(NSInteger)page
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1.5];
    
    NSLog(@"orderType = %d" , orderType);
    [[PSNetTrans getInstance] return_orderList:self Type:orderType Page:[NSString stringWithFormat:@"%ld",(long)countPage]];
}
- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
/* 更新数据 */
- (void)updateDateTableFromServer:(NSMutableArray *)serverArr{
    // 首次加载 ｜｜ 下拉刷新清空数据
    if (requestStyle != Load_MoreStyle)
    {
        [self.orderListArray removeAllObjects];
        [self.orderListArray addObjectsFromArray:serverArr];
    }
    else
    {
        [self.orderListArray addObjectsFromArray:serverArr];
    }
    if (self.orderListArray.count == 0)
    {
        self._tableView.hidden = YES;
        resultImage.hidden = NO;
    }
    else
    {
        self._tableView.hidden = NO;
        resultImage.hidden = YES;
    }
    // 清楚转赠数组数据
    [self._tableView reloadData];
    
    if (requestStyle == Load_MoreStyle)
    {
        if (self.total == orderListArray.count)
        {
            self.dataState = EGOOOther;
        }
        else
        {
            self.dataState = EGOOHasMore;
        }
    }
    else
    {
        if (orderListArray.count <10)
        {
            self.dataState = EGOOOther;
        }
        else
        {
            self.dataState = EGOOHasMore;
        }
    }
    self.total = orderListArray.count;
    [self._tableView reloadData];
    [self testFinishedLoadData];
    [self finishLoadTableViewData];
}

#pragma mark ---------------------------------------------------Request Delegate


-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 待支付／已支付／已完成
    if (nTag == t_API_PS_RETURN_ORDER_LIST) {
        NSMutableArray *successArr = (NSMutableArray *)netTransObj;
        [self updateDateTableFromServer:successArr];
       
//        [NSThread detachNewThreadSelector:@selector(delayTime) toTarget:self withObject:nil];
//        [self performSelector:<#(SEL)#> onThread:<#(NSThread *)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];
    }
    if (nTag == t_API_PS_RETURN_ORDER) {
        GJGLAlertView *alertView = [GJGLAlertView shareInstance];
        if (alertView) {
            [alertView removeFromSuperview];
        }
        [self reloadTableViewDataSource];
    }
    [self finishLoadTableViewData];
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [self finishLoadTableViewData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag == t_API_PS_RETURN_ORDER_LIST) {
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
    else if (nTag == t_API_PS_RETURN_ORDER)
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
//    [self showAlert:errMsg];
    [[iToast makeText:errMsg] show];
}

#pragma mark ---------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath  *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReturnOrderEntity *orderEntity = [self.orderListArray objectAtIndex:indexPath.row];
    if ([orderEntity.carry_or_not isEqualToString:@"1"]||[orderEntity.carry_or_not isEqualToString:@"3"] )
    {
        YHReturnOrderDetailAlreadyViewController *returnOrderDetail = [[YHReturnOrderDetailAlreadyViewController alloc] init];
        returnOrderDetail.myReturnOrderEntity = orderEntity;
        returnOrderDetail.cancelBlock = ^(){
            [self cancelOrderSuccessBlock];
        };
        returnOrderDetail.deliveryBlock = ^(){
            [self submitOrderSuccessBlock];
        };
        [self.navigationController pushViewController:returnOrderDetail animated:YES];
    }
    else if ([orderEntity.carry_or_not isEqualToString:@"2"]||[orderEntity.carry_or_not isEqualToString:@"0"])
    {
        YHReturnOrderDetailViewController *returnOrderDetail = [[YHReturnOrderDetailViewController alloc] init];
        returnOrderDetail.myReturnOrderEntity = orderEntity;
        returnOrderDetail.cancelBlock = ^(){
            [self cancelOrderSuccessBlock];
        };
        [self.navigationController pushViewController:returnOrderDetail animated:YES];
    }
    
    if (myOrderType == 1)
    {
        YHOrderDetailViewController *orderDetail = [[YHOrderDetailViewController alloc] init];
        orderDetail.fromReturn = YES;
        [orderDetail setOrderListId:orderEntity];
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

#pragma mark ----------------------------------------------------UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    YHReturnCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell==nil) {
        cell=[[YHReturnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.orderListArray.count) {
        ReturnOrderEntity *orderEntity = [self.orderListArray objectAtIndex:indexPath.row];
        NSLog(@"orderid %@",orderEntity.sales_return_id);
        cell.returnController = self;
        [cell setReturnCell:orderEntity NSIndexPath:indexPath OrderType:myOrderType];
    }
    return cell;
}

#pragma -mark
#pragma -YHReturnCellDelegate
- (void)handSeleClicked:(NSIndexPath *)indexPath{
    ReturnOrderEntity *orderEntity = [self.orderListArray objectAtIndex:indexPath.row];
    // 如果是快速输入单号 - 退货中
    if (myOrderType == 2)
    {
        GJGLAlertView *alertView = [GJGLAlertView shareInstance];
        [[GJGLAlertView shareInstance] setAlertViewBlock:^(NSString *companyName,NSString *orderName){
            if (orderEntity.sales_return_id.length == 0) {
                [self showNotice:@"单号id不能为空!"];
                return ;
            }
            [[PSNetTrans getInstance] API_order_InputExpress:self sales_return_id:orderEntity.sales_return_id express_name:companyName express_num:orderName];
        } CancelBlock:^(){
            if (alertView) {
                [alertView removeFromSuperview];
            }
        }];
        [self.view addSubview:alertView];
        return;
    }
    
    if (myOrderType == 1)
    {
        int order_state = [orderEntity.total_state intValue];
        if (order_state<100)
        {//未提货
            YHApplyReturnGoodsViewController *vc = [[YHApplyReturnGoodsViewController alloc]init];
            vc.submitBlock=^(){
                [self submitOrderSuccessBlock];
            };
            [vc setData:orderEntity];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {//已提货
            YHApplyReturnGoodsViewDeliveredController *vc = [[YHApplyReturnGoodsViewDeliveredController alloc]init];
            vc.submitBlock=^()
            {
                [self submitOrderSuccessBlock];
            };
            [vc setData:orderEntity];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)submitOrderSuccessBlock{
    [self buttonClickWithSytle:alreadyPay];
}

- (void)cancelOrderSuccessBlock{
    [self buttonClickWithSytle:getAlreadyPay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
