//
//  YHShakeViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-11-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ShakeEntity.h"
#import "YHShakeRecordViewController.h"
#import "YHShakeAddressViewController.h"
#import "YHAlertView.h"
#import "YHGoodsDetailViewController.h"
#import "YHShakeActivityDetailViewController.h"

@interface YHShakeViewController ()<YHAlertViewDelegate>
{
    UIImageView * bgView;
    UIImageView * shake;
    SystemSoundID soundId;
    BOOL isAllowShake;
    
    UILabel * infoLabel;
    UILabel * extraLabel;
    UILabel * infomationLabel;
    
    ShakeEntity * shakeEntity;
    AwardEntity * awardEntity;
    
    kAwardType awardType;
    
    
    UIAlertController * alertC;
    UIActionSheet * as;
    UILabel * number;
    NSInteger m;

}
@end

@implementation YHShakeViewController

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
    // Do any additional setup after loading the view from its nib.
    [MTA trackPageViewBegin:PAGE30];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationBar];
    [self addShakeView];
    [self addExtraLabel];
    [self addLabel];
    [self addFunctionBtn];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NetTrans getInstance] shake_info:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    isAllowShake = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    //[self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.5];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MTA trackPageViewEnd:PAGE30];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIInit
- (void)addNavigationBar{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self.navigationItem.title = @"摇一摇";
}
- (UIView *)rightItem{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 40);
    rightBtn.titleLabel.numberOfLines = 2;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn setTitle:@"活动详情" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}
