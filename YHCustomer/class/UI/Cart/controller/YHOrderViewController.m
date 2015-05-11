//
//  YHOrderViewController.m
//  YHCustomer
//
//  Created by lichentao on 13-12-14.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//  提交订单

#import "YHOrderViewController.h"
#import "YHConfirmOrderViewController.h"

#import "YHPSStorePickViewController.h"
#import "YHPSDeliveryDoorViewController.h"
#import "YHPSStoreInfoViewController.h"
#import "YHPSStoreInfoViewController.h"
#import "YHPSPaymentStyleViewController.h"
#import "AddressesManagerViewController.h"
#import "YHCouponListViewController.h"
#import "YHPSGoodListViewController.h"
#import "OrderEntity.h"
#import "YHPaySucceedViewController.h"
#import "AddNewAddressViewController.h"
#import "PSEntity.h"
@interface YHOrderViewController (){

}

@property (nonatomic, strong) NSMutableArray *deliveryArray;
@end

@implementation YHOrderViewController
@synthesize deliveryArray;
@synthesize myCouponDic;
@synthesize arrAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"确认订单";
        model = Fetch;
        deliveryArray = [[NSMutableArray alloc] init];
        DeliveryStyleArray = [[NSMutableArray alloc] init];
        
        arrAddress = [[NSMutableArray alloc] init];
        needInvoice = NO;
        invoiceIsCompany = NO;
        
        //支付方式
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"paymentStyle"]) {
            NSDictionary *payDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"paymentStyle"];
            _pay_name = [payDic objectForKey:@"name"];
            _pay_method = [[payDic objectForKey:@"id"] stringValue];
        }
        
        //收货地址
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"storeAddress"]) {
            NSDictionary *addDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"storeAddress"];
            _name = [addDic objectForKey:@"true_name"];
            _tel = [addDic objectForKey:@"mobile"];
            _logistics_area_name = [addDic objectForKey:@"logistics_area_name"];
            _logistics_address = [addDic objectForKey:@"logistics_address"];
            _order_address_id = [addDic objectForKey:@"id"];
        }
        
        long today_time=(long)[[NSDate date] timeIntervalSince1970];
        long tomorrow_time = today_time + 24*3600;
        NSString *today_date = [PublicMethod timeStampConvertToFullTime:[NSString stringWithFormat:@"%ld",today_time]];
        NSString *tomorrow_date = [PublicMethod timeStampConvertToFullTime:[NSString stringWithFormat:@"%ld",tomorrow_time]];
        today = [today_date substringToIndex:10];
        tomorrow = [tomorrow_date substringToIndex:10];
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
    [self addTableView];
    [self addFootView];
    [[PSNetTrans getInstance]ps_getDeliveryStyle:self transaction_type:@"1"];

    //自提门店
    NSMutableDictionary *store = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeInfo"];
    if (store) {
        _bu_name = [store objectForKey:@"bu_name"];
        _bu_address = [store objectForKey:@"bu_address"];
        _bu_id = [store objectForKey:@"bu_id"];
//        _bu_code = [store objectForKey:@"bu_code"];
    }
    [self getPickUp_time];
    [self getAddressList];
}
// 获取自提时间api
- (void)getPickUp_time{
    [[PSNetTrans getInstance] get_PickUp_Time:self ReginId:[UserAccount instance].region_id];
}
// 获取收获地址api
- (void)getAddressList{
    [[PSNetTrans getInstance] API_order_address_list_func:self goods_id:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
//    [MTA trackCustomKeyValueEvent:EVENT_ID41 props:nil];
    [tableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
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

#pragma mark ------------------------- add UI
-(void)addTableView {
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44-kTabBarHeight) style:UITableViewStylePlain];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableview setBackgroundColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    [tableview setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [self.view addSubview:tableview];
}

-(void)addActionSheetView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择发票"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"个人",@"公司", nil];
    [actionSheet showInView:self.view];
}

/*提交订单footview*/
-(void)addFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, ScreenSize.height - NAVBAR_HEIGHT-kTabBarHeight, 320, kTabBarHeight)];
    footView.backgroundColor =[PublicMethod colorWithHexValue:0x434343 alpha:1];
    
    //价钱信息
    priceInfo =[[UILabel alloc] initWithFrame:CGRectMake(20, 14, 170, 16)];
    priceInfo.text = [NSString stringWithFormat:@"¥ %@",self.entity.total_amount];
    priceInfo.backgroundColor=[UIColor clearColor];
    priceInfo.textColor =[UIColor whiteColor];
    priceInfo.font =[UIFont boldSystemFontOfSize:22.0];
    self.totalLabel = priceInfo;
    [footView addSubview:priceInfo];
    
    //提交
    UIButton *sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame =CGRectMake(220, 0, 100, 50);
    sendButton.backgroundColor = [UIColor orangeColor];
    [sendButton setTitle:@"提交订单" forState:UIControlStateNormal];
    sendButton.titleLabel.font =[UIFont systemFontOfSize:17.0];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:sendButton];
    [self.view addSubview:footView];
}

