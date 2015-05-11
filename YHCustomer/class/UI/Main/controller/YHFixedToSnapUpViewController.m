//
//  YHFixedToSnapUpViewController.m
//  YHCustomer
//
//  Created by wangliang on 15-1-7.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//  固定抢购界面

#import "YHFixedToSnapUpViewController.h"
#import "YHForInstructionsViewController.h"
#import "YHGoodsDetailViewController.h"//YHGoodsDetailViewController
#import "TORSegmentControl.h"
#import "FixedToSnapUpEntity.h"
#import "YHCartViewController.h"
#import "YHNewOrderViewController.h"


#define kDefaultFireIntervalNormal  0.1
#define HOUR 3600
#define SCEND 60
#define DAY 86400


@interface YHFixedToSnapUpViewController ()
{
    UIView * _headView;
    NSString * selectNum;
    NSString * selectAid;
    NSMutableArray *dataArray;
    int pages;
    BOOL _reloadingOther;

    UIScrollView *titleView;
    
    CGFloat heigt;

    NSString *goodID;

    BOOL isCountDown;
    BOOL isEven;
    
    UIView * tiShiView;
    NSDate * dateNow_D;
    NSString *dataNow_S;
    
    NSMutableArray * itemArr;
    
    BOOL isSame;
    
    NSDate * date_EC1;
    NSDate * date_EC2;
    NSInteger str_N;
    
    NSString *good_id;
    NSString *total;
    NSString *transaction_type;
    
}
@property(nonatomic , strong)NSTimer * timeOne;
@end

@implementation YHFixedToSnapUpViewController
@synthesize goodListArray;
@synthesize refreshFooterOtherView;
@synthesize Forward;
-(void)viewWillAppear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    
    if (cartView)
    {
        [cartView changeCartNum];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PAGE108];
    //1代表固定抢购，无需传activity_id
    if (Forward)
    {
        [self getSnapUpInfo];
    }
   
}

-(void)getSnapUpInfo
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"1111111111%@",currentTime);
    [[NetTrans getInstance]API_YH_Buy_Activity_Info:self type:@"1" activity_id:0];
   
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PAGE108];
    Forward = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    selectAid = @"";
    selectNum = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"辉抢购";
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    [self addBackNav];
    
}
-(void)addUI
{
    //[self headView];
    
    //创建分段选择器显示活动标题
    if (_headView)
    {
        [_headView removeFromSuperview];
        _headView = nil;
    }
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    _headView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    NSMutableArray *arr = [NSMutableArray array];
//    if (infoArray.count > 0)
//    {
//        FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
//        entity = (FixedToSnapUpEntity *)infoArray[0];
//        dateNow_D = [PublicMethod dateFromStringOther:entity.date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        dataNow_S = [dateFormatter stringFromDate:dateNow_D];
//        [self compareTime];
//        
//    }
//    for (int i = 0; i < itemArr.count; i++)
//    {
//        NSMutableArray * arr1 = [itemArr objectAtIndex:i];
//        NSMutableArray * arr_1 = [NSMutableArray array];
//        [arr_1 addObject:arr1[0]];
//        [arr_1 addObject:arr1[1]];
//        [arr addObject:arr_1];
//    }
    if ([dataArray count] == 0)
    {
        for (int i = 0; i<(3 - dataArray.count); i++)
        {
            NSArray *arr2 = [NSArray arrayWithObjects:@"敬请期待",@"暂无", nil];
            [arr addObject:arr2];
        }
    }
    if (segMent)
    {
        [segMent removeFromSuperview];
        segMent = nil;
    }
    segMent = [[TORSegmentControl alloc] initWithItems:arr vertical:NO];
    [segMent setFrame:CGRectMake(0,0, SCREEN_WIDTH, 50)];
    
    [self getSelectNum];
    NSInteger num = [selectNum integerValue];
    [segMent setSelectedSegmentIndex:num];
    
    [segMent addTarget:self action:@selector(segMentClick) forControlEvents:UIControlEventValueChanged];
//    if (infoArray.count > 0)
//    {
//        FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
//        entity = (FixedToSnapUpEntity *)infoArray[num];
//        [self startTimer];
//        //        [NSThread detachNewThreadSelector:@selector(startTime) toTarget:self withObject:nil];
//        int act_id = [entity.activity_id intValue];
//        [[NetTrans getInstance]API_YH_Buy_Activity_List:self activity_id:act_id page:pages limit:10];
//        
//    }
    
    
    UIView * xline = [[UIView alloc]initWithFrame:CGRectMake(0, segMent.height -1, SCREEN_WIDTH, 1)];
    xline.backgroundColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0] ;
    [segMent addSubview:xline];
    
    [_headView addSubview:segMent];
    heigt = xline.bottom;
    //    [self addTitleView];
    [self.view addSubview:_headView];
    
    
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.bottom - 35, SCREEN_WIDTH, SCREEN_HEIGHT - _headView.height)];
    view.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.f];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-90)/2, (SCREEN_HEIGHT - 260)/2, 90, 90)];
        imageView.image = [UIImage imageNamed:@"icon_表情微笑.png"];
        [view addSubview:imageView];
        
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom + 10, SCREEN_WIDTH , 30)];
    label.text = @"精彩的抢购活动正在准备中，敬请期待!";
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f];
    [view addSubview:label];
    [self.view addSubview:view];

}

