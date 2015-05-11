//
//  YHMyOrderViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-14.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  我的订单

#import "YHMyOrderViewController.h"
#import "OneOrderInfoView.h"
#import "OrderEntity.h"
#import "YHOrderDetailViewController.h"
#import "DonationEntity.h"
#import "YHModifyPickTimeViewController.h"
#import "YHGoodsDetailViewController.h"
#import "YHPSDeliveryDoorViewController.h"
#import "YHConfirmOrderViewController.h"
#import "YHQuickScanOrderViewController.h"

#define SELECT_BUTTON_WIDTH 80.f
#define SELECT_BUTTON_HEIGHT 30.f
#define ORDER_CELL_HEADER_HEIGHT 125.f
#define ORDER_CELL_GOODS_VIEW_HEIGHT 70.f
#define ORDER_CELL_GOODS_FOOT_HEIGHT 70.f
#define CANCELBUTTONTAG 10001

#define CELL_LABEL_ORIGINX 47.f
@interface YHMyOrderViewController (){

    UIImage         *selectAllBgImage;
    UIImage         *selectAllSelectImage;
}

@end

@implementation YHMyOrderViewController
@synthesize orderListArray;
@synthesize sectionTag;         // 支付
@synthesize myOrderType;
@synthesize cancelSectionTag;   // 取消支付
@synthesize forwardSelectTag;   // 转赠
@synthesize fromType,handleSelArray;
#pragma mark -------------------------------------------------初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.myOrderType =1;        // 全部订单
        countPage=1;                // 初始化页码为 1
        orderListArray =[[NSMutableArray alloc] init];
        
        // 转赠数组
        handleSelArray = [[NSMutableArray alloc] init];
        selectAllBgImage = [UIImage imageNamed:@"agreeBg.png"];
        selectAllSelectImage = [UIImage imageNamed:@"agreeArg.png"];
        
        // init msg
        [self initMsg];

    }
    return self;
}

#pragma mark -------------------------------------------------声明周期
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [MTA trackPageViewBegin:PAGE10];
    
    [self requestWithParamers:myOrderType WithCountPage:1];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [MTA trackPageViewEnd:PAGE10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"我的订单";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));

    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
//    [self setRightBarButton:self Action:@selector(donation:) SetImage:@"donation" SelectImg:@"donation_selected"];

    resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    resultImage.image = [UIImage imageNamed:@"cart_No_Result.png"];
    [self.view addSubview: resultImage];
    resultImage.hidden = YES;
    
    [self setupSegmentedControl];
    [self addTableView];
    [self addRefreshTableFooterView];
    // 首次请求数据
    [self initRequestUnpay];

}

#pragma -
#pragma mark ---------------------------------------------------添加UI
// 添加tableview
- (void)addTableView{
    CGFloat floatY = 39.f;
    self._tableView.frame = CGRectMake(0, floatY, 320, ScreenSize.height- NAVBAR_HEIGHT - floatY);
    self._tableView.backgroundView = nil;
    self._tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self._tableView.showsVerticalScrollIndicator = NO;
    self._tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
}