- (void)addShakeView{
    bgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    shake = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    shake.image = [UIImage imageNamed:@"action_1"];
    [self.view addSubview:shake];
    CGPoint center =[UIApplication sharedApplication].keyWindow.center ;
    shake.center = CGPointMake(center.x, center.y -100);
                             
     NSMutableArray * array = [[NSMutableArray alloc]init];
     for (int i= 0 ; i< 3; i++ )
     {
         UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"action_%d.png",i+1]];
         [array addObject:image];
     }
     //动画数组
     shake.animationImages = array;
     //设置动画时间
     shake.animationDuration = 1.0f;
     //开始动画
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shakeSound" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId);
}
- (void)addExtraLabel
{
    extraLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, shake.bottom + 20, SCREEN_WIDTH, 30)];
    extraLabel.text = @"暂时没有摇一摇活动";
    extraLabel.textAlignment = NSTextAlignmentCenter;
    extraLabel.font = [UIFont systemFontOfSize:18];
    extraLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    extraLabel.backgroundColor = [UIColor clearColor];
    extraLabel.hidden = YES;
    [self.view addSubview:extraLabel];
}
- (void)addLabel{
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, shake.bottom + 60, SCREEN_WIDTH, 50)];
//    infoLabel.text = @"已有0人摇中礼品，分享给朋友可以多摇一次哦！";
    infoLabel.text = @"分享给朋友可以多摇一次哦！";
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.hidden = YES;
    [self.view addSubview:infoLabel];
}
- (void)addFunctionBtn{
    NSArray * array = [NSArray arrayWithObjects:@"分享",@"积分摇奖",@"摇奖记录", nil];
    for (int i = 0; i < 3 ; i ++) {
        UIButton  * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( (SCREEN_WIDTH/3)* i, SCREEN_HEIGHT -64- 50, SCREEN_WIDTH/3, 50);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.backgroundColor = [PublicMethod colorWithHexValue:0x393c3c alpha:1.0];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10 +i;
        if (i == 0) {
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
            image.image = [UIImage imageNamed:@"shake_share_icon"];
            image.alpha = 0.33;
            image.tag = 15;
            [btn addSubview:image];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,35, 0, 0);
        }
        if (i < 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3-1, 0, 1, 50)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0x2e3132 alpha:1.0];
            [btn addSubview:line];
            [btn setEnabled:NO];
            [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:0.33] forState:UIControlStateNormal];
        }
        
        [self.view addSubview:btn];
    }
}
#pragma mark - ShowAlertView
- (void)showIntegralView{
    isAllowShake = NO;
    awardType = kIntergralExchange;
    NSArray * array = [NSArray arrayWithObjects:@"确认兑换",@"取消", nil];
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 20, 90)];
    customView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    //总积分
    UILabel * total = [PublicMethod addLabel:CGRectMake(0, 0, 200, 30) setTitle:[NSString stringWithFormat:@"总积分:%@", shakeEntity.total_score] setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
    total.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    total.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    //兑换信息
    UILabel * amount = [PublicMethod addLabel:CGRectMake(0, total.bottom, 80, 30) setTitle:@"兑换数量:" setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
    amount.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    amount.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    //减
    UIButton * minus = [PublicMethod addButton:CGRectMake(amount.right, total.bottom, 30, 30) title:@"-" backGround:nil setTag:1001 setId:self selector:@selector(minusOrAdd:) setFont:[UIFont systemFontOfSize:30] setTextColor:nil];
    [minus setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    minus.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    minus.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    minus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    minus.layer.cornerRadius = 15;
    minus.layer.borderColor = [UIColor blackColor].CGColor;
    minus.layer.borderWidth = 1;
    //兑换数量
    number = [PublicMethod addLabel:CGRectMake(minus.right +10, total.bottom, 40, 30) setTitle:@"1" setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
    number.textAlignment = NSTextAlignmentCenter;
    number.layer.borderColor = [UIColor blackColor].CGColor;
    number.layer.borderWidth = 1;
    //加
    UIButton * add = [PublicMethod addButton:CGRectMake(number.right +10, total.bottom, 30, 30) title:@"+" backGround:nil setTag:1002 setId:self selector:@selector(minusOrAdd:) setFont:[UIFont systemFontOfSize:30] setTextColor:nil];
    [add setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
    add.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    add.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    add.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    add.layer.cornerRadius = 15;
    add.layer.borderColor = [UIColor blackColor].CGColor;
    add.layer.borderWidth = 1;
    //兑换规则
    UILabel * exchange = [PublicMethod addLabel:CGRectMake(0, amount.bottom, 260, 30) setTitle:[NSString stringWithFormat:@"%@积分可摇奖一次！",shakeEntity.intergral_exchange] setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
    exchange.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    exchange.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
 
    [customView addSubview:total];
    [customView addSubview:amount];
    [customView addSubview:minus];
    [customView addSubview:number];
    [customView addSubview:add];
    [customView addSubview:exchange];
    
    YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"积分兑换" customView:customView delegate:self buttonTitles:array];
    [alert showInView:self.view];
   
}
- (void)showAwardView{
    isAllowShake = NO;

    switch (awardType) {
        case kCouponAward:
        case kIntergralAward:
        {
            [self showCouponView];
        }
            break;
        case kGoodsAward:
        {
            [self showGoodsView];
        }
            break;
        case kNoneAward:
        {
            [self showNoneView];
        }
            break;
            
        default:
            break;
    }
}
- (void)showCouponView{
    isAllowShake = NO;
    NSArray * array = [NSArray arrayWithObjects:@"再摇一次",@"分享", nil];
    YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"运气不错！" message:awardEntity.notice delegate:self buttonTitles:array];
    [alert showInView:self.view];
}
- (void)showGoodsView{
    isAllowShake = NO;
    NSArray * array = [NSArray arrayWithObjects:@"填写快递地址",@"再摇一次",@"分享", nil];
    YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"运气不错！" message:awardEntity.notice delegate:self buttonTitles:array];
    [alert showInView:self.view];
}
- (void)showNoneView{
    isAllowShake = NO;
    if (awardEntity.recommend_goods.count != 0 && awardEntity.recommend_goods) {
        NSArray * array = [NSArray arrayWithObjects:@"看看热卖商品",@"再摇一次",@"分享", nil];
        UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 20, 140 -40)];
        customView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        
        NSDictionary * dict = [awardEntity.recommend_goods lastObject];
//        UILabel * infoLab = [[UILabel alloc ]initWithFrame:CGRectMake(0, 10, 200, 30)];
//        infoLab.text = @"为您推荐热卖商品";
//        infoLabel.font = [UIFont systemFontOfSize:15];
//        infoLab.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
//        infoLab.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
//        [customView addSubview:infoLab];
//        UIImageView * goodsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, infoLab.bottom +10, 90, 90)];
        UIImageView * goodsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 90, 90)];
        [goodsView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"goods_image"]] placeholderImage:[UIImage imageNamed: @"goods_default@2x"]];
        goodsView.layer.borderWidth = 1;
        goodsView.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
        [customView addSubview:goodsView];
        
        UILabel * goodsName = [[UILabel alloc]initWithFrame:CGRectMake(goodsView.right +10, 10, 160, 60)];
        goodsName.text = [dict objectForKey:@"goods_name"];
        goodsName.numberOfLines = 2;
        goodsName.font = [UIFont systemFontOfSize:15];
        goodsName.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        goodsName.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        [customView addSubview:goodsName];
        
        UILabel * discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsView.right + 10, goodsName.bottom , 80, 30)];
        discountLabel.text = [NSString stringWithFormat:@"￥%@", [dict objectForKey:@"discount_price"]];
        discountLabel.font = [UIFont systemFontOfSize:18];
        discountLabel.contentMode = UIViewContentModeLeft;
        discountLabel.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
        discountLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        CGSize rect = [discountLabel.text sizeWithFont:discountLabel.font constrainedToSize:CGSizeMake(200, 40)];
        discountLabel.frame = CGRectMake(goodsView.right + 10, goodsName.bottom , rect.width, 30);
        [customView addSubview:discountLabel];
        
        UILabelStrikeThrough * priceLabel = [[UILabelStrikeThrough alloc]initWithFrame:CGRectMake(discountLabel.right, goodsName.bottom, 80, 30)];
        priceLabel.isWithStrikeThrough = YES;
        priceLabel.contentMode = UIViewContentModeLeft;
        priceLabel.font = [UIFont systemFontOfSize:13];
        priceLabel.text = [NSString stringWithFormat:@"￥%@", [dict objectForKey:@"price"]];
        priceLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        priceLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        CGFloat width = discountLabel.width >= 80 ? discountLabel.width:80;
        CGSize size = [priceLabel.text sizeWithFont:priceLabel.font constrainedToSize:CGSizeMake(priceLabel.frame.size.width, 40)];
        priceLabel.frame = CGRectMake(goodsView.right + 10+ width, goodsName.bottom , size.width, 30);
        [customView addSubview:priceLabel];
        
        if ([[dict objectForKey:@"discount_price"] integerValue]>=[[dict objectForKey:@"price"] integerValue]) {
            priceLabel.hidden = YES;
        }else{
            if (width > 80) {
                goodsName.frame = CGRectMake(goodsView.right +10, 10, 160, 50);
                discountLabel.frame = CGRectMake(goodsView.right + 10, goodsName.bottom , width, 25);
                priceLabel.frame = CGRectMake(goodsView.right + 10, discountLabel.bottom , 80, 20);
            }
        }
        
        YHAlertView * alert = [[YHAlertView alloc]initWithTitle:awardEntity.notice customView:customView delegate:self buttonTitles:array];
