//
//  YHPaySucceedViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-4-8.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHPaySucceedViewController.h"
#import "YHMyOrderViewController.h"

@interface YHPaySucceedViewController ()

@end

@implementation YHPaySucceedViewController
@synthesize orderTableView;
@synthesize orderEntity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        orderEntity = [[OrderSubmitEntity alloc] init];
        self.navigationItem.title = @"订单支付成功";
        self.model = FetchPS;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 52, 44);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_shou-ye"] forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_shou-ye_selected"] forState:UIControlStateHighlighted];
    [backBtn setTitle:@"首页" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (IOS_VERSION >= 7) {
        negativeSpacer.width = -15;
    }else{
        negativeSpacer.width = -5;
    }
    NSArray *barItems = [NSArray arrayWithObjects:negativeSpacer,leftBarItem, nil];
    self.navigationItem.leftBarButtonItems =barItems;
    
    // 添加tableview
    UITableView *tmpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-originY-44) style:UITableViewStylePlain];
    tmpTable.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    tmpTable.scrollEnabled = NO;
    tmpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView = tmpTable;
    [self.view addSubview:tmpTable];
    
    [[PSNetTrans getInstance] order_pay_succeed:self order_list_id:self.order_list_id];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [MTA trackCustomKeyValueEvent:EVENT_ID43 props:nil];
    [self.orderTableView reloadData];
}

- (void)back:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
}

/*我得订单*/
-  (void)myOrder:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(gotoMyorder) withObject:nil
               afterDelay:5.f];
}

- (void)gotoMyorder{
    YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrder animated:YES
     ];
}

#pragma -
#pragma mark ---------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if (self.model == DeliverPS_PayOffline) {
                return 263;
            } else if (self.model == FetchPS) {
                return 271-10+[PublicMethod getLabelHeight:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setLabelWidth:300 setFont:[UIFont systemFontOfSize:12]]-10;
            } else  {
                return 251-10;
            }
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
        default:
            return 50;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark -
