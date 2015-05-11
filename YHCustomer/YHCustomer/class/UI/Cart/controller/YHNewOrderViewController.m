//
//  YHNewOrderViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-10-9.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHNewOrderViewController.h"
#import "YHConfirmOrderViewController.h"

#import "YHPSNewStorePickViewController.h"
#import "YHPSStorePickViewController.h"
#import "YHPSDeliveryDoorViewController.h"
#import "YHPickUpTimeViewContorller.h"
#import "YHPSStoreInfoViewController.h"
#import "YHPSPaymentStyleViewController.h"
#import "AddressesManagerViewController.h"
#import "YHCouponListViewController.h"
#import "YHPSGoodListViewController.h"
#import "OrderEntity.h"
#import "YHPaySucceedViewController.h"
#import "AddNewAddressViewController.h"
#import "PSEntity.h"
#import "YHTimeView.h"
#import "YHActionSheet.h"

@interface YHNewOrderViewController (){
    YHTimeView * _yhTimeView;
    YHActionSheet * as;
    UIView * shadow;
    NSInteger _fastest_pick_up_time;
    NSInteger _fastest_pick_up_time_min;
    NSInteger _startHour;
    NSInteger _endHour;
    NSInteger _startMinute;
    NSInteger _endMinute;
    NSInteger _count;
    NSInteger _support_days;
    NSInteger _select_days;
    NSString * _currentTime;
    NSString * _selectTime;
    NSString * _defaultDate;
    
    NSMutableArray *_hourMinuteArray;
    NSMutableArray *_sevenWeekDayArray;
    NSMutableArray *_sevenDayArray;
    NSMutableArray *_sevenDateArray;
    NSMutableArray *_dateArray;
    NSString * _dateString;
    NSString * _hourString;
    //cell 上的子控件
    UILabel *_timeLabel;
    
    //是否选择优惠券
    NSString * coupon_num;
    NSString * coupon_name;
    BOOL payMethodSelected;
    BOOL deliveryMethodChanged;
    BOOL cancelCouponSelect;
}

@property (nonatomic, strong) NSMutableArray *deliveryArray;
@end

@implementation YHNewOrderViewController
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
        
        _sevenWeekDayArray = [[NSMutableArray alloc]init ];
        _sevenDayArray = [[NSMutableArray alloc]init ];
        _sevenDateArray = [[NSMutableArray alloc]init ];
        
        arrAddress = [[NSMutableArray alloc] init];
        needInvoice = NO;
        invoiceIsCompany = NO;
        
        _immdiateBuy = NO;       /*    默认    */
        _transaction_type = @"0";/*  购物车流程 */
        
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
    if (_immdiateBuy) {
        model = Deliver;
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t global = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, global, ^{
        [[PSNetTrans getInstance] ps_getDeliveryStyle:self transaction_type:self.transaction_type];
    });
    dispatch_group_async(group, global, ^{
        [self getAddressList];
        
    });
    dispatch_group_async(group, global, ^{
        [self getPickUpTime];
    });
    
    
    
    
    //自提门店
    NSMutableDictionary *store = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeInfo"];
    if (store) {
        _bu_name = [store objectForKey:@"bu_name"];
        _bu_address = [store objectForKey:@"bu_address"];
        _bu_id = [store objectForKey:@"bu_id"];
        _bu_code = [store objectForKey:@"bu_code"];
        
    }
    //优惠券数量--与支付方式相关联
    if(_pay_method){
        payMethodSelected = NO;
        dispatch_group_async(group, global, ^{
            [self getCouponList];
        });
    }else{
        coupon_num = self.entity.coupon_num;
    }
    //优惠券数量--与运费相关（只有配送才会用到）--默认为自提
    deliveryMethodChanged = NO;
    