- (void)setupSegmentedControl
{
    buttonBackgroundImage = [UIImage imageNamed:@"unselected_indicator_front"];
    buttonSelectImage = [UIImage imageNamed:@"selected_indicator_front"];
    
    buttonFinishBgImage = [UIImage imageNamed:@"unselected_indicator_front"];
    buttonFinishSelectImage = [UIImage imageNamed:@"selected_indicator_front"];
    
    buttonCancelBgImage = [UIImage imageNamed:@"unselected_indicator_front"];
    buttonCancelSelectImage = [UIImage imageNamed:@"selected_indicator_front"];
    
    // 全部订单
    readyPay = [UIButton buttonWithType:UIButtonTypeCustom];
    readyPay.frame = CGRectMake(0, 8, SELECT_BUTTON_WIDTH, SELECT_BUTTON_HEIGHT);
    [readyPay setBackgroundImage: buttonSelectImage forState:UIControlStateNormal];
    [readyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateHighlighted];
    readyPay.tag = 1001;
    [readyPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [readyPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readyPay setTitle:@"全部订单" forState:UIControlStateNormal];
    readyPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    
    // 待付款
    alreadyPay = [UIButton buttonWithType:UIButtonTypeCustom];
    alreadyPay.frame = CGRectMake(80, 8, SELECT_BUTTON_WIDTH, SELECT_BUTTON_HEIGHT);
    [alreadyPay setBackgroundImage:buttonFinishBgImage forState:UIControlStateNormal];
    [alreadyPay setBackgroundImage:buttonFinishSelectImage forState:UIControlStateHighlighted];
    alreadyPay.tag = 1002;
    [alreadyPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [alreadyPay setTitle:@"待付款" forState:UIControlStateNormal];
    alreadyPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [alreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // 待收获
    finishPay = [UIButton buttonWithType:UIButtonTypeCustom];
    finishPay.frame = CGRectMake(160, 8, SELECT_BUTTON_WIDTH, SELECT_BUTTON_HEIGHT);
    [finishPay setBackgroundImage:buttonCancelBgImage forState:UIControlStateNormal];
    [finishPay setBackgroundImage:buttonCancelSelectImage forState:UIControlStateHighlighted];
    finishPay.tag = 1003;
    [finishPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [finishPay setTitle:@"待收货" forState:UIControlStateNormal];
    finishPay.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [finishPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // 已收获
    getAlreadyPay = [UIButton buttonWithType:UIButtonTypeCustom];
    getAlreadyPay.frame = CGRectMake(240, 8, SELECT_BUTTON_WIDTH+2, SELECT_BUTTON_HEIGHT);
    [getAlreadyPay setBackgroundImage:buttonCancelBgImage forState:UIControlStateNormal];
    [getAlreadyPay setBackgroundImage:buttonCancelSelectImage forState:UIControlStateHighlighted];
    getAlreadyPay.tag = 1004;
    [getAlreadyPay addTarget:self action:@selector(buttonClickWithSytle:) forControlEvents:UIControlEventTouchUpInside];
    [getAlreadyPay setTitle:@"已收货" forState:UIControlStateNormal];
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

#pragma mark ---------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath  *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyOrderEntity *orderEntity = [orderListArray objectAtIndex:indexPath.row];
    YHOrderDetailViewController *orderDetail = [[YHOrderDetailViewController alloc] init];
    orderDetail.fromReturn = YES;
    //517 立即购。。
    if (orderEntity.transaction_type.integerValue == 1){
//        GoodsEntity * entity = [orderEntity.orderArray lastObject];
//        orderDetail.goods_id = entity.bu_goods_id;
        orderDetail.transaction_type = @"1";
    }
    [orderDetail setOrderListId:orderEntity];
    [self.navigationController pushViewController:orderDetail animated:YES];
}


#pragma mark ----------------------------------------------------UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=  [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    cell.backgroundColor =[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [cell.contentView removeAllSubviews];
    
    // cell -bg
    UIView *bgCellView = [PublicMethod addBackView:CGRectMake(0, 0, cell.frame.size.width, 190) setBackColor:[UIColor whiteColor]];
    [cell.contentView addSubview:bgCellView];

    if (indexPath.row < orderListArray.count) {
        MyOrderEntity *orderEntity = [orderListArray objectAtIndex:indexPath.row];
        // 送货上门 || 门店自提
        UILabel *orderIcon = [PublicMethod addLabel:CGRectMake(10, 13, 28, 28) setTitle:nil setBackColor:[UIColor whiteColor] setFont:[UIFont systemFontOfSize:16]];
        // ordertype = 1(app) ordertype=2(pda)
        if ([orderEntity.order_type isEqualToString:@"1"]) {
            if ([orderEntity.delivery_id isEqualToString:@"1"]) {
                orderIcon.text = @"提";
                orderIcon.backgroundColor = [PublicMethod colorWithHexValue:0x9ac6df alpha:1.0f];
                
            }else if([orderEntity.delivery_id isEqualToString:@"2"]){
                orderIcon.text = @"送";
                orderIcon.backgroundColor = [PublicMethod colorWithHexValue:0xdbaadc
                                                                      alpha:1.0f];
            }
        }else if ([orderEntity.order_type isEqualToString:@"2"]){
            orderIcon.text = @"PDA";
            orderIcon.font = [UIFont systemFontOfSize:12];
            orderIcon.backgroundColor = [PublicMethod colorWithHexValue:0xceb9a6 alpha:1.0f];
        }
        orderIcon.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:orderIcon];
        
        // 下单编号 & 订单金额 & 下单时间
        UILabel *order_list_no = [PublicMethod addLabel:CGRectMake(CELL_LABEL_ORIGINX, 8, 200, 20) setTitle:[NSString stringWithFormat:@"订单编号 : %@",orderEntity.order_list_no] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:order_list_no];
        
        UILabel *order_totalAmount = [PublicMethod addLabel:CGRectMake(CELL_LABEL_ORIGINX, 28, 200, 20) setTitle:[NSString stringWithFormat:@"订单金额 :¥ %@",orderEntity.totalAmount] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:order_totalAmount];
        
        UILabel *order_createTime = [PublicMethod addLabel:CGRectMake(CELL_LABEL_ORIGINX, 48, 200, 20) setTitle:[NSString stringWithFormat:@"下单时间 : %@",orderEntity.create_date] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        [cell.contentView addSubview:order_createTime];

        UIView *seperateLine1 = [PublicMethod addBackView:CGRectMake(0, 73, 320, 1) setBackColor:[UIColor lightGrayColor]];
        seperateLine1.alpha = .1f;
        [cell.contentView addSubview:seperateLine1];
        // 开启转赠
        if ([orderEntity.pay_status isEqualToString:@"1"]){
            if ([orderEntity.delivery_id isEqualToString:@"1"] && [orderEntity.order_type isEqualToString:@"1"]) {
                if ([orderEntity.total_state isEqualToString:@"0"] ||[orderEntity.total_state isEqualToString:@"20"] ||[orderEntity.total_state isEqualToString:@"50"] ||[orderEntity.total_state isEqualToString:@"40"] ) {
                    
                    UIButton *handleSel = [UIButton buttonWithType:UIButtonTypeCustom];
                    handleSel.tag = indexPath.row ;
                    handleSel.frame = CGRectMake(250, 10, 60, 25);
                    handleSel.titleLabel.font = [UIFont systemFontOfSize:12];
                    if ([orderEntity.is_handsel isEqualToString:@"0"]){
                        // 转赠button
                        [handleSel setTitle:@"礼品转赠" forState:UIControlStateNormal];
                        [handleSel setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
                        handleSel.titleLabel.font = [UIFont systemFontOfSize:12];
                        [handleSel addTarget:self action:@selector(donation:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:handleSel];
                    }else{
                        [handleSel setTitle:@"已转赠" forState:UIControlStateNormal];
                        handleSel.enabled = NO;
                        [handleSel setBackgroundColor:[PublicMethod colorWithHexValue:0x9adc6e alpha:1.0f]];
                        [cell.contentView addSubview:handleSel];

                    }
                }

            }
           
        // 未支付
        }else if ([orderEntity.pay_status isEqualToString:@"0"]){
            if (![orderEntity.total_state isEqualToString:@"10"]) {
                
                UIButton *handleSel = [UIButton buttonWithType:UIButtonTypeCustom];
                handleSel.frame = CGRectMake(270, 10, 45, 25);
                handleSel.titleLabel.font = [UIFont systemFontOfSize:14];
                // 支付
                [handleSel setTitle:@"付款" forState:UIControlStateNormal];
                handleSel.tag = indexPath.row ;
                handleSel.backgroundColor = [PublicMethod colorWithHexValue:0xff8000 alpha:1.f];
                [handleSel addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:handleSel];

                // 取消
                UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                cancelBtn.frame = CGRectMake(225, 10, 40, 25);
                cancelBtn.backgroundColor = [UIColor whiteColor];
                cancelBtn.layer.borderWidth = 1.0f;
                cancelBtn.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
                cancelBtn.tag = indexPath.row ;
                [cell.contentView addSubview:cancelBtn];
            }
        }
        /* cell中 商品列表 */
        if(orderEntity.orderArray.count == 1) {
            GoodsEntity *goodsEnty = [orderEntity.orderArray objectAtIndex:0];
            UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 85, 38, 38)];
            [goodsImageView setImageWithURL:[NSURL URLWithString:goodsEnty.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
            goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
            goodsImageView.layer.borderWidth = .1f;
            [cell.contentView addSubview:goodsImageView];
            
            UILabel *goodsInfo = [PublicMethod addLabel:CGRectMake(60, 70, 200, 50) setTitle:goodsEnty.goods_name setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:goodsInfo];
            goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
            goodsImageView.layer.borderWidth = 1.0f;

            UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 96, 15, 18)];
            accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
            [cell.contentView addSubview:accessImg];
            
        }else if(orderEntity.orderArray.count <=3 && orderEntity.orderArray.count > 1){
            for (int i = 0; i < orderEntity.orderArray.count; i ++) {
                GoodsEntity *goodsEnty = [orderEntity.orderArray objectAtIndex:i];
                UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10 + i*45, 85, 38, 38)];
                [goodsImageView setImageWithURL:[NSURL URLWithString:goodsEnty.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
                goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
                goodsImageView.layer.borderWidth = 1.0f;
                [cell.contentView addSubview:goodsImageView];
            }
            UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 96, 15, 18)];
            accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
            [cell.contentView addSubview:accessImg];
        }else if(orderEntity.orderArray.count >3){
            for (int i = 0; i < 3; i ++) {
                GoodsEntity *goodsEnty = [orderEntity.orderArray objectAtIndex:i];
                UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10 + i*45, 85, 38, 38)];
                [goodsImageView setImageWithURL:[NSURL URLWithString:goodsEnty.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
                goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
                goodsImageView.layer.borderWidth = 1.0f;
                [cell.contentView addSubview:goodsImageView];
            }
            UILabel *pointLabel = [PublicMethod addLabel:CGRectMake(150, 82, 100, 38) setTitle:@"..." setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:16]];
            [cell.contentView addSubview:pointLabel];
            UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 96, 15, 18)];
            accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
            [cell.contentView addSubview:accessImg];
        }
        
        // pda 商品展示部分
        if ([orderEntity.order_type isEqualToString:@"2"] && orderEntity.orderArray.count == 0) {
            UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 85, 38, 38)];
            [goodsImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"image_pda.png"]];
            goodsImageView.layer.borderColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0].CGColor;
            goodsImageView.layer.borderWidth = 1.0f;
            [cell.contentView addSubview:goodsImageView];
            
            UILabel *goodsInfo = [PublicMethod addLabel:CGRectMake(60, 70, 200, 50) setTitle:@"永辉超市PDA快速通道购物" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
            [cell.contentView addSubview:goodsInfo];
            
            UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 96, 15, 18)];
            accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
            [cell.contentView addSubview:accessImg];
        }
        
        UIView *seperateLine2 = [PublicMethod addBackView:CGRectMake(0, 140, 320, 1) setBackColor:[UIColor lightGrayColor]];
        seperateLine2.alpha = 0.1f;
        [cell.contentView addSubview:seperateLine2];
        // 订单状态
        UILabel *orderStatus = [PublicMethod addLabel:CGRectMake(5, 150, 60, 33) setTitle:orderEntity.orderStatus setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        orderStatus.text = @"订单状态: ";
        orderStatus.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:orderStatus];
        
        UILabel *orderContext = [PublicMethod addLabel:CGRectMake(65, 150, 50, 33) setTitle:orderEntity.total_state_name setBackColor:[UIColor redColor] setFont:[UIFont systemFontOfSize:12]];
        orderContext.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:orderContext];
        
        UILabel *payStatus = [PublicMethod addLabel:CGRectMake(120, 150, 60, 33) setTitle:orderEntity.orderStatus setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        payStatus.text = @"支付状态 :";
        payStatus.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:payStatus];
        
        UILabel *payContext = [PublicMethod addLabel:CGRectMake(180, 150, 60, 33) setTitle:orderEntity.pay_status_name setBackColor:[UIColor redColor] setFont:[UIFont systemFontOfSize:12]];
        payContext.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:payContext];
        
        // 配送详情 －已经支付过的&不是pda
        if ([orderEntity.order_type isEqualToString:@"1"] && [orderEntity.pay_status isEqualToString:@"1"]) {
                // 配送详情
            UIButton *deliveryDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deliveryDetailBtn.frame = CGRectMake(250, 152, 60, 25);
            deliveryDetailBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
            deliveryDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [deliveryDetailBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
            deliveryDetailBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [deliveryDetailBtn addTarget:self action:@selector(handSeleClicked:) forControlEvents:UIControlEventTouchUpInside];
            deliveryDetailBtn.tag = indexPath.row ;
            [cell.contentView addSubview:deliveryDetailBtn];
        }
    }
    return cell;
}

