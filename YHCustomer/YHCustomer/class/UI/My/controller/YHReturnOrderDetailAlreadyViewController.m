//
//  YHReturnOrderDetailAlreadyViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-5-6.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  退货订单详情－已提货(已取货)

#import "YHReturnOrderDetailAlreadyViewController.h"
#import "GoodsView.h"
#import "OneOrderInfoView.h"
#import "GJGLAlertView.h"

#define TABLEVIEW_HEADER_LABEL_HEIGHT 10
@interface YHReturnOrderDetailAlreadyViewController ()

@end

@implementation YHReturnOrderDetailAlreadyViewController
@synthesize myReturnOrderEntity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myReturnOrderEntity = [[ReturnOrderEntity alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    self.navigationItem.title = @"退货单详情";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self._tableView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-   NAVBAR_HEIGHT);
    self._tableView.backgroundColor = LIGHT_GRAY_COLOR;
    self._tableView.backgroundView = nil;
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self._tableView.tableHeaderView = [self addTableViewHeaderView];
}

- (void)addRefreshTableHeaderView{
}
- (void)addGetMoreFootView{
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)addTableViewHeaderView{
    
    UIView *headerBg = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 130+35) setBackColor:LIGHT_GRAY_COLOR];
    
    CGFloat originY1 = 7.0f;