-(void)createUI
{
    //添加购物车
    if (IOS_VERSION >=7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (_tableView)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,85,SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT-NAV_BACK_HEIGTH - 85) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;    
    [self.view addSubview:_tableView];
    
    [self addCartView];
}

-(void)addCartView
{
    cartView = [[YHCartView alloc] initWithFrame:CGRectMake(260, SCREEN_HEIGHT-48-124, 54, 54)];
    cartView.delegate = self;
    [self.view addSubview:cartView];
}

-(void)headView
{
    //创建分段选择器显示活动标题
    if (_headView)
    {
        [_headView removeFromSuperview];
        _headView = nil;
    }
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    _headView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
    NSMutableArray *arr = [NSMutableArray array];
    if (infoArray.count > 0)
    {
        FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
        entity = (FixedToSnapUpEntity *)infoArray[0];
        dateNow_D = [PublicMethod dateFromStringOther:entity.date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dataNow_S = [dateFormatter stringFromDate:dateNow_D];
        [self compareTime];
        
    }
    for (int i = 0; i < itemArr.count; i++)
    {
        NSMutableArray * arr1 = [itemArr objectAtIndex:i];
        NSMutableArray * arr_1 = [NSMutableArray array];
        [arr_1 addObject:arr1[0]];
        [arr_1 addObject:arr1[1]];
        [arr addObject:arr_1];
    }
    if ([itemArr count] != 3)
    {
        for (int i = 0; i<(3 - itemArr.count); i++)
        {
            NSArray *arr2 = [NSArray arrayWithObjects:@"敬请期待",@"暂无", nil];
            [arr addObject:arr2];
        }
    }
    if (segMent)
    {
        [segMent removeFromSuperview];
        segMent = nil;
    }
    segMent = [[TORSegmentControl alloc] initWithItems:arr vertical:NO];
    [segMent setFrame:CGRectMake(0,0, SCREEN_WIDTH, 50)];
    
    [self getSelectNum];
    NSInteger num = [selectNum integerValue];
    [segMent setSelectedSegmentIndex:num];
    
    [segMent addTarget:self action:@selector(segMentClick) forControlEvents:UIControlEventValueChanged];
    if (infoArray.count > 0)
    {
        FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
        entity = (FixedToSnapUpEntity *)infoArray[num];
        [self startTimer];
//        [NSThread detachNewThreadSelector:@selector(startTime) toTarget:self withObject:nil];
        int act_id = [entity.activity_id intValue];
        [[NetTrans getInstance]API_YH_Buy_Activity_List:self type:@"panic_buying" activity_id:act_id page:pages limit:10];
        
    }
    
    
    UIView * xline = [[UIView alloc]initWithFrame:CGRectMake(0, segMent.height -1, SCREEN_WIDTH, 1)];
    xline.backgroundColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0] ;
    [segMent addSubview:xline];
    
    [_headView addSubview:segMent];
    heigt = xline.bottom;
//    [self addTitleView];
    [self.view addSubview:_headView];
}

-(void)getSelectNum
{
    if (infoArray.count > 0)
    {
        if ([selectAid isEqualToString:@""] || !selectAid)
        {
            selectAid = [[infoArray firstObject] activity_id];
            selectNum = @"0";
        }
        else
        {
            NSMutableArray * arr_T = [NSMutableArray array];
            for (int i = 0 ; i < infoArray.count; i++)
            {
                [arr_T addObject:[[infoArray objectAtIndex:i] activity_id]];
            }
            
            if ([arr_T containsObject:selectAid])
            {
                NSInteger a = [arr_T indexOfObject:selectAid];
                selectNum = [NSString stringWithFormat:@"%ld" , (long)a];
            }
            else
            {
                selectAid = [[infoArray lastObject] activity_id];
                selectNum = [NSString stringWithFormat:@"%d" , 0];
            }
        }
    }
    else
    {
        selectAid = @"";
        selectNum = @"0";
    }
}

-(void)startTimer
{
    if (_timeOne == nil)
    {
        _timeOne = [NSTimer scheduledTimerWithTimeInterval:kDefaultFireIntervalNormal target:self selector:@selector(upTiShi) userInfo:nil repeats:YES];
         [[NSRunLoop currentRunLoop] addTimer:_timeOne forMode:NSRunLoopCommonModes];
        [_timeOne fire];
    }
}

-(void)stopTimer
{
    [_timeOne invalidate];
    _timeOne = nil;
}

