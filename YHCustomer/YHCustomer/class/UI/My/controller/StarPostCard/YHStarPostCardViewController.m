//
//  YHStarPostCardViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-4-29.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHStarPostCardViewController.h"
#import "YHStarCardRecordViewController.h"
#import "YHStarCardInStructionViewController.h"
#import "AlixPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "StarPostCardEntity.h"
@interface YHStarPostCardViewController ()
{
    NSMutableArray *_buttonArray;
    NSMutableArray *btnCardArray;
    NSMutableArray *payArray;
    UILabel *moneytitle;
    NSString *money;
    UIButton *cardBtn;
    StarPostCardEntity *entity;
    NSInteger idnum;
    
}
@end

@implementation YHStarPostCardViewController
#pragma mark - 初始化
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        if (IOS_VERSION >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        _buttonArray = [[NSMutableArray alloc]init];
        btnCardArray = [[NSMutableArray alloc]init];
        payArray = [[NSMutableArray alloc]init];
    }

    return self;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"购买星级包邮卡";
    [self addNavRightButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back));
    [self addUIData];
    
}
-(void)addUIData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance]API_YH_Star_Post_Card_Goods_List:self];

}
-(void)addNavRightButton
{

    [self setRightBarButton:self Action:@selector(rightRecord) SetImage:nil SelectImg:nil title:@"记录"];

}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - createUI
-(void)createUI
{
    //计算字符串的长度
    NSString *title  = @"请选择您需要购买的星级包邮卡:";
    CGSize size = CGSizeMake(320, 2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    size = [title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, size.width, 30)];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.textColor = [UIColor blackColor];
    headLabel.font = [UIFont fontWithName:@"Arial" size:15];
    headLabel.text = title;
    [self.view addSubview:headLabel];
    
//    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    titleBtn.frame = CGRectMake(headLabel.right + 5, 16, 16, 16);
//    titleBtn.layer.cornerRadius = 8;
//    titleBtn.layer.borderColor = [UIColor redColor].CGColor;
//    titleBtn.layer.borderWidth = 1.0f;
//    [titleBtn setTitle:@"?" forState:UIControlStateNormal];
//    [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:titleBtn];
//    NSArray *titleArray = @[@"三星卡10次",@"五星卡30次",@"七星卡50次"];
    
    for (NSInteger i = 0; i<btnCardArray.count; i++)
    {
        entity = [btnCardArray objectAtIndex:i];
        NSInteger b = i%3;
        NSInteger c = i/3;
        CGFloat btn_width = (SCREEN_WIDTH - 60)/3;
        CGFloat btn_hight = 40;
        CGFloat btn_x = 10 + b*(btn_width + 20);
        CGFloat btn_y = headLabel.bottom + 20 +(btn_hight + 20)*c;
        cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cardBtn.frame = CGRectMake(btn_x, btn_y, btn_width, btn_hight);
        cardBtn.tag = 101+i;
        [cardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cardBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [cardBtn setTitle:entity.ppc_goods_name forState:UIControlStateNormal];
        if (cardBtn.tag == 101)
        {
            [cardBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
            money = entity.ppc_goods_code;
            idnum = cardBtn.tag - 101;
            cardBtn.enabled = NO;
        }
        else
        {
            [cardBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0f]];
             cardBtn.enabled = YES;
        
        }
        
        [cardBtn addTarget:self action:@selector(cartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:cardBtn];
        [self.view addSubview:cardBtn];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cardBtn.bottom + 20, SCREEN_WIDTH, 1.0f)];
    line.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0f];
    [self.view addSubview:line];
//    //计算字符串的长度
//    NSString *title1  = @"需支付金额:";
//    CGSize size1 = CGSizeMake(320, 2000);
//    UIFont *font1 = [UIFont fontWithName:@"Arial" size:15];
//    size1 = [title1 sizeWithFont:font1 constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    moneytitle  = [[UILabel alloc]initWithFrame:CGRectMake(10, line.bottom +10, SCREEN_WIDTH, 30)];
    moneytitle.backgroundColor = [UIColor clearColor];
    moneytitle.font = [UIFont fontWithName:@"Arial" size:15];
    moneytitle.textColor = [UIColor blackColor];
    
    NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",[money floatValue]];
    NSString *str = [NSString stringWithFormat:@"需支付金额: %@",moneyStr];
    NSMutableAttributedString *str_s = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [str rangeOfString:moneyStr];
    [str_s addAttribute:NSForegroundColorAttributeName value:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] range:range];
    moneytitle.attributedText = str_s;
    [self.view addSubview:moneytitle];
    
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(10, moneytitle.bottom + 40, SCREEN_WIDTH - 20, 40);
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f]];
    [buyButton addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    //说明按钮
    
    /*忘记密码*/
    UIButton *structionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    structionBtn.frame = CGRectMake(205, buyButton.bottom + 5, 105, 30);
    [structionBtn setTitle:@"星级包邮卡说明" forState:UIControlStateNormal];
    structionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [structionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [structionBtn addTarget:self action:@selector(structionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:structionBtn];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(structionBtn.left-14, structionBtn.top+7, 15, 15)];
    [image setImage:[UIImage imageNamed:@"plaint"]];
    [self.view addSubview:image];
    

}
-(void)structionBtnClick:(id)sender
{

    YHStarCardInStructionViewController *scd = [[YHStarCardInStructionViewController alloc]init];
    
    [self.navigationController pushViewController:scd animated:YES];

}
-(void)cartBtnClick:(UIButton *)button
{
    //枚举所有的数组中的按钮
    for (UIButton * btn in _buttonArray)
    {
        if (button.tag != btn.tag)
        {
            btn.enabled = YES;
            btn.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0f];
        }
        else
        {
            btn.enabled = NO;
            entity = btnCardArray[button.tag - 101];
            NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",[entity.ppc_goods_code floatValue]];
            NSString *str = [NSString stringWithFormat:@"需支付金额: %@",moneyStr];
            NSMutableAttributedString *str_s = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange range = [str rangeOfString:moneyStr];
            [str_s addAttribute:NSForegroundColorAttributeName value:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] range:range];
            moneytitle.attributedText = str_s;
            
//            moneytitle.text = [NSString stringWithFormat:@"需支付金额: %@￥",entity.ppc_goods_code];
            idnum = button.tag - 101;
            btn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        
        }
    }
   

}
-(void)buyBtnClick:(UIButton *)button
{

    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    [[NetTrans getInstance]API_YH_Star_Post_Card_Pay_Method:self];


}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);

    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
        StarPostCardPayMethod *payEntity = (StarPostCardPayMethod *)payArray[buttonIndex];
        StarPostCardEntity *Cardentity = [btnCardArray objectAtIndex:idnum];
        NSLog(@"Cardentity.ppc_goods_code = %@\npayEntity._id = %@",Cardentity.ppc_goods_code,payEntity._id);
        //购买接口
        [[NetTrans getInstance]API_YH_Star_Post_Card_Buy_Card:self ppc_goods_code:Cardentity.ppc_goods_code pay_method:payEntity._id];
    
   
    
}
#pragma mark - 网络回调
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_YH_STAR_POST_CARD_GOODS_LIST)
    {
        btnCardArray = (NSMutableArray *)netTransObj;
        if (btnCardArray.count>0)
        {
            [self createUI];
        }
        

        
    }
    else if (nTag == t_API_YH_STAR_POST_CARD_PAY_METHOD)
    {
        //支付方式显示
        payArray = (NSMutableArray *)netTransObj;
        UIActionSheet *sheetView = [[UIActionSheet alloc]initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (StarPostCardPayMethod *payEntity in payArray)
        {
            NSString *payEntityName = [NSString stringWithFormat:@"%@",payEntity.name];
            [sheetView addButtonWithTitle:payEntityName];
            
        }
        [sheetView addButtonWithTitle:@"取消"];
        sheetView.cancelButtonIndex = sheetView.numberOfButtons - 1 ;
        
        [sheetView showInView:self.view];
        
    }
    else if (nTag == t_API_YH_STAR_POST_CARD_BUY_CARD)
    {
        StarPostCardBuyCard *buyEntity = (StarPostCardBuyCard *)netTransObj;
        NSString *pay_method = [NSString stringWithFormat:@"%d",[buyEntity.pay_method intValue]];
        NSString *sn = [NSString stringWithFormat:@"%@",buyEntity.pay_str];
        NSLog(@"pay_method = %@,sn = %@",pay_method,sn);
        if ([pay_method isEqualToString:@"100"])
        {
            [UPPayPlugin startPay:sn mode:CHINA_UNIONPAY_MODE viewController:self delegate:self];
        }
        else if ([pay_method isEqualToString:@"200"])
        {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AlixPayResult:) name:@"AlixPayResult" object:nil];
            [[AlipaySDK defaultService]payOrder:sn fromScheme:@"YHCustomer" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSLog(@"str = %@",[resultDic objectForKey:@"memo"]);
            
            }];
        
        }
        
        
    }
    
