//
//  YHApplyReturnGoodsViewDeliveredController.m
//  YHCustomer
//
//  Created by kongbo on 14-5-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  已提货状态，申请退货界面

#import "YHApplyReturnGoodsViewDeliveredController.h"
#import "YHGoodsReturnViewController.h"
#import "MyPickerView.h"
#import "ReturnEntity.h"
#import "OrderAddressEntity.h"
#import "AddNewAddressViewController.h"
#import "AddressesManagerViewController.h"
#import "UserUploadImageEntity.h"
#import "YHReturnImageViewController.h"

@interface YHApplyReturnGoodsViewDeliveredController ()

@end

@implementation YHApplyReturnGoodsViewDeliveredController
@synthesize returnGoodsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        refreshUI = NO;
        pickView = [[MyPickerView alloc] init];
        pickView.target = self;
        arrAddress = [NSMutableArray array];
        returns_goods_images_array = [NSMutableArray array];
        returns_goods_images_url_array = [NSMutableArray array];
        store_name = @"办理门店:";
        store_add = @"门店地址:";
        returns_method = @"1";
    }
    return self;
}

#pragma mark --------------------------生命周期
-(void)loadView
{
    [super loadView];
    self.navigationItem.title = @"申请退货";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    [[PSNetTrans getInstance] API_order_address_list_func:self goods_id:nil];
    
    // 退货商品列表
    [[PSNetTrans getInstance] ps_returnGoodsList:self OrderListId:orderEntity.order_list_id];
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
    
    if ([payMethod isEqualToString:@"100"])
    {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,661+49+30);
    } else {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,661+70+110);
    }
    [scrollView setScrollEnabled:YES];
    [scrollView setShowsVerticalScrollIndicator:YES];
    scrollView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [self.view addSubview:scrollView];
    
    //订单相关
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
    
    [self addReturnGoodsView];
    [self addReturnReasonView];
    
    if ([payMethod isEqualToString:@"200"]) {
        [self addAlixPayView];
    } else {
        //        [self addUPPayView];
    }
    
    [self addReturnMethodView];
    
    //提交按钮
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.tag = 102;
    submitBtn.frame = CGRectMake(10, bg5.bottom+10, 300, 40);
    [submitBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0]];
    [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitBtn];
}

-(void)addReturnGoodsView {
    //退货商品
    bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 10+78+10, 320, 35)];
    bg2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg2];
    
    UILabel *label = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"请选择退货商品" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg2 addSubview:label];
    
    UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(300,8.5, 15, 18)];
    accessImg.userInteractionEnabled = YES;
    accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
    [bg2 addSubview:accessImg];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnGoodsList)];
    [bg2 addGestureRecognizer:ges];
}