//    [self getAddressList];
//    [self getPickUpTime];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
// 获取优惠券数量api
- (void)getCouponList
{
    [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:nil goods_id:self.goods_id total:self.total];
}
// 获取收获地址api
- (void)getAddressList
{
    [[PSNetTrans getInstance] API_order_address_list_func:self goods_id:self.goods_id];
}
// 获取配送时间API
- (void)getPickUpTime
{
    [[PSNetTrans getInstance] get_PickUp_Time:self ReginId:[UserAccount instance].region_id];
}
//// 获取优惠券数量
//- (void)getCouponNumber{
//    [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    _is_tel = @"1";
    _receipt_type = @"0";
    
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-225, 0, 200, 40)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    _timeLabel.textAlignment = NSTextAlignmentRight;

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
    footView.backgroundColor =[PublicMethod colorWithHexValue:0xd3d3d4 alpha:1];
    
    //价钱信息
    priceInfo =[[UILabel alloc] initWithFrame:CGRectMake(20, 14, 170, 16)];
    priceInfo.text = [NSString stringWithFormat:@"¥ %@",self.entity.total_amount];
    priceInfo.backgroundColor=[UIColor clearColor];
    priceInfo.textColor =[PublicMethod colorWithHexValue:0x333333 alpha:1.0];
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
        return 8;
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
    
    if (indexPath.row == 0) {
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
        if (_immdiateBuy) {
            leftBtn.hidden = YES;
        }
    }
    //0行之下
    if (model == Fetch) {
        switch (indexPath.row) {
            case 1:
            {
                UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
                bg.backgroundColor = [UIColor whiteColor];
                [cell addSubview:bg];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
                label.backgroundColor = [UIColor clearColor];
                label.text = @"自提门店";
                label.font = [UIFont systemFontOfSize:15.0];
                label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
                [bg addSubview:label];
                
                UILabel *store = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-225, 0, 200, 40)];
                store.backgroundColor = [UIColor clearColor];
                store.text = @"请选择自提门店";
                
                if (_bu_name) {
                    store.text = _bu_name;
                } else{
                    if ([[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_name"] &&
                        [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"] &&
                        [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"] &&
                        [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_address"]){
                        
                        store.text = [[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_name"];
                        _bu_name = [[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_name"];
                        _bu_code = [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"];
                        _bu_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_id"];
                        _bu_address = [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_address"];
                    }
                    
                }
                
                store.font = [UIFont systemFontOfSize:12.0];
                store.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
                store.textAlignment = NSTextAlignmentRight;
                [bg addSubview:store];
                //箭头
                UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
                [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
                [bg addSubview:arrow];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom-0.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                [bg addSubview:line];
                
                UIView *yellowBg = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom, SCREEN_WIDTH, 32)];
                yellowBg.backgroundColor = [PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0];
                if (_bu_id) {
                    [cell addSubview:yellowBg];
                }
                
                UILabel *address = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, SCREEN_WIDTH, 20)];
                address.backgroundColor = [UIColor clearColor];
                address.text = @"自提地址:";
                if (_bu_address) {
                    address.text = [NSString stringWithFormat:@"自提地址:%@",_bu_address];
                }

                address.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
                address.font = [UIFont systemFontOfSize:12.0];
                [yellowBg addSubview:address];
            }
                break;
            case 2:
            {
                UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
                bg.backgroundColor = [UIColor whiteColor];
                [cell addSubview:bg];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
                label.backgroundColor = [UIColor clearColor];
                label.text = @"自提时间";
                label.font = [UIFont systemFontOfSize:15.0];
                label.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
                [bg addSubview:label];
                
                
                //箭头
                UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20, 14, 12, 12)];
                [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
                [bg addSubview:arrow];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bg.bottom-0.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
                [bg addSubview:line];
                
                
                if (model == Fetch) {
                    
                } else {
                    _timeLabel.text = @"半日达";
                    if (_lm_name) {
                        _timeLabel.text = _lm_name;
                    }
                }
                
                [bg addSubview:_timeLabel];

            }
                break;
            case 3:
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
            case 4:
            {
                if (model == Fetch) {
                    [self addCellCouponView:cell];
                } else {
                    [self addCellPayMethodView:cell];
                }
            }
                break;
            case 5:
            {
                if (model == Fetch) {
                    [self addCellMarkView:cell];
                } else {
                    [self addCellCouponView:cell];
                }
            }
                break;
            case 6:
            {
                if (model == Fetch) {
                    [self addCellGoodsListView:cell];
                } else {
                    [self addCellInvoiceView:cell];
                }
            }
                break;
            case 7:
            {
                if (model == Fetch) {
                    [self addCellPriceListView:cell];
                } else {
                    [self addCellMarkView:cell];
                }
            }
                break;
            case 8:
            {
                [self addCellGoodsListView:cell];
            }
                break;
                
            case 9:
            {
                [self addCellPriceListView:cell];
            }
                break;
            default:
                break;
        }

    }else{
        switch (indexPath.row) {
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
                store.text = @"请选择送货方式";
                if (_lm_name) {
                    store.text = _lm_name;
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
                [cell addSubview:yellowBg];
    
                
                UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, SCREEN_WIDTH, 20)];
                time.backgroundColor = [UIColor clearColor];
                time.text = @"送货时间:";
                if (_lm_time_id) {
                    time.text = [NSString stringWithFormat:@"送货时间:%@",_lm_time_name];
                }
                time.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
                time.font = [UIFont systemFontOfSize:12.0];
                [yellowBg addSubview:time];
                
                UILabel *add = [[UILabel alloc]initWithFrame:CGRectMake(10, time.bottom, SCREEN_WIDTH, 20)];
                add.backgroundColor = [UIColor clearColor];
                add.text = @"是否送货前电话确认:否";
                if ([_is_tel integerValue] == 0) {
                    add.text = @"是否送货前电话确认:否";
                } else if ([_is_tel integerValue] == 1) {
                    add.text = @"是否送货前电话确认:是";
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

    }
    
    
    return cell;

}

#pragma mark -------------- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (model == Fetch) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
                
            case 1:
            {
                //自提门店
                YHPSNewStorePickViewController *store = [[YHPSNewStorePickViewController alloc] init];
                store.bu_code = _bu_code;
                store.bu_name = _bu_name;
                store.bu_id = _bu_id;
                store.bu_address = _bu_address;
                store.psStoreBlock = ^(NSString *bu_id,NSString *bu_name,NSString * bu_code,NSString *address){
                    _bu_id = bu_id;
                    _bu_name = bu_name;
                    _bu_code = bu_code;
                    _bu_address = address;
                };
                [self.navigationController pushViewController:store animated:YES];
            }
                break;
            case 2:
            {
                YHPickUpTimeViewContorller * pickUpVC = [[YHPickUpTimeViewContorller alloc] init];
                YHNewOrderViewController * vc = self;
                pickUpVC.isFromNewOrder = YES;
                pickUpVC.pickUpBlock = ^(NSString * pickUpString, NSString * paramString)
                    {
                        if(pickUpString && paramString){
                            vc->_timeLabel.text = pickUpString;
                            vc->_time_id = paramString;
                            [vc->tableview reloadData];
                        }
                    };
                [self.navigationController pushViewController:pickUpVC animated:YES];
                
            }
                break;
            case 3:
            {   //支付方式
                [self choosePaymentStyle];
            }
                break;
                
            case 4:
            {
                //优惠券
                if ([coupon_num intValue]==0) {
                    [[iToast makeText:@"暂无优惠券"] show];
                } else {
                    if (!_pay_method) {
                        [self showAlert:@"请先选择支付方式"];
                        return;
                    }
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:nil goods_id:self.goods_id total:self.total];
                }
            }
                break;
            case 5:
            {
                //订单备注
            }
                break;
                
            case 6:
            {
                //商品清单
                    
                YHPSGoodListViewController *psGoodsList = [[YHPSGoodListViewController alloc] init];
                psGoodsList.goodsWight=[NSString stringWithFormat:@"重量总计%@kg",self.entity.goods_weight];
                psGoodsList.logistics_amount = self.entity.logistics_amount;
                psGoodsList.goods_num = self.entity.goods_num;
                psGoodsList.goods_id = self.goods_id;
                psGoodsList.total = self.total;
                [self.navigationController pushViewController:psGoodsList animated:YES];
                
            }
                break;
            case 7:
            {
                
            }
                break;
                
            case 8:
            {
                
            }
                break;
                
            default:
                break;
        }

    }else{
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
                
            case 1:
            {
                //送货信息
                YHPSDeliveryDoorViewController *delivery = [[YHPSDeliveryDoorViewController alloc] init];
//                delivery.dataArray = self.deliveryArray;
                delivery.isTel = [_is_tel boolValue];
                delivery.goods_id = self.goods_id;
//                [delivery setDeliveryEntity:_lm_name];
                delivery.pickTimeBlock = ^(NSString *lm_id,NSString *lm_name,NSString *lm_time_name,NSString *lm_time_id,BOOL isTel){
                    NSLog(@"%@,%@,%@,%@,%d",lm_id,lm_name,lm_time_id,lm_time_name,isTel);
                    
                    _lm_name = lm_name;
                    _lm_time_id = lm_time_id;
                    _lm_time_name = lm_time_name;
                    _is_tel = [NSString stringWithFormat:@"%hhd",isTel];
                    if (![_lm_id isEqualToString:lm_id]){
                        deliveryMethodChanged = YES;
                        _lm_id = lm_id;
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.goods_id total:self.total];
                    }
                    
                };
                [self.navigationController pushViewController:delivery animated:YES];
                }
                break;
            case 2:
            {
               //收货地址
                if ([self.arrAddress count]== 0) {
                    AddNewAddressViewController *addVC = [[AddNewAddressViewController alloc]init];
                    addVC._isNewOrEdit= YES;
                    addVC.goods_id = self.goods_id;
                    addVC.block = ^(id param){
                        [self getAddressList];
                    };
                    [self.navigationController pushViewController:addVC animated:YES];
                } else {
                    AddressesManagerViewController *address = [[AddressesManagerViewController alloc] init];
                    
                    address.entityID = _order_address_id;
                    address.goods_id = self.goods_id;
                    address.addressDefaultCallBack = ^(OrderAddressEntity *addEntity,NSMutableArray *addressArray){
                        _logistics_address = addEntity.logistics_address;
                        _logistics_area_name = addEntity.logistics_area_name;
                        _name = addEntity.true_name;
                        _tel = addEntity.mobile;
                        _order_address_id = addEntity.ID;
                        //_bu_code = addEntity.bu_code;
                        self.arrAddress = addressArray;
                    };
                    [self.navigationController pushViewController:address animated:YES];
                    
                }
            }
                break;
                
            case 3:
            {
                //支付方式
                [self choosePaymentStyle];
            }
                break;
            case 4:
            {
                if (model == Deliver) {//优惠券
                    
                    if ([coupon_num intValue]==0) {
                        [[iToast makeText:@"暂无优惠券"] show];
                    } else {
                        if (!_pay_method) {
                            [self showAlert:@"请先选择支付方式"];
                            return;
                        }
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:_lm_id goods_id:self.goods_id total:self.total];
                    }
                    
                }
            }
                break;
                
            case 5:
            {
            
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
                    psGoodsList.goods_num = self.entity.goods_num;
                    psGoodsList.goods_id = self.goods_id;
                    psGoodsList.total = self.total;
                    [self.navigationController pushViewController:psGoodsList animated:YES];
                    
                }
            }
                break;
                
            default:
                break;
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(model == Fetch){
        switch (indexPath.row) {
            case 0:
                return 10+40+10;
                break;
            case 1:
                if (!_bu_id) {
                    return 40+10;
                } else {
                    return 40+32+10;
                }
                break;
            case 2:
                return 40+10;
                break;
            case 3:
                return 40+10;
                break;
            case 4:
                return 40+10;
                break;
            case 5:
                return 30+50+20;
                break;
            case 6:
                return 40+10;
                break;
            case 7:
                return 40+90+10;
                break;
            case 8:
                return 40+10;
                break;
            case 9:
                return 40+90+10;
                break;
            default:
                return 0;
                break;
        }

    }else{
        switch (indexPath.row) {
            case 0:
                return 10+40+10;
                break;
            case 1:
                return 40+53+10;
            case 2:
                if (!_tel) {
                    return 40+10;
                } else {
                    return 40+73+10;
                }
                break;
            case 3:
                return 40+10;
                break;
            case 4:
                return 40+10;
                break;
            case 5:
               if (needInvoice) {
                    return 40+45+10;
                } else {
                    return 40;
                }
                break;
            case 6:
                return 30+50+20;
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
}

/**
 * 选择支付方式
 */
- (void)choosePaymentStyle{
    if (model == Deliver) {
        if (!_lm_id) {
            [self showAlert:@"请先选择配送方式"];
            return;
        }
    }
    YHPSPaymentStyleViewController *paymentStyle = [[YHPSPaymentStyleViewController alloc] init];
    paymentStyle.paystyle = _pay_name;
    paymentStyle.fromNewOrder = YES;
    paymentStyle.model = model;
    paymentStyle.goods_id = self.goods_id;
    paymentStyle.total = self.total;
    paymentStyle.lm_id = [NSString stringWithFormat:@"%@",_lm_id];
    __unsafe_unretained YHNewOrderViewController * vc = self;
    paymentStyle.chooseBlock = ^(NSString *pay_method,id object,NSInteger number){

        if (_coupon_type) {
            if (_coupon_type.integerValue != 0 && _coupon_type.integerValue != pay_method.integerValue) {
                if ( !_pay_method) {
                    [vc showAlert:@"优惠券不可用，请重新选择。"];
                    _coupon_name = @"";
                    _coupon_id = @"";
                    _coupon_type = nil;
                    cancelCouponSelect = YES;
                    [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.goods_id total:self.total];
                }else{
                    _coupon_name = @"";
                    _coupon_id = @"";
                    _coupon_type = nil;
                    cancelCouponSelect = YES;
                    [vc showAlert:@"请重新选择优惠券"];
                    [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.goods_id total:self.total];
                }
            }
        }else{
            //可用
        }
        coupon_num = [NSString stringWithFormat:@"%ld", (long)number];
        _pay_method = pay_method;
        if (_pay_method) {
            payMethodSelected = YES;
        }
        if ([pay_method isEqualToString:@"100"]) {
            _pay_name = @"银联支付";
        } else if ([pay_method isEqualToString:@"200"]) {
            _pay_name = @"支付宝支付";
        } else if ([pay_method isEqualToString:@"250"]) {
            _pay_name = @"永辉钱包支付";
        }
        [vc->tableview reloadData];
    };
    [self.navigationController pushViewController:paymentStyle animated:YES];
}

#pragma mark -------------------------按钮事件处理
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//timeA 后台返回的开始时间 timeB 由当前时间加最快自提时间所确定 返回值为最终的可选的最快自提时间
- (NSString *)selectTimeForCompareA:(NSString *)timeA withB:(NSString *)timeB{
    NSArray * aArray = [timeA componentsSeparatedByString:@":"];
    NSInteger aHour = [[aArray objectAtIndex:0] integerValue];
    NSInteger aMinute = [[aArray objectAtIndex:1] integerValue];
    
    NSArray * bArray = [timeA componentsSeparatedByString:@":"];
    NSInteger bHour = [[bArray objectAtIndex:0] integerValue];
    NSInteger bMinute = [[bArray objectAtIndex:1] integerValue];
    
    if ((aHour < bHour) || (aHour == bHour && aMinute < bMinute)) {
        return timeA;
    }else{
        return timeB;
    }
}
- (NSString *)calculatorFpTime:(NSString *)timeString{
    //最快自提时间对比，计算
    NSString * fpTimeString;
    fpTimeString = [NSString stringWithString:timeString];
    
    NSString * f ;
    NSArray * arr = [fpTimeString componentsSeparatedByString:@":"];
    if ([[arr objectAtIndex:1] integerValue]>0 &&[[arr objectAtIndex:1] integerValue] <=30 ) {
        f = [NSString stringWithFormat:@"%@:%d",[arr objectAtIndex:0],30];
    }else if([[arr objectAtIndex:1] integerValue]==0){
        f = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],@"00"];
    }else{
        f = [NSString stringWithFormat:@"%ld:%@",(long)[[arr objectAtIndex:0] integerValue]+1,@"00"];
    }
    return f;
}
- (NSString *)defaultTime:(NSString *)selectTime{
    NSString * fpTime = [self calculatorFpTime:selectTime];
    NSUInteger index = [_hourMinuteArray indexOfObject:fpTime];
    NSArray * fpArray = [fpTime componentsSeparatedByString:@":"];
    NSInteger hour = [[fpArray objectAtIndex:0] integerValue];
    NSInteger minute = [[fpArray objectAtIndex:1] integerValue];
    
    NSString * startString = [_hourMinuteArray objectAtIndex:0];
    NSString * endString = [_hourMinuteArray lastObject];
    NSInteger startHour = [[startString substringToIndex:2] integerValue];
    NSInteger startMinute = [[startString substringFromIndex:3] integerValue];
    NSInteger endHour = [[endString substringToIndex:2] integerValue];
    NSInteger endMinute = [[endString substringFromIndex:3] integerValue];
    NSUInteger location;
    NSString * string;
    NSString *character;
    NSString *strNum=@"";
    NSString *dayString;
    NSString *hourMinuteString;
    for (NSString * s in _sevenDateArray) {
        if ([s hasPrefix:_defaultDate]) {
            if (index == NSNotFound) {
                if ([s hasSuffix:@"今天"]) {
                    location = [_sevenDateArray indexOfObject:s];
                    hourMinuteString = [_hourMinuteArray objectAtIndex:0];
                    if (hour < startHour || (hour == startHour && minute < startMinute)){
                        string = [_sevenDateArray objectAtIndex:location];
                        dayString = [NSString stringWithFormat:@"今天"];
                    }else if(hour > endHour || (hour == endHour && minute > endMinute)){
                        string = [_sevenDateArray objectAtIndex:location +1];
                        dayString = [NSString stringWithFormat:@"明天"];
                    }
                }else if ([s hasSuffix:@"明天"]) {
                    location = [_sevenDateArray indexOfObject:s];
                    hourMinuteString = [_hourMinuteArray objectAtIndex:0];
                    if (hour < startHour || (hour == startHour && minute < startMinute)){
                        string = [_sevenDateArray objectAtIndex:location];
                        dayString = [NSString stringWithFormat:@"明天"];
                    }else if(hour > endHour || (hour == endHour && minute > endMinute)){
                        string = [_sevenDateArray objectAtIndex:location +1];
                        dayString = @"";
                    }
                }else{
                    location = [_sevenDateArray indexOfObject:s];
                    hourMinuteString = [_hourMinuteArray objectAtIndex:0];
                    string = [_sevenDateArray objectAtIndex:location];
                    dayString = @"";
                }
            }else{
                if ([s hasSuffix:@"今天"]) {
                    dayString = [NSString stringWithFormat:@"今天"];
                }else if ([s hasSuffix:@"明天"]) {
                    dayString = [NSString stringWithFormat:@"明天"];
                }else{
                    dayString = @"";
                }
                location = [_sevenDateArray indexOfObject:s];
                hourMinuteString = [NSString stringWithString:[self calculatorFpTime: selectTime]];
                string = [_sevenDateArray objectAtIndex:location];
            }
        }
        
    }

    for (int i=0; i<string.length; ++i) {
        character=[string substringWithRange:NSMakeRange(i, 1)];//循环取每个字符
        
        if ([character isEqual: @"0"]|
            [character isEqual: @"1"]|
            [character isEqual: @"2"]|
            [character isEqual: @"3"]|
            [character isEqual: @"4"]|
            [character isEqual: @"5"]|
            [character isEqual: @"6"]|
            [character isEqual: @"7"]|
            [character isEqual: @"8"]|
            [character isEqual: @"9"]) {
            
            strNum=[strNum stringByAppendingString:character];//是数字的拼接字符串
        }
        
    }
    NSString * year = [strNum substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [strNum substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [strNum substringWithRange:NSMakeRange(6, 2)];
    NSString * f;
    if (dayString && dayString.length != 0) {
        f = [NSString stringWithFormat:@"%@（%@月%@日）%@",dayString,month,day,hourMinuteString];
    }else{
        f = [NSString stringWithFormat:@"%@月%@日%@",month,day,hourMinuteString];
    }
    //不建议这样做，体验不好，为了两端统一，作此处理
    if (_select_days == 0 || (_select_days == 1 && index == NSNotFound && ((hour > endHour) || (hour == endHour && minute > endMinute)))) {
        f = [NSString stringWithFormat:@"暂无可选自提时间"];
    }
    //订单默认时间
    NSString * time = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,hourMinuteString];
    _time_id = [PublicMethod NSStringToNSDate:time];
    return f;
    
}
- (void)changeTime{
    NSString * string = _yhTimeView.dateLabel.text;

    NSString *character;
    NSString *strNum=@"";
    
    
    for (int i=0; i<string.length; ++i) {
        character=[string substringWithRange:NSMakeRange(i, 1)];//循环取每个字符
        
        if ([character isEqual: @"0"]|
            [character isEqual: @"1"]|
            [character isEqual: @"2"]|
            [character isEqual: @"3"]|
            [character isEqual: @"4"]|
            [character isEqual: @"5"]|
            [character isEqual: @"6"]|
            [character isEqual: @"7"]|
            [character isEqual: @"8"]|
            [character isEqual: @"9"]) {
            
            strNum=[strNum stringByAppendingString:character];//是数字的累加起来
        }
        
    }
    NSString * year = [strNum substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [strNum substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [strNum substringWithRange:NSMakeRange(6, 2)];
    NSUInteger index = [_sevenDateArray indexOfObject:string];
    
    if (index != NSNotFound) {
        if ([string hasSuffix:@"今天"]) {
            _timeLabel.text = [NSString stringWithFormat:@"今天（%@月%@日）%@",month,day,_yhTimeView.hourString];
        }else if ([string hasSuffix:@"明天"]) {
            _timeLabel.text = [NSString stringWithFormat:@"明天（%@月%@日）%@",month,day,_yhTimeView.hourString];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"%@月%@日 %@",month,day,_yhTimeView.hourString];
        }
        NSString * time = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,_yhTimeView.hourString];
        _time_id = [PublicMethod NSStringToNSDate:time];
    }
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
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 215, 40)];
    pay.backgroundColor = [UIColor clearColor];
    if ([coupon_num intValue]==0) {
        pay.text = @"暂无优惠券";
    } else {
        pay.text = [NSString stringWithFormat:@"有%@张优惠券可以使用",coupon_num];
    }
    
    if (_coupon_name.length != 0) {
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
    
//    markField = [[UITextField alloc]initWithFrame:CGRectMake(10, label.bottom, 300, 40)];
//    markField.backgroundColor = [UIColor whiteColor];
//    markField.autocorrectionType = UITextAutocorrectionTypeNo;
//    markField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    markField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    markField.returnKeyType = UIReturnKeyDone;
//    markField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    markField.delegate = self;
//    markField.placeholder = @" 限30个字以内";
//    if (remarkText.length>0) {
//        markField.text = remarkText;
//    }
//    [cell.contentView addSubview:markField];
    
    
    markField = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, label.bottom, 300, 50)];
    markField.backgroundColor = [UIColor whiteColor];
    markField.autocorrectionType = UITextAutocorrectionTypeNo;
    markField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    markField.textAlignment = NSTextAlignmentLeft;
    markField.returnKeyType = UIReturnKeyDone;
    markField.font = [UIFont systemFontOfSize:15];
    markField.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    markField.placeholderColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
    markField.editable = YES;
    markField.delegate = self;
    markField.placeholder = @"亲，活鱼宰杀先？排骨剁块先？您对生鲜的特殊要求，可填在这告诉我们哟。";
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
    if (model == Deliver){
        label1.text = [NSString stringWithFormat:@"重量共计%@kg",self.entity.goods_weight];
    }
    
    label1.font = [UIFont systemFontOfSize:12.0];
    label1.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    label1.textAlignment = NSTextAlignmentRight;
    [bg addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.right+45, 0, 30, 40)];
    label2.backgroundColor = [UIColor clearColor];
    if (model == Deliver) {
        label2.text = @"运费:";
    }
    label2.font = [UIFont systemFontOfSize:12.0];
    label2.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    label2.textAlignment = NSTextAlignmentRight;
    [bg addSubview:label2];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(label2.right, 0, 50, 40)];
    label3.backgroundColor = [UIColor clearColor];
    if (model == Deliver) {
        label3.text = [NSString stringWithFormat:@"￥%@",self.entity.logistics_amount];
    }
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
- (void)selectHour
{
    
}
-(void)btnAction {
    [self addActionSheetView];
}