-(void)upTiShi
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   dateNow_D = [dateNow_D dateByAddingTimeInterval:kDefaultFireIntervalNormal];
    dataNow_S = [dateFormatter stringFromDate:dateNow_D];
    for (int i = 0 ; i < itemArr.count; i++)
    {
        NSMutableArray * arr = [itemArr objectAtIndex:i];
        FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
        entity = (FixedToSnapUpEntity *)infoArray[i];
        NSString * state_S = entity.start_date;
        NSString * end_S = entity.end_date;
        NSDate * state_D = [PublicMethod dateFromStringOther:state_S];
        NSDate * end_D = [PublicMethod dateFromStringOther:end_S];
        NSArray * arr_now = [dataNow_S componentsSeparatedByString:@" "];
        NSArray * arr_State = [state_S componentsSeparatedByString:@" "];
        NSArray * arr_end = [end_S componentsSeparatedByString:@" "];
        if ([[arr lastObject] isEqualToString:@"0"])
        {
            if ([[arr_now firstObject] isEqualToString:[arr_State firstObject]])
            {
                [self performSelector:@selector(getSnapUpInfo) withObject:nil afterDelay:0];
                [self stopTimer];
            }
            else
            {
                NSString * strI = [NSString stringWithFormat:@"%d" , i];
                NSString * str_1_0 = [[arr_State firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                NSString * str_1_1 = [[arr_State lastObject] substringWithRange:NSMakeRange(0, 5)];
                NSString * str_1_2 = [[arr_end lastObject] substringWithRange:NSMakeRange(0, 5)];
                NSString * str_1 = [NSString stringWithFormat:@"%@ %@~%@" , str_1_0 , str_1_1 , str_1_2];
                [self CountDown:strI andStrTimeS:@"0" andStr:str_1 andTime:0];
            }
        }
        else if ([[arr lastObject] isEqualToString:@"1"])
        {
            if ([dateNow_D compare:state_D] == NSOrderedSame|| [dateNow_D compare:state_D] == NSOrderedDescending)
            {
                selectNum = @"0";
                [self performSelector:@selector(getSnapUpInfo) withObject:nil afterDelay:1.0];
                [self stopTimer];
            }
            else
            {
                NSTimeInterval timeNum = [state_D timeIntervalSinceDate:dateNow_D];
                NSString * strI = [NSString stringWithFormat:@"%d" , i];
                NSString * str = [NSString stringWithFormat:@"%.1f" , timeNum];
                NSArray * arr = [str componentsSeparatedByString:@"."];
                if ([[arr lastObject] integerValue] > 4)
                {
                     isSame = YES;
                }
                else
                {
                    isSame = NO;
                }
                [self CountDown:strI andStrTimeS:@"1" andStr:nil andTime:timeNum];
            }
        }
        else if ([[arr lastObject] isEqualToString:@"2"])
        {
            if ([dateNow_D compare:end_D] == NSOrderedSame || [dateNow_D compare:end_D] == NSOrderedDescending)
            {
                selectNum = @"0";
                [self performSelector:@selector(getSnapUpInfo) withObject:nil afterDelay:2];
                [self stopTimer];
            }
            else
            {
                 NSTimeInterval timeNum = [end_D timeIntervalSinceDate:dateNow_D];
                NSString * strI = [NSString stringWithFormat:@"%d" , i];
                NSString * str = [NSString stringWithFormat:@"%.1f" , timeNum];
                NSArray * arr = [str componentsSeparatedByString:@"."];
                if ([[arr lastObject] integerValue] > 4)
                {
                    isSame = YES;
                }
                else
                {
                    isSame = NO;
                }
                [self CountDown:strI andStrTimeS:@"2" andStr:nil andTime:timeNum];
            }
        }
    }
}


-(void)CountDown:(NSString *)_strI andStrTimeS:(NSString *)_timeS andStr:(NSString *)_strK andTime:(NSTimeInterval)_time
{
    if ([_strI isEqualToString:selectNum])
    {
        if (tiShiView)
        {
            [tiShiView removeFromSuperview];
        }
        tiShiView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segMent.frame), SCREEN_HEIGHT, 35)];
        tiShiView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:tiShiView];
        if ([_timeS isEqualToString:@"0"])
        {
            UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 35)];
            lab_1.font = [UIFont systemFontOfSize:15];
            lab_1.text = @"未开始";
            lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
            [tiShiView addSubview:lab_1];
            
            UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(lab_1.frame), 0, SCREEN_WIDTH-10-CGRectGetMidX(lab_1.frame), 35)];
            lab_2.backgroundColor = [UIColor clearColor];
            lab_2.textAlignment = NSTextAlignmentRight;
            lab_2.font = [UIFont systemFontOfSize:15];
            lab_2.text = _strK;
             lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
            [tiShiView addSubview:lab_2];
        }
        else if ([_timeS isEqualToString:@"1"])
        {
            UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 35)];
            lab_1.font = [UIFont systemFontOfSize:15];
            lab_1.text = @"未开始";
            lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
            [tiShiView addSubview:lab_1];
           CGFloat a =  [self countDown:(int)_time];
            UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_1.frame), 0, a - CGRectGetMaxX(lab_1.frame) - 5, 35)];
            lab_2.backgroundColor = [UIColor clearColor];
            lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
            lab_2.font = [UIFont systemFontOfSize:15];
            lab_2.text = @"距开始还有";
            lab_2.textAlignment = UITextAlignmentRight;
            [tiShiView addSubview:lab_2];
        }
        else if([_timeS isEqualToString:@"2"])
        {
            UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 35)];
            lab_1.font = [UIFont systemFontOfSize:15];
            lab_1.text = @"抢购中";
            lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
            [tiShiView addSubview:lab_1];
            CGFloat a =  [self countDown:(int)_time];
            UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab_1.frame), 0, a - CGRectGetMaxX(lab_1.frame) - 5, 35)];
            lab_2.backgroundColor = [UIColor clearColor];
            lab_2.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
            lab_2.font = [UIFont systemFontOfSize:15];
            lab_2.text = @"距结束还有";
            lab_2.textAlignment = UITextAlignmentRight;
            [tiShiView addSubview:lab_2];
        }
    }
}