/*已完成订单点击商品跳转到商品详情页面,进而可以进行评论*/
- (void)goGoodsDetailWithBuyFinish:(GoodsEntity *)goodEntity{
    YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,goodEntity.bu_goods_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    [detailVC setMainGoodsUrl:url goodsID:goodEntity.bu_goods_id];
    [self.navigationController pushViewController:detailVC animated:YES];
}

///*转赠*/
- (void)donation:(id)sender{
    [MTA trackCustomKeyValueEvent :EVENT_ID11 props:nil];
    UIButton *btn = (UIButton *)sender;
    self.forwardSelectTag = btn.tag;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请慎重操作本步" message:@"按确定后,将触发短信转赠给您的友人,且无法取消." delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
//    alert.tag =1004;
//    [alert show];
    
    MyOrderEntity *orderEntity=[orderListArray objectAtIndex:self.forwardSelectTag];
    [[NetTrans getInstance]donation_Order:self OrderId:orderEntity.order_list_no];
}

/*订单详情*/
- (void)handSeleClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MyOrderEntity *orderEntity = [orderListArray objectAtIndex:btn.tag];
    YHOrderDetailViewController *orderDetail = [[YHOrderDetailViewController alloc] init];
    [orderDetail setDeliveryEntity:orderEntity];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

