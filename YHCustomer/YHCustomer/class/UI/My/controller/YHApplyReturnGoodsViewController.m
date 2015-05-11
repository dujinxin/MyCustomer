//
//  YHApplyReturnGoodsViewController.m
//  YHCustomer
//
//  Created by kongbo on 14-4-30.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHApplyReturnGoodsViewController.h"
#import "MyPickerView.h"
#import "ReturnEntity.h"

@interface YHApplyReturnGoodsViewController ()

@end

@implementation YHApplyReturnGoodsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pickView = [[MyPickerView alloc] init];
        pickView.target = self;
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"申请退货";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    [[PSNetTrans getInstance]order_return_reason:self order_state:@"1"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

#pragma mark ------------------  add UI
-(void)addUI {
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-NAVBAR_HEIGHT)];
    if (!iPhone5) {
        if ([payMethod isEqualToString:@"200"]) {
            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,454-49);
        } else {
            scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,454);
        }
    }
    [scrollView setScrollEnabled:YES];
    [scrollView setShowsVerticalScrollIndicator:YES];
    scrollView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [self.view addSubview:scrollView];
    
    UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 320, 78)];
    bg1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 28, 28)];
    if ([orderEntity.delivery_id isEqualToString:@"1"]) {
        label.text = @"提";
        label.backgroundColor = [PublicMethod colorWithHexValue:0x9ac6df alpha:1.0f];
    } else if ([orderEntity.delivery_id isEqualToString:@"2"]) {
        label.text = @"送";
        label.backgroundColor = [PublicMethod colorWithHexValue:0xdbaadc
                                                          alpha:1.0f];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [PublicMethod colorWithHexValue:0x9ac6df alpha:1.0f];
    [bg1 addSubview:label];
    UILabel *orderNum = [PublicMethod addLabel:CGRectMake(label.right+10, 10, 280, 10) setTitle:[NSString stringWithFormat:@"订单编号:%@",orderEntity.order_list_no] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:orderNum];
    UILabel *orderPrice = [PublicMethod addLabel:CGRectMake(label.right+10, orderNum.bottom+7, 280, 10) setTitle:[NSString stringWithFormat:@"订单金额:￥%@",orderEntity.totalAmount] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:orderPrice];
    UILabel *orderTime = [PublicMethod addLabel:CGRectMake(label.right+10,orderPrice.bottom+ 7, 280, 10) setTitle:[NSString stringWithFormat:@"下单时间:%@",orderEntity.create_date] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:orderTime];
    UILabel *orderStates = [PublicMethod addLabel:CGRectMake(label.right+10,orderTime.bottom +7, 280, 10) setTitle:@"订单状态:" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:orderStates];
    UILabel *orderStates_det = [PublicMethod addLabel:CGRectMake(label.right+55,orderTime.bottom +7, 280, 10) setTitle:orderEntity.total_state_name setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [bg1 addSubview:orderStates_det];
    
    
    bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, bg1.bottom+10, 320, 94)];
    bg2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg2];
    UILabel *label2 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退货原因" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg2 addSubview:label2];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom+10, SCREEN_WIDTH, 1)];
    line1.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg2 addSubview:line1];
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, line1.bottom+10, 300, 39);
    [btn setBackgroundImage:[UIImage imageNamed:@"return_btn_bg"] forState:UIControlStateNormal];
    [btn setTitle:@" 请选择退货原因" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bg2 addSubview:btn];
    returnReason = [[UITextField alloc]initWithFrame:CGRectMake(10, 94, 300, 39)];
    [returnReason setLeftSpace:5];
    returnReason.placeholder = @"请输入退货原因";
    returnReason.font = [UIFont systemFontOfSize:15.0];
    returnReason.layer.borderWidth = 1;
    returnReason.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    returnReason.delegate = self;
    [returnReason setHidden:YES];
    [returnReason setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [bg2 addSubview:returnReason];
    
    if ([payMethod isEqualToString:@"200"]) {
        [self addAlixPayView];
    } else {
        //        [self addUPPayView];
    }
    
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([payMethod isEqualToString:@"100"]) {
        submitBtn.frame = CGRectMake(10, bg2.bottom+10, 300, 40);
    } else if([payMethod isEqualToString:@"200"]){
        submitBtn.frame = CGRectMake(10, bg3.bottom+10, 300, 40);
    } else{
        submitBtn.frame = CGRectMake(10, bg2.bottom+10, 300, 40);
    }
    [submitBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0]];
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitBtn];
}

-(void)addAlixPayView {
    bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, bg2.bottom+10, 320, 143)];
    bg3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg3];
    UILabel *label3 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"支付宝信息" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg3 addSubview:label3];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom+10, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg3 addSubview:line2];
    name = [[UITextField alloc]initWithFrame:CGRectMake(10, line2.bottom+10, 300, 39)];
    name.returnKeyType = UIReturnKeyDone;
    name.placeholder = @" 姓名";
    name.font = [UIFont systemFontOfSize:15.0];
    name.layer.borderWidth = 1;
    name.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    name.delegate = self;
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg3 addSubview:name];
    
    accout = [[UITextField alloc]initWithFrame:CGRectMake(10, name.bottom+10, 300, 39)];
    accout.returnKeyType = UIReturnKeyDone;
    accout.placeholder = @" 账号";
    accout.font = [UIFont systemFontOfSize:15.0];
    accout.layer.borderWidth = 1;
    accout.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    accout.delegate = self;
    accout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg3 addSubview:accout];
}