-(void)addReturnReasonView {
    //退货原因
    bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, bg2.bottom+10, 320, 94)];
    bg3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg3];
    
    UILabel *label3 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退货原因" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg3 addSubview:label3];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, label3.bottom+10, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg3 addSubview:line2];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, line2.bottom+10, 300, 39);
    [btn setBackgroundImage:[UIImage imageNamed:@"return_btn_bg"] forState:UIControlStateNormal];
    [btn setTitle:@" 请选择退货原因" forState:UIControlStateNormal];
    btn.tag = 100;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    btn.layer.borderWidth = 0.5;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bg3 addSubview:btn];
    
    returnReason = [[UITextField alloc]initWithFrame:CGRectMake(10, 94, 300, 39)];
    [returnReason setLeftSpace:5];
    returnReason.returnKeyType = UIReturnKeyDone;
    returnReason.placeholder = @"请输入退货原因";
    returnReason.font = [UIFont systemFontOfSize:15.0];
    returnReason.layer.borderWidth = 1;
    returnReason.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    returnReason.delegate = self;
    [returnReason setHidden:YES];
    [returnReason setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [bg3 addSubview:returnReason];
    
    returnInfo = [[UITextField alloc]initWithFrame:CGRectMake(10, 94, 300, 39)];
    [returnInfo setLeftSpace:5];
    returnInfo.returnKeyType = UIReturnKeyDone;
    returnInfo.placeholder = @"退货说明（限140个字）";
    returnInfo.font = [UIFont systemFontOfSize:15.0];
    returnInfo.layer.borderWidth = 1;
    returnInfo.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    returnInfo.delegate = self;
    [returnInfo setHidden:YES];
    [returnInfo setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [bg3 addSubview:returnInfo];
    
    uploadBg = [[UIView alloc]initWithFrame:CGRectMake(0, btn.bottom+10, SCREEN_WIDTH, 110)];
    uploadBg.backgroundColor = [UIColor whiteColor];
    [uploadBg setHidden:YES];
    [bg3 addSubview:uploadBg];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line3.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [uploadBg addSubview:line3];
    UILabel *label4 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 12) setTitle:@"请上传商品图片" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
    [uploadBg addSubview:label4];
    imageCount = [PublicMethod addLabel:CGRectMake(80, 10, 230, 12) setTitle:@"" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
    imageCount.textAlignment = NSTextAlignmentRight;
    [uploadBg addSubview:imageCount];
    
    uploadView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, label4.bottom+18, SCREEN_WIDTH, 40)];
    uploadView.showsHorizontalScrollIndicator = NO;
    [uploadBg addSubview:uploadView];
    
    addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    [addBtn setImage:[UIImage imageNamed:@"add_good_pic_btn"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"add_good_pic_btn_selected"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(changeUserIconInfoImage) forControlEvents:UIControlEventTouchUpInside];
    [uploadView addSubview:addBtn];
    
    UILabel *tip = [PublicMethod addLabel:CGRectMake(10, uploadView.bottom+10, 200, 10) setTitle:@"小提示:每个商品需上传1-3张图片!" setBackColor:[PublicMethod colorWithHexValue:0x666666 alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    [uploadBg addSubview:tip];
}

-(void)addAlixPayView {
    bg4 = [[UIView alloc]initWithFrame:CGRectMake(0, bg3.bottom+10, 320, 143)];
    bg4.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg4];
    UILabel *label = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退款账号信息" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg4 addSubview:label];
    UILabel *labelDet = [PublicMethod addLabel:CGRectMake(30, 10, 280, 15) setTitle:@"支付宝" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    labelDet.textAlignment = NSTextAlignmentRight;
    [bg4 addSubview:labelDet];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+10, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg4 addSubview:line2];
    name = [[UITextField alloc]initWithFrame:CGRectMake(10, line2.bottom+10, 300, 39)];
    [name setLeftSpace:5];
    name.returnKeyType = UIReturnKeyDone;
    name.placeholder = @"姓名";
    name.font = [UIFont systemFontOfSize:15.0];
    name.layer.borderWidth = 1;
    name.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    name.delegate = self;
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg4 addSubview:name];
    accout = [[UITextField alloc]initWithFrame:CGRectMake(10, name.bottom+10, 300, 39)];
    [accout setLeftSpace:5];
    accout.returnKeyType = UIReturnKeyDone;
    accout.placeholder = @"账号";
    accout.font = [UIFont systemFontOfSize:15.0];
    accout.layer.borderWidth = 1;
    accout.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    accout.delegate = self;
    accout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg4 addSubview:accout];
}

-(void)addUPPayView {
    bg4 = [[UIView alloc]initWithFrame:CGRectMake(0, bg3.bottom+10, 320, 143+49)];
    bg4.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg4];
    UILabel *label = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退款帐号信息" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg4 addSubview:label];
    UILabel *labelDet = [PublicMethod addLabel:CGRectMake(30, 10, 280, 15) setTitle:@"银联" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    labelDet.textAlignment = NSTextAlignmentRight;
    [bg4 addSubview:labelDet];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+10, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg4 addSubview:line2];
    name = [[UITextField alloc]initWithFrame:CGRectMake(10, line2.bottom+10, 300, 39)];
    [name setLeftSpace:5];
    name.returnKeyType = UIReturnKeyDone;
    name.placeholder = @"开户人";
    name.font = [UIFont systemFontOfSize:15.0];
    name.layer.borderWidth = 1;
    name.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    name.delegate = self;
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg4 addSubview:name];
    bank = [[UITextField alloc]initWithFrame:CGRectMake(10, name.bottom+10, 300, 39)];
    [bank setLeftSpace:5];
    bank.returnKeyType = UIReturnKeyDone;
    bank.placeholder = @"开户行";
    bank.font = [UIFont systemFontOfSize:15.0];
    bank.layer.borderWidth = 1;
    bank.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    bank.delegate = self;
    bank.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg4 addSubview:bank];
    accout = [[UITextField alloc]initWithFrame:CGRectMake(10, bank.bottom+10, 300, 39)];
    [accout setLeftSpace:5];
    accout.returnKeyType = UIReturnKeyDone;
    accout.placeholder = @"银行卡号";
    accout.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    accout.font = [UIFont systemFontOfSize:15.0];
    accout.layer.borderWidth = 1;
    accout.layer.borderColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0].CGColor;
    accout.delegate = self;
    accout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bg4 addSubview:accout];
}