-(void)buttonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        if(model == Deliver){
            deliveryMethodChanged = YES;
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
            
            //自提
            _bu_id = nil;
            _bu_name = nil;
            _bu_code = nil;
            _bu_address = nil;
            
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.goods_id total:self.total];
        }else{
            deliveryMethodChanged = NO;
        }

        [tableview reloadData];
    } else if (btn.tag == 101) {
        [[PSNetTrans getInstance] ps_getLogisticStyle:self goods_id:self.goods_id];
        model = Deliver;
        [tableview reloadData];
    }
}

-(void)submitAction:(id)sender {
    [MTA trackCustomKeyValueEvent :EVENT_ID14 props:nil];
    _remark = [markField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _receipt_title = [invoiceField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *delivery_id;
    if (model == Fetch) {
        delivery_id = @"1";
        if (_bu_code.length == 0) {
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
                                  goods_id:self.goods_id
                                     total:self.total];
    
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
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (IOS_VERSION < 8) {
        if (range.location > 30){
            //复制粘贴的问题
            NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
            string = [string substringToIndex:30];
            textView.text = string;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于30" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        }
    }
    if (textView.text.length>0) {
        remarkText = textView.text;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
//    //复制粘贴的问题
//    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    if ([string length] > 30){
//        string = [string substringToIndex:30];
//    }
//    textView.text = string;
//    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (IOS_VERSION >= 8) {
        NSInteger number = [textView.text length];
        if (number > 30) {
            NSString * string = [NSString stringWithString:textView.text];
            textView.text = [string substringToIndex:30];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于30" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
            
        }
    }
    if (textView.text.length>0) {
        remarkText = textView.text;
    }
//    [self showAlert:[NSString stringWithFormat:@"%d/30",number]];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    markField.placeHolderLabel.alpha = 0;
    if (model == Fetch) {
        if (SCREEN_HEIGHT >480) {
            [tableview setContentOffset:CGPointMake(0, 80) animated:YES];
        } else {
            [tableview setContentOffset:CGPointMake(0, 150) animated:YES];
        }
        
    } else {
        if (SCREEN_HEIGHT >480) {
            [tableview setContentOffset:CGPointMake(0, 300) animated:YES];
        } else {
            [tableview setContentOffset:CGPointMake(0, 370) animated:YES];
        }
        
    }
}
#pragma mark - connectionDelegate
-(void)restoreDeliveryInfo:(NSDictionary *)dict{
    if ([[dict objectForKey:@"delivery_id"] integerValue] == 1 && model == Fetch) {
        //保存自提信息
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"bu_code"] forKey:@"bu_code"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"bu_id"] forKey:@"bu_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"bu_name"] forKey:@"bu_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"address"] forKey:@"bu_address"];
        
        //        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_id"] forKey:@"region_id"];
        //        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_name"] forKey:@"region_name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"psStyle"];
        //清除配送信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_name"];
    }else if([[dict objectForKey:@"delivery_id"] integerValue] == 2 && model == Deliver){
        //保存配送信息
        //        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_id"] forKey:@"region_id"];
        //        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_name"] forKey:@"region_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"area_code"] forKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"street_code"] forKey:@"street_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"area_name"] forKey:@"country_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"street_name"] forKey:@"street_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"bu_code"] forKey:@"bu_code"];
        //        [[NSUserDefaults standardUserDefaults] setObject:[[array lastObject] objectForKey:@"type"] forKey:@"bu_type"];//实体店，虚拟店
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"psStyle"];
        //清除自提信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_address"];
    }
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
}
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API)
    {
        if ((model == Fetch && deliveryMethodChanged == NO )|| deliveryMethodChanged == YES) {
            _coupon_id = @"";
            _coupon_name = @"";
            _coupon_type = nil;
            //在此界面如果需要结算的商品已缺货，那么会导致循环调用，以status来做区分，为2，需要刷新
            //所选优惠券不可用，需把优惠券置空，来重新刷新金额

            if ([status isEqualToString:@"2"]){
                [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:_lm_id goods_id:self.goods_id total:self.total];
            }
//            cancelCouponSelect = YES;
//            [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:_lm_id goods_id:self.goods_id total:self.total];
            
            [tableview reloadData];
            
        }
    }
    if ([status isEqualToString:WEB_STATUS_3])
    {
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
        return;
    }
    [[iToast makeText:errMsg]show];
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg withObject:(id)object{
    if (nTag == t_API_SUBMIT_ORDER) {
        if (object && [object isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = (NSDictionary *)object;
            if (dict && dict.count){
                if (model == Fetch && [[dict objectForKey:@"delivery_id"] integerValue] == 1) {
                    [self restoreDeliveryInfo:dict];
                }else if([[dict objectForKey:@"delivery_id"] integerValue] == 2 && model == Deliver){
                    [self restoreDeliveryInfo:dict];
                }
            }
        }
        [self showNotice:errMsg];
    }
}

#pragma mark --------------------------Request Delegate
-(void)updateViewController:(NSMutableArray*)arr
{
    if (arr != nil) {
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
    }else{
        //        [[iToast makeText:@"数据为空!"] show];
    }
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // 获取物流配送数组
    if (nTag == t_API_PS_LOGISTIC_STYLE)
    {
//        self.deliveryArray = (NSMutableArray *)netTransObj;
//            for (LogisticModelEntity *logisticEntity in self.deliveryArray) {
//                if ([logisticEntity.title isEqualToString:@"半日达"]) {
//                      NSDictionary *dicDefault = [logisticEntity.delivery_time objectAtIndex:0];
//                    _lm_name = logisticEntity.title;
//                    _lm_id = logisticEntity.logisId;
//                    _lm_time_name = [dicDefault objectForKey:@"title"];
//                    _lm_time_id = [dicDefault objectForKey:@"id"];
//
//                    [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id];
//                    break;
//                }
//            }
    }
    if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API)
    {
        self.entity = (OrderSubmitEntity *)netTransObj;
        priceInfo.text = [NSString stringWithFormat:@"¥ %@",self.entity.total_amount];
//        if (deliveryMethodChanged == YES || (model == Fetch && deliveryMethodChanged == NO)) {
//            deliveryMethodChanged = YES;
//        }
        if (_coupon_name && _coupon_name.length != 0){
            
        }else{
            cancelCouponSelect = YES;
            [[PSNetTrans getInstance] ps_getCouponList:self payMethod:_pay_method lm_idForPs:_lm_id goods_id:self.goods_id total:self.total];
        }
        [tableview reloadData];
    }
    if (t_API_ADDRESS_LIST == nTag)
    {
        NSMutableArray * arrData = (NSMutableArray *)netTransObj;
        [self updateViewController:arrData];
    }
    
    if (nTag == t_API_PS_ORDER_COUPON_LIST)
    {
        //首次进入，没有默认的支付方式
        if (payMethodSelected == NO)
        {
            NSMutableArray * array  = (NSMutableArray *)netTransObj;
            coupon_num = [NSString stringWithFormat:@"%lu", (unsigned long)array.count];
            payMethodSelected = YES;
            [tableview reloadData];
            return;
        }
        //配送方式已修改
        if (deliveryMethodChanged == YES) {
            NSMutableArray * array  = (NSMutableArray *)netTransObj;
            coupon_num = [NSString stringWithFormat:@"%lu", (unsigned long)array.count];
            deliveryMethodChanged = NO;
            cancelCouponSelect = NO;
            [tableview reloadData];
            return;
        }
        //取消选择优惠券,优惠券失效
        if (cancelCouponSelect == YES) {
            cancelCouponSelect = NO;
            deliveryMethodChanged = NO;
            NSMutableArray * array  = (NSMutableArray *)netTransObj;
            coupon_num = [NSString stringWithFormat:@"%lu", (unsigned long)array.count];
            [tableview reloadData];
            return;
        }
        YHCouponListViewController *coupon = [[YHCouponListViewController alloc] init];
        if (_coupon_name.length != 0) {
            coupon.selectDictionary = myCouponDic;
        }
        coupon.dataArray = (NSMutableArray *)netTransObj;
        coupon.payMethod = _pay_method;
        coupon.successCallBlock = ^(NSDictionary *dic){
            if (dic) {
                self.myCouponDic = dic;
                NSLog(@"dic %@",dic);
                _coupon_id = [dic objectForKey:@"id"];
                _coupon_name = [dic objectForKey:@"title"];
                _coupon_type = [dic objectForKey:@"coupon_type"];
                cancelCouponSelect = NO;
            }else{
                _coupon_id = nil;
                _coupon_name = nil;
                _coupon_type = nil;
                cancelCouponSelect = YES;
            }
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:_coupon_id lm_id:_lm_id goods_id:self.goods_id total:self.total];
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
        
        if (model == Fetch) {
            NSDictionary *storeDic1 = @{@"bu_id": _bu_id,@"bu_name":_bu_name,@"bu_code":_bu_code,@"bu_address":_bu_address};
            [[NSUserDefaults standardUserDefaults] setObject:storeDic1 forKey:@"storeInfo"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        OrderSubmitEntity *subentity = (OrderSubmitEntity *)netTransObj;
        //更新本地信息
        if (subentity.deliveryDict && subentity.deliveryDict.count){
            if (model == Fetch && [[subentity.deliveryDict objectForKey:@"delivery_id"] integerValue] == 1) {
                [self restoreDeliveryInfo:subentity.deliveryDict];
            }else if([[subentity.deliveryDict objectForKey:@"delivery_id"] integerValue] == 2 && model == Deliver){
                [self restoreDeliveryInfo:subentity.deliveryDict];
            }
        }
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
        conVC.goods_id = self.goods_id;
        conVC.total = self.total;
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
            pickUpTimeEntity.fastest_pick_up_time_min = [dic objectForKey:@"fastest_pick_up_time_min"];
            pickUpTimeEntity.date = [dic objectForKey:@"date"];
            
//            pickUpTimeEntity.fastest_pick_up_time_min = [NSString stringWithFormat:@"%d",1440];
//            pickUpTimeEntity.start_time = @"10:30:00";
//            pickUpTimeEntity.end_time =  @"22:00:00";
//            pickUpTimeEntity.date = @"2015-01-30 22:02:08";
            /*时间小时分钟数组生成方法*/
            
            NSArray *start_time = [pickUpTimeEntity.start_time componentsSeparatedByString:@":"];
            NSArray *end_time = [pickUpTimeEntity.end_time componentsSeparatedByString:@":"];
            
            
            
            _fastest_pick_up_time =  [pickUpTimeEntity.fastest_pick_up_time integerValue];
            _fastest_pick_up_time_min =  [pickUpTimeEntity.fastest_pick_up_time_min integerValue];
            
            _startHour = [[start_time objectAtIndex:0] integerValue];
            _endHour = [[end_time objectAtIndex:0] integerValue];
            //开始与结束时间不为整点和半点时的处理
            if ([[start_time objectAtIndex:1] integerValue] <= 30 && [[start_time objectAtIndex:1] integerValue] > 0){
                _startMinute = 30;
            }else if ([[start_time objectAtIndex:1] integerValue] == 0){
                _startMinute = 0;
            }else{
                _startMinute = 0;
                _startHour += 1;
            }
            if ([[end_time objectAtIndex:1] integerValue] < 30) {
                _endMinute = 0;
            }else{
                _endMinute = 30;
            }
            
            _count = _endHour-_startHour;
            _support_days = [pickUpTimeEntity.support_days integerValue];
//            _support_days = 6;
            
            if (_endMinute-_startMinute>0)
            {//8:00-9:30   1*2+2
                _count = _count*2 + 2;
            }
            else if (_endMinute-_startMinute < 0)
            {//8:30   --9:00     1*2 +0
                _count = _count*2;
            }
            else
            {//8:00--9:00     1*2+1
                _count = _count*2 + 1;
            }
            
//            if ([[end_time objectAtIndex:1] integerValue]-[[start_time objectAtIndex:1] integerValue]>0)
//            {//8:00-9:30   1*2+2
//                _count = _count*2 + 2;
//            }
//            else if ([[end_time objectAtIndex:1] integerValue]-[[start_time objectAtIndex:1] integerValue] < 0)
//            {//8:30   --9:00     1*2 +0
//                _count = _count*2;
//            }
//            else
//            {//8:00--9:00     1*2+1
//                _count = _count*2 + 1;
//            }
            
            ymdArray = [NSMutableArray array];
            _hourMinuteArray = [NSMutableArray array];
            
            if (_startMinute>0) {//开始的时间分钟大于0，也就是等于30
                for (int i= 0; i< _count ; i++) {
                    if ((i +1) %2 == 0)
                    {//奇数
                        NSString *time = [NSString stringWithFormat:@"%ld:00",(long)_startHour+(i +1)/2];
                        [_hourMinuteArray addObject:time];
                    } else {
                        NSString *time = [NSString stringWithFormat:@"%ld:30",(long)_startHour+(i +1)/2];
                        [_hourMinuteArray addObject:time];
                    }
                }
            }else {
                for (int i= 0; i< _count; i++) {
                    if (i%2 == 0) {//偶数
                        NSString *time = [NSString stringWithFormat:@"%ld:00",(long)_startHour+i/2];
                        [_hourMinuteArray addObject:time];
                    } else {
                        NSString *time = [NSString stringWithFormat:@"%ld:30",(long)_startHour+i/2];
                        [_hourMinuteArray addObject:time];
                    }
                }
            }
            
            
            /*默认时间生成方法*/
            //                long time=(long)[[NSDate date] timeIntervalSince1970];
            long time = (long)[[PublicMethod NSStringToNSDateToSS:pickUpTimeEntity.date] longLongValue];
            //可选的自提开始时间--总的秒数
            NSString  *time_id;
            
            if ((time +60*_fastest_pick_up_time_min)%(60*30) == 0)
            {
                time_id = [[NSNumber numberWithLong:(time+60*_fastest_pick_up_time_min)]stringValue];
            }
            else
            {
                time_id = [[NSNumber numberWithLong:(time+60*_fastest_pick_up_time_min + 60*30-(time +60*_fastest_pick_up_time_min)%(60*30))]stringValue];
            }
//            NSString  *time_id = [[NSNumber numberWithLong:(time+60*_fastest_pick_up_time_min + 60*30-(time +60*_fastest_pick_up_time_min)%(60*30))]stringValue];
//            NSString  *time_id = [[NSNumber numberWithLong:(time+3600*fastest_pick_up_time+60*30-time%(60*30))] stringValue];
            NSDate * defaultDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:time_id]];
            NSDate * firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:[[NSNumber numberWithLong:time]stringValue]]];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:[time_id longLongValue]]];
            
            NSString *_dayNum=@"";
            switch ([comps weekday]) {
                case 1:{
                    _dayNum=@"日";
                    break;
                }
                case 2:{
                    _dayNum=@"一";
                    break;
                }
                case 3:{
                    _dayNum=@"二";
                    break;
                }
                case 4:{
                    _dayNum=@"三";
                    break;
                }
                case 5:{
                    _dayNum=@"四";
                    break;
                }
                case 6:{
                    _dayNum=@"五";
                    break;
                }
                case 7:{
                    _dayNum=@"六";
                    break;
                }
                default:
                    break;
            }
            
            
            //时间显示格式调整
            NSDateFormatter *showDateFormatter = [[NSDateFormatter alloc] init];
            [showDateFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSDateFormatter *showDayFormatter = [[NSDateFormatter alloc] init];
            [showDayFormatter setDateFormat:@"yyyyMMdd"];

            _dateArray = [[NSMutableArray alloc]init];
//            _defaultDate = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)[comps year],(long)[comps month],(long)[comps day]];
            _defaultDate = [showDateFormatter stringFromDate:[defaultDay dateByAddingTimeInterval:0]];
            /*年月日数组生成方法*/
            NSTimeInterval secondsPerDay = 24 * 60 * 60;
            
            NSDateFormatter *storeDateFormatter = [[NSDateFormatter alloc] init];
            [storeDateFormatter setDateFormat:@"yyyy-MM-dd"];

            if ([comps day] == [[pickUpTimeEntity.date substringWithRange:NSMakeRange(8, 2)] integerValue]) {
                _select_days = _support_days;
            }else{
                if ([comps month] == [[pickUpTimeEntity.date substringWithRange:NSMakeRange(5, 2)] integerValue]) {
                    _select_days = _support_days - ([comps day] - [[pickUpTimeEntity.date substringWithRange:NSMakeRange(8, 2)] integerValue]);
                }else{
                    NSInteger days = 0;
                    NSInteger month = [[pickUpTimeEntity.date substringWithRange:NSMakeRange(5, 2)] integerValue];
                    if (month == 1 || month == 3 ||month == 5 || month == 7 ||month == 8 || month == 10 ||month == 12 ) {
                        days = 31;
                    }else if (month == 4 || month == 6 ||month == 9 || month == 11){
                        days = 30;
                    }else{
                        if (([comps year] %4 ==0 && [comps year] %100 !=0) || [comps year] %400 ==0 ) {
                            days = 29;
                        }else{
                            days = 28;
                        }
                    }
                    _select_days = _support_days - (days + [comps day] - [[pickUpTimeEntity.date substringWithRange:NSMakeRange(8, 2)] integerValue]);
                    
                }
            }
            if (_select_days < 0) {
                _select_days = 0;
            }

            //可选时间
            if ([comps minute]== 0) {
                _selectTime = [NSString stringWithFormat:@"%ld:%ld0",(long)[comps hour], (long)[comps minute]];
            }else{
                _selectTime = [NSString stringWithFormat:@"%ld:%ld",(long)[comps hour], (long)[comps minute]];
            }

 
            //七天显示时间计算
            if ([comps hour]>_endHour || (([comps hour]==_endHour) && ([comps minute]>[[end_time objectAtIndex:1] integerValue]))) {//不在自提时间内,结束时间-->24
                if (_support_days <= 4)
                {
                    for (int i = -3 ; i < 4; i ++ )
                    {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i *secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time = [NSString stringWithFormat:@"%@ %@",[ymdArray objectAtIndex:0],[_hourMinuteArray objectAtIndex:0]];
                        _time_id = [PublicMethod NSStringToNSDate:_time];
                    }

                }else if(_support_days <=7 &&_support_days >4){
                    for (NSInteger i = _support_days-7  ; i < _support_days; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }
                    
                }else{
                    for (int i = 0 ; i < 7; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }
                }
                
            } else if (([comps hour]<_startHour) || (([comps hour]==_startHour) && ([comps minute]<[[start_time objectAtIndex:1] integerValue]))) {//不在自提时间内,0-->开始时间
                if (_support_days <=4) {
                    for (int i = -3 ; i < 4; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:(i+1) * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time = [NSString stringWithFormat:@"%@ %@",[ymdArray objectAtIndex:0],[_hourMinuteArray objectAtIndex:0]];
                        _time_id = [PublicMethod NSStringToNSDate:_time];
                    }

                }else if(_support_days <=7 &&_support_days >4){
                    for (NSInteger i = _support_days-7  ; i < _support_days; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i *secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }
                    
                }else{
                    for (int i = 0 ; i < 7; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }
                }

                
            } else {
                if(_support_days <= 4){
                    for (int i = -3 ; i < 4; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i *secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }

                }else if(_support_days <=7 &&_support_days >4){
                    for (NSInteger i = _support_days-7  ; i < _support_days; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }

                }else{
                    for (int i = 0 ; i < 7; i ++ ) {
                        NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
                        NSString * weekDayString = [self weekDay:i*secondsPerDay];
                        [_sevenDayArray addObject:[dayString substringFromIndex:6]];
                        [_sevenWeekDayArray addObject:weekDayString];
                        NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        if (i == 0) {
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
                        }else if(i == 1){
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
                        }else{
                            [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@",dateS,weekDayString]];
                        }
                    }
                    for (int i = 0; i < _support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                        NSString * dayString = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [_dateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dayString,_dayNum]];
                    }
                    
                    if ([ymdArray count]>0) {
                        _time= [PublicMethod timeStampConvertToFullTime:time_id];
                        _time_id = time_id;
                    }
                }
                
                
            }

            
            dispatch_async(dispatch_get_main_queue(), ^{
                _timeLabel.text = [self defaultTime:_selectTime];
                [tableview reloadData];
            });
            
        });
        
        
        
        
    }
}
- (NSString *)weekDay:(double)timeInterval{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
    
    NSString *_dayNum=@"";
    switch ([comps weekday]) {
        case 1:{
            _dayNum=@"日";
            break;
        }
        case 2:{
            _dayNum=@"一";
            break;
        }
        case 3:{
            _dayNum=@"二";
            break;
        }
        case 4:{
            _dayNum=@"三";
            break;
        }
        case 5:{
            _dayNum=@"四";
            break;
        }
        case 6:{
            _dayNum=@"五";
            break;
        }
        case 7:{
            _dayNum=@"六";
            break;
        }
        default:
            break;
    }
    return _dayNum;
}
@end
