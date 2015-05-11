//
//  YHReturnCell.m
//  YHCustomer
//
//  Created by lichentao on 14-5-4.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  退货申请cell

#import "YHReturnCell.h"
#import "GoodsView.h"
@implementation YHReturnCell
@synthesize returnController;
@synthesize returnIndexPath;
@synthesize returnOrderType;
@synthesize returnOrderEntity;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor=  [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        self.backgroundColor =[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
        // bg
        UIView *cellBg = [PublicMethod addBackView:CGRectMake(0, 0, 320, 170) setBackColor:[UIColor whiteColor]];
        [self.contentView addSubview:cellBg];
        
        // 提货配送icon
        UILabel *orderIcon = [PublicMethod addLabel:CGRectMake(10, 12, 28, 28) setTitle:nil setBackColor:[UIColor whiteColor] setFont:[UIFont systemFontOfSize:16]];
        orderIcon.tag = 999;
        orderIcon.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:orderIcon];
        
        // 下单编号 & 订单金额 & 申请时间
        UILabel *order_list_no = [PublicMethod addLabel:CGRectMake(orderIcon.right+10, 8, 200, 20) setTitle:[NSString stringWithFormat:@"订单编号"] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        order_list_no.tag = 1000;
        [self.contentView addSubview:order_list_no];
        // 订单金额
        UILabel *order_totalAmount = [PublicMethod addLabel:CGRectMake(orderIcon.right+10, 22, 200, 20) setTitle:[NSString stringWithFormat:@"订单金额"] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        order_totalAmount.tag = 1001;
        [self.contentView addSubview:order_totalAmount];
        // 申请时间
        UILabel *order_createTime = [PublicMethod addLabel:CGRectMake(orderIcon.right+10, 37, 200, 20) setTitle:[NSString stringWithFormat:@"下单时间"] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        order_createTime.tag = 1002;
        [self.contentView addSubview:order_createTime];
        // 分割线
        UIView *seperateLine1 = [PublicMethod addBackView:CGRectMake(0, 65, 320, 1) setBackColor:[UIColor lightGrayColor]];
        seperateLine1.alpha = .1f;
        [self.contentView addSubview:seperateLine1];
        // 商品
        GoodsView *goodsView = [[GoodsView alloc] initWithFrame:CGRectMake(0, 75, 320, 60)];
        goodsView.tag = 1003;
        [self.contentView addSubview:goodsView];
        // 分割线
        UIView *seperateLine2 = [PublicMethod addBackView:CGRectMake(0, 127, 320, 1) setBackColor:[UIColor lightGrayColor]];
        seperateLine2.alpha = 0.1f;
        [self.contentView addSubview:seperateLine2];
        // 订单状态
        UILabel *orderStatusTitle = [PublicMethod addLabel:CGRectMake(10, 135, 80, 33) setTitle:@"订单状态:" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
        orderStatusTitle.tag = 1004;
        orderStatusTitle.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:orderStatusTitle];
        
        UILabel *orderStatus = [PublicMethod addLabel:CGRectMake(85, 135, 100, 33) setTitle:@"退货单状态" setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
        orderStatus.tag = 1005;
        orderStatus.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:orderStatus];
        
        // 退货方式按钮
        UIButton *deliveryDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deliveryDetailBtn.frame = CGRectMake(230, 138, 80, 25);
        deliveryDetailBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        deliveryDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [deliveryDetailBtn setTitle:@"申请退货" forState:UIControlStateNormal];
        deliveryDetailBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [deliveryDetailBtn addTarget:self action:@selector(handSeleClicked:) forControlEvents:UIControlEventTouchUpInside];
        deliveryDetailBtn.tag = 1006 ;
        [self.contentView addSubview:deliveryDetailBtn];
    }
    return self;
}

- (void)setReturnCell:(ReturnOrderEntity *)orderEntity NSIndexPath:(NSIndexPath *)indexPath OrderType:(NSInteger)myType{
    self.returnIndexPath = indexPath;
    self.returnOrderType =myType;
    self.returnOrderEntity = orderEntity;
    UILabel *orderIcon = (UILabel *)[self.contentView viewWithTag:999];
    if ([orderEntity.delivery_id isEqualToString:@"1"]) {
        orderIcon.text = @"提";
        orderIcon.backgroundColor = [PublicMethod colorWithHexValue:0x9ac6df alpha:1.0f];
        
    }else if([orderEntity.delivery_id isEqualToString:@"2"]){
        orderIcon.text = @"送";
        orderIcon.backgroundColor = [PublicMethod colorWithHexValue:0xdbaadc
                                                            alpha:1.0f];
    }
    // 订单编号
    UILabel *order_list_no = (UILabel *)[self.contentView viewWithTag:1000];
    // 订单金额
    UILabel *order_amount = (UILabel *)[self.contentView viewWithTag:1001];
    // 申请时间
    UILabel *order_time = (UILabel *)[self.contentView viewWithTag:1002];
    
    // 商品
    GoodsView *goodsView = (GoodsView *)[self.contentView viewWithTag:1003];
    [goodsView setGoodsArray:orderEntity.orderArray];
    
    // 订单状态
    UILabel *orderStaTitle = (UILabel *)[self.contentView viewWithTag:1004];
    UILabel *orderStatus = (UILabel *)[self.contentView viewWithTag:1005];
    
    // 申请退货
    UIButton *deliveryDetailBtn = (UIButton *)[self.contentView viewWithTag:1006];
    if (myType == 1 ) {
        if ([orderEntity.apply_type isEqualToString:@"2"]) {
            [deliveryDetailBtn setTitle:@"电话退货" forState:UIControlStateNormal];
            deliveryDetailBtn.frame = CGRectMake(230, 138, 80, 25);
            deliveryDetailBtn.hidden = NO;
        }else if([orderEntity.apply_type isEqualToString:@"1"]){
            [deliveryDetailBtn setTitle:@"申请退货" forState:UIControlStateNormal];
            deliveryDetailBtn.frame = CGRectMake(230, 138, 80, 25);
            deliveryDetailBtn.hidden = NO;
        }else{
            deliveryDetailBtn.hidden = YES;
        }
    }else if(myType == 2){ // 已经审核
        if ([orderEntity.orderStatus isEqualToString:@"已审核"] && [orderEntity.returns_method isEqualToString:@"3"]) {
            [deliveryDetailBtn setTitle:@"请输入快递单号" forState:UIControlStateNormal];
            deliveryDetailBtn.frame = CGRectMake(210, 138, 100, 25);
            deliveryDetailBtn.hidden = NO;

        }else{
            deliveryDetailBtn.frame = CGRectMake(210, 138, 0, 25);
            deliveryDetailBtn.hidden = YES;
        }
    }else{
        deliveryDetailBtn.hidden = YES;
    }
    if (returnOrderType != 1) {
        orderIcon.hidden = YES;
        order_list_no.text = [NSString stringWithFormat:@"退货单号: %@",orderEntity.sales_return_no];
        order_amount.text = [NSString stringWithFormat:@"退款金额: ¥ %@",orderEntity.retamt];
        order_time.text =[NSString stringWithFormat:@"申请时间: %@",orderEntity.sdate];
        orderStaTitle.text = [NSString stringWithFormat:@"退货单状态 :"];
        orderStatus.text =orderEntity.total_state_str;
        order_list_no.origin = CGPointMake(10, 8);
        order_amount.origin = CGPointMake(10, 22);
        order_time.origin = CGPointMake(10, 37);
        order_amount .hidden = NO;
        
        if (returnOrderType == 2) {
            order_amount .hidden = YES;
            order_time.origin = CGPointMake(10, 30);
        }
    }else{
        orderIcon.hidden = NO;
        order_list_no.text = [NSString stringWithFormat:@"订单编号: %@",orderEntity.order_list_no];
        order_amount.text = [NSString stringWithFormat:@"订单金额: ¥ %@",orderEntity.totalAmount];
        order_time.text =[NSString stringWithFormat:@"下单时间: %@",orderEntity.create_date];
        orderStaTitle.text = [NSString stringWithFormat:@"订单状态 :"];
        orderStatus.text =orderEntity.total_state_name;
        order_list_no.origin = CGPointMake(orderIcon.right + 10, 8);
        order_amount.origin = CGPointMake(orderIcon.right + 10, 22);
        order_time.origin = CGPointMake(orderIcon.right + 10, 37);
    }
}

- (void)handSeleClicked:(id)sender
{
    if (returnOrderType == 1)
    {
        if ([self.returnOrderEntity.apply_type isEqualToString:@"2"])
        {
            NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",@"4001009333"];
            NSURL *url = [[NSURL alloc] initWithString:telUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [returnController handSeleClicked:returnIndexPath];
        }
    }
    else if (returnOrderType == 2)
    {
            [returnController handSeleClicked:returnIndexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
