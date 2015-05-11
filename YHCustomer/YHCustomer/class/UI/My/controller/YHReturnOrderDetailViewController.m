//
//  YHReturnOrderDetailViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-5-8.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHReturnOrderDetailViewController.h"
#import "GoodsEntity.h"
#import "OneOrderInfoView.h"

@interface YHReturnOrderDetailViewController ()

@end

@implementation YHReturnOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.myReturnOrderEntity = [[ReturnOrderEntity alloc] init];
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
    
    UIView *headerBg = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 115+35) setBackColor:LIGHT_GRAY_COLOR];
    
    UIView *headerView = [PublicMethod addBackView:CGRectMake(0, 10, ScreenSize.width, 95+35) setBackColor:[UIColor whiteColor]];
    UILabel *order_no = [PublicMethod addLabel:CGRectMake(10, 10, 230, 10) setTitle:[NSString stringWithFormat:@"退款单号:%@",self.myReturnOrderEntity.sales_return_no] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_time = [PublicMethod addLabel:CGRectMake(10, order_no.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"申请时间:%@",self.myReturnOrderEntity.sdate] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_apply_amount = [PublicMethod addLabel:CGRectMake(10, order_time.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"申请金额:%@",self.myReturnOrderEntity.apply_retamt] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_amount = [PublicMethod addLabel:CGRectMake(10, order_apply_amount.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"实退金额:￥%@",self.myReturnOrderEntity.retamt]setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];

    if (!self.myReturnOrderEntity.apply_retamt || [self.myReturnOrderEntity.apply_retamt isEqualToString:@""]) {//申请金额为空
        headerBg.frame = CGRectMake(0, 0, ScreenSize.width, headerBg.height - 13);
        headerView.frame = CGRectMake(0, 10, ScreenSize.width, headerView.height - 13);
        
        order_amount.frame = CGRectMake(10, order_time.bottom+7, 230, 10);
        
    } else {
        [headerView addSubview:order_apply_amount];
    }
    
    UILabel *order_returns_logistics_amount = [PublicMethod addLabel:CGRectMake(10, order_amount.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"上门取货费:￥%@",self.myReturnOrderEntity.returns_logistics_amount]setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_fc_amt = [PublicMethod addLabel:CGRectMake(10, order_amount.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"运险费:￥%@",self.myReturnOrderEntity.fc_amt]setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    
    UILabel *order_state = [PublicMethod addLabel:CGRectMake(10, order_fc_amt.bottom+7, 55, 10) setTitle:@"退货单状态:" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    UILabel *order_state_det = [PublicMethod addLabel:CGRectMake(order_state.right, order_fc_amt.bottom+7, 230, 10) setTitle:self.myReturnOrderEntity.total_state_str setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *order_style = [PublicMethod addLabel:CGRectMake(10, order_state.bottom+7, 230, 10) setTitle:[NSString stringWithFormat:@"申请方式:%@",self.myReturnOrderEntity.how_to_apply_str] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:10]];

    
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
    
    if ([self.myReturnOrderEntity.total_state isEqualToString:@"0"]) {//已申请
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(225, 12, 80, 30);
        cancelBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        cancelBtn.tag = 1001;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelBtn setTitle:@"取消退货" forState:UIControlStateNormal];
        cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:cancelBtn];
    }
    
    [headerBg addSubview:headerView];
    
    return headerBg;
}

- (void)handSeleClicked:(id)sender{
    
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if(![self.myReturnOrderEntity.returns_reason_id isEqualToString:@"8"]){//不是其它
            if (self.myReturnOrderEntity.returns_reject_info.length != 0) {
                return 40+90;
            } else
            return 40.f;
        } else {
            if (self.myReturnOrderEntity.returns_reject_info.length != 0) {
                return 90+90;
            } else
         return 90.f;
        }
    } else if (indexPath.section == 1) {
        if ([self.myReturnOrderEntity.pay_method isEqualToString:@"200"]) {//支付宝
            return 90.f;
        } else {
            return  30 + self.myReturnOrderEntity.orderArray.count*60;
        }
      
    } else if (indexPath.section == 2) {
        return  30 + self.myReturnOrderEntity.orderArray.count*60;
    }
    return 90.f;
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
    if ([self.myReturnOrderEntity.pay_method isEqualToString:@"200"]) {//支付宝,显示账号信息
        return 3;
    } else {
        return 2;
    }
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
    
    
    UIView *bgCell = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 90-10) setBackColor:[UIColor whiteColor]];
    [cell.contentView addSubview:bgCell];
    
    UILabel *titleLabel = [PublicMethod addLabel:CGRectMake(10, 0, 310, 30) setTitle:@"title" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:15]];
    [cell.contentView addSubview:titleLabel];
    
    UIView *rowCellBg = [PublicMethod addBackView:CGRectMake(0, 30, 320, 90 - 30 -10) setBackColor:[PublicMethod colorWithHexValue:0xfcfee2 alpha:1.0f]];

    switch (indexPath.section) {
        case 0:
        {
            if (self.myReturnOrderEntity.returns_reject_info.length != 0) {
                titleLabel.text = @"取消原因";
                bgCell.frame = CGRectMake(0, 0, 320, 80);
                [cell.contentView addSubview:rowCellBg];
                    
                UILabel *reasonDet = [PublicMethod addLabel:CGRectMake(10, 0, 300, 50) setTitle:self.myReturnOrderEntity.returns_reason_explanation setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
                reasonDet.numberOfLines = 0;
                reasonDet.lineBreakMode = NSLineBreakByWordWrapping;
                reasonDet.text = self.myReturnOrderEntity.returns_reject_info;
                [rowCellBg addSubview:reasonDet];
                
                UIView *whiteBg = [PublicMethod addBackView:CGRectMake(0, rowCellBg.bottom+10, ScreenSize.width, 30) setBackColor:[UIColor whiteColor]];
                [cell.contentView addSubview:whiteBg];
                UILabel *title = [PublicMethod addLabel:CGRectMake(10, 0, 310, 30) setTitle:@"退货原因" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:15]];
                [whiteBg addSubview:title];
                UILabel *reason = [PublicMethod addLabel:CGRectMake(80, 0, 230, 30) setTitle:self.myReturnOrderEntity.returns_reason_info setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:15]];
                reason.numberOfLines = 1;
                [whiteBg addSubview:reason];
                
                reason.textAlignment = NSTextAlignmentRight;
                if([self.myReturnOrderEntity.returns_reason_id isEqualToString:@"8"]){//其它
                    reason.text = @"其它";
                    whiteBg.frame = CGRectMake(0, rowCellBg.bottom+10, ScreenSize.width, 80);
                    UIView *yellowBg = [PublicMethod addBackView:CGRectMake(0, 30, 320, 90 - 30 -10) setBackColor:[PublicMethod colorWithHexValue:0xfcfee2 alpha:1.0f]];
                    [whiteBg addSubview:yellowBg];
                    
                    UILabel *reasonDet = [PublicMethod addLabel:CGRectMake(10, 0, 300, 50) setTitle:self.myReturnOrderEntity.returns_reason_explanation setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
                    reasonDet.numberOfLines = 0;
                    reasonDet.lineBreakMode = NSLineBreakByWordWrapping;
                    reasonDet.text = self.myReturnOrderEntity.returns_reason_info;
                    [yellowBg addSubview:reasonDet];
                }
                
            } else {
                titleLabel.text = @"退货原因";
                bgCell.frame = CGRectMake(0, 0, 320, 30);
                
                UILabel *reason = [PublicMethod addLabel:CGRectMake(80, 0, 230, 30) setTitle:self.myReturnOrderEntity.returns_reason_info setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:15]];
                reason.numberOfLines = 1;
                [cell.contentView addSubview:reason];
                
                reason.textAlignment = NSTextAlignmentRight;
                if([self.myReturnOrderEntity.returns_reason_id isEqualToString:@"8"]){//其它
                    reason.text = @"其它";
                    bgCell.frame = CGRectMake(0, 0, 320, 80);
                    [cell.contentView addSubview:rowCellBg];
                    
                    UILabel *reasonDet = [PublicMethod addLabel:CGRectMake(10, 0, 300, 50) setTitle:self.myReturnOrderEntity.returns_reason_explanation setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
                    reasonDet.numberOfLines = 0;
                    reasonDet.lineBreakMode = NSLineBreakByWordWrapping;
                    reasonDet.text = self.myReturnOrderEntity.returns_reason_info;
                    [rowCellBg addSubview:reasonDet];
                }
            }
        }
            break;
        case 2:
        {
              bgCell.frame = CGRectMake(0, 0, 320, 30);
            if (indexPath.row == 0) {
                titleLabel.text = @"退货商品";
                
                UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:[NSString stringWithFormat:@"共%lu件商品",(unsigned long)self.myReturnOrderEntity.orderArray.count] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
                titleLabelInfo.textAlignment = NSTextAlignmentRight;
                [titleLabel addSubview:titleLabelInfo];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, SCREEN_WIDTH, 1)];
                line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                [bgCell addSubview:line];
            } else {
                [titleLabel removeFromSuperview];
            }
            
            for (int i=0; i < self.myReturnOrderEntity.orderArray.count; i ++) {
                GoodsEntity *oneGoods =  [self.myReturnOrderEntity.orderArray objectAtIndex:i];
                OneOrderInfoView *oneGoodsView = [[OneOrderInfoView alloc] initWithFrame:CGRectMake(0, 30+i * 60, 320, 60)];
                [oneGoodsView setReturnInfoGoodEntity:oneGoods];
                [cell.contentView addSubview:oneGoodsView];
            }

        }
            break;
        case 1:
        {
            if ([self.myReturnOrderEntity.pay_method isEqualToString:@"200"]) {
                titleLabel.text = @"退货帐号信息";
                [cell.contentView addSubview:titleLabel];
                [cell.contentView addSubview:rowCellBg];
                // 退货支付方式
                NSString *pay_method = nil;
                if ([self.myReturnOrderEntity.pay_method isEqualToString:@"100"]) {
                    pay_method = self.myReturnOrderEntity.pay_method_str;
                }
                else if ([self.myReturnOrderEntity.pay_method isEqualToString:@"200"])
                {
                     pay_method = self.myReturnOrderEntity.pay_method_str;
                }
                else if ([self.myReturnOrderEntity.pay_method isEqualToString:@"250"])
                {
                     pay_method = self.myReturnOrderEntity.pay_method_str;
                }
                UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:pay_method setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
                titleLabelInfo.textAlignment = NSTextAlignmentRight;
                [titleLabel addSubview:titleLabelInfo];
                
                UILabel *name = [PublicMethod addLabel:CGRectMake(10, 40, 200, 12) setTitle:[NSString stringWithFormat:@"姓名:%@",self.myReturnOrderEntity.returns_name] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
                
                UILabel *account = [PublicMethod addLabel:CGRectMake(10, name.bottom+10, 200, 12) setTitle:[NSString stringWithFormat:@"账号:%@",self.myReturnOrderEntity.returns_account] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
                
                [cell.contentView addSubview:name];
                [cell.contentView addSubview:account];
            } else {
                bgCell.frame = CGRectMake(0, 0, 320, 30);
                if (indexPath.row == 0) {
                    titleLabel.text = @"退货商品";
                    
                    UILabel *titleLabelInfo = [PublicMethod addLabel:CGRectMake(200, 0, 100, 30) setTitle:[NSString stringWithFormat:@"共%lu件商品",(unsigned long)self.myReturnOrderEntity.orderArray.count] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
                    titleLabelInfo.textAlignment = NSTextAlignmentRight;
                    [titleLabel addSubview:titleLabelInfo];
                    
                    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, SCREEN_WIDTH, 1)];
                    line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                    [bgCell addSubview:line];
                } else {
                    [titleLabel removeFromSuperview];
                }
                
                for (int i=0; i < self.myReturnOrderEntity.orderArray.count; i ++) {
                    GoodsEntity *oneGoods =  [self.myReturnOrderEntity.orderArray objectAtIndex:i];
                    OneOrderInfoView *oneGoodsView = [[OneOrderInfoView alloc] initWithFrame:CGRectMake(0, 30+i * 60, 320, 60)];
                    [oneGoodsView setReturnInfoGoodEntity:oneGoods];
                    [cell.contentView addSubview:oneGoodsView];
                }
            }

        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------------- action
-(void)cancelAction:(UIButton *)button {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要取消此退货订单?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
    [alert show];
}

#pragma mark ----------  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[PSNetTrans getInstance]cancel_return_goods:self sales_return_id:self.myReturnOrderEntity.sales_return_id];
    }
}

#pragma mark ---------------- net
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (T_API_CANCEL_RETURN_GOODS == nTag)
    {
        [self showNotice:@"取消成功!"];
        _cancelBlock();
        [self back:nil];
    } 
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
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
    [[iToast makeText:errMsg] show];
}

@end