#pragma mark ---------------------------------------------------------UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.model) {
        case DeliverPS_PayOffline:
            return 1;
            break;
        case DeliverPS_PayOnline:
            return 2;
            break;
        case FetchPS:
            return 2;
            break;
        default:
            break;
    }
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
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
    
    switch (indexPath.row) {
        case 0:
        {
            UIView *yellowBG = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 59)];
            yellowBG.backgroundColor = [PublicMethod colorWithHexValue:0xfff6c6 alpha:1.0];
            UILabel *title = [PublicMethod addLabel:CGRectMake(10, 0, 280, 59) setTitle:@"订单已生成，祝你购物愉快!" setBackColor:[UIColor clearColor] setFont:[UIFont systemFontOfSize:13]];
            title.frame = CGRectMake(10, 13.5, 280, 12);
            yellowBG.frame = CGRectMake(10, 10, 300, 39);
            if (self.model == DeliverPS_PayOnline) {
                title.text = @"订单已付款，祝您购物愉快！";
            } else if (self.model == FetchPS) {
                title.text = @"订单已付款，祝您购物愉快！";
            } else {
                title.frame = CGRectMake(10, 13.5, 280, 12);
                yellowBG.frame = CGRectMake(10, 10, 300, 39);
            }
            title.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            title.lineBreakMode = NSLineBreakByWordWrapping;
            title.numberOfLines = 0;
            [yellowBG addSubview:title];
            [cell.contentView addSubview:yellowBG];
            
            UIView *infoBG1 = [[UIView alloc]initWithFrame:CGRectMake(10, yellowBG.bottom+10, 300, 76)];
            infoBG1.backgroundColor = [UIColor whiteColor];
            UILabel *orderNum = [PublicMethod addLabel:CGRectMake(10, 10, 300, 12) setTitle:[NSString stringWithFormat:@"订单编号:%@",orderEntity.order_list_no] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:orderNum];
            UILabel *goodsNum = [PublicMethod addLabel:CGRectMake(10, orderNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"商品数:%@件",orderEntity.goods_count] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:goodsNum];
            UILabel *price = [PublicMethod addLabel:CGRectMake(10, goodsNum.bottom+10, 60, 12) setTitle:[NSString stringWithFormat:@"支付金额:"] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:price];
            UILabel *priceDetail = [PublicMethod addLabel:CGRectMake(price.right-10, goodsNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"￥%@",orderEntity.total_amount] setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG1 addSubview:priceDetail];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, price.bottom+9, 300, 2)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
            [infoBG1 addSubview:line];
            [cell.contentView addSubview:infoBG1];
            
            UIView *infoBG2 = [[UIView alloc]initWithFrame:CGRectMake(10, infoBG1.bottom+1, 300, 76)];
            infoBG2.backgroundColor = [UIColor whiteColor];
            UILabel *psWay = [PublicMethod addLabel:CGRectMake(10, 10, 300, 12) setTitle:[NSString stringWithFormat:@"配送方式:%@",orderEntity.delivery_name] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG2 addSubview:psWay];
            UILabel *deliverWay = [PublicMethod addLabel:CGRectMake(10, orderNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"送货方式:%@",orderEntity.lm_title] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG2 addSubview:deliverWay];
            UILabel *deliverTime = [PublicMethod addLabel:CGRectMake(10, goodsNum.bottom+10, 300, 12) setTitle:[NSString stringWithFormat:@"送货时间:%@",orderEntity.lm_time_title] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
            [infoBG2 addSubview:deliverTime];
            [cell.contentView addSubview:infoBG2];
            
            if (self.model == FetchPS) {
                infoBG2.frame = CGRectMake(10, infoBG1.bottom+1, 300, 96-10+[PublicMethod getLabelHeight:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setLabelWidth:300 setFont:[UIFont systemFontOfSize:12]]);
                deliverWay.text = [NSString stringWithFormat:@"自提门店:%@",orderEntity.bu_name];
                deliverTime.text = [NSString stringWithFormat:@"自提时间:%@",orderEntity.pick_up_time];
                [infoBG2 addSubview:deliverWay];
                UILabel *deliverAdd = [PublicMethod addLabel:CGRectMake(10, deliverTime.bottom+10, 280, 12) setTitle:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
                deliverAdd.height = [PublicMethod getLabelHeight:[NSString stringWithFormat:@"自提地址:%@",orderEntity.address] setLabelWidth:280 setFont:[UIFont systemFontOfSize:12]];
                deliverAdd.numberOfLines = 0;
                deliverAdd.lineBreakMode = UILineBreakModeWordWrap;
                [infoBG2 addSubview:deliverAdd];
            } else {
                UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, price.bottom+9, 300, 1)];
                line2.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
                [infoBG2 addSubview:line];
            }
            
            if (self.model == DeliverPS_PayOffline) {
                UIView *infoBG3 = [[UIView alloc]initWithFrame:CGRectMake(10, infoBG2.bottom, 300, 32)];
                infoBG3.backgroundColor = [UIColor whiteColor];
                UILabel *payWay = [PublicMethod addLabel:CGRectMake(10, 10, 300, 12) setTitle:[NSString stringWithFormat:@"支付方式:"] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
                if ([orderEntity.pay_method isEqualToString:@"100"]) {
                    payWay.text = @"支付方式:银联支付";
                } else if ([orderEntity.pay_method isEqualToString:@"200"]) {
                    payWay.text = @"支付方式:支付宝支付";
                }else if ([orderEntity.pay_method isEqualToString:@"250"]) {
                    payWay.text = @"支付方式:永辉钱包支付";
                }
                payWay.textAlignment = NSTextAlignmentRight;
                [infoBG3 addSubview:payWay];
//                [cell.contentView addSubview:infoBG3];
            }
        }
            break;
        case 1:
        {
            [self addCellMyOrderBtn:cell];
        }
            break;
        default:
            break;
    }
    
    return cell;
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	if (alertView.tag == 123 && buttonIndex == 1) {
//		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
//	}
//    if (alertView.tag == 1002) {
//        YHMyOrderViewController *myOrder = [[YHMyOrderViewController alloc] init];
//        [self.navigationController pushViewController:myOrder animated:YES];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------------- cell
-(void)addCellPayMethodView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"支付方式";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 0, 110, 40)];
    pay.backgroundColor = [UIColor clearColor];
    pay.text = @"请选择支付方式";
    pay.font = [UIFont systemFontOfSize:12.0];
    pay.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    pay.textAlignment = NSTextAlignmentRight;
    [bg addSubview:pay];
    
    if ([orderEntity.pay_method isEqualToString:@"100"]) {
        pay.text = @"银联支付";
    } else if ([orderEntity.pay_method isEqualToString:@"200"]) {
        pay.text = @"支付宝支付";
    } else if ([orderEntity.pay_method isEqualToString:@"250"]) {
        pay.text = @"永辉钱包支付";
    }
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 20, 20)];
    [arrow setImage:[UIImage imageNamed:@"cart_myOrderAccess"]];
    [bg addSubview:arrow];
}

-(void)addCellMyOrderBtn :(UITableViewCell *) cell{
    UIButton *order=[UIButton buttonWithType:UIButtonTypeCustom];
    order.frame =CGRectMake(10, 0, 300, 40);
    [order setBackgroundImage:[UIImage imageNamed:@"cart_my_order_btn"] forState:UIControlStateNormal];
    [order setBackgroundImage:[UIImage imageNamed:@"cart_my_order_btn_selected"] forState:UIControlStateHighlighted];
    //    [pay setTitle:@"立即支付" forState:UIControlStateNormal];
    order.titleLabel.font =[UIFont systemFontOfSize:15.0];
    [order setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [order addTarget:self action:@selector(myOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:order];
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == T_API_ORDER_PAY_SUCCEED)
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

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (nTag == T_API_ORDER_PAY_SUCCEED)
    {
        self.orderEntity = (OrderSubmitEntity *)netTransObj;
        [self.orderTableView reloadData];
    }
}


@end