-(void)addUPPayView {
    bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, bg2.bottom+10, 320, 143+49)];
    bg3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg3];
    UILabel *label3 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退款帐号信息:银联" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg3 addSubview:label3];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom+10, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg3 addSubview:line2];
    name = [[UITextField alloc]initWithFrame:CGRectMake(10, line2.bottom+10, 300, 39)];
    name.placeholder = @" 开户人";
    name.font = [UIFont systemFontOfSize:15.0];
    name.layer.borderWidth = 1;
    name.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    name.delegate = self;
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg3 addSubview:name];
    UITextField *bank = [[UITextField alloc]initWithFrame:CGRectMake(10, name.bottom+10, 300, 39)];
    bank.placeholder = @" 开户行";
    bank.font = [UIFont systemFontOfSize:15.0];
    bank.layer.borderWidth = 1;
    bank.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    bank.delegate = self;
    bank.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg3 addSubview:bank];
    accout = [[UITextField alloc]initWithFrame:CGRectMake(10, bank.bottom+10, 300, 39)];
    accout.placeholder = @" 银行卡号";
    accout.font = [UIFont systemFontOfSize:15.0];
    accout.layer.borderWidth = 1;
    accout.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    accout.delegate = self;
    accout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg3 addSubview:accout];
}

#pragma mark ---------------- data
-(void)setData:(MyOrderEntity *)entity {
    orderEntity = entity;
    payMethod = entity.pay_method;
    [self addUI];
}

#pragma mark ------------------  action
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnAction {
    if ([reasonArray count]>0) {
        NSMutableArray *array = [NSMutableArray array];
        for (ReasonEntity *reasonEntity in reasonArray) {
            [array addObject:reasonEntity.reason_name];
        }
        //        NSString * string = [NSString stringWithFormat:@" 请选择退货原因"];
        //        NSString * selectString;
        //        if ([string isEqualToString:@" 请选择退货原因"]) {
        //            selectString = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        //        }else{
        //            selectString = [NSString stringWithFormat:@"%@",reason_name];
        //        }
        [pickView initWithPickerData:array MyPickerBlock:^(NSString *
                                                           selectRow){
            NSString *selectRow_code = @"";
            
            for (ReasonEntity * reasonEntity in reasonArray) {
                if ([reasonEntity.reason_name isEqualToString:selectRow]) {
                    selectRow_code = reasonEntity.reason_code;
                    
                    break;
                }
            }
            if ([selectRow_code isEqualToString:@"8"]) {//其它原因
                bg2.height = 94+49;
                [returnReason setHidden:NO];
                bg3.frame = CGRectMake(0, bg2.bottom+10, 320, bg3.height);
                if ([payMethod isEqualToString:@"200"]) {
                    submitBtn.frame = CGRectMake(10, bg3.bottom+10, 300, 40);
                } else {
                    submitBtn.frame = CGRectMake(10, bg2.bottom+10, 300, 40);
                }
                if (!iPhone5) {
                    if ([payMethod isEqualToString:@"200"]) {
                        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,454-49+49);
                    } else {
                        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,454+49);
                    }
                }
            } else {
                bg2.height = 94;
                [returnReason setHidden:YES];
                bg3.frame = CGRectMake(0, bg2.bottom+10, 320, bg3.height);
                if ([payMethod isEqualToString:@"200"]) {
                    submitBtn.frame = CGRectMake(10, bg3.bottom+10, 300, 40);
                } else {
                    submitBtn.frame = CGRectMake(10, bg2.bottom+10, 300, 40);
                }
                if (!iPhone5) {
                    if ([payMethod isEqualToString:@"200"]) {
                        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,454-49);
                    } else {
                        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,454);
                    }
                }
            }
            [btn setTitle:[NSString stringWithFormat:@" %@",selectRow] forState:UIControlStateNormal];
            reason_name = selectRow;
            reason_code = selectRow_code;
        }];
    } else {
        [[PSNetTrans getInstance]order_return_reason:self order_state:@"1"];
    }
}

-(void)submitAction {
    if (!reason_code) {
        [[iToast makeText:@"请选择退货原因"] show];
        return;
    }
    if (![returnReason isHidden]) {
        reason_name = returnReason.text;
        if (returnReason.text.length==0) {
            [[iToast makeText:@"请输入退货原因"] show];
            return;
        }
    }
    if ([payMethod isEqualToString:@"200"]) {
        returns_name = name.text;
        returns_account = accout.text;
        if (returns_name.length == 0) {
            [[iToast makeText:@"请输入姓名"] show];
            return;
        }
        if (returns_account.length == 0) {
            [[iToast makeText:@"请输入账号"] show];
            return;
        }
    }
    
    [[PSNetTrans getInstance]apply_return_goods:self
                                  order_list_id:orderEntity.order_list_id
                                    reason_code:reason_code
                                    reason_name:reason_name
                                   returns_name:returns_name
                                returns_account:returns_account];
}

#pragma mark --------------  UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (name.text.length>0) {
        returns_name = name.text;
    }
    if (accout.text.length>0) {
        returns_account = accout.text;
    }
    if (![returnReason isHidden]) {
        reason_name = returnReason.text;
    }
    CGRect rect = [textField convertRect:textField.bounds toView:self.view];
    [scrollView setContentOffset:CGPointMake(0, rect.origin.y+scrollView.contentOffset.y-40) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (name.text.length>0) {
        returns_name = name.text;
    }
    if (accout.text.length>0) {
        returns_account = accout.text;
    }
    if (![returnReason isHidden]) {
        reason_name = returnReason.text;
    }
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ---------------- net
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if (T_API_ORDER_RETURN_REASON == nTag)
    {
        reasonArray = (NSMutableArray *)netTransObj;
    } else if (T_API_ORDER_RETURN_SUBMIT == nTag) {
        _submitBlock();
        [self.navigationController popViewControllerAnimated:YES ];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == T_API_ORDER_RETURN_SUBMIT)
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