#pragma mark -----------------  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (model == Fetch) {
        return 7;
    }
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.row) {
        case 0:
        {
            UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
            bg.backgroundColor = [UIColor whiteColor];
            [cell addSubview:bg];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"配送方式";
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            [bg addSubview:label];
       
            leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.tag = 100;
            if (model == Fetch) {
                [leftBtn setBackgroundImage:[UIImage imageNamed:@"fetch_btn_selected"] forState:UIControlStateNormal];
            } else {
                [leftBtn setBackgroundImage:[UIImage imageNamed:@"fetch_btn"] forState:UIControlStateNormal];
            }
        
            leftBtn.frame = CGRectMake(110, 8, 94, 24);
            [leftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:leftBtn];
            
            rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.tag = 101;
            if (model == Fetch) {
                [rightBtn setBackgroundImage:[UIImage imageNamed:@"deliver_btn"] forState:UIControlStateNormal];
            } else {
                [rightBtn setBackgroundImage:[UIImage imageNamed:@"deliver_btn_selected"] forState:UIControlStateNormal];
            }
       
            rightBtn.frame = CGRectMake(leftBtn.right+10, 8, 94, 24);
            [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:rightBtn];
            
            
            if ([DeliveryStyleArray count]== 1) {
                DeliveryStyleEntity *delEntity = [DeliveryStyleArray objectAtIndex:0];
                if ([delEntity.i_d isEqualToString:@"1"]) {//门店自提
                    leftBtn.frame = CGRectMake(rightBtn.left, 8, 94, 24);
                    [rightBtn removeFromSuperview];
                }
            }
        }
            break;
        case 1:
        {
            UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            bg.backgroundColor = [UIColor whiteColor];
            [cell addSubview:bg];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
            label.backgroundColor = [UIColor clearColor];
            if (model == Fetch) {
                label.text = @"自提门店";
            } else {
                label.text = @"送货信息";
            }
        
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            [bg addSubview:label];
            
            UILabel *store = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-225, 0, 200, 40)];
            store.backgroundColor = [UIColor clearColor];
            if (model == Fetch) {
                store.text = @"请选择自提门店";
                if (_bu_name) {
                    store.text = _bu_name;
                }
            } else {
//                store.text = @"半日达";
                if (_lm_name) {
                    store.text = _lm_name;
                }
            }
        
            store.font = [UIFont systemFontOfSize:12.0];
            store.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            store.textAlignment = NSTextAlignmentRight;
            [bg addSubview:store];
            //箭头
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
            [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
            [bg addSubview:arrow];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom-0.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
            [bg addSubview:line];
            
            UIView *yellowBg = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom, SCREEN_WIDTH, 53)];
            yellowBg.backgroundColor = [PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0];
            if (model == Fetch) {
                if (_bu_id) {
                    [cell addSubview:yellowBg];
                }
            } else {
               [cell addSubview:yellowBg];
            }
            
            UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, SCREEN_WIDTH, 20)];
            time.backgroundColor = [UIColor clearColor];
            if (model == Fetch) {
                time.text = @"自提时间:";
                if (_time_id) {
                    
                    NSString *time_ = [PublicMethod timeStampConvertToFullTime:_time_id];
                    
                    NSString *btnTimeStart = [time_ substringToIndex:10];
                    NSString *btnTimeEnd = [time_ substringFromIndex:11];
                    
                    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
                    ;
                    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_time_id integerValue]];
                    
                    NSString *date_ = [NSString stringWithFormat:@"(%@)",[[PublicMethod nsdateConvertToTimeString:date] substringWithRange:NSMakeRange(5, 6)]];
                    
                    
                    if ([btnTimeStart isEqualToString:today]) {
                        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"今天",date_,btnTimeEnd];
                    } else if ([btnTimeStart isEqualToString:tomorrow]) {
                        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"明天",date_,btnTimeEnd];
                    } else {
                        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
                    }
                    
                    
//                    if ([btnTimeStart isEqualToString:today]) {
//                        dateString = [NSString stringWithFormat:@"%@ %@ %@",btnTimeStart,@"(今天)",btnTimeEnd];
//                    } else if ([btnTimeStart isEqualToString:tomorrow]) {
//                        dateString = [NSString stringWithFormat:@"%@ %@ %@",btnTimeStart,@"(明天)",btnTimeEnd];
//                    } else {
//                        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
//                    }
                    time.text = [NSString stringWithFormat:@"自提时间:%@",dateString];
                }
            } else {
                time.text = @"送货时间:";
                if (_lm_time_id) {
                    time.text = [NSString stringWithFormat:@"送货时间:%@",_lm_time_name];
                }
            }
          
            time.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
            time.font = [UIFont systemFontOfSize:12.0];
            [yellowBg addSubview:time];
            
            UILabel *add = [[UILabel alloc]initWithFrame:CGRectMake(10, time.bottom, SCREEN_WIDTH, 20)];
            add.backgroundColor = [UIColor clearColor];
            if (model == Fetch) {
                add.text = @"自提地址:";
                if (_bu_address) {
                    add.text = [NSString stringWithFormat:@"自提地址:%@",_bu_address];
                }
            } else {
                add.text = @"是否送货前电话确认:否";
                if ([_is_tel integerValue] == 0) {
                    add.text = @"是否送货前电话确认:否";
                } else if ([_is_tel integerValue] == 1) {
                    add.text = @"是否送货前电话确认:是";
                }
            }
         
            add.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
            add.font = [UIFont systemFontOfSize:12.0];
            [yellowBg addSubview:add];
        }
            break;
        case 2:
        {
            UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            bg.backgroundColor = [UIColor whiteColor];
            [cell addSubview:bg];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
            label.backgroundColor = [UIColor clearColor];
            if (model == Fetch) {
                label.text = @"支付方式";
            } else {
                label.text = @"收货地址";
            }
     
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            [bg addSubview:label];
            
            UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-135, 0, 110, 40)];
            pay.backgroundColor = [UIColor clearColor];
            if (model == Fetch) {
                pay.text = @"请选择支付方式";
                if (_pay_name) {
                    pay.text = _pay_name;
                }
            } else {
                if ([self.arrAddress count]==0) {
                    pay.text = @"请新建收货地址";
                } else {
                    pay.text = @"请选择收货地址";
                }
             
                if (_name) {
                    pay.text = _name;
                    pay.frame = CGRectMake(SCREEN_WIDTH-95, 0, 70, 40);
                } else {
                    pay.frame = CGRectMake(SCREEN_WIDTH-135, 0, 110, 40);
                }
            }
         
            pay.font = [UIFont systemFontOfSize:12.0];
            pay.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            pay.textAlignment = NSTextAlignmentRight;
            [bg addSubview:pay];
            
            if (model == Fetch) {
                
            } else {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom-0.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                [bg addSubview:line];
                
                UIView *yellowBg = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom, SCREEN_WIDTH, 73)];
                yellowBg.backgroundColor = [PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0];
                if (_tel) {
                    [cell addSubview:yellowBg];
                }
             
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 70, 20)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
                label.font = [UIFont systemFontOfSize:12.0];
                if (_name) {
                    label.text = _name;
                }
                [yellowBg addSubview:label];
                
                UILabel *labelTel = [[UILabel alloc]initWithFrame:CGRectMake(85, 7, 200, 20)];
                labelTel.backgroundColor = [UIColor clearColor];
                labelTel.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
                labelTel.font = [UIFont systemFontOfSize:12.0];
                if (_tel) {
                    labelTel.text = _tel;
                }
                [yellowBg addSubview:labelTel];
                
                UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, label.bottom, 300, 20)];
                label1.backgroundColor = [UIColor clearColor];
                label1.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
                label1.font = [UIFont systemFontOfSize:12.0];
                if (_logistics_area_name) {
                    label1.text = _logistics_area_name;
                }
                [yellowBg addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom, 300, 20)];
                label2.backgroundColor = [UIColor clearColor];
                label2.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
                label2.font = [UIFont systemFontOfSize:12.0];
                if (_logistics_address) {
                    label2.text = _logistics_address;
                }
                [yellowBg addSubview:label2];
                
                
            }
            //箭头
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
            [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
            [bg addSubview:arrow];
            
        }
            break;
        case 3:
        {
            if (model == Fetch) {
                [self addCellCouponView:cell];
            } else {
                [self addCellPayMethodView:cell];
            }
        }
            break;
        case 4:
        {
            if (model == Fetch) {
                [self addCellMarkView:cell];
            } else {
                [self addCellCouponView:cell];
            }
        }
            break;
        case 5:
        {
            if (model == Fetch) {
                [self addCellGoodsListView:cell];
            } else {
                [self addCellInvoiceView:cell];
            }
        }
            break;
        case 6:
        {
            if (model == Fetch) {
                [self addCellPriceListView:cell];
            } else {
                [self addCellMarkView:cell];
            }
        }
            break;
        case 7:
        {
            [self addCellGoodsListView:cell];
        }
            break;
            
        case 8:
        {
            [self addCellPriceListView:cell];
        }
            break;
        default:
            break;
            
    }
    return cell;
}