//    NSString *str_num = @"100";
//    if([str_num isEqualToString:@"100"])
//    {
//        NSString *sn = @"";
//        
//    }
//    else if ([str_num isEqualToString:@"200"])
//    {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AlixPayResult:) name:@"AlixPayResult" object:nil];
//    
//        [[AlipaySDK defaultService]payOrder:@"" fromScheme:@"YHCustomer" callback:^(NSDictionary *resultDic) {
//            
//        }];
//    }
    
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    
    [[iToast makeText:errMsg]show];
    
}
#pragma mark - UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString *)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:@""];
    if ([result isEqualToString:@"success"]) {
        [self pushPaySucceedVC];
    } else if ([result isEqualToString:@"fail"]) {
        [resultString appendString:@"支付失败"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    } else if ([result isEqualToString:@"cancel"])
    {
        [resultString appendString:@"用户取消"];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    }

}
- (void)AlixPayResult:(NSNotification *)notification {
    NSString *resultCode =  [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlixPayResult" object:nil];
    if ([resultCode isEqualToString:@"9000"])
    {//支付成功
        [self pushPaySucceedVC];
    } else if ([resultCode isEqualToString:@"6001"]) {//用户取消
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"用户取消"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    } else if ([resultCode isEqualToString:@"4006"]) {//支付失败
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"支付失败"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    }
}
-(void)pushPaySucceedVC
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertview.tag = 1005;
    [alertview show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1005:
            {
                //支付成功后，执行什么操作,跳转到记录页面
                YHStarCardRecordViewController *record = [[YHStarCardRecordViewController alloc]init];
                [self.navigationController pushViewController:record animated:YES];
            }
            
            break;
            
        default:
            break;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightRecord
{
    YHStarCardRecordViewController *record = [[YHStarCardRecordViewController alloc]init];
    
    [self.navigationController pushViewController:record animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