-(void)compareTime
{
    if (itemArr == nil)
    {
        itemArr = [[NSMutableArray alloc] init];
    }
    else
    {
        [itemArr removeAllObjects];
    }
    
    for (int i = 0 ; i < infoArray.count; i++)
    {
        NSMutableArray * arr_T = [NSMutableArray array];
        NSString * str_Title;//标题
        NSString * str_State;//下标题
        TimeStype timeS;
        FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
        entity = (FixedToSnapUpEntity *)infoArray[i];
        
        NSString * state_S = entity.start_date;
        NSString * end_S = entity.end_date;
        NSDate * state_D = [PublicMethod dateFromStringOther:state_S];
        NSDate * end_D = [PublicMethod dateFromStringOther:end_S];
        NSArray * arr_now = [dataNow_S componentsSeparatedByString:@" "];
        NSArray * arr_state = [state_S componentsSeparatedByString:@" "];
        NSArray * arr_end = [end_S componentsSeparatedByString:@" "];
        if (![[arr_now firstObject] isEqualToString:[arr_state firstObject]])
        {
            str_Title = entity.title;
            timeS = One_Stype;
            str_State = [[arr_state firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            [arr_T addObject:str_Title];
            [arr_T addObject:str_State];
            [arr_T addObject:@"0"];
        }
        else
        {
            if ([dateNow_D compare:state_D] == NSOrderedAscending)
            {
                timeS = Two_Stype;
                NSString * str_1 = [[arr_state lastObject] substringWithRange:NSMakeRange(0, 5)];
                NSString * str = [NSString stringWithFormat:@"%@开始" , str_1];
                str_State = str;
                str_Title = entity.title;
                [arr_T addObject:str_Title];
                [arr_T addObject:str_State];
                [arr_T addObject:@"1"];
               
            }
            else
            {
                if ([dateNow_D compare:end_D] == NSOrderedAscending)
                {
                    timeS = Three_Stype;
                    NSString * str_1 = [[arr_end lastObject] substringWithRange:NSMakeRange(0, 5)];
                    NSString * str = [NSString stringWithFormat:@"%@结束" , str_1];
                    str_State = str;
                    str_Title = entity.title;
                    [arr_T addObject:str_Title];
                    [arr_T addObject:str_State];
                    [arr_T addObject:@"2"];
                }
            }
        }
        [itemArr addObject:arr_T];
    }
}

-(CGFloat)countDown:(int)_time
{
    int ATime = _time;
    CGFloat countDownLable = 0.0;
    NSString * strIII= nil;
    if (_time > 60)
    {
        strIII = @"0";
    }
    else if (_time < 10)
    {
        strIII = @"2";
    }
    else
    {
        strIII = @"1";
    }
    
    int a_H = ATime/HOUR;
    NSMutableArray * arr = [NSMutableArray array];
    if (a_H>9)
    {
        int a_H_1 = a_H/10;
        int a_H_2 = a_H%10;
        NSString * str_1 = [NSString stringWithFormat:@"%d" , a_H_1];
        NSString * str_2 = [NSString stringWithFormat:@"%d" , a_H_2];
        [arr addObject:str_1];
        [arr addObject:str_2];
    }
    else if(a_H < 0)
    {
        [arr addObject:@"0"];
        [arr addObject:@"0"];
    }
    else
    {
        [arr addObject:@"0"];
        NSString * str = [NSString stringWithFormat:@"%d" , a_H];
        [arr addObject:str];
    }
    [arr addObject:@"h"];
    ATime = ATime - a_H*HOUR;
    int a_S = ATime/SCEND;
    if (a_S>9)
    {
        int a_S_1 = a_S/10;
        int a_S_2 = a_S%10;
        NSString * str_1 = [NSString stringWithFormat:@"%d" , a_S_1];
        NSString * str_2 = [NSString stringWithFormat:@"%d" , a_S_2];
        [arr addObject:str_1];
        [arr addObject:str_2];
    }
    else if(a_S < 0)
    {
        [arr addObject:@"0"];
        [arr addObject:@"0"];
    }
    else
    {
        
        [arr addObject:@"0"];
        NSString * str = [NSString stringWithFormat:@"%d" , a_S];
        [arr addObject:str];
    }
    [arr addObject:@"m"];
    ATime = ATime - a_S*SCEND;
    if (ATime>9)
    {
        int a_T_1 = ATime/10;
        int a_T_2 = ATime%10;
        NSString * str_1 = [NSString stringWithFormat:@"%d" , a_T_1];
        NSString * str_2 = [NSString stringWithFormat:@"%d" , a_T_2];
        [arr addObject:str_1];
        [arr addObject:str_2];
    }
    else if(ATime < 0)
    {
        [arr addObject:@"0"];
        [arr addObject:@"0"];
    }
    else
    {
        [arr addObject:@"0"];
        NSString * str = [NSString stringWithFormat:@"%d" , ATime];
        [arr addObject:str];
    }
    [arr addObject:@"s"];
//    NSLog(@"arr = %@" , arr);
    for (int i = 0 ; i<arr.count ; i++)
    {
        NSString * str = [arr objectAtIndex:arr.count-i-1];
        UILabel * lab;
        NSString * str_CZ = @"0";//判断lab是否存在 “0”为不存在“1”为存在
        if ([tiShiView viewWithTag:10000+i])
        {
            str_CZ = @"1";
            lab = (UILabel *)[tiShiView viewWithTag:10000+i] ;
        }
        else
        {
            str_CZ = @"0";
            UILabel * lab;
            lab.tag = i+10000;
        }
        if (i == 0)
        {
            if ([str_CZ isEqualToString:@"0"])
            {
               lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10, 10, 15)];
                lab.font = [UIFont systemFontOfSize:15];
            }
         
        }
        else if (i == 1)
        {
            if (![strIII isEqualToString:@"0"])
            {
                if (isSame)
                {
                    if ([str_CZ isEqualToString:@"0"])
                    {
                        lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-1-(10+1)*i, 10-2, 10+1, 15+2)];//变大
                        lab.font = [UIFont systemFontOfSize:16];
                    }
                     
                }
                else
                {
                    if ([str_CZ isEqualToString:@"0"])
                    {
                         lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10, 10, 15)];
                        lab.font = [UIFont systemFontOfSize:15];
                    }
                }
            }
           else
           {
               if ([str_CZ isEqualToString:@"0"])
               {
                   lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10, 10, 15)];
                   lab.font = [UIFont systemFontOfSize:15];
               }
           }
        }
        else if (i == 2)
        {
            if ([strIII isEqualToString:@"1"])
            {
                if (isSame)
                {
                    if ([str_CZ isEqualToString:@"0"])
                    {
                        lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10-2, 10+1, 15+2)];//变大
                        lab.font = [UIFont systemFontOfSize:16];
                    }
                    else
                    {
                        [lab setFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10-2, 10+1, 15+2)];
                         lab.font = [UIFont systemFontOfSize:16];
                    }
                }
                else
                {
                    if ([str_CZ isEqualToString:@"0"])
                    {
                        lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10, 10, 15)];
                        lab.font = [UIFont systemFontOfSize:15];
                    }
                    else
                    {
                        [lab setFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10, 10, 15)];
                        lab.font = [UIFont systemFontOfSize:15];
                    }
                }
            }
            else
            {
                if ([str_CZ isEqualToString:@"0"])
                {
                    lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-(10+1)*i, 10, 10, 15)];
                    lab.font = [UIFont systemFontOfSize:15];
                }
            }

        }
        else if (i == 3)
        {
            if ([str_CZ isEqualToString:@"0"])
            {
                lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25-(10+1)*i, 10, 15, 15)];
                lab.font = [UIFont systemFontOfSize:15];
            }
        }
        else
        {
            if ([str_CZ isEqualToString:@"0"])
            {
                lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25-(10+1)*i, 10, 10, 15)];
                lab.font = [UIFont systemFontOfSize:15];
            }
            
        }
        
        if ((i == 0)||(i == 3)||(i == 6))
        {
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
        }
        else
        {
            lab.backgroundColor = [PublicMethod colorWithHexValue1:@"#FC5860"];
            lab.textColor =[PublicMethod colorWithHexValue1:@"#FFFFFF"];;
        }
        lab.text = str;
        lab.textAlignment = NSTextAlignmentCenter;
        
        [tiShiView addSubview:lab];
        countDownLable = CGRectGetMinX(lab.frame);
    }
    return countDownLable;
}