-(void)addReturnMethodView {
    //退货方式
    if (bg4) {
        bg5 = [[UIView alloc]initWithFrame:CGRectMake(0, bg4.bottom+10, 320, 94+73)];
    } else {
        bg5 = [[UIView alloc]initWithFrame:CGRectMake(0, bg3.bottom+10, 320, 94+73)];
    }
    
    bg5.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg5];
    UILabel *label5 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退货方式" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
    [bg5 addSubview:label5];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, label5.bottom+10, SCREEN_WIDTH, 1)];
    line5.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
    [bg5 addSubview:line5];
    returnMethodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnMethodBtn.tag = 101;
    returnMethodBtn.frame = CGRectMake(10, line5.bottom+10, 300, 39);
    [returnMethodBtn setBackgroundImage:[UIImage imageNamed:@"return_btn_bg"] forState:UIControlStateNormal];
    [returnMethodBtn setTitle:@" 送货到门店" forState:UIControlStateNormal];
    returnMethodBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    returnMethodBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [returnMethodBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [returnMethodBtn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    returnMethodBtn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    returnMethodBtn.layer.borderWidth = 0.5;
    [returnMethodBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bg5 addSubview:returnMethodBtn];
    yellowBg = [[UIView alloc]initWithFrame:CGRectMake(0, returnMethodBtn.bottom+10, 320, 73)];
    yellowBg.userInteractionEnabled = NO;
    yellowBg.backgroundColor = [PublicMethod colorWithHexValue:0xfcfee2 alpha:1.0];
    [bg5 addSubview:yellowBg];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressAction)];
    [yellowBg addGestureRecognizer:ges];
    top = [PublicMethod addLabel:CGRectMake(10, 10, 300, 14) setTitle:@"办理门店:" setBackColor:[PublicMethod colorWithHexValue:0x666666 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
    [yellowBg addSubview:top];
    mid = [PublicMethod addLabel:CGRectMake(10, top.bottom+7, 300, 14) setTitle:@"门店地址:" setBackColor:[PublicMethod colorWithHexValue:0x666666 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
    mid.numberOfLines = 1;
    [yellowBg addSubview:mid];
    bottom = [PublicMethod addLabel:CGRectMake(10, mid.bottom+7, 300, 14) setTitle:@"ffffff" setBackColor:[PublicMethod colorWithHexValue:0x666666 alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
    [bottom setHidden:YES];
    bottom.numberOfLines = 1;
    [yellowBg addSubview:bottom];
    
    returnMethodAcess = [[UIImageView alloc] initWithFrame:CGRectMake(300,27.5, 15, 18)];
    returnMethodAcess.userInteractionEnabled = YES;
    [returnMethodAcess setHidden:YES];
    returnMethodAcess.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
    [yellowBg addSubview:returnMethodAcess];
    
}

#pragma mark ---------------- data
-(void)setData:(MyOrderEntity *)entity {
    orderEntity = entity;
    payMethod = entity.pay_method;
    [self addUI];
    [[PSNetTrans getInstance]order_return_store:self order_list_id:orderEntity.order_list_id];
    [[PSNetTrans getInstance]order_return_reason:self order_state:@"2"];
    [[PSNetTrans getInstance]order_return_method:self];
}

#pragma mark ------------------  action
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteAction:(UILongPressGestureRecognizer *)ges {
    YHReturnImageViewController *imageVC = [[YHReturnImageViewController alloc]init];
    imageVC.url = [returns_goods_images_url_array objectAtIndex:ges.view.tag];
    imageVC.tag = ges.view.tag;
    imageVC.block = ^(NSInteger tag){
        [uploadView removeAllSubviews];
        [returns_goods_images_array removeObjectAtIndex:tag];
        [returns_goods_images_url_array removeObjectAtIndex:tag];
        
        if ([returns_goods_images_url_array count] == 0) {
            imageCount.text = @"";
        }else {
            imageCount.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)[returns_goods_images_url_array count]];
        }
        
        for (int i = 0; i<[returns_goods_images_url_array count]; i++) {
            UIImageView *addImg = [[UIImageView alloc]initWithFrame:CGRectMake(10+50*i, addBtn.top, 40, 40)];
            addImg.userInteractionEnabled = YES;
            addImg.tag = [returns_goods_images_url_array count]-1;
            [addImg setImageWithURL:[NSURL URLWithString:[returns_goods_images_url_array objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"goods_default"]];
            [uploadView addSubview:addImg];
            
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAction:)];
            [addImg addGestureRecognizer:ges];
            
            
            if ([[uploadView subviews] count]>6) {
                uploadView.contentSize = CGSizeMake([[uploadView subviews] count]*50, 40);
            }
        }
        
        addBtn.frame = CGRectMake(50*[returns_goods_images_array count]+10, addBtn.top, 40, 40);
        [uploadView addSubview:addBtn];
        
    };
    [self.navigationController pushViewController:imageVC animated:YES];
}

-(void)changeUserIconInfoImage
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSLog(@"user info icon click");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"从相册获取", nil];
    [actionSheet showInView:self.view];
    
}

- (void)showImagePicker:(NSNumber*)sourceType
{
    //sourceType=0相机，1相册
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    [imagepicker setDelegate:self];
    [imagepicker setAllowsEditing:YES];
    [imagepicker setSourceType:[sourceType intValue]];
    [self presentViewController:imagepicker animated:NO completion:nil];
}