//    if ([self.myReturnOrderEntity.total_state_str isEqualToString:@"退款中"] || [self.myReturnOrderEntity.total_state_str isEqualToString:@"款已退"]) {
//         originY1 = 0.0f;
//    }
    
    UIView *headerView = [PublicMethod addBackView:CGRectMake(0, 10, ScreenSize.width, 110+35) setBackColor:[UIColor whiteColor]];
    UILabel *order_no = [PublicMethod addLabel:CGRectMake(10, 10 , 230,TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:[NSString stringWithFormat:@"退货单号:%@",myReturnOrderEntity.sales_return_no] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];

    UILabel *order_time = [PublicMethod addLabel:CGRectMake(10, order_no.bottom+originY1, 230, TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:[NSString stringWithFormat:@"下单时间:%@",myReturnOrderEntity.sdate]  setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];

    UILabel *order_apply_amount = [PublicMethod addLabel:CGRectMake(10, order_time.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"申请金额:%@",self.myReturnOrderEntity.apply_retamt] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_amount = [PublicMethod addLabel:CGRectMake(10, order_apply_amount.bottom+originY1, 230, TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:[NSString stringWithFormat:@"实退金额:¥ %@",myReturnOrderEntity.retamt] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];

    if (!self.myReturnOrderEntity.apply_retamt || [self.myReturnOrderEntity.apply_retamt isEqualToString:@""]) {//申请金额为空
        headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height - 13);
        headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height - 13);
        
        order_amount.frame = CGRectMake(10, order_time.bottom+7, 230, 10);
        
    } else {
        [headerView addSubview:order_apply_amount];
    }
    
    UILabel *order_returns_logistics_amount = [PublicMethod addLabel:CGRectMake(10, order_amount.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"上门取货费:￥%@",self.myReturnOrderEntity.returns_logistics_amount]setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_fc_amt = [PublicMethod addLabel:CGRectMake(10, order_returns_logistics_amount.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"运险费:￥%@",self.myReturnOrderEntity.fc_amt]setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];

    UILabel *order_state = [PublicMethod addLabel:CGRectMake(10, order_fc_amt.bottom+originY1, 55, TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:@"退货单状态:"  setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_state_det = [PublicMethod addLabel:CGRectMake(order_state.right, order_fc_amt.bottom+originY1, 100, TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:myReturnOrderEntity.total_state_str  setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_style = [PublicMethod addLabel:CGRectMake(10, order_state.bottom+originY1, 230, TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:[NSString stringWithFormat:@"申请方式:%@",myReturnOrderEntity.how_to_apply_str] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
  

    [headerView addSubview:order_no];
    [headerView addSubview:order_time];


    if ([self.myReturnOrderEntity.returns_method isEqualToString:@"2"]) {//上门取货
        
        if (!([self.myReturnOrderEntity.total_state_str isEqualToString:@"退款中"] || [self.myReturnOrderEntity.total_state_str isEqualToString:@"款已退"])) {
            //隐藏实退金额
            headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height - 13);
            headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height - 13);
            
            if (!self.myReturnOrderEntity.apply_retamt  || [self.myReturnOrderEntity.apply_retamt isEqualToString:@""]) {//申请金额为空
                order_returns_logistics_amount.frame = CGRectMake(10, order_time.bottom+7, 230, 10);
            } else {
                order_returns_logistics_amount.frame = CGRectMake(10, order_apply_amount.bottom+7, 230, 10);
            }
            
        } else  {
            
            [headerView addSubview:order_amount];
        
        }
        
        [headerView addSubview:order_returns_logistics_amount];
        
        order_state.frame = CGRectMake(10, order_returns_logistics_amount.bottom+7, 55, 10);
        order_state_det.frame = CGRectMake(order_state.right, order_returns_logistics_amount.bottom+7, 230, 10);
        order_style.frame = CGRectMake(10, order_state.bottom+7, 230, 10);
        
    } else if ([self.myReturnOrderEntity.returns_method isEqualToString:@"3"]) {//快递送货
        
        if (!([self.myReturnOrderEntity.total_state_str isEqualToString:@"退款中"] || [self.myReturnOrderEntity.total_state_str isEqualToString:@"款已退"])) {
            //隐藏实退金额
            headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height - 13);
            headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height - 13);
            
            if (!self.myReturnOrderEntity.apply_retamt  || [self.myReturnOrderEntity.apply_retamt isEqualToString:@""]) {//申请金额为空
                order_fc_amt.frame = CGRectMake(10, order_time.bottom+7, 230, 10);
            } else {
                order_fc_amt.frame = CGRectMake(10, order_apply_amount.bottom+7, 230, 10);
            }
            
        } else  {
            order_fc_amt.frame = CGRectMake(10, order_amount.bottom+7, 230, 10);
            [headerView addSubview:order_amount];
        }
        
        [headerView addSubview:order_fc_amt];
        
        order_state.frame = CGRectMake(10, order_fc_amt.bottom+7, 55, 10);
        order_state_det.frame = CGRectMake(order_state.right, order_fc_amt.bottom+7, 230, 10);
        order_style.frame = CGRectMake(10, order_state.bottom+7, 230, 10);
        
    } else {//送货到门店
        headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height - 13);
        headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height - 13);

        if (!([self.myReturnOrderEntity.total_state_str isEqualToString:@"退款中"] || [self.myReturnOrderEntity.total_state_str isEqualToString:@"款已退"])) {
            //隐藏实退金额
            headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height - 13);
            headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height - 13);
            
            if (!self.myReturnOrderEntity.apply_retamt  || [self.myReturnOrderEntity.apply_retamt isEqualToString:@""]) {//申请金额为空
                order_state.frame = CGRectMake(10, order_time.bottom+7, 55, 10);
                order_state_det.frame = CGRectMake(order_state.right, order_time.bottom+7, 230, 10);
                order_style.frame = CGRectMake(10, order_state.bottom+7, 230, 10);
            } else {
                order_state.frame = CGRectMake(10, order_apply_amount.bottom+7, 55, 10);
                order_state_det.frame = CGRectMake(order_state.right, order_apply_amount.bottom+7, 230, 10);
                order_style.frame = CGRectMake(10, order_state.bottom+7, 230, 10);
            }
            
            
        } else  {
            [headerView addSubview:order_amount];
            
            order_state.frame = CGRectMake(10, order_amount.bottom+7, 55, 10);
            order_state_det.frame = CGRectMake(order_state.right, order_amount.bottom+7, 230, 10);
            order_style.frame = CGRectMake(10, order_state.bottom+7, 230, 10);
        }
    }
    

    
    [headerView addSubview:order_style];
    [headerView addSubview:order_state];
    [headerView addSubview:order_state_det];
    
    if ([myReturnOrderEntity.total_state_str isEqualToString:@"款已退"]) {
        UILabel *order_bank = [PublicMethod addLabel:CGRectMake(10, order_style.bottom+originY1, 230, TABLEVIEW_HEADER_LABEL_HEIGHT) setTitle:@"退款到账:以银行为准" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
        [headerView addSubview:order_bank];
    }else{
        headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height-13);
        headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height-13);
    }
    
    if ([self.myReturnOrderEntity.total_state_str isEqualToString:@"已申请"]) {
        UIButton *deliveryDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deliveryDetailBtn.frame = CGRectMake(230, 10, 80, 24);
        deliveryDetailBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        deliveryDetailBtn.tag = 1001;
        deliveryDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [deliveryDetailBtn setTitle:@"取消退货" forState:UIControlStateNormal];
        deliveryDetailBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [deliveryDetailBtn addTarget:self action:@selector(cancelReturnOrder:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:deliveryDetailBtn];
    }
    
    if ([myReturnOrderEntity.returns_method isEqualToString:@"3"] && [myReturnOrderEntity.orderStatus isEqualToString:@"已审核"]) {
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(200, 65, 110, 24);
        orderBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [orderBtn setTitle:@"请输入快递单号" forState:UIControlStateNormal];
        orderBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [orderBtn addTarget:self action:@selector(handSeleClicked:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.tag = 1002 ;
        [headerView addSubview:orderBtn];
    }
    [headerBg addSubview:headerView];
    return headerBg;
}

- (void)cancelReturnOrder:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要取消此退货订单?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"否",@"是", nil];
    alert.tag = 1005;
    [alert show];
}