-(void)segMentClick
{
    NSLog(@"segMent.selectedSegmentIndex = %ld" , (long)segMent.selectedSegmentIndex);
    NSInteger num = segMent.selectedSegmentIndex;
    if ((num+1 < infoArray.count)||(num+1 == infoArray.count))
    {
        if (num == [selectNum intValue])
        {
            
        }
        else
        {
            NSString * str = [NSString stringWithFormat:@"%ld" , (long)num];
            //        [segMent setSelectedSegmentIndex:num];
            selectNum = str;
            FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
            entity = (FixedToSnapUpEntity *)infoArray[num];
            int act_id = [entity.activity_id intValue];
            [dataArray removeAllObjects];
            pages = 1 ;
            selectAid = entity.activity_id;
            [self createUI];
            [[NetTrans getInstance] API_YH_Buy_Activity_List:self type:@"panic_buying" activity_id:act_id page:pages limit:10];
        }
    }
    else
    {
        NSInteger a = [selectNum integerValue];
        [segMent setSelectedSegmentIndex:a];
        return;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat a;
    BuyActiviteListEntity *entity = (BuyActiviteListEntity *)[dataArray objectAtIndex:indexPath.row];
    if ((entity.goods_introduction.length == 0)||!entity.goods_introduction||(entity.goods_introduction== nil))
    {
         a = 140;
    }
    else
    {
        a = 155;
    }
    
    if (indexPath.row == 0)
    {
        a = a+10;
    }
    return a;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"11"];
       
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0f];
    
    BuyActiviteListEntity *entity = (BuyActiviteListEntity *)[dataArray objectAtIndex:indexPath.row];
    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.height)];