-(void)addressAction {
    if ([arrAddress count]== 0) {
        AddNewAddressViewController *addVC = [[AddNewAddressViewController alloc]init];
        addVC._isNewOrEdit= YES;
        addVC.block = ^(id param){
            [[PSNetTrans getInstance] API_order_address_list_func:self goods_id:nil];
            refreshUI = YES;
        };
        [self.navigationController pushViewController:addVC animated:YES];
    } else {
        AddressesManagerViewController *address = [[AddressesManagerViewController alloc] init];
        [address setNavTitle:@"请选择取货地址"];
        address.entityID = _order_address_id;
        address.addressDefaultCallBack = ^(OrderAddressEntity *addEntity,NSMutableArray *addressArray){
            
            
            _logistics_address = addEntity.logistics_address;
            _logistics_area_name = addEntity.logistics_area_name;
            _name = addEntity.true_name;
            _tel = addEntity.mobile;
            _order_address_id = addEntity.ID;
            arrAddress = addressArray;
            
            //UI
            top.text = [NSString stringWithFormat:@"%@ %@",_name,_tel];//姓名和电话
            mid.text = _logistics_area_name;//区域地址
            bottom.text = _logistics_address;//详细地址
            if (!addEntity) {
                top.text = @"";//姓名和电话
                if ([arrAddress count]==0) {
                    mid.text = @"请新建取货地址";
                } else {
                    mid.text = @"请选择取货地址";
                }
                bottom.text = @"";//详细地址
            }
        };
        [self.navigationController pushViewController:address animated:YES];
    }
}

/**
 * 退货商品列表
 */