#pragma mark -------------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
   
        }
            break;
            
        case 1:
        {
            if (model == Fetch) {
                //自提门店
                YHPSStorePickViewController *store = [[YHPSStorePickViewController alloc] init];
                if (_time_id) {
                    store.dateStringDefault = [PublicMethod timeStampConvertToFullTime:_time_id];;
                    store.monthDayStr = [_time substringToIndex:10];
                }
                if ([ymdArray count] > 0) {
                    store.ymdArray = ymdArray;
                }
                store.defaultPickTime = defaultPickTime;
  
                store.pickTimeBlock = ^(NSString *bu_id,NSString *bu_name,NSString *timestamp,NSString *dayTimeStr,NSString *address){
                    _bu_id = bu_id;
                    _bu_name = bu_name;
                    _time = [NSString stringWithFormat:@"%@ %@",[dayTimeStr substringToIndex:10],[dayTimeStr substringFromIndex:15]];
                    dateString = dayTimeStr;
                    _time_id = timestamp;
                    _bu_address = address;
                };
                [self.navigationController pushViewController:store animated:YES];
            } else {
                //送货信息
                YHPSDeliveryDoorViewController *delivery = [[YHPSDeliveryDoorViewController alloc] init];
                delivery.dataArray = self.deliveryArray;
                delivery.isTel = [_is_tel boolValue];
                [delivery setDeliveryEntity:_lm_name];
                delivery.pickTimeBlock = ^(NSString *lm_id,NSString *lm_name,NSString *lm_time_name,NSString *lm_time_id,BOOL isTel){
                    NSLog(@"%@,%@,%@,%d",lm_id,lm_time_id,lm_time_name,isTel);
                    _lm_id = lm_id;
                    _lm_name = lm_name;
                    _lm_time_id = lm_time_id;
                    _lm_time_name = lm_time_name;
                    _is_tel = [NSString stringWithFormat:@"%hhd",isTel];;
                    
//                    [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id];
                };
                [self.navigationController pushViewController:delivery animated:YES];
            }
        }
            break;
        case 2:
        {
            if (model == Fetch) {//支付方式
                [self choosePaymentStyle];
            } else {//收货地址
                if ([self.arrAddress count]== 0) {
                    AddNewAddressViewController *addVC = [[AddNewAddressViewController alloc]init];
                    addVC._isNewOrEdit= YES;
                    addVC.block = ^(id param){
                        [self getAddressList];
                    };
                    [self.navigationController pushViewController:addVC animated:YES];
                } else {
                    AddressesManagerViewController *address = [[AddressesManagerViewController alloc] init];
                    
                    address.entityID = _order_address_id;
                    
                    address.addressDefaultCallBack = ^(OrderAddressEntity *addEntity,NSMutableArray *addressArray){
                        _logistics_address = addEntity.logistics_address;
                        _logistics_area_name = addEntity.logistics_area_name;
                        _name = addEntity.true_name;
                        _tel = addEntity.mobile;
                        _order_address_id = addEntity.ID;
                        self.arrAddress = addressArray;
                    };
                    [self.navigationController pushViewController:address animated:YES];
                    
                }
         
            }
        }
            break;
            
        case 3:
        {
            if (model == Fetch) {//优惠券
                
                if ([self.entity.coupon_num intValue]==0) {
                    [[iToast makeText:@"暂无优惠券"] show];
                } else {
                    [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:nil goods_id:nil total:nil];
                }
   
            } else {//支付方式
                [self choosePaymentStyle];
            }
        }
            break;
        case 4:
        {
            if (model == Deliver) {//优惠券
                
                if ([self.entity.coupon_num intValue]==0) {
                    [[iToast makeText:@"暂无优惠券"] show];
                } else {
                    [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:nil goods_id:nil total:nil];
                }
                
            }
        }
            break;
            
        case 5:
        {
            if (model == Fetch) {//商品清单
                
                YHPSGoodListViewController *psGoodsList = [[YHPSGoodListViewController alloc] init];
                psGoodsList.goodsWight=[NSString stringWithFormat:@"重量总计%@kg",self.entity.goods_weight];
                psGoodsList.logistics_amount = self.entity.logistics_amount;
                [self.navigationController pushViewController:psGoodsList animated:YES];

            } else {//
                
            }
        }
            break;
        case 6:
        {
         
        }
            break;
            
        case 7:
        {
            if (model == Deliver) {//商品清单
                
                YHPSGoodListViewController *psGoodsList = [[YHPSGoodListViewController alloc] init];
                psGoodsList.goodsWight=[NSString stringWithFormat:@"重量总计%@kg",self.entity.goods_weight];
                psGoodsList.logistics_amount = self.entity.logistics_amount;
                [self.navigationController pushViewController:psGoodsList animated:YES];

            }
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 10+40+10;
            break;
        case 1:
            if (model == Fetch) {
                if (!_bu_id) {
                    return 40+10;
                } else {
                return 40+53+10;
                }
            } else
                return 40+53+10;
            break;
        case 2:
            if (model == Fetch) {
                return 40+10;
            } else {
                if (!_tel) {
                    return 40+10;
                } else {
                    return 40+73+10;
                }
            }
          
            break;
        case 3:
            return 40+10;
            break;
        case 4:
            if (model == Fetch) {
                return 30+40+20;
            } else {
                return 40+10;
            }
            break;
        case 5:
            if (model == Fetch) {
                return 40+10;
            } else {
                if (needInvoice) {
                  return 40+45+10;
                } else {
                    return 40;
                }
            }
            break;
        case 6:
            if (model == Fetch) {
                return 40+90+10;
            } else {
                return 30+40+20;
            }
            break;
        case 7:
            return 40+10;
            break;
        case 8:
            return 40+90+10;
            break;
        default:
            return 0;
            break;
    }
}

