//
//  YHSearchOrderViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-1-18.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  pda快速扫描－搜索

#import "YHSearchOrderViewController.h"
#import "YHQuickScanOrderViewController.h"
#import "YHGoodsDetailViewController.h"
#import "GoodSaoDetailEntity.h"

@interface YHSearchOrderViewController ()

@end

@implementation YHSearchOrderViewController
@synthesize padNumField;
@synthesize saoType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor  whiteColor];
    
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    
    self.navigationItem.title = @"手动输入";
    
    // field
    UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 40)];
    //passwordTxtField.secureTextEntry = YES;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    search.returnKeyType = UIReturnKeySearch;
    search.keyboardType = UIKeyboardTypeNumberPad;
    search.placeholder = @"请输入您的订单号";
    search.textAlignment = NSTextAlignmentCenter;
    //    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    //    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    //    [left addSubview:leftView];
    //    search.leftView = left;
    search.delegate = self;
    search.leftViewMode = UITextFieldViewModeAlways;
    search.layer.borderWidth = 0.5;
    search.layer.borderColor = [UIColor lightGrayColor].CGColor;
    search.layer.cornerRadius = 3;
    [self.view addSubview:search];
    self.padNumField = search;
    
    if (saoType == Sao_Pay)
    {
        search.placeholder = @"请输入您的订单号";
    }
    else
    {
        search.placeholder = @"请输入您的条形码号";
    }
    // 搜素确定按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(20, padNumField.bottom+40, 280, 44);
    [searchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [searchBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn"] forState:UIControlStateNormal];
    //    [searchBtn setBackgroundImage:[UIImage imageNamed:@"dark_gray_btn_selected"] forState:UIControlStateHighlighted];
    [searchBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}

// 确定
- (void)searchAction{
    if (padNumField.text.length != 0)
    {
        //  根据扫瞄结果下单
        if (saoType == Sao_Pay)
        {
            [[NetTrans getInstance] API_ScanQuick:self Order_List_No:padNumField.text coupon_id:nil];
        }
        else
        {
            [[NetTrans getInstance] API_Goods_Saomiao:self Code:padNumField.text];
        }
    }
    else
    {
        [[iToast makeText:@"请输入搜索内容"] show];
    }
}

#pragma -
#pragma -mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchAction];
    return YES;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    
    if (nTag == t_API_SCAN_CODE)
    {
        OrderSubmitEntity *submitOrder = (OrderSubmitEntity *)netTransObj;
        YHQuickScanOrderViewController *quickScan = [[YHQuickScanOrderViewController alloc] init];
        quickScan.submitOrder = submitOrder;
        [self.navigationController pushViewController:quickScan animated:YES];
    }
    else if (nTag == t_API_SAOMIAO)
    {
        GoodSaoDetailEntity *submitOrder = (GoodSaoDetailEntity *)netTransObj;
        if ([submitOrder.is_published isEqualToString:@"0"])
        {
            [self showAlert:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！"];
        }
        else
        {
            YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
            NSString *url = [NSString stringWithFormat:GOODS_DETAIL,submitOrder.good_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            detaiVC.url = url;
            [detaiVC setMainGoodsUrl:url goodsID:submitOrder.good_id];
            [self.navigationController pushViewController:detaiVC animated:YES];
        }
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    if (t_API_SCAN_CODE == nTag)
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
         [[iToast makeText:errMsg]show];
    }
    else if (t_API_SAOMIAO == nTag)
    {
         [[iToast makeText:errMsg]show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