-(void)returnGoodsList {
    YHGoodsReturnViewController *tuihuo = [[YHGoodsReturnViewController alloc] init];
    tuihuo.returnBlock=^(NSMutableArray *returnArray,NSString *totalReturnNum){
        self.returnGoodsArray = returnArray;
        NSLog(@"returnArray :%@ totalReturnNum %@",returnArray,totalReturnNum);
        if ([returnArray count]>0) {
            [bg2 removeAllSubviews];
            bg2.frame = CGRectMake(0, 10+78+10, 320, 90);
            UILabel *label2 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退货商品" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
            [bg2 addSubview:label2];
            UILabel *count = [PublicMethod addLabel:CGRectMake(100, 10, 210, 15) setTitle:[NSString stringWithFormat:@"共%@个商品",totalReturnNum] setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
            count.textAlignment = NSTextAlignmentRight;
            [bg2 addSubview:count];
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom+10, SCREEN_WIDTH, 1)];
            line1.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
            [bg2 addSubview:line1];
            UIImageView *accessImg = [[UIImageView alloc] initWithFrame:CGRectMake(300,line1.bottom+ 21, 15, 18)];
            accessImg.userInteractionEnabled = YES;
            accessImg.image = [UIImage imageNamed:@"cart_myOrderAccess.png"];
            [bg2 addSubview:accessImg];
            
            //挪动坐标
            bg3.frame = CGRectMake(0, bg2.bottom+10, 320, bg3.height);
            if ([payMethod isEqualToString:@"100"]) {
                bg4.frame = CGRectMake(0, bg3.bottom+10, 320, 143+49);
            } else {
                bg4.frame = CGRectMake(0, bg3.bottom+10, 320, 143);
            }
            if (bg4) {
                bg5.frame = CGRectMake(0, bg4.bottom+10, 320, 94+73);
            } else {
                bg5.frame = CGRectMake(0, bg3.bottom+10, 320, 94+73);
            }
            
            submitBtn.frame = CGRectMake(10, bg5.bottom+10, 300, 40);
            
            goods_info = @"";
        }
        for (int i=0; i<[returnArray count]; i++) {
            NSMutableDictionary *dic = [returnArray objectAtIndex:i];
            if ((!goods_info) || goods_info.length==0) {
                goods_info = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"bu_goods_code"],[dic objectForKey:@"goods_num"]];
            } else {
                goods_info = [NSString stringWithFormat:@"%@,%@:%@",goods_info,[dic objectForKey:@"bu_goods_code"],[dic objectForKey:@"goods_num"]];
            }
            
            if (i<3) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*50, 45, 35, 35)];
                image.layer.borderWidth = 1.0;
                image.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                [image setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"goods_default"]];
                [bg2 addSubview:image];
                
                if ([returnArray count]==1) {
                    //商品标题
                    UILabel *title = [PublicMethod addLabel:CGRectMake(60, 45, 250, 30) setTitle:[dic objectForKey:@"goods_name"] setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
                    title.lineBreakMode = NSLineBreakByWordWrapping;
                    title.numberOfLines = 0;
                    [bg2 addSubview:title];
                }
            }
            
            
            if (i==2) {
                if ([returnArray count]>3) {
                    UILabel *pointLabel = [PublicMethod addLabel:CGRectMake(160, 45, 70, 15) setTitle:@"..." setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:16]];
                    [bg2 addSubview:pointLabel];
                }
            }
        }
    };
    tuihuo.cartArray = _listEntity.goodsArray;
    if (self.returnGoodsArray.count > 0) {
        tuihuo.selectAllArray = self.returnGoodsArray;// 标记已经退货的商品－到下一级页面时候显示用到
    }
    [self.navigationController pushViewController:tuihuo animated:YES];
}
-(void)btnAction:(UIButton *)button {
    if (button.tag == 100)
    {//退货原因
        if ([reasonArray count]>0)
        {
            NSMutableArray *array = [NSMutableArray array];
            for (ReasonEntity *reasonEntity in reasonArray)
            {
                [array addObject:reasonEntity.reason_name];
            }
            
            [pickView initWithPickerData:array
                           MyPickerBlock:^(NSString *selectRow)
            {
                               NSString *selectRow_code = @"";
                               for (ReasonEntity *reasonEntity in reasonArray)
                               {
                                   if ([reasonEntity.reason_name isEqualToString:selectRow])
                                   {
                                       selectRow_code = reasonEntity.reason_code;
                                       break;
                                   }
                               }
                               if (![selectRow_code isEqualToString:@"3"])
                               {//7天无理由退货
                                   if ([selectRow_code isEqualToString:@"8"])
                                   {//其它原因
                                       bg3.height = 94+49+110+49;
                                       [returnReason setHidden:NO];
                                       [returnInfo setHidden:NO];
                                       [uploadBg setHidden:NO];
                                       returnInfo.frame = CGRectMake(10, returnReason.bottom+10, 300, 39);
                                       uploadBg.frame = CGRectMake(0, returnInfo.bottom+10, SCREEN_WIDTH, 110);
                                       
                                       bg4.frame = CGRectMake(0, bg3.bottom+10, 320, bg4.height);
                                       if (bg4)
                                       {
                                           bg5.frame = CGRectMake(0, bg4.bottom+10, 320, bg5.height);
                                       }
                                       else
                                       {
                                           bg5.frame = CGRectMake(0, bg3.bottom+10, 320, bg5.height);
                                       }
                                       
                                       submitBtn.frame = CGRectMake(10, bg5.bottom+10, 300, 40);
                                       CGFloat height = scrollView.contentSize.height+ 50;
                                       scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
                                   }
                                   else
                                   {
                                       bg3.height = 94+110+49;
                                       [returnReason setHidden:YES];
                                       [returnInfo setHidden:NO];
                                       [uploadBg setHidden:NO];
                                       returnInfo.frame = CGRectMake(10, 94, 300, 39);
                                       uploadBg.frame = CGRectMake(0, returnInfo.bottom+10, SCREEN_WIDTH, 110);
                                       bg4.frame = CGRectMake(0, bg3.bottom+10, 320, bg4.height);
                                       if (bg4)
                                       {
                                           bg5.frame = CGRectMake(0, bg4.bottom+10, 320, bg5.height);
                                       }
                                       else
                                       {
                                           bg5.frame = CGRectMake(0, bg3.bottom+10, 320, bg5.height);
                                       }
                                       
                                       submitBtn.frame = CGRectMake(10, bg5.bottom+10, 300, 40);
                                   }
                               }
                               else
                               {
                                   bg3.height = 94;
                                   [returnInfo setHidden:YES];
                                   [returnReason setHidden:YES];
                                   [uploadBg setHidden:YES];
                                   bg4.frame = CGRectMake(0, bg3.bottom+10, 320, bg4.height);
                                   if (bg4)
                                   {
                                       bg5.frame = CGRectMake(0, bg4.bottom+10, 320, bg5.height);
                                   }
                                   else
                                   {
                                       bg5.frame = CGRectMake(0, bg3.bottom+10, 320, bg5.height);
                                   }
                                   submitBtn.frame = CGRectMake(10, bg5.bottom+10, 300, 40);
                               }
                               [btn setTitle:[NSString stringWithFormat:@" %@",selectRow] forState:UIControlStateNormal];
                               reason_name = selectRow;
                               reason_code = selectRow_code;
                               
                           }];
        }
        else
        {
            [[PSNetTrans getInstance]order_return_reason:self order_state:@"2"];
        }
        
    }
    else if (button.tag == 101)
    {//退货方式
        if ([returnMethodArray count]>0)
        {
            pickView = [[MyPickerView alloc] init];
            pickView.target = self;
            [pickView initWithPickerData:returnMethodArray MyPickerBlock:^(NSString *selectRow) {
                if ([selectRow isEqualToString:@"送货到门店"]) {
                    top.text = [NSString stringWithFormat:@"办理门店:%@",store_name];
                    mid.text = [NSString stringWithFormat:@"门店地址:%@",store_add];
                    [bottom setHidden:YES];
                    [returnMethodAcess setHidden:YES];
                    yellowBg.userInteractionEnabled = NO;
                    returns_method = @"1";
                } else if ([selectRow isEqualToString:@"上门取货"]) {
                    if (_name.length>0) {
                        top.text = [NSString stringWithFormat:@"%@ %@",_name,_tel];//姓名和电话
                        mid.text = _logistics_area_name;//区域地址
                        bottom.text = _logistics_address;//详细地址
                    } else {
                        top.text = @"";
                        if ([arrAddress count]==0) {
                            mid.text = @"请新建取货地址";
                        } else {
                            mid.text = @"请选择取货地址";
                        }
                        bottom.text = @"";
                    }
                    
                    [bottom setHidden:NO];
                    [returnMethodAcess setHidden:NO];
                    yellowBg.userInteractionEnabled = YES;
                    returns_method = @"2";
                } else if ([selectRow isEqualToString:@"快递送货"]) {
                    top.text = [NSString stringWithFormat:@"办理门店:%@",store_name];
                    mid.text = [NSString stringWithFormat:@"门店地址:%@",store_add];
                    [bottom setHidden:YES];
                    [returnMethodAcess setHidden:YES];
                    yellowBg.userInteractionEnabled = NO;
                    returns_method = @"3";
                }
                [returnMethodBtn setTitle:selectRow forState:UIControlStateNormal];
            }];
            
        }
        else
        {
            [[PSNetTrans getInstance]order_return_method:self];
        }
        
    }
    else if (button.tag == 102)
    {//提交
        if (goods_info.length == 0) {
            [[iToast makeText:@"请选择退货商品"] show];
            return;
        }
        if (reason_code.length == 0) {
            [[iToast makeText:@"请选择退货原因"] show];
            return;
        }
        if (![returnReason isHidden]) {
            reason_name = returnReason.text;
            if (reason_name.length == 0) {
                [[iToast makeText:@"请输入退货原因"] show];
                return;
            }
        }
        
        if (![returnInfo isHidden]) {
            reason_info = returnInfo.text;
            if (reason_info.length==0) {
                [[iToast makeText:@"请输入退货说明"] show];
                return;
            } else if (reason_info.length>140) {
                [[iToast makeText:@"退货说明不能超过140个字"] show];
                return;
            }
        } else {
            reason_info = nil;
        }
        
        //上传图片拼接
        if ([returns_goods_images_array count]>=1) {
            returns_goods_images = [returns_goods_images_array objectAtIndex:0];
            for (int i=1; i<[returns_goods_images_array count]; i++) {
                returns_goods_images = [NSString stringWithFormat:@"%@,%@",returns_goods_images,[returns_goods_images_array objectAtIndex:i]];
            }
        }
        if (![reason_code isEqualToString:@"3"]) {//7天无理由退货
            if (returns_goods_images.length == 0) {
                [[iToast makeText:@"请上传退货商品图片"] show];
                return;
            }
        }
        
        if ([payMethod isEqualToString:@"100"]) {
            //            if (returns_name.length == 0) {
            //                [[iToast makeText:@"请输入开户人"] show];
            //                return;
            //            }
            //            if (returns_account.length == 0) {
            //                [[iToast makeText:@"请输入开户行"] show];
            //                return;
            //            }
            //            if (returns_card_num.length == 0) {
            //                [[iToast makeText:@"请输入银行卡号"] show];
            //                return;
            //            }
        }else if([payMethod isEqualToString:@"250"]){
            
        }else{
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
            returns_card_num = nil;
        }
        
        if (returns_method.length == 0) {
            [[iToast makeText:@"请选择退货方式"] show];
            return;
        }
        if ([returns_method isEqualToString:@"2"]) {
            if (_name.length == 0) {
                [[iToast makeText:@"请选择上门取货地址"] show];
                return;
            }
        }
        // 再次请求退货商品列表－和之前第一次请求的退货商品进行较艳，如果又商品过期则优先提示
        [[PSNetTrans getInstance] ps_returnGoodsList:self OrderListId:orderEntity.order_list_id];
    }
}