//    bgView.backgroundColor = [UIColor whiteColor];
    
    cell.backgroundColor = [UIColor whiteColor];
    UIView *colorView = [[UIView alloc]init];
    if (indexPath.row == 0)
    {
        colorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        colorView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0f];
        [cell addSubview:colorView];
    }
    
    UIImageView *imageView = [[UIImageView alloc]init];
    if (indexPath.row == 0)
    {
        imageView.frame = CGRectMake(10, colorView.bottom+10, 120, 120);
    }else
    {
        imageView.frame = CGRectMake(10, 10, 120, 120);
    }
    
    [imageView setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"goods_default"]];
    [cell addSubview:imageView];
    //
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, imageView.origin.y, SCREEN_WIDTH - imageView.right - 10, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = entity.goods_name;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
    [cell addSubview:titleLabel];
    BOOL isYes = NO;
    //说明
    UILabel * illustrate;
    if (!((entity.goods_introduction.length == 0)||!entity.goods_introduction||(entity.goods_introduction== nil)))
    {
        illustrate = [PublicMethod addLabel:CGRectMake(imageView.right+10, titleLabel.bottom, titleLabel.width, 15) setTitle:entity.goods_introduction setBackColor:[PublicMethod colorWithHexValue:0x398cdd alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
        illustrate.backgroundColor = [UIColor clearColor];
        illustrate.numberOfLines = 1;
        //    illustrate.hidden = YES;
        illustrate.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
        illustrate.textAlignment = NSTextAlignmentLeft;
        isYes = YES;
         [cell addSubview:illustrate];
    }
    
    //促销价
    UILabel *priceLabel = [[UILabel alloc]init];
        if (isYes)
        {
            priceLabel.frame = CGRectMake(imageView.right + 10, illustrate.bottom , SCREEN_WIDTH - imageView.width - 20, 36);
        }
        else
        {
            priceLabel.frame = CGRectMake(imageView.right + 10, titleLabel.bottom , SCREEN_WIDTH - imageView.width - 20, 36);
        }

    priceLabel.backgroundColor = [UIColor clearColor];
    NSString * str_price = [NSString stringWithFormat:@"￥%@" , entity.discount_price];
    priceLabel.text = str_price;
    
    priceLabel.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
    priceLabel.font = [UIFont systemFontOfSize:18];
    [cell addSubview:priceLabel];
    
//    NSString *text = [NSString stringWithFormat:@"%@",entity.price];
    CGSize size = CGSizeMake(320, 2000);
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    NSString * str_money = [NSString stringWithFormat:@"￥%@" , entity.price];
    size = [str_money sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, priceLabel.bottom, size.width, 20)];
    moneyLabel.lineBreakMode = UILineBreakModeWordWrap;
    //CGRectMake(imageView.right + 10,size.width , 20)
    moneyLabel.backgroundColor = [UIColor clearColor];
    
    moneyLabel.text = str_money;
    moneyLabel.font = [UIFont fontWithName:@"Arial" size:12];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, size.width, 1)];
    lineView.backgroundColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f];
    [moneyLabel addSubview:lineView];
    moneyLabel.textColor = [PublicMethod colorWithHexValue:0xcdcdcd alpha:1.0f];
    
    [cell addSubview:moneyLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 85, priceLabel.bottom , 75, 24);
    [button setTitle:entity.goods_status_name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    if ([entity.goods_status intValue] == 1)
    {
        button.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0f];
        button.enabled = NO;
    }
    if ([entity.goods_status intValue] == 2)
    {
        button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        button.tag = 101;
    }
    if ([entity.goods_status intValue] == 3)
    {
        button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
        button.tag = 102;
    }
    if ([entity.goods_status intValue] == 4)
    {
        button.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0f];
        button.enabled = NO;
    }
//    goodID = entity.iid;
    [button setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0f] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(addcart:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 10, button.bottom + 5, SCREEN_WIDTH - imageView.width - 20 - 85, 20)];
    storeLabel.backgroundColor = [UIColor clearColor];
    
    CGFloat a;
    a = ([entity.salse_num floatValue] - [entity.salse_deductions_num floatValue])/([entity.salse_num floatValue]);
    NSString *str = @"%";
    int b = a*100;
    
    storeLabel.text = [NSString stringWithFormat:@"可抢购库存：%d%@",b,str];
    storeLabel.font = [UIFont systemFontOfSize:10];
    storeLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0f];