/**
 * 选择支付方式
 */
- (void)choosePaymentStyle{
    YHPSPaymentStyleViewController *paymentStyle = [[YHPSPaymentStyleViewController alloc] init];
    paymentStyle.paystyle = _pay_name;
    paymentStyle.chooseBlock = ^(NSString *pay_method,id object,NSInteger number)
    {
        _pay_method = pay_method;
        NSLog(@"pay_method is %@",pay_method);
        if ([pay_method isEqualToString:@"100"]) {
            _pay_name = @"银联支付";
        } else if ([pay_method isEqualToString:@"200"]) {
            _pay_name = @"支付宝支付";
        } else if ([pay_method isEqualToString:@"250"]) {
            _pay_name = @"永辉钱包支付";
        }
    };
    [self.navigationController pushViewController:paymentStyle animated:YES];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------  cell
-(void)addCellPayMethodView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"支付方式";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-135, 0, 110, 40)];
    pay.backgroundColor = [UIColor clearColor];
    pay.text = @"请选择支付方式";
    if (_pay_name) {
        pay.text = _pay_name;
    }
    pay.textAlignment = NSTextAlignmentRight;
    pay.font = [UIFont systemFontOfSize:12.0];
    pay.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:pay];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
    [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
    [bg addSubview:arrow];
}

-(void)addCellCouponView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"优惠券";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 0, 125, 40)];
    pay.backgroundColor = [UIColor clearColor];
    if ([self.entity.coupon_num intValue]==0) {
        pay.text = @"暂无优惠券";
    } else {
       pay.text = [NSString stringWithFormat:@"有%@张优惠券可以使用",self.entity.coupon_num];
    }
 
    if (_coupon_name) {
        pay.text = _coupon_name;
    }
    pay.font = [UIFont systemFontOfSize:12.0];
    pay.textAlignment = NSTextAlignmentRight;
    pay.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [bg addSubview:pay];
    //箭头
     UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
    [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
    [bg addSubview:arrow];
}

-(void)addCellMarkView:(UITableViewCell *) cell {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"订单备注";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [cell.contentView addSubview:label];
    
    markField = [[UITextField alloc]initWithFrame:CGRectMake(10, label.bottom, 300, 40)];
    markField.backgroundColor = [UIColor whiteColor];
    markField.autocorrectionType = UITextAutocorrectionTypeNo;
    markField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    markField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    markField.returnKeyType = UIReturnKeyDone;
    markField.clearButtonMode = UITextFieldViewModeWhileEditing;
    markField.delegate = self;
    markField.placeholder = @" 限30个字以内";
    if (remarkText.length>0) {
        markField.text = remarkText;
    }
    [cell.contentView addSubview:markField];
}