- (void)submitAction{
 
    [[PSNetTrans getInstance]apply_return_goods_delivered:self
                                            order_list_id:orderEntity.order_list_id
                                              reason_code:reason_code
                                              reason_name:reason_name
                                             returns_name:returns_name
                                          returns_account:returns_account
                                              reason_info:reason_info
                                               goods_info:goods_info
                                     returns_goods_images:returns_goods_images
                                         returns_card_num:returns_card_num
                                           returns_method:returns_method
                                               store_name:store_name
                                            store_address:store_add
                                                user_name:_name
                                                 user_tel:_tel
                                           logistics_area:_logistics_area_name
                                        logistics_address:_logistics_address order_address_id:_order_address_id];
}


#pragma mark –-------------------------UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypeCamera]];
    }
    if (buttonIndex == 1) {
        //相册选择
        [self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypePhotoLibrary]];
    }
}

#pragma mark –-------------------------Camera View Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        [picker dismissViewControllerAnimated:NO completion:nil];
        
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        originImage = [PublicMethod imageWithImageSimple:originImage scaledToSize:CGSizeMake(640, originImage.size.height*640.0/originImage.size.width)];
        [PublicMethod saveImage:originImage WithName:@"userImage.jpg"];
        
        //imageV.image = originImage;
        
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userImage.jpg"];
        NSFileManager *fileMag = [NSFileManager defaultManager];
        if ([fileMag fileExistsAtPath:filePath])
        {
            [[NetTrans getInstance] user_upLoadImage:self Type:@"upload" Image:filePath];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark --------------  UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([payMethod isEqualToString:@"100"]) {
        returns_name = name.text;
        returns_account = bank.text;
        returns_card_num = accout.text;
        if (![returnReason isHidden]) {
            reason_name = returnReason.text;
        }
        if (![returnInfo isHidden]) {
            reason_info = returnInfo.text;
        }
    } else {
        returns_name = name.text;
        returns_account = accout.text;
        if (![returnReason isHidden]) {
            reason_name = returnReason.text;
        }
        if (![returnInfo isHidden]) {
            reason_info = returnInfo.text;
        }
    }
    CGRect rect = [textField convertRect:textField.bounds toView:self.view];
    [scrollView setContentOffset:CGPointMake(0, rect.origin.y+scrollView.contentOffset.y-40) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([payMethod isEqualToString:@"100"]) {
        returns_name = name.text;
        returns_account = bank.text;
        returns_card_num = accout.text;
    } else {
        returns_name = name.text;
        returns_account = accout.text;
    }
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ---------------- net

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (T_API_ORDER_RETURN_REASON == nTag)
    {
        reasonArray = (NSMutableArray *)netTransObj;
    }
    else if (T_API_ORDER_RETURN_METHOD == nTag)
    {
        NSArray *array = (NSArray *)netTransObj;
        returnMethodArray = [NSMutableArray array];
        for (ReturnMethod *returnMethod in array) {
            [returnMethodArray addObject:returnMethod.name];
        }
        
    }
    else if (T_API_ORDER_RETURN_STORE == nTag)
    {
        ReturnStoreEntity *returnStoreEntityty = (ReturnStoreEntity *)netTransObj;
        top.text = [NSString stringWithFormat:@"办理门店:%@",returnStoreEntityty.store_name];
        mid.text = [NSString stringWithFormat:@"门店地址:%@",returnStoreEntityty.store_address];
        store_name = returnStoreEntityty.store_name;
        store_add = returnStoreEntityty.store_address;
    }
    else if (t_API_USER_PLATFORM_UPLOAD_IMAGE_API == nTag)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UserUploadImageEntity *useren = (UserUploadImageEntity *)netTransObj;
        [returns_goods_images_array addObject:useren.image_id];
        [returns_goods_images_url_array addObject:useren.image_url];
        imageCount.text = [NSString stringWithFormat:@"已上传%lu张",(unsigned long)[returns_goods_images_array count]];
        
        UIImageView *addImg = [[UIImageView alloc]initWithFrame:CGRectMake(addBtn.left, addBtn.top, 40, 40)];
        addImg.userInteractionEnabled = YES;
        addImg.tag = [returns_goods_images_array count]-1;
        [addImg setImageWithURL:[NSURL URLWithString:useren.image_url] placeholderImage:[UIImage imageNamed:@"goods_default"]];
        [uploadView addSubview:addImg];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAction:)];
        [addImg addGestureRecognizer:ges];
        
        
        if ([[uploadView subviews] count]>6) {
            uploadView.contentSize = CGSizeMake([[uploadView subviews] count]*50, 40);
        }
        addBtn.frame = CGRectMake(addImg.right+10, addImg.top, 40, 40);
    }
    else if (nTag == t_API_PS_RETURN_GOODS_LIST)
    {
        if (_listEntity.goodsArray.count == 0) {
            _listEntity =(GoodsListEntity*)netTransObj;
        }else{
            GoodsListEntity *_listEntity1 =  (GoodsListEntity*)netTransObj;
            NSMutableString *outTimeGoods = [[NSMutableString alloc] init];
            // origin returnGoods
            for (int i= 0; i < _listEntity.goodsArray.count; i ++ ) {
                GoodsEntity *originEntity = [_listEntity.goodsArray objectAtIndex:i];
                // new returnGoods
                BOOL isExsit = NO;
                for (int j = 0; j < _listEntity1.goodsArray.count; j ++) {
                    GoodsEntity *newEntity = [_listEntity1.goodsArray objectAtIndex:j];
                    if ([originEntity.bu_goods_id isEqualToString:newEntity.bu_goods_id]) {
                        isExsit = YES;
                    }
                }
                if (!isExsit) {
                    [outTimeGoods appendString:originEntity.goods_name];
                }
            }
            if (outTimeGoods.length > 0) {
                [self showAlert:outTimeGoods];
                return;
            }else{
                _listEntity=_listEntity1;
                // 提交申请
                [self submitAction];
            }
        }
        
        if ([_listEntity.goodsArray count] == 1)
        {
            GoodsEntity *goodEntity = [_listEntity.goodsArray objectAtIndex:0];
            if ([goodEntity.goodNum isEqualToString:@"1"]) {
                //退货商品
                [bg2 removeAllSubviews];
                bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 10+78+10, 320, 90)];
                bg2.backgroundColor = [UIColor whiteColor];
                [scrollView addSubview:bg2];
                UILabel *label2 = [PublicMethod addLabel:CGRectMake(10, 10, 280, 15) setTitle:@"退货商品" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:15.0]];
                [bg2 addSubview:label2];
                UILabel *count = [PublicMethod addLabel:CGRectMake(100, 10, 210, 15) setTitle:@"共1个商品" setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
                count.textAlignment = NSTextAlignmentRight;
                [bg2 addSubview:count];
                UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.bottom+10, SCREEN_WIDTH, 1)];
                line1.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee  alpha:1.0];
                [bg2 addSubview:line1];
                
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 35, 35)];
                image.layer.borderWidth = 1.0;
                image.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                [image setImageWithURL:[NSURL URLWithString:goodEntity.goods_image] placeholderImage:[UIImage imageNamed:@"goods_default"]];
                [bg2 addSubview:image];
                
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnGoodsList)];
                [bg2 removeGestureRecognizer:ges];
                
                //商品标题
                UILabel *title = [PublicMethod addLabel:CGRectMake(image.right+10, 45, 250, 30) setTitle:goodEntity.goods_name setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:12.0]];
                title.lineBreakMode = NSLineBreakByWordWrapping;
                title.numberOfLines = 0;
                [bg2 addSubview:title];
                
                //挪动坐标
                bg3.frame = CGRectMake(0, bg2.bottom+10, 320, bg3.height);
                if ([payMethod isEqualToString:@"100"]) {
                    bg4.frame = CGRectMake(0, bg3.bottom+10, 320, 143+49);
                } else {
                    bg4.frame = CGRectMake(0, bg3.bottom+10, 320, 143);
                }
                if (bg4) {
                    bg5.frame = CGRectMake(0, bg4.bottom+10, 320, 94+73);
                } else {
                    bg5.frame = CGRectMake(0, bg3.bottom+10, 320, 94+73);
                }
                
                submitBtn.frame = CGRectMake(10, bg5.bottom+10, 300, 40);
                
                goods_info = [NSString stringWithFormat:@"%@:%@",goodEntity.bu_goods_code,goodEntity.goodNum];
            }
        }
    }
    else if (T_API_ORDER_RETURN_SUBMIT == nTag)
    {
        _submitBlock();
        [self.navigationController popViewControllerAnimated:YES ];
        
    }
    else if (t_API_ADDRESS_LIST == nTag)
    {
        NSMutableArray * arrData = (NSMutableArray *)netTransObj;
        [arrAddress removeAllObjects];
        [arrAddress addObjectsFromArray:arrData];
        if (arrAddress != nil)
        {
            if ([arrAddress count]==0)
            {
                _name = nil;
                _tel = nil;
                _logistics_area_name = @"您当前还没有收货地址,请新建收货地址";
                _logistics_address = nil;
                _order_address_id = nil;
            }
            else
            {
                for (OrderAddressEntity *addEntity in arrAddress)
                {
                    if (addEntity.is_default)
                    {
                        _name = addEntity.true_name;
                        _tel = addEntity.mobile;
                        _logistics_area_name = addEntity.logistics_area_name;
                        _logistics_address = addEntity.logistics_address;
                        _order_address_id = addEntity.ID;
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
                    OrderAddressEntity *lastEntity = (OrderAddressEntity *)[arrAddress lastObject];
                    _name = lastEntity.true_name;
                    _tel = lastEntity.mobile;
                    _logistics_area_name = lastEntity.logistics_area_name;
                    _logistics_address = lastEntity.logistics_address;
                    _order_address_id = lastEntity.ID;
                }
                
            }
            if (refreshUI) {
                //UI
                top.text = [NSString stringWithFormat:@"%@ %@",_name,_tel];//姓名和电话
                mid.text = _logistics_area_name;//区域地址
                bottom.text = _logistics_address;//详细地址
                refreshUI = NO;
            }
        }else{
            //        [[iToast makeText:@"数据为空!"] show];
        }
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag ==t_API_USER_PLATFORM_UPLOAD_IMAGE_API)
    {
        if ([status isEqualToString:WEB_STATUS_3]) {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
    }
    else if (nTag == t_API_PS_RETURN_GOODS_LIST)
    {
        if ([status isEqualToString:WEB_STATUS_3]) {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
    }
    else  if (nTag == T_API_ORDER_RETURN_SUBMIT)
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
    else if (nTag == T_API_ORDER_RETURN_STORE)
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
    [[iToast makeText:errMsg] show];
}

@end