// 是否存在此可转发订单
- (BOOL)isHasHandleSelEntity:(MyOrderEntity *)entity{
    BOOL isExist = NO;
    for (MyOrderEntity *entity1 in handleSelArray) {
        if ([entity isEqual:entity1]) {
            isExist = YES;
        }
    }
    return isExist;
}

/*调用短信*/
-(void)openMsg:(NSString *)text {
    if([MFMessageComposeViewController canSendText])
    {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _msgVC.body = text;
        [self presentModalViewController:_msgVC animated:YES];
    }
}

#pragma mark ---------------- MFMessageComposeViewController Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    [self initMsg];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    switch ( result ) {
        case MessageComposeResultCancelled:
        {
            // 取消
            [controller popViewControllerAnimated:YES];
            [self requestWithParamers:myOrderType WithCountPage:1];
        }
            break;
        case MessageComposeResultFailed:// send failed
        {
            // 发送失败
            [self requestWithParamers:myOrderType WithCountPage:1];
        }
            break;
        case MessageComposeResultSent:
        {
            // 发送成功
            //do something
            [[NetTrans getInstance] change_donation_order_state:self OrderId:donation_order_id];
//            [self requestWithParamers:myOrderType WithCountPage:1];
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

/*刷新接口请求*/
- (void)reloadTableViewDataSource{
	_moreloading = YES;
    requestStyle = Load_RefrshStyle ;
    countPage = 1;
    [self requestWithParamers:myOrderType WithCountPage:countPage];}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;

    [self requestWithParamers:myOrderType WithCountPage:countPage];
}