-(void)addCellInvoiceView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"是否需要发票";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 8, 24, 24)];
    [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn"] forState:UIControlStateNormal];
    yesBtn.backgroundColor = [UIColor yellowColor];
    [yesBtn addTarget:self action:@selector(invoiceAciton:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:yesBtn];
    
    noBtn = [[UIButton alloc]initWithFrame:CGRectMake(yesBtn.right+10, 8, 24, 24)];
    [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn_selected"] forState:UIControlStateNormal];
    noBtn.backgroundColor = [UIColor yellowColor];
    [noBtn addTarget:self action:@selector(invoiceAciton:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:noBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [bg addSubview:line];
    
    UIView *yellowBg = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom, SCREEN_WIDTH, 45)];
    yellowBg.backgroundColor = [PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0];
    if (needInvoice) {
        [cell addSubview:yellowBg];
    }
    
    invoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    invoiceBtn.frame = CGRectMake(10, 10, 100, 25);
    [invoiceBtn setBackgroundImage:[UIImage imageNamed:@"invoice_btn_bg"] forState:UIControlStateNormal];
    [invoiceBtn setTitle:@"个人" forState:UIControlStateNormal];
    if (invoiceIsCompany) {
        [invoiceBtn setTitle:@"公司" forState:UIControlStateNormal];
    }
    invoiceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    invoiceBtn.titleLabel.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    [invoiceBtn setTitleColor:[PublicMethod colorWithHexValue:0x666666 alpha:1.0] forState:UIControlStateNormal];
    invoiceBtn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    invoiceBtn.layer.borderWidth = 0.5;
    [invoiceBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [yellowBg addSubview:invoiceBtn];
    
    invoiceField = [[UITextField alloc]initWithFrame:CGRectMake(invoiceBtn.right+5, 10, 200, 25)];
    invoiceField.backgroundColor = [UIColor whiteColor];
    invoiceField.autocorrectionType = UITextAutocorrectionTypeNo;
    invoiceField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    invoiceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    invoiceField.returnKeyType = UIReturnKeyDone;
    invoiceField.clearButtonMode = UITextFieldViewModeWhileEditing;
    invoiceField.delegate = self;
    invoiceField.placeholder = @" 请输入发票抬头";
    invoiceField.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    invoiceField.layer.borderWidth = 0.5;
    invoiceField.hidden = YES;
    invoiceField.font = [UIFont systemFontOfSize:12];
    if (invoiceIsCompany) {
        invoiceField.hidden = NO;
        invoiceField.text = invoiceText;
    }
    [yellowBg addSubview:invoiceField];
    
    if ([_receipt_type isEqualToString:@"1"]) {//个人
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn_selected"] forState:UIControlStateNormal];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn"] forState:UIControlStateNormal];
        [invoiceBtn setHidden:NO];
        [invoiceField setHidden:YES];
    } else if ([_receipt_type isEqualToString:@"0"]) {
        _receipt_title = @"";
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn"] forState:UIControlStateNormal];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn_selected"] forState:UIControlStateNormal];
        [invoiceBtn setHidden:YES];
        [invoiceField setHidden:YES];
    }else if ([_receipt_type isEqualToString:@"2"]) {//公司
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn_selected"] forState:UIControlStateNormal];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn"] forState:UIControlStateNormal];
        [invoiceBtn setHidden:NO];
        [invoiceField setHidden:NO];
    }
}

-(void)addCellGoodsListView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"共%@个商品",self.entity.goods_num];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.right, 0, 90, 40)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = [NSString stringWithFormat:@"重量共计%@kg",self.entity.goods_weight];
    label1.font = [UIFont systemFontOfSize:12.0];
    label1.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    label1.textAlignment = NSTextAlignmentRight;
    [bg addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.right+45, 0, 30, 40)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"运费:";
    label2.font = [UIFont systemFontOfSize:12.0];
    label2.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    label2.textAlignment = NSTextAlignmentRight;
    [bg addSubview:label2];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(label2.right, 0, 50, 40)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = [NSString stringWithFormat:@"￥%@",self.entity.logistics_amount];
    label3.font = [UIFont systemFontOfSize:12.0];
    label3.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    label3.textAlignment = NSTextAlignmentLeft;
    [bg addSubview:label3];
    //箭头
     UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
    [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
    [bg addSubview:arrow];
}

-(void)addCellPriceListView:(UITableViewCell *) cell {
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell addSubview:bg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"价格清单";
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    [bg addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [bg addSubview:line];
    
    UIView *yellowBg = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom, SCREEN_WIDTH, 90)];
    yellowBg.backgroundColor = [PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0];
    [cell addSubview:yellowBg];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"商品总额";
    label1.font = [UIFont systemFontOfSize:12.0];
    label1.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    [yellowBg addSubview:label1];
    UILabel *label1_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 200, 20)];
    label1_detail.backgroundColor = [UIColor clearColor];
    label1_detail.text = [NSString stringWithFormat:@"￥%@",self.entity.goods_amount];
    label1_detail.font = [UIFont systemFontOfSize:12.0];
    label1_detail.textAlignment = NSTextAlignmentRight;
    label1_detail.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [yellowBg addSubview:label1_detail];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, label1.bottom, 200, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"运费";
    label2.font = [UIFont systemFontOfSize:12.0];
    label2.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    [yellowBg addSubview:label2];
    UILabel *label2_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, label1.bottom, 200, 20)];
    label2_detail.backgroundColor = [UIColor clearColor];
    label2_detail.text = [NSString stringWithFormat:@"+￥%@",self.entity.logistics_amount];
    label2_detail.font = [UIFont systemFontOfSize:12.0];
    label2_detail.textAlignment = NSTextAlignmentRight;
    label2_detail.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [yellowBg addSubview:label2_detail];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, label2.bottom, 200, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"优惠券";
    label3.font = [UIFont systemFontOfSize:12.0];
    label3.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    [yellowBg addSubview:label3];
    UILabel *label3_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, label2.bottom, 200, 20)];
    label3_detail.backgroundColor = [UIColor clearColor];
    label3_detail.text = [NSString stringWithFormat:@"-￥%@",self.entity.coupon_amount];
    label3_detail.font = [UIFont systemFontOfSize:12.0];
    label3_detail.textAlignment = NSTextAlignmentRight;
    label3_detail.textColor = [PublicMethod colorWithHexValue:0x00a1fd alpha:1.0];
    [yellowBg addSubview:label3_detail];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, label3.bottom, 200, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.text = @"共需支付";
    label4.font = [UIFont systemFontOfSize:12.0];
    label4.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    [yellowBg addSubview:label4];
    UILabel *label4_detail = [[UILabel alloc]initWithFrame:CGRectMake(110, label3.bottom, 200, 20)];
    label4_detail.backgroundColor = [UIColor clearColor];
    label4_detail.text = [NSString stringWithFormat:@"￥%@",self.entity.total_amount];
    label4_detail.font = [UIFont systemFontOfSize:12.0];
    label4_detail.textAlignment = NSTextAlignmentRight;
    label4_detail.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [yellowBg addSubview:label4_detail];
}

