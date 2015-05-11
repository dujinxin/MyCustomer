//
//  YHOrderDetailViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-22.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHOrderDetailViewController.h"
#import "DonationEntity.h"
#import "YHMyOrderViewController.h"
#import "YHGoodsDetailViewController.h"
#import "YHModifyPickTimeViewController.h"
#import "YHPSDeliveryDoorViewController.h"
#import "YHConfirmOrderViewController.h"
#import "YHQuickScanOrderViewController.h"

@interface YHOrderDetailViewController ()

@end

@implementation YHOrderDetailViewController
@synthesize url;
@synthesize orderEntity;
@synthesize orderList_no;
@synthesize fromReturn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        orderEntity = [[MyOrderEntity alloc] init];
        self.navigationItem.title = @"订单详情";
        self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
        [self initMsg];
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:PAGE11];
    
    [self loadRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [MTA trackPageViewEnd:PAGE11];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}

// 支付按钮
- (void)payButtonAction:(id)sender{
    __unsafe_unretained YHOrderDetailViewController * dvc = self;
    //app订单
    if ([orderEntity.order_type isEqualToString:@"1"]) {
        YHConfirmOrderViewController * covc = [[YHConfirmOrderViewController alloc]init ];
        covc.isFromOrderDetail = YES;
        covc.order_list_id = orderEntity.order_list_id;
        if (self.transaction_type) {
            covc.transaction_type = self.transaction_type;
        }
        [[PSNetTrans getInstance] my_orderDetail:covc order_list_id:covc.order_list_id];
        covc.block = ^(id obj){
            MyOrderEntity * entity = (MyOrderEntity *)obj;
            [dvc setOrderListId:entity];
            [self loadRequest];
        };
        [self.navigationController pushViewController:covc animated:YES];
    //PDA订单
    }else if ([orderEntity.order_type isEqualToString:@"2"]){
        YHQuickScanOrderViewController * scvc = [[YHQuickScanOrderViewController alloc]init ];
        scvc.isFromOrderDetail = YES;
        scvc.order_list_no = orderEntity.order_list_no;
        [[PSNetTrans getInstance] my_orderDetailForPDA:scvc order_list_no:scvc.order_list_no];
        scvc.block = ^(id obj){
            MyOrderEntity * entity = (MyOrderEntity *)obj;
            [dvc setOrderListId:entity];
            [self loadRequest];
        };
        [self.navigationController pushViewController:scvc animated:YES];
    }
}

#pragma mark--------------------------------------------------- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.numberOfButtons-1)
        return;
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
-(void)addWebView {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
}

#pragma mark ------------------------- 数据获取
- (void)loadRequest{
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:requestObj];
}

#pragma mark-
#pragma mark -UIWebViewDelegate

#pragma mark --------------------------webView代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSString *decode =[requestString URLDecodeString];
    if([decode rangeOfString:@"#myrainbowparams#"].length > 0){
        NSString *finalStr = [decode getJsonStrWithOutHttpBySeprateStr:@"#myrainbowparams#"];
        NSString *urlStr = [decode getGoodUrlWithParmer:@"#myrainbowparams#"];
        NSDictionary *paramDic = [finalStr objectFromJSONString];
        BOOL isSkip = [self webRequestStringAnalytics:paramDic URL:urlStr];
        return isSkip;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

#pragma mark --------------------------webview字符解析
-(BOOL)webRequestStringAnalytics:(NSDictionary*)dicParam URL:(NSString*)url
{
    // 关于商品详细
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"000"]) {
        self.navigationItem.title = @"配送详情";
        return YES;
    }
    // 进入购物车
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"001"])
    {

    }
    // 进入商品评论列表
    else if([[dicParam objectForKey:@"actionid"]isEqualToString:@"002"])
    {
        
    }
    // 登陆页面
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"003"])
    {
        [[YHAppDelegate appDelegate]  checkLogin];
    }
    // 专柜首页
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"004"])
    {
        
        
        if (![self.orderEntity.region_id isEqualToString:[UserAccount instance].region_id]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您目前在%@站，查看的商品是在其他城市站购买的，请切换城市后再查看，谢谢!",[UserAccount instance].location_CityName] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag = 10000;
            
            [alert show];
            
            return NO;
            
        }
        
        
        
        YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
        NSString *url1 = [NSString stringWithFormat:GOODS_DETAIL,[[dicParam objectForKey:@"params"] objectForKey:@"bu_goods_id"],[UserAccount instance].session_id,self.orderEntity.region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
        [detailVC setMainGoodsUrl:url1 goodsID:[[dicParam objectForKey:@"params"] objectForKey:@"bu_goods_id"]];
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    // 查看购物车商品数
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"005"])
    {
        [self showNotice:@"已成功加入购物车"];
        [MTA trackCustomKeyValueEvent :EVENT_ID5 props:nil];
        NSString *totalNum = [NSString stringWithFormat:@"%@",[[dicParam objectForKey:@"params"] objectForKey:@"total"]];
        [[NSUserDefaults standardUserDefaults] setObject:totalNum forKey:@"cartNum"];
        [[YHAppDelegate appDelegate] changeCartNum:totalNum];
    }
    // 达到购买上线
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"006"]) {
        [self showNotice:[[dicParam objectForKey:@"params"] objectForKey:@"marked_words"]];
    }
    // 确认加入购物车／*本地调用api*/
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"007"])
    {
        
    }
    // 门店首页
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"008"])
    {
        
    }
    // 支付
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"009"])
    {
        [self payButtonAction:nil];
    }
    
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"010"])
    {
        self.orderList_no =[[dicParam objectForKey:@"params"] objectForKey:@"order_list_no"];
        [self donation];
    }
    // 取消
    if ([[dicParam objectForKey:@"actionid"] isEqualToString:@"011"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除此订单" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        alertView.tag = 1003;
        [alertView show];
    }
    return NO;
}