//    if ([entity.is_or_not_salse intValue] == 1&&[entity.salse_num intValue] > 0)
//    {
//        [cell addSubview:storeLabel];
//        
//    }
    
    UIView *progressBg = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - button.width, button.bottom + 10, button.width, 10)];
    progressBg.layer.borderColor = [PublicMethod colorWithHexValue1:@"#53d769"].CGColor;
    progressBg.layer.borderWidth = 1.0;
    
    if ([entity.out_of_stock integerValue] != 1)
    {
    
        if ([entity.is_or_not_salse intValue] == 1&&[entity.salse_num intValue] > 0)
        {
            [cell addSubview:storeLabel];
            [cell addSubview:progressBg];
            
        }
        
    }
    
    
    
    UIView *progress = [[UIView alloc]init];
    progress.backgroundColor = [PublicMethod colorWithHexValue:0x53d769 alpha:1.0f];
    
    if (a>=0)
    {
        progress.frame = CGRectMake(0, 0, a*progressBg.width, 10);
        [progressBg addSubview:progress];
    }
   
    UIView * xline;
    if (indexPath.row == 0)
    {
        if ((entity.goods_introduction.length == 0)||!entity.goods_introduction||(entity.goods_introduction== nil))
        {
            xline = [[UIView alloc]initWithFrame:CGRectMake(0, 149, SCREEN_WIDTH, 1)];
            xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0] ;
        }
        else
        {
            xline = [[UIView alloc]initWithFrame:CGRectMake(0, 164, SCREEN_WIDTH, 1)];
            xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0] ;
        }
    }
    else
    {
        if ((entity.goods_introduction.length == 0)||!entity.goods_introduction||(entity.goods_introduction== nil))
        {
            xline = [[UIView alloc]initWithFrame:CGRectMake(0, 139, SCREEN_WIDTH, 1)];
            xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0] ;
        }
        else
        {
            xline = [[UIView alloc]initWithFrame:CGRectMake(0, 154, SCREEN_WIDTH, 1)];
            xline.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0] ;
        }
    }
    
  
    [cell addSubview:xline];

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyActiviteListEntity *entity ;
    //= [[GoodsEntity alloc]init];
    entity = [dataArray objectAtIndex:indexPath.row];
    
    
    YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
    NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.iid,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
    detaiVC.url = url;
    [detaiVC setMainGoodsUrl:url goodsID:entity.iid];
    [self.navigationController pushViewController:detaiVC animated:YES];


}
-(void)addcart:(id)button
{
    UIButton * btn = (UIButton *)button;
    NSLog(@"[[btn superview] superview] = %@" , [[btn superview] superview]);
    NSLog(@"[[btn superview] superview] = %@" , [btn superview]);
    NSLog(@"[[btn superview] superview] = %@" , [[[btn superview] superview] superview]);
    UITableViewCell * cell ;
    if (IOS_VERSION >= 8)
    {
        cell= (UITableViewCell*)[btn superview];
    }
    else
    {
        cell= (UITableViewCell*)[[btn superview] superview];
    }
    
    
    NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
    BuyActiviteListEntity *entity = (BuyActiviteListEntity *)[dataArray objectAtIndex:indexPath.row];
    goodID = entity.iid;
    if (btn.tag == 101)
    {
        [MTA trackCustomKeyValueEvent:EVENT_ID5 props:nil];
        if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
            return;
        }
        //加入购物车
        if (entity.transaction_type.integerValue == 0)
        {
            [[NetTrans getInstance] addCart:self GoodsID:goodID Total:@"1"];

        }
        //立即购买
        else
        {
            good_id = goodID;
            total = @"1";
            
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:good_id total:total];
        
        }
    }
    if (btn.tag == 102) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"原价购买" message:@"本商品抢购活动已结束，已经恢复抢购前的价格，您确定以抢购前价格购买么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        transaction_type = entity.transaction_type;
        alertView.tag = 1000;
        [alertView show];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        [MTA trackCustomKeyValueEvent:EVENT_ID5 props:nil];
        if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
            return;
        }
        //加入购物车
        if (transaction_type.integerValue == 0)
        {
            [[NetTrans getInstance] addCart:self GoodsID:goodID Total:@"1"];
            
        }
        //立即购买
        else
        {
            good_id = goodID;
            total = @"1";
            
            [[NetTrans getInstance] buy_confirmOrder:self CouponId:nil lm_id:nil goods_id:good_id total:total];
            
        }
    }
}


-(void)addBackNav
{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 40);
    rightBtn.titleLabel.numberOfLines = 2;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn setTitle:@"抢购说明" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}


//跳转到抢购说明
-(void)rightItemClick:(id)button
{
    YHForInstructionsViewController *fic = [[YHForInstructionsViewController alloc]init];
    [self.navigationController pushViewController:fic animated:YES];
}

-(void)back:(id)button
{
    [self.navigationController popViewControllerAnimated:YES];
    [self stopTimer];
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    //抢购活动信息
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_YH_BUY_ACTIVITY_INFO)
    {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        NSString *currentTime = [formatter stringFromDate:[NSDate date]];
        NSLog(@"22222222222%@",currentTime);
        date_EC1 = [NSDate date];
        NSLog(@"date_EC1 = %@" , date_EC1);
        [infoArray removeAllObjects];
        infoArray = [[NSMutableArray alloc]init];
        infoArray =  (NSMutableArray *)netTransObj;
        pages = 1;
        dataArray = [[NSMutableArray alloc] init];
//        infoArray = [[NSMutableArray alloc]init];
        goodListArray = [[NSMutableArray alloc]init];
        //当抢购没有活动的时候
        if (infoArray.count == 0)
        {
            //显示笑脸图案
            [self addUI];
        }
        else
        {
            //显示活动信息
            for (UIView * view in [self.view subviews])
            {
                [view removeFromSuperview];
            }
            [self createUI];
            [self headView];
        }
    }
    if(nTag == t_API_YH_BUY_ACTIVITY_LIST)
    {
        [goodListArray removeAllObjects];
       
        goodListArray = (NSMutableArray *)netTransObj;

        if (pages > 1)
        {
            if ([goodListArray count] == 0)
            {
                [[iToast makeText:@"已加载全部数据"] show];
                pages--;
            }
            else
            {
                [dataArray addObjectsFromArray:goodListArray];
            }
            
        }
        if (pages == 1)
        {
            [dataArray addObjectsFromArray:goodListArray];
            [self createUI];
        }
        [self performSelector:@selector(testFinishedLoadDataOther) withObject:nil afterDelay:0.0f];
        [_tableView reloadData];
    }
    if(nTag == t_API_ADDCART_GOODS)//t_API_ADDCART_GOODS
    {
        [[iToast makeText:@"添加到购物车成功"]show];
        [cartView changeCartNum];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *num = [userDefault objectForKey:@"cartNum"];
        int numInt = [num intValue];
        if (num && numInt>=0) {
            numInt++;
            [userDefault setObject:[NSString stringWithFormat:@"%d",numInt] forKey:@"cartNum"];
            [[YHAppDelegate appDelegate] changeCartNum:[NSString stringWithFormat:@"%d",numInt]];
        } else if (num == nil) {
            numInt = 1;
            [userDefault setObject:[NSString stringWithFormat:@"%d",numInt] forKey:@"cartNum"];
            [[YHAppDelegate appDelegate] changeCartNum:[NSString stringWithFormat:@"%d",numInt]];
        }
        //刷新购物车
        
        if (self.cartBlock) {
            self.cartBlock ();
        }
    }//立即购买
    else if (nTag == t_API_BUY_PLATFORM_SUBMITORDER_API){
        YHNewOrderViewController *orderCart = [[YHNewOrderViewController alloc] init];
        orderCart.transaction_type = @"1";
        orderCart.goods_id = good_id;
        orderCart.total = total;
        orderCart.immdiateBuy = YES;
        orderCart.entity = (OrderSubmitEntity *)netTransObj;
        [self.navigationController pushViewController:orderCart animated:YES];
    }
}