#pragma mark -------------- btnAction 
-(void)btnAction {
    [self addActionSheetView];
}

-(void)buttonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        model = Fetch;
        needInvoice = NO;
        _receipt_type = @"0";
        _receipt_title = @"";
        invoiceText = @"";
        
        _lm_id = nil;
        _lm_name = nil;
        _lm_time_id = nil;
        _lm_time_name = nil;
        _is_tel = nil;
        
        [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.entity.goods_id total:self.entity.total];
        [tableview reloadData];
    } else if (btn.tag == 101) {
        [[PSNetTrans getInstance] ps_getLogisticStyle:self goods_id:self.entity.goods_id];
        model = Deliver;
        [tableview reloadData];
    }
}

-(void)submitAction:(id)sender {
    
    _remark = [markField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _receipt_title = [invoiceField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *delivery_id;
    if (model == Fetch) {
        delivery_id = @"1";
        if (_bu_name.length == 0) {
            [[iToast makeText:@"请选择自提门店"] show];
            return;
        }
        if (_time_id.length == 0) {
            [[iToast makeText:@"请选择自提时间"] show];
            return;
        }
        if (_pay_name.length == 0) {
            [[iToast makeText:@"请选择支付方式"] show];
            return;
        }
        if (_remark.length>30) {
            [[iToast makeText:@"备注不能超过30个字"] show];
            return;
        }
    } else {
        delivery_id = @"2";
        if (_lm_time_id.length == 0) {
            [[iToast makeText:@"请选择送货时间"] show];
            return;
        }
        if (_order_address_id.length == 0) {
            [[iToast makeText:@"请选择收货地址"] show];
            return;
        }
        if (_pay_name.length == 0) {
            [[iToast makeText:@"请选择支付方式"] show];
            return;
        }
        if (![invoiceField isHidden] && [invoiceBtn.titleLabel.text isEqualToString:@"公司"]) {
            if (invoiceField.text.length == 0) {
                 [[iToast makeText:@"请输入发票抬头"] show];
                 return;
            }
            if (invoiceField.text.length > 20) {
                [[iToast makeText:@"发票抬头不能超过20个字"] show];
                return;
            }
        }
        if (_remark.length>30) {
            [[iToast makeText:@"备注不能超过30个字"] show];
            return;
        }
    }
    
    
    
    [[PSNetTrans getInstance] submit_order:self
                               delivery_id:delivery_id
                                     lm_id:_lm_id
                                lm_time_id:_lm_time_id
                                    is_tel:_is_tel
                              receipt_type:_receipt_type
                             receipt_title:_receipt_title
                          order_address_id:_order_address_id
                                 coupon_id:_coupon_id
                                    remark:_remark
                                pay_method:_pay_method
                                     bu_id:_bu_id
                                      time:_time_id
                                  goods_id:self.entity.goods_id
                                     total:self.entity.total];

}

-(void)invoiceAciton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn == yesBtn) {
        invoiceIsCompany = NO;
        needInvoice = YES;
        _receipt_type = @"1";
        _receipt_title = @"";
        [invoiceBtn setTitle:@"个人" forState:UIControlStateNormal];
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn_selected"] forState:UIControlStateNormal];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn"] forState:UIControlStateNormal];
        [invoiceBtn setHidden:NO];
        [invoiceField setHidden:YES];
    } else if (btn == noBtn) {
          needInvoice = NO;
        _receipt_type = @"0";
        _receipt_title = @"";
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn"] forState:UIControlStateNormal];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn_selected"] forState:UIControlStateNormal];
        [invoiceBtn setHidden:YES];
        [invoiceField setHidden:YES];
    }
    [tableview reloadData];
}

#pragma mark--------------------------------------------------- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.numberOfButtons-1)
        return;
    
    if (buttonIndex == 0) {
        invoiceIsCompany = NO;
        [invoiceBtn setTitle:@"个人" forState:UIControlStateNormal];
        invoiceField.hidden = YES;
        _receipt_type = @"1";
        invoiceText = @"";
    }
    else if (buttonIndex == 1) {
        invoiceIsCompany = YES;
        [invoiceBtn setTitle:@"公司" forState:UIControlStateNormal];
        invoiceField.hidden = NO;
        _receipt_type = @"2";
    }
    
}