// 配送详情
- (void)setDeliveryEntity:(MyOrderEntity *)orderEntity2{
    self.orderEntity = orderEntity2;
    self.navigationItem.title = @"订单跟踪";
    url = [NSString stringWithFormat:DEVELIY_DETAIL,[UserAccount instance].session_id,orderEntity.order_list_id,self.orderEntity.region_id];
}

// 设置商品详情bu_goods_id
- (void)setOrderListId:(MyOrderEntity *)orderEntity1{
    self.orderEntity =orderEntity1;
    self.url = [NSString stringWithFormat:ORDER_DETAIL,orderEntity1.order_list_id,[UserAccount instance].session_id,orderEntity1.region_id];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    
    if (fromReturn) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 取消订单以后返回跳转到myorder页面
    if (orderCancelSuccess == YES) {
        YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
        myOrder.fromType = 1;
        [self.navigationController pushViewController:myOrder animated:YES];

    }else{
        if ([webView canGoBack]) {
            [webView goBack];
            self.navigationItem.title = @"订单详情";
        }else{
            YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
            myOrder.fromType = 1;
            [self.navigationController pushViewController:myOrder animated:YES];
        }
    }
}

-(void)donation {
    
    [MTA trackCustomKeyValueEvent :EVENT_ID11 props:nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请慎重操作本步" message:@"按确定后,将触发短信转赠给您的友人,且无法取消." delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
//    alert.tag = 1001;
//    [alert show];
    
    [[NetTrans getInstance]donation_Order:self OrderId:orderEntity.order_list_no];
    
}

-(void)openMsg:(NSString *)text {
    if([MFMessageComposeViewController canSendText])
    {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _msgVC.body = text;
        [self presentModalViewController:_msgVC animated:YES];
    }
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
//    [self showAlert:errMsg];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [[iToast makeText:errMsg]show];

}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    
    if (nTag == t_API_BUY_PLATFORM_CANCELORDER_API) {
        [self showNotice:@"取消订单成功"];
        orderCancelSuccess = YES;
        [self BackButtonClickEvent:nil];
    }
    
    if (t_API_BUY_PLATFORM_DONATION_API == nTag) {
        NSMutableArray *data = (NSMutableArray *)netTransObj;
        DonationEntity *entity = [data objectAtIndex:0];
        donation_order_id = entity.order_list_id;
        [self openMsg:entity.info];
    }
    
    if (t_API_CHANGE_DONATION_STATE_API == nTag) {
        [self loadRequest];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1001 && buttonIndex == 1) {
       [[NetTrans getInstance]donation_Order:self OrderId:orderEntity.order_list_no];
    }
	if (alertView.tag == 123 && buttonIndex == 1) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    if (alertView.tag == 1003  && buttonIndex == 1) {
        [[NetTrans getInstance] buy_cancelOrder:self OrderId:orderEntity.order_list_id];
    }
}

#pragma mark ---------------- MFMessageComposeViewController Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
//    [self loadRequest];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [self initMsg];
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            [controller popViewControllerAnimated:YES];
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
        case MessageComposeResultSent:
        {
            
          [[NetTrans getInstance] change_donation_order_state:self OrderId:donation_order_id];
        }
            break;
        default:
            break;
    }
    
}

-(void)initMsg {
    if([MFMessageComposeViewController canSendText]){
        _msgVC = [[MFMessageComposeViewController alloc] init];
        _msgVC.messageComposeDelegate = self;
        if ([_msgVC.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            [_msgVC.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }
    }
}

@end