// 输入账单号
- (void)handSeleClicked:(id)sender{
    GJGLAlertView *alertView = [GJGLAlertView shareInstance];
    [[GJGLAlertView shareInstance] setAlertViewBlock:^(NSString *companyName,NSString *orderName){
        if (myReturnOrderEntity.sales_return_id.length == 0) {
            [self showNotice:@"单号id不能为空!"];
            return ;
        }
        [[PSNetTrans getInstance] API_order_InputExpress:self sales_return_id:myReturnOrderEntity.sales_return_id express_name:companyName express_num:orderName];
    } CancelBlock:^(){
        if (alertView) {
            [alertView removeFromSuperview];
        }
    }];
    [self.view addSubview:alertView];
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([myReturnOrderEntity.returns_reject_info length] == 0)
            return 0.f;
        return 90.f;
    }else if (indexPath.section == 1){
        if (![myReturnOrderEntity.returns_reason_id isEqualToString:@"8"])
            return 40.f;
        return 90.f;
    }else if (indexPath.section == 2){
        if ([myReturnOrderEntity.returns_reason_id isEqualToString:@"3"])
            return 0.f;
        return 90.f;
    }else if (indexPath.section == 3){
        if ([myReturnOrderEntity.returns_reason_id isEqualToString:@"3"])
            return 0.f;
        return 90.f;
    }else if (indexPath.section == 4){
        if([myReturnOrderEntity.pay_method isEqualToString:@"100"])
            return 0.f;
        return 90.f;

    }else if (indexPath.section == 5){
        if (![myReturnOrderEntity.returns_method isEqualToString:@"3"])
            return 50.f+45.f;
        return 90.f+35.f;
    }else if (indexPath.section == 6){
        return 30 + myReturnOrderEntity.orderArray.count*60;
    }
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    
    UIView *bgCell = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 90-10) setBackColor:[UIColor clearColor]];
    [cell.contentView addSubview:bgCell];
    
    UILabel *titleLabel = [PublicMethod addLabel:CGRectMake(0, 0, 320, 30) setTitle:@"title" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:15]];
    titleLabel.backgroundColor = [UIColor whiteColor];
    UIView *line1 = [PublicMethod addBackView:CGRectMake(0, 29, 320, 1) setBackColor:LIGHT_GRAY_COLOR];
    [titleLabel addSubview:line1];
    
    UIView *rowCellBg = [PublicMethod addBackView:CGRectMake(0, 30, 320, 90 - 30 -10) setBackColor:[PublicMethod colorWithHexValue:0xfcfee2 alpha:1.0f]];

    switch (indexPath.section) {
        case 0:
        {
            titleLabel.text = @"  取消原因";
            if ([myReturnOrderEntity.returns_reject_info length] > 0) {
                [cell.contentView addSubview:titleLabel];
                
                [cell.contentView addSubview:rowCellBg];
                UILabel *reasonLabel = [PublicMethod addLabel:CGRectMake(9, 45, 320, 20) setTitle:myReturnOrderEntity.returns_reject_info setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:reasonLabel];
            }
      
        }
            break;
        case 1:
        {
            titleLabel.text = @"  退货原因";
            NSString *reasonInfo = nil;
            if ([myReturnOrderEntity.returns_reason_id isEqualToString:@"8"]) {
                reasonInfo = @"其他";
                [cell.contentView addSubview:rowCellBg];
                if (myReturnOrderEntity.returns_reason_info.length == 0) {
                    myReturnOrderEntity.returns_reason_info = @"未输入";
                }
                UILabel *reasonLabel = [PublicMethod addLabel:CGRectMake(9, 45, 320, 20) setTitle:myReturnOrderEntity.returns_reason_info setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:reasonLabel];
            }else{
                if (myReturnOrderEntity.returns_reason_info.length == 0) {
                    reasonInfo = @"未输入";
                }else{
                    reasonInfo =myReturnOrderEntity.returns_reason_info;
                }
            }
            [cell.contentView addSubview:titleLabel];

            UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(170, 0, 130, 30) setTitle:reasonInfo  setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
            titleLabelInfo.textAlignment = NSTextAlignmentRight;
            [titleLabel addSubview:titleLabelInfo];
        }
            break;
        case 2:
        {
            NSString *reasonInfo = nil;
            if (![myReturnOrderEntity.returns_reason_id isEqualToString:@"3"]) {
                titleLabel.text = @"  退货说明";
                [cell.contentView addSubview:rowCellBg];
                if (myReturnOrderEntity.returns_reason_info.length == 0) {
                    reasonInfo = @"未输入";
                }else{
                    reasonInfo =myReturnOrderEntity.returns_reason_explanation;
                }
                UILabel *reasonLabel = [PublicMethod addLabel:CGRectMake(9, 45, 320, 20) setTitle:reasonInfo setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                [cell.contentView addSubview:reasonLabel];
                [cell.contentView addSubview:titleLabel];
            }
        }
            break;
        case 3:
        {
            if (![myReturnOrderEntity.returns_reason_id isEqualToString:@"3"]) {
                titleLabel.text = @"  退货商品照片";
                GoodsView *goodsView = [[GoodsView alloc] initWithFrame:CGRectMake(0, 30, 320, 35)];
                [goodsView setGoodsArray:myReturnOrderEntity.returnsImagesArray];
                rowCellBg.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:rowCellBg];
                [cell.contentView addSubview:goodsView];
                [cell.contentView addSubview:titleLabel];
            }
        }
            break;
        case 4:
        {
            // 退货支付方式 － 支付宝
            NSString *pay_method = nil;
            if ([myReturnOrderEntity.pay_method isEqualToString:@"200"])
            {
                
                titleLabel.text = @"  退货帐号信息";
                [cell.contentView addSubview:titleLabel];
                [cell.contentView addSubview:rowCellBg];

                pay_method = myReturnOrderEntity.pay_method_str;
                UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:pay_method setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                titleLabelInfo.textAlignment = NSTextAlignmentRight;
                [titleLabel addSubview:titleLabelInfo];
                
                if (myReturnOrderEntity.returns_name.length == 0) {
                    myReturnOrderEntity.returns_name = @"未输入";
                }
                if (myReturnOrderEntity.returns_card_num.length == 0) {
                    myReturnOrderEntity.returns_card_num = @"未输入";
                }
                if (myReturnOrderEntity.returns_account.length == 0) {
                    myReturnOrderEntity.returns_account = @"未输入";
                }
                UILabel *name = [PublicMethod addLabel:CGRectMake(7, 32, 200, 15) setTitle:[NSString stringWithFormat:@"姓名 :%@",myReturnOrderEntity.returns_name] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                UILabel *card = [PublicMethod addLabel:CGRectMake(7, 62, 200, 15) setTitle:[NSString stringWithFormat:@"帐号 :%@",myReturnOrderEntity.returns_account] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                name.origin = CGPointMake(7, 38);
                card.origin = CGPointMake(7, 56);
                
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:card];
            }
           
        }
            break;
        case 5:
        {
            titleLabel.text = @"  退货方式";
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:rowCellBg];
        
            NSString *returnMethod = nil;
            if ([myReturnOrderEntity.returns_method isEqualToString:@"1"]) {
                returnMethod = @"送货到门店";
                UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:returnMethod setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                titleLabelInfo.textAlignment = NSTextAlignmentRight;
                [titleLabel addSubview:titleLabelInfo];
                
                if (myReturnOrderEntity.returns_method_a.length == 0) {
                    myReturnOrderEntity.returns_method_a = @"未输入";
                }
                UILabel *name = [PublicMethod addLabel:CGRectMake(7, 36, 200, 15) setTitle:[NSString stringWithFormat:@"办理门店 : %@",myReturnOrderEntity.returns_method_a] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                if (myReturnOrderEntity.returns_method_b.length == 0) {
                    myReturnOrderEntity.returns_method_b = @"未输入";
                }
                
                UILabel *address = [PublicMethod addLabel:CGRectMake(7, 47, 300, 30) setTitle:[NSString stringWithFormat:@"门店地址 : %@",myReturnOrderEntity.returns_method_b] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:address];
            }
            else if([myReturnOrderEntity.returns_method isEqualToString:@"2"]) {
                returnMethod = @"上门取货";
                UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:returnMethod setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                titleLabelInfo.textAlignment = NSTextAlignmentRight;
                [titleLabel addSubview:titleLabelInfo];
                
                if (myReturnOrderEntity.returns_method_a.length == 0) {
                    myReturnOrderEntity.returns_method_a = @"未输入";
                }
                UILabel *name = [PublicMethod addLabel:CGRectMake(7, 34, 200, 15) setTitle:[NSString stringWithFormat:@"%@  %@",myReturnOrderEntity.returns_method_a,myReturnOrderEntity.returns_method_b] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                if (myReturnOrderEntity.returns_method_b.length == 0) {
                    myReturnOrderEntity.returns_method_b = @"未输入";
                }
                
                UILabel *address = [PublicMethod addLabel:CGRectMake(7, 48, 300, 30) setTitle:[NSString stringWithFormat:@"地址 : %@%@",myReturnOrderEntity.returns_method_c,myReturnOrderEntity.returns_method_d] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:address];

            }else{
                
                returnMethod = @"快递送货";
                UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:returnMethod setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
                titleLabelInfo.textAlignment = NSTextAlignmentRight;
                [titleLabel addSubview:titleLabelInfo];
                
                UIView *bgExpress = [PublicMethod addBackView:CGRectMake(0, 75, 320, 40) setBackColor:[UIColor whiteColor]];
                
                if (myReturnOrderEntity.returns_method_a.length == 0) {
                    myReturnOrderEntity.returns_method_a = @"未输入";
                }
                
                UILabel *name = [PublicMethod addLabel:CGRectMake(7, 36, 200, 15) setTitle:[NSString stringWithFormat:@"办理门店 : %@",myReturnOrderEntity.returns_method_a] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                if (myReturnOrderEntity.returns_method_b.length == 0) {
                    myReturnOrderEntity.returns_method_b = @"未输入";
                }
                
                UILabel *address = [PublicMethod addLabel:CGRectMake(7, 47, 300, 30) setTitle:[NSString stringWithFormat:@"门店地址 : %@",myReturnOrderEntity.returns_method_b] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:address];
                
                NSString *info = nil;
                if (myReturnOrderEntity.returns_method_f.length == 0) {
                    info = @"未输入";
                }else{
                    info =myReturnOrderEntity.returns_method_f;
                }
                UILabel *express_company = [PublicMethod addLabel:CGRectMake(7, 7, 200, 15) setTitle:[NSString stringWithFormat:@"快递公司 :%@",info] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                if (myReturnOrderEntity.returns_method_f.length == 0) {
                    myReturnOrderEntity.returns_method_g = @"未输入";
                }
                UILabel *express_no = [PublicMethod addLabel:CGRectMake(7, 23, 200, 15) setTitle:[NSString stringWithFormat:@"快递单号 :%@",myReturnOrderEntity.returns_method_g] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
                
                [bgExpress addSubview:express_company];
                [bgExpress addSubview:express_no];
                [cell.contentView addSubview:bgExpress];
            }
        }
            break;
        case 6:
        {
            titleLabel.text = @"  退货商品";
            [cell.contentView addSubview:titleLabel];
            UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:[NSString stringWithFormat:@"共%lu件商品",(unsigned long)myReturnOrderEntity.orderArray.count] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
            titleLabelInfo.textAlignment = NSTextAlignmentRight;
            [titleLabel addSubview:titleLabelInfo];
            bgCell.frame = CGRectMake(0, 0, 320, 130);
            
            for (int i=0; i < myReturnOrderEntity.orderArray.count; i ++) {
                GoodsEntity *oneGoods =  [myReturnOrderEntity.orderArray objectAtIndex:i];
                OneOrderInfoView *oneGoodsView = [[OneOrderInfoView alloc] initWithFrame:CGRectMake(0, 30+i * 60, 320, 60)];
                [oneGoodsView setReturnInfoGoodEntity:oneGoods];
                [cell.contentView addSubview:oneGoodsView];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark ---------------------------------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag == T_API_CANCEL_RETURN_GOODS) {
        [self showNotice:@"取消成功!"];
        _cancelBlock();
        [self back:nil];
    }
    
    if (nTag == t_API_PS_RETURN_ORDER) {
        [self showNotice:@"提交成功!"];
        _deliveryBlock();
        GJGLAlertView *alertView = [GJGLAlertView shareInstance];
        if (alertView) {
            [alertView removeFromSuperview];
        }
        [self back:nil];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag == T_API_CANCEL_RETURN_GOODS)
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
     [[iToast makeText:errMsg]show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1005 && buttonIndex == 1) {
        [[PSNetTrans getInstance]cancel_return_goods:self sales_return_id:self.myReturnOrderEntity.sales_return_id];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