#pragma mark --------------  UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (markField.text.length>0) {
        remarkText = markField.text;
    }
    if (invoiceField.text.length>0) {
        invoiceText = invoiceField.text;
    }

    if (model == Fetch) {
        if (iPhone5) {
            [tableview setContentOffset:CGPointMake(0, 80) animated:YES];
        } else {
            [tableview setContentOffset:CGPointMake(0, 150) animated:YES];
        }
     
    } else {
        if (iPhone5) {
           [tableview setContentOffset:CGPointMake(0, 300) animated:YES];
        } else {
           [tableview setContentOffset:CGPointMake(0, 370) animated:YES];
        }
     
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (markField.text.length>0) {
        remarkText = markField.text;
    }
    if (invoiceField.text.length>0) {
        invoiceText = invoiceField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API)
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
    else if (nTag == t_API_PS_DELIVERY_STYLE)
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
    else if (nTag == t_API_SUBMIT_ORDER)
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
    else if (nTag == t_API_ADDRESS_LIST)
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
    else if(t_API_PS_PICK_UP_TIME_INFO)
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

#pragma mark --------------------------Request Delegate

-(void)updateViewController:(NSMutableArray*)arr
{
    if (arr != nil)
    {
        [self.arrAddress removeAllObjects];
        [self.arrAddress addObjectsFromArray:arr];
        if ([self.arrAddress count]==0) {
            _name = nil;
            _tel = nil;
            _logistics_area_name = nil;
            _logistics_address = nil;
            _order_address_id = nil;
        } else {
            for (OrderAddressEntity *addEntity in self.arrAddress) {
                if (addEntity.is_default) {
                    _name = addEntity.true_name;
                    _tel = addEntity.mobile;
                    _logistics_area_name = addEntity.logistics_area_name;
                    _logistics_address = addEntity.logistics_address;
                    _order_address_id = addEntity.ID;
                    [tableview reloadData];
                    return;
                }
            }
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"storeAddress"]) {
                NSDictionary *addDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"storeAddress"];
                _name = [addDic objectForKey:@"true_name"];
                _tel = [addDic objectForKey:@"mobile"];
                _logistics_area_name = [addDic objectForKey:@"logistics_area_name"];
                _logistics_address = [addDic objectForKey:@"logistics_address"];
                _order_address_id = [addDic objectForKey:@"id"];
            } else {
                OrderAddressEntity *lastEntity = (OrderAddressEntity *)[self.arrAddress lastObject];
                _name = lastEntity.true_name;
                _tel = lastEntity.mobile;
                _logistics_area_name = lastEntity.logistics_area_name;
                _logistics_address = lastEntity.logistics_address;
                _order_address_id = lastEntity.ID;
            }
         
        }
           [tableview reloadData];
    }
    else
    {
//        [[iToast makeText:@"数据为空!"] show];
    }
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
//    NSLog(@"%@,%@,%@,%d",lm_id,Im_time_id,lm_time_name,isTel);
//    _lm_id = lm_id;
//    _lm_name = lm_name;
//    _lm_time_id = Im_time_id;
//    _is_tel = [NSString stringWithFormat:@"%hhd",isTel];;
    
    // 获取物流配送数组
    if (nTag == t_API_PS_LOGISTIC_STYLE)
    {
        self.deliveryArray = (NSMutableArray *)netTransObj;
//        for (LogisticModelEntity *logisticEntity in self.deliveryArray) {
//            if ([logisticEntity.title isEqualToString:@"半日达"]) {
//                  NSDictionary *dicDefault = [logisticEntity.delivery_time objectAtIndex:0];
//                _lm_name = logisticEntity.title;
//                _lm_id = logisticEntity.logisId;
//                _lm_time_name = [dicDefault objectForKey:@"title"];
//                _lm_time_id = [dicDefault objectForKey:@"id"];
//
//                [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id];
//                break;
//            }
//        }
    }
    
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API)
    {
        self.entity = (OrderSubmitEntity *)netTransObj;
        priceInfo.text = [NSString stringWithFormat:@"¥ %@",self.entity.total_amount];
        [tableview reloadData];
    }
    
    if (nTag == t_API_PS_ORDER_COUPON_LIST)
    {
        YHCouponListViewController *coupon = [[YHCouponListViewController alloc] init];
        coupon.selectDictionary = myCouponDic;
        coupon.dataArray = (NSMutableArray *)netTransObj;
        coupon.successCallBlock = ^(NSDictionary *dic){
            self.myCouponDic = dic;
            NSLog(@"dic %@",dic);
            _coupon_id = [dic objectForKey:@"id"];
            _coupon_name = [dic objectForKey:@"title"];
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.entity.goods_id total:self.entity.total];
        };
        [self.navigationController pushViewController:coupon animated:YES];
    }
    else if (nTag == t_API_SUBMIT_ORDER)
    {
        OrderAddressEntity *orderEntity = [[OrderAddressEntity alloc]init];
        orderEntity.true_name = _name;
        orderEntity.mobile = _tel;
        orderEntity.logistics_address = _logistics_address;
        orderEntity.logistics_area_name = _logistics_area_name;
        orderEntity.ID = _order_address_id;
        NSDictionary *addressDic = [orderEntity convertAddressEntityToDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:addressDic forKey:@"storeAddress"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        OrderSubmitEntity *subentity = (OrderSubmitEntity *)netTransObj;
        YHConfirmOrderViewController *conVC = [[YHConfirmOrderViewController alloc]init];
        if (model == Fetch) {
            conVC.model = FetchPS;
        } else {
            if ([_pay_method isEqualToString:@"100"] || [_pay_method isEqualToString:@"200"]|| [_pay_method isEqualToString:@"250"]) {
                conVC.model = DeliverPS_PayOnline;
            } else {
                conVC.model = DeliverPS_PayOffline;
            }
        }
    
        conVC.orderEntity = subentity;
        [self.navigationController pushViewController:conVC animated:YES];
    }
    else if (t_API_PS_DELIVERY_STYLE == nTag)
    {
        NSMutableArray *arr = (NSMutableArray *)netTransObj;
        [DeliveryStyleArray removeAllObjects];
        for (NSMutableDictionary *dic in arr) {
            DeliveryStyleEntity *styleEntity = [[DeliveryStyleEntity alloc]init];
            styleEntity.i_d = [[dic objectForKey:@"id"] stringValue];
            styleEntity.name = [dic objectForKey:@"name"];
            [DeliveryStyleArray addObject:styleEntity];
        }
        [tableview reloadData];
    }
    else if (t_API_PS_PICK_UP_TIME_INFO == nTag)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSMutableArray *data = (NSMutableArray *)netTransObj;
            NSMutableDictionary *dic = [data objectAtIndex:0];
            
            PickUpTimeEntity *pickUpTimeEntity = [[PickUpTimeEntity alloc] init];
            pickUpTimeEntity.start_time = [dic objectForKey:@"start_time"];
            pickUpTimeEntity.end_time = [dic objectForKey:@"end_time"];
            pickUpTimeEntity.support_days = [dic objectForKey:@"support_days"];
            pickUpTimeEntity.fastest_pick_up_time = [dic objectForKey:@"fastest_pick_up_time"];
            pickUpTimeEntity.date = [dic objectForKey:@"date"];
//            PickUpTimeEntity *pickUpTimeEntity = [[PickUpTimeEntity alloc] init];
//            pickUpTimeEntity.start_time = @"08:00:00";
//            pickUpTimeEntity.end_time = @"22:00:00";
//            pickUpTimeEntity.support_days = @"2";
//            pickUpTimeEntity.fastest_pick_up_time = @"2";
//            pickUpTimeEntity.date = @"2014-10-13 21:41:00";
            
            
            /*时间小时分钟数组生成方法*/
            NSArray *start_time = [pickUpTimeEntity.start_time componentsSeparatedByString:@":"];
            NSArray *end_time = [pickUpTimeEntity.end_time componentsSeparatedByString:@":"];
            
            
            NSInteger fastest_pick_up_time = [pickUpTimeEntity.fastest_pick_up_time integerValue];
            NSInteger startHour = [[start_time objectAtIndex:0] integerValue];
            NSInteger endHour = [[end_time objectAtIndex:0] integerValue];
            NSInteger count = endHour-startHour;
            NSInteger support_days = [pickUpTimeEntity.support_days integerValue];
            
            if ([[end_time objectAtIndex:1] integerValue]-[[start_time objectAtIndex:1] integerValue]>0) {//8:00   ----    9:30      4
                count = count*2 + 2;
            } else if ([[end_time objectAtIndex:1] integerValue]-[[start_time objectAtIndex:1] integerValue] < 0) {//8:30   ----    9:00     2
                count = count*2;
            } else {//8:00   ----    9:00        3
                count = count*2 + 1;
            }
            
            ymdArray = [NSMutableArray array];
            NSMutableArray *hourMinuteArray = [NSMutableArray array];
   
            for (int i=0; i<count; i++) {
                
                if ([[start_time objectAtIndex:1] integerValue]>0) {//开始的时间分钟大于0，也就是等于30
                    
                    if (i%2 == 0) {//偶数
                        NSString *time = [NSString stringWithFormat:@"%ld:30",[[start_time objectAtIndex:0] integerValue]+i/2];
                        [hourMinuteArray addObject:time];
                    } else {
                        NSString *time = [NSString stringWithFormat:@"%ld:00",[[start_time objectAtIndex:0] integerValue]+i/2];
                        [hourMinuteArray addObject:time];
                    }
                    
                } else {
                    
                    if (i%2 == 0) {//偶数
                        NSString *time = [NSString stringWithFormat:@"%ld:00",[[start_time objectAtIndex:0] integerValue]+i/2];
                        [hourMinuteArray addObject:time];
                    } else {
                        NSString *time = [NSString stringWithFormat:@"%ld:30",[[start_time objectAtIndex:0] integerValue]+i/2];
                        [hourMinuteArray addObject:time];
                    }
                    
                }
            }
            
            
            /*默认时间生成方法*/
            //                long time=(long)[[NSDate date] timeIntervalSince1970];
            long time = (long)[[PublicMethod NSStringToNSDateToSS:pickUpTimeEntity.date] longLongValue];
            NSString  *time_id = [[NSNumber numberWithLong:(time+3600*fastest_pick_up_time+60*30-time%(60*30))] stringValue];
            NSDate *firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:time_id]];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:[time_id longLongValue]]];
            
            /*年月日数组生成方法*/
            NSTimeInterval secondsPerDay = 24 * 60 * 60;
            
            NSDateFormatter *storeDateFormatter = [[NSDateFormatter alloc] init];
            [storeDateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            support_days = support_days - ([comps day] - [[pickUpTimeEntity.date substringWithRange:NSMakeRange(8, 2)] integerValue]);
        
            if ([comps hour]>endHour || (([comps hour]==endHour) && ([comps minute]>[[end_time objectAtIndex:1] integerValue]))) {//不在自提时间内,结束时间-->24
        
                for (int i = 0; i < support_days; i ++) {
                    NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:(i+1) * secondsPerDay]];
                    [ymdArray addObject:dateStore];
                }
      
                if ([ymdArray count]>0) {
                    _time = [NSString stringWithFormat:@"%@ %@",[ymdArray objectAtIndex:0],[hourMinuteArray objectAtIndex:0]];
                    _time_id = [PublicMethod NSStringToNSDate:_time];
                }

                
            } else if (([comps hour]<startHour) || (([comps hour]==startHour) && ([comps minute]<[[start_time objectAtIndex:1] integerValue]))) {//不在自提时间内,0-->开始时间
                
                for (int i = 0; i < support_days; i ++) {
                    NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                    [ymdArray addObject:dateStore];
                }
                
                if ([ymdArray count]>0) {
                    _time = [NSString stringWithFormat:@"%@ %@",[ymdArray objectAtIndex:0],[hourMinuteArray objectAtIndex:0]];
                    _time_id = [PublicMethod NSStringToNSDate:_time];
                }
     
                
            } else {
                
                for (int i = 0; i < support_days; i ++) {
                    NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                    [ymdArray addObject:dateStore];
                }
                
                if ([ymdArray count]>0) {
                    _time= [PublicMethod timeStampConvertToFullTime:time_id];
                    _time_id = time_id;
                }
        
                
            }
            
            
            if ([ymdArray count]>0) {
                defaultPickTime = _time;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableview reloadData];
                });
            }
   
            
        });
    }
    else if (t_API_ADDRESS_LIST == nTag)
    {
        NSMutableArray * arrData = (NSMutableArray*)netTransObj;
        [self updateViewController:arrData];
    }
}

@end