//        [alert show];
        [alert showInView:self.view];
    }else{
        NSArray * array = [NSArray arrayWithObjects:@"再摇一次",@"分享", nil];
        YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"运气不佳，再来一次吧！" message:@"差一点就中了，再接再厉" delegate:self buttonTitles:array];
        [alert showInView:self.view];
    }
    
}
#pragma mark -YHAlertViewDelegate
- (void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    isAllowShake = YES;
    NSLog(@"%d",awardType);
    switch (awardType) {
        case kCouponAward:
        case kIntergralAward:
        {
            if(buttonIndex == 0){
                //再摇一次
            }else{
                //分享
                [self share:(kCouponAward | kIntergralAward)];
            }
        }
            break;
        case kGoodsAward:
        {
            if (buttonIndex == 0) {
                //填写地址
                YHShakeAddressViewController * savc = [[YHShakeAddressViewController alloc]init ];
                savc.activityId = awardEntity.activity_id;
                [self.navigationController pushViewController:savc animated:YES];
            }else if(buttonIndex == 1){
                //再摇一次
            }else{
                //分享
                [self share:kGoodsAward];
            }
        }
            break;
        case kNoneAward:
        {
            if (buttonIndex == 0) {
                if (awardEntity.recommend_goods.count != 0 && awardEntity.recommend_goods) {
                    //看热卖商品
                    NSDictionary * dict = [awardEntity.recommend_goods lastObject];
                    YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
                    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,[dict objectForKey:@"goods_id"],[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
                    detaiVC.url = url;
                    [detaiVC setMainGoodsUrl:url goodsID:[dict objectForKey:@"goods_id"]];
                    [self.navigationController pushViewController:detaiVC animated:YES];
                }else{
                    //再摇一次
                }
            }else if(buttonIndex == 1){
                if (awardEntity.recommend_goods.count != 0 && awardEntity.recommend_goods) {
                    //再摇一次
                }else{
                    //分享
                    [self share:kNoneAward];
                }
            }else{
                //分享
                [self share:kNoneAward];
            }
        }
            break;
        case kIntergralExchange:
        {
            if (buttonIndex == 0) {
                //积分兑换
                [[NetTrans getInstance] shake_intergral_exchange:number.text transdel:self activity_id:shakeEntity.activity_id];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }else{
                //取消
            }
        }
            break;
        case kNoneTimes:
        {
            //没有次数
        }
            break;
        case kNoneInfo:
        {
            //首次进入，没有获取到活动信息
//            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -shakeMethod
-(void)addAnimations
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_4, 0, 0, 100)];
    
    
    translation.duration = 0.2;
    translation.repeatCount = 2;
    translation.autoreverses = YES;
    
    [shake.layer addAnimation:translation forKey:@"translation"];
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
/*
 - (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event NS_AVAILABLE_IOS(3_0);
 - (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event NS_AVAILABLE_IOS(3_0);
 - (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event NS_AVAILABLE_IOS(3_0);
 */
//static void completionCallback (SystemSoundID  mySSID, void* myself) {
//    YHShakeViewController * vc = [[YHShakeViewController alloc]init ];
//    AudioServicesPlaySystemSound(mySSID);
//    [vc performSelector:@selector(shake) withObject:nil afterDelay:0.5];
//}
//- (void)shake{
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇一摇");
    if(motion==UIEventSubtypeMotionShake && isAllowShake && shakeEntity.activity_id && ![shakeEntity.activity_id isEqualToString:@"0"])
    {
//        [self addAnimations];
//        if ([shake isAnimating]){
//            [shake stopAnimating];
//            [shake startAnimating];
//        }else{
//            [shake startAnimating];
//        }
//        //防止特殊情况，监测不到摇动结束，不掉结束的方法，动画一直转。。
//        [self performSelector:@selector(stop) withObject:nil afterDelay:5];
        
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇一摇结束");
//    [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                             selector:@selector(shake)
//                                               object:nil];
//    AudioServicesRemoveSystemSoundCompletion (kSystemSoundID_Vibrate);
    if(motion==UIEventSubtypeMotionShake && ![shakeEntity.activity_id isEqualToString:@"0"] && shakeEntity.activity_id && isAllowShake)
    {
//        [self addAnimations];
        if (isAllowShake && ![shakeEntity.activity_id isEqualToString:@"0"]) {
            if ([shake isAnimating]){
                [shake stopAnimating];
                [shake startAnimating];
            }else{
                [shake startAnimating];
            }
            //摇一摇音效，震动
            AudioServicesPlaySystemSound (soundId);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            if ([shake isAnimating]) {
                [self performSelector:@selector(stop) withObject:nil afterDelay:3];
            }
            if(shakeEntity.remanent_times.integerValue == 0){
                NSArray * array = [NSArray arrayWithObjects:@"下次再来试试手气", nil];
                isAllowShake = NO;
                awardType = kNoneTimes;
                YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"今天摇一摇机会用完了" message:@"明天再来摇吧！" delegate:self buttonTitles:array];
                [alert showInView:self.view];
            }else{
                if(![shakeEntity.activity_id isEqualToString:@"0"]){
                    [[NetTrans getInstance]shake_doing:self shake_id:shakeEntity.activity_id];
                }
            }
        }
        
    }else if([shakeEntity.activity_id isEqualToString:@"0"]){
        //没有活动
    }else {
//        NSArray * array = [NSArray arrayWithObjects:@"确定", nil];
//        isAllowShake = NO;
//        awardType = kNoneInfo;
//        YHAlertView * alert = [[YHAlertView alloc]initWithTitle:@"获取活动信息失败！" message:@"请检查你的网络设置，重新进入！" delegate:self buttonTitles:array];
//        [alert showInView:self.view];
    }
    
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇一摇取消");
//    if(motion==UIEventSubtypeMotionShake){
//        [self resignFirstResponder];
//    }
}
- (void)stop{
    
    if ([shake isAnimating]) {
        [shake stopAnimating];
    }
}
#pragma mark - ClickMethod
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UIButton *)btn{
    if (isAllowShake) {
        YHShakeActivityDetailViewController * sadvc = [[YHShakeActivityDetailViewController alloc]init ];
        sadvc._description = shakeEntity._description;
        sadvc.activity_id = shakeEntity.activity_id;
        sadvc.description_image = shakeEntity.description_image;
        [self.navigationController pushViewController:sadvc animated:YES];
    }
}
- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 10:
        {
//            PublicMethod * p = [[PublicMethod alloc]init];
//            p.block = ^(id obj){
//                //
//                NSLog(@"分享回调");
//            };
            [MTA trackCustomKeyValueEvent:EVENT_ID46 props:nil];
            [PublicMethod showCustomShareListViewWithContent:[NSString stringWithFormat:@"%@%@", shakeEntity.share_tip,shakeEntity.download_url] title:shakeEntity.share_title imageUrl:shakeEntity.image_url url:shakeEntity.page_url description:shakeEntity._description block:^(id obj){
                //
                NSLog(@"分享回调");
                [[NetTrans getInstance] shake_share_record:self];
            } VController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
        }
            break;
        case 11:
        {
            [self showIntegralView];
        }
            break;
        case 12:
        {
            YHShakeRecordViewController * srvc = [[YHShakeRecordViewController alloc]init ];
            srvc.dataArray = [[NSMutableArray alloc] init];
            [[NetTrans getInstance] shake_award_list:srvc page:@"1"];
            [self.navigationController pushViewController:srvc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)minusOrAdd:(UIButton *)btn{
    UIView * view = btn.superview;
    UIButton * minus = (UIButton *) [view viewWithTag:1001];
    UIButton * add = (UIButton *) [view viewWithTag:1002];
    NSInteger num = number.text.integerValue ;
    if (minus.tag == btn.tag) {
        if (num == 1) {
            //次数为1，不可减
            minus.enabled = NO;
        }else{
            NSLog(@"减");
            add.enabled = YES;
            m--;
            number.text = [NSString stringWithFormat:@"%ld",(long)--num];
        }
    }else{
//        if (m == 0) {
            //积分不够兑换，不可加
//            btn.enabled = NO;
//        }else{
            NSLog(@"加");
            minus.enabled = YES;
            m--;
            number.text = [NSString stringWithFormat:@"%ld",(long)++num];
//        }
    }
    
}
#pragma mark - ShareMethod
- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)share:(kAwardType)type{
    [MTA trackCustomKeyValueEvent:EVENT_ID46 props:nil];
    switch (type) {
        case kCouponAward:
        case kIntergralAward:
        {
            [PublicMethod showCustomShareListViewWithContent:[NSString stringWithFormat:@"%@%@", awardEntity.share_tip,awardEntity.download_url] title:awardEntity.share_title imageUrl:awardEntity.image_url url:awardEntity.page_url description:awardEntity._description block:^(id obj){
                //摇一摇加积分，只有首次分享成功才加一，下同
                [[NetTrans getInstance] shake_share_record:self];
            }VController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
        }
            break;
        case kGoodsAward:
        {
            [PublicMethod showCustomShareListViewWithContent:[NSString stringWithFormat:@"%@%@", awardEntity.share_tip,awardEntity.download_url] title:awardEntity.share_title imageUrl:awardEntity.image_url url:awardEntity.page_url description:awardEntity._description block:^(id obj){
                [[NetTrans getInstance] shake_share_record:self];
            }VController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
        }
            break;
        case kNoneAward:
        {
            NSString * s;
            if (awardEntity.recommend_goods.count != 0 && awardEntity.recommend_goods) {
                NSDictionary * dict = [awardEntity.recommend_goods lastObject];
                s = [dict objectForKey:@"goods_image"];
            }else{
                s = awardEntity.image_url;
            }
            [PublicMethod showCustomShareListViewWithContent:[NSString stringWithFormat:@"%@%@", awardEntity.share_tip,awardEntity.download_url] title:awardEntity.share_title imageUrl:s url:awardEntity.page_url description:awardEntity._description block:^(id obj){
                [[NetTrans getInstance] shake_share_record:self];
            }VController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
            
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark -RequestDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    if ([status isEqualToString:WEB_STATUS_3])
    {
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
        return;
    }
    [self showNotice:errMsg];
    //积分兑换失败等等，也需刷新活动信息
    [[NetTrans getInstance]shake_info:self];
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag == t_API_SHAKE_INFO) {
        m = 0;
        shakeEntity = nil;
        shakeEntity = (ShakeEntity *)netTransObj;
        if (![shakeEntity.activity_id isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[self rightItem]];
            [bgView setImageWithURL:[NSURL URLWithString:shakeEntity.background_image]];
            extraLabel.text = [NSString stringWithFormat:@"今天还能摇%@次", shakeEntity.remanent_times];
            //设置特殊颜色
            NSInteger length = [NSString stringWithFormat:@"%ld", (long)shakeEntity.remanent_times.integerValue].length;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:extraLabel.text];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0 ] range:NSMakeRange(5,length)];
            extraLabel.attributedText = attributedString;
            
//            infoLabel.text = [NSString stringWithFormat:@"已有%@人摇中礼品，分享给朋友可以多摇一次哦！", shakeEntity.total_shake];
//            infoLabel.font = [UIFont systemFontOfSize:12];

            [extraLabel setHidden:NO];
            [infoLabel setHidden:NO];
            UIButton * btn1 =(UIButton *)[self.view viewWithTag:10];
            UIButton * btn2 =(UIButton *)[self.view viewWithTag:11];
            UIImageView * image = (UIImageView *)[btn1 viewWithTag:15];
            [btn1 setEnabled:YES];
            [btn2 setEnabled:YES];
            image.alpha = 1;
            [btn1 setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
            [btn2 setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
            if (shakeEntity.intergral_exchange.floatValue == 0 ) {
                [btn2 setEnabled:NO];
                [btn2 setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:0.33] forState:UIControlStateNormal];
            }else{
                m = shakeEntity.total_score.integerValue / shakeEntity.intergral_exchange.integerValue;
            }
            
        }else{
            self.navigationItem.rightBarButtonItem = nil;
//            isAllowShake = NO;
            extraLabel.text = @"暂时没有摇一摇活动";
            [extraLabel setHidden:NO];
            [infoLabel setHidden:YES];
            UIButton * btn1 =(UIButton *)[self.view viewWithTag:10];
            UIButton * btn2 =(UIButton *)[self.view viewWithTag:11];
            UIImageView * image = (UIImageView *)[btn1 viewWithTag:15];
            [btn1 setEnabled:NO];
            [btn2 setEnabled:NO];
            image.alpha = 0.33;
            [btn1 setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:0.33] forState:UIControlStateNormal];
            [btn2 setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:0.33] forState:UIControlStateNormal];
            
        }
        
        
    }else if (nTag == t_API_SHAKE_DOING){
        awardEntity = (AwardEntity *)netTransObj;
        awardType = [awardEntity.prize_type intValue];
        //摇过之后，要刷新数据
        [[NetTrans getInstance] shake_info:self];
        [self showAwardView];
        
    }else if (nTag == t_API_SHAKE_INTERGRAL_EXCHANGE){
        [self showNotice:@"兑换成功"];
        [[NetTrans getInstance]shake_info:self];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else if (nTag == t_API_SHAKE_SHARE_RECORD){
        [self showNotice:@"分享成功"];
        //分享成功刷新界面
        [[NetTrans getInstance]shake_info:self];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}
@end