#pragma mark ------------  CartViewDelegate
-(void)cartViewClickAction
{
    if ([[YHAppDelegate appDelegate] checkLogin] == NO)
    {
        return;
    }
    YHCartViewController *cart = [[YHCartViewController alloc] init];
    cart.isFromOther = YES;
    [self.navigationController pushViewController:cart animated:YES];
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [[iToast makeText:errMsg] show];
}

-(void)setFooterView
{
    //    UIEdgeInsets test = self._tableView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    //    height = self._tableView.contentSize.height;
    if (refreshFooterOtherView && [refreshFooterOtherView superview]) {
        // reset position
        refreshFooterOtherView.frame = CGRectMake(0.0f,
                                                  height,
                                                  _tableView.frame.size.width,
                                                  self.view.bounds.size.height);
    }else {
        // create the footerView
        refreshFooterOtherView = [[EGORefreshTableFooterOtherView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             _tableView.frame.size.width, self.view.bounds.size.height)];
        refreshFooterOtherView.delegate = self;
        [_tableView addSubview:refreshFooterOtherView];
    }
    
    if (refreshFooterOtherView) {
        [refreshFooterOtherView refreshLastOtherUpdatedDate];
    }
    
    NSString * str_num = [(BuyActiviteListEntity *)[dataArray lastObject] total];
    
    if ([str_num intValue] == [dataArray count])
    {
        if (refreshFooterOtherView)
        {
            [refreshFooterOtherView removeFromSuperview];
            [[refreshFooterOtherView superview] removeFromSuperview];
            refreshFooterOtherView = nil;
        }
    }
}
#pragma mark ------------------------------- 上拉加载
-(void)testFinishedLoadDataOther
{
    [self finishReloadingData];
    [self setFooterView];
}

- (void)finishReloadingData
{
    _reloadingOther = NO;
    if (refreshFooterOtherView)
    {
        [refreshFooterOtherView egoRefreshOtherScrollViewDataSourceDidFinishedLoading:_tableView];
        //        [refreshFooterOtherView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}
/*加载更多接口请求*/
-(void)getMoreData
{
    //    [self removeFooterView];
    pages ++;
    //NSString * str_num = [NSString stringWithFormat:@"%d" , pages];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[NetTrans getInstance] API_YH_Card_List:self pages:str_num Type:@"2" block:^(NSString *someThing) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
    
    int num = [selectNum intValue];
    FixedToSnapUpEntity *entity = [[FixedToSnapUpEntity alloc]init];
    entity = (FixedToSnapUpEntity *)infoArray[num];
    int act_id = [entity.activity_id intValue];
//    [[NetTrans getInstance]API_YH_Buy_Activity_List:self activity_id:act_id page:pages limit:10];
    [[NetTrans getInstance]API_YH_Buy_Activity_List:self type:@"panic_buying" activity_id:act_id page:pages limit:10];
    
    [self testFinishedLoadDataOther];
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (refreshFooterOtherView)
    {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidScroll:_tableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (refreshFooterOtherView)
    {
        [refreshFooterOtherView egoRefreshOtherScrollViewDidEndDragging:_tableView];
    }
}

#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerOtherRefresh:(EGORefreshPos)aRefreshPos
{
    
    [self beginToReloadData:aRefreshPos];
    
}
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
    
    //  should be calling your tableviews data source model to reload
    _reloadingOther = YES;
    if(aRefreshPos == EGORefreshOtherFooter){
        // pull up to load more data
        [self performSelector:@selector(getMoreData) withObject:nil afterDelay:1.0];
    }
    // overide, the actual loading data operation is done in the subclass
}

- (BOOL)egoRefreshTableDataSourceIsOtherLoading:(UIView *)view
{
    
    return _reloadingOther; // should return if data source model is reloading
    
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastOtherUpdated:(UIView *)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