#pragma mark  ---------------------------------------------------新事件Button处理
- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/* 未支付／已支付/ 已完成 */
- (void)buttonClickWithSytle:(id)sender
{
    self.total = 0;
    self.dataState = EGOOHasMore;
    [self.orderListArray removeAllObjects];
    UIButton *button = (UIButton *)sender;
    NSInteger orderTypeTag = button.tag - 1000;
   
    [self resetButtonBackGround];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (button == readyPay) {
        [button setBackgroundImage:buttonSelectImage forState:UIControlStateNormal];
    }else if(button == alreadyPay){
        [button setBackgroundImage:buttonFinishSelectImage forState:UIControlStateNormal];
    }else if (button == getAlreadyPay){
        [button setBackgroundImage:buttonFinishSelectImage forState:UIControlStateNormal];
    }
    else{
        [button setBackgroundImage:buttonCancelSelectImage forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 选择状态 在切换过程中根据 button.tag － 1000 ＝ 1.2.3.4分别代表四种切换状态
    self.myOrderType = orderTypeTag;
    countPage = 1;
    [self requestWithParamers:myOrderType WithCountPage:countPage];
}

/* reset 未支付／已支付／已完成 */
- (void)resetButtonBackGround{
    [readyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [alreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [finishPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [getAlreadyPay setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [readyPay setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [alreadyPay setBackgroundImage:buttonFinishBgImage forState:UIControlStateNormal];
    [finishPay setBackgroundImage:buttonCancelBgImage forState:UIControlStateNormal];
    [getAlreadyPay setBackgroundImage:buttonCancelBgImage forState:UIControlStateNormal];

}

/* 支付 */
-(void)payAction:(id)sender
{
    UIButton *sectionBtn = (UIButton *)sender;
    sectionTag = sectionBtn.tag;
    _orderEntity = [orderListArray objectAtIndex:sectionTag];
    
    //app订单
    if ([_orderEntity.order_type isEqualToString:@"1"]) {
        YHConfirmOrderViewController * covc = [[YHConfirmOrderViewController alloc]init ];
        covc.isFromOrderDetail = YES;
        //517 立即购。。
        if (_orderEntity.transaction_type.integerValue == 1){
            GoodsEntity * entity = [_orderEntity.orderArray lastObject];
            covc.goods_id = entity.bu_goods_id;
        }
        covc.order_list_id = _orderEntity.order_list_id;
        covc.order_type = _orderEntity.order_type;
        [[PSNetTrans getInstance] my_orderDetail:covc order_list_id:covc.order_list_id];
        [self.navigationController  pushViewController:covc animated:YES];
        //PDA订单
    }else if ([_orderEntity.order_type isEqualToString:@"2"]){
        YHQuickScanOrderViewController * scvc = [[YHQuickScanOrderViewController alloc]init ];
        scvc.isFromMyOrder = YES;
        scvc.order_list_no = _orderEntity.order_list_no;
        [[PSNetTrans getInstance] my_orderDetailForPDA:scvc order_list_no:scvc.order_list_no];
//        scvc.block = ^(id obj){
//            [self requestWithParamers:myOrderType WithCountPage:1];
//        };
        [self.navigationController pushViewController:scvc animated:YES];
    }
    
}

/*取消订单*/
- (void)cancelAction:(id)sender{
    UIButton *orderBtn = (UIButton *)sender;
    cancelSectionTag = orderBtn.tag;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要取消该订单吗?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"否",@"是", nil];
    alertView.tag = 1001;
    [alertView show];
}


#pragma mark--------------------------------------------------- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark ----------------------------------------------------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (alertView.tag == 123 && buttonIndex == 1) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
    //  取消订单
    if (alertView.tag == 1001 && buttonIndex == 1) {
        MyOrderEntity *orderEntity = [orderListArray objectAtIndex:cancelSectionTag];
        [[NetTrans getInstance] buy_cancelOrder:self OrderId:orderEntity.order_list_id];
    }
    
    // 刷新接口
    if (alertView.tag == 1002) {
        [self reloadTableViewDataSource];
    }
    
    // 转赠
    if (alertView.tag == 1004 && buttonIndex == 1) {
        MyOrderEntity *orderEntity=[orderListArray objectAtIndex:self.forwardSelectTag];
        [[NetTrans getInstance]donation_Order:self OrderId:orderEntity.order_list_no];
    }
}

/* 首次请求待支付数据 */
- (void)initRequestUnpay{
    // init requestData
    requestStyle = Load_InitStyle ;
    countPage = 1;
//    [self requestWithParamers:myOrderType WithCountPage:countPage];
}

/* 请求接口方法 */
- (void)requestWithParamers:(MyOrderType)orderType WithCountPage:(NSInteger)page{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[PSNetTrans getInstance] my_orderList:self Type:orderType Page:[NSString stringWithFormat:@"%ld",(long)countPage]];
}

/* 更新数据 */
- (void)updateDateTableFromServer:(NSMutableArray *)serverArr{
    // 首次加载 ｜｜ 下拉刷新清空数据
    if (requestStyle != Load_MoreStyle) {
        [self.orderListArray removeAllObjects];
        [self.orderListArray addObjectsFromArray:serverArr];
    }else{
        [self.orderListArray addObjectsFromArray:serverArr];
    }
    if (self.orderListArray.count < self.orderListArray.count) {
        self._tableView.tableFooterView.hidden = NO;
    }else{
        self._tableView.tableFooterView.hidden = YES;
    }
    
    if (self.orderListArray.count == 0) {
        self._tableView.hidden = YES;
        resultImage.hidden = NO;
    }else{
        self._tableView.hidden = NO;
        resultImage.hidden = YES;
    }
    
    // 清楚转赠数组数据
    [handleSelArray removeAllObjects];
    
    if (requestStyle == Load_MoreStyle) {
        if (self.total == orderListArray.count) {
            self.dataState = EGOOOther;
        }else{
            self.dataState = EGOOHasMore;
        }
    }else{
        if (orderListArray.count <10) {
            self.dataState = EGOOOther;
        }else{
            self.dataState = EGOOHasMore;
        }
    }
    
    self.total = orderListArray.count;
    [self._tableView reloadData];
    //移除上拉
    if (self.total * 200 < SCREEN_HEIGHT - 64-40) {
        [self removeFooterView];
    }else{
        [self testFinishedLoadData];
    }
    [self finishLoadTableViewData];
}

#pragma mark ---------------------------------------------------Request Delegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [[iToast makeText:errMsg]show];
    self.dataState = EGOOLoadFail;
    [self testFinishedLoadData];
    [self finishLoadTableViewData];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // 开启转赠
    if (t_API_BUY_PLATFORM_DONATION_API == nTag) {
        NSMutableString *msgInfo = [[NSMutableString alloc] init];
        NSMutableArray *array = (NSMutableArray *)netTransObj;
        for (DonationEntity *entity in array) {
            [msgInfo appendString:entity.info];
            donation_order_id = entity.order_list_id;
        }
        [self openMsg:msgInfo];
    }
    // 取消订单
    if (nTag == t_API_BUY_PLATFORM_CANCELORDER_API) {
        requestStyle = Load_InitStyle ;
        [orderListArray removeAllObjects];
        [self requestWithParamers:myOrderType WithCountPage:1];
        [self showNotice:@"取消订单成功"];
        [self._tableView reloadData];
    }
    // 待支付／已支付／已完成
    if (nTag == t_API_PS_MYORDER_LIST) {
        NSMutableArray *successArr = (NSMutableArray *)netTransObj;
        [self updateDateTableFromServer:successArr];
    }
    
    if (t_API_CHANGE_DONATION_STATE_API == nTag) {
         [self requestWithParamers:myOrderType WithCountPage:1];
    }
    [self finishLoadTableViewData];
}



@end
