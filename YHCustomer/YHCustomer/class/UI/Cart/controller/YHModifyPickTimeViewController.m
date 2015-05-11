//
//  YHModifyPickTimeViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-1-18.
//  Changed by dujinxin on 14-10-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  修改自提时间

#import "YHModifyPickTimeViewController.h"
#import "YHTimeView.h"

@interface YHModifyPickTimeViewController (){
    UIButton *btn;
    
    PSModel model;
    YHTimeView * _yhTimeView;
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
    
    NSMutableArray *_hourMinuteArray;
    NSMutableArray *_sevenWeekDayArray;
    NSMutableArray *_sevenDayArray;
    NSMutableArray *_sevenDateArray;
    NSMutableArray *_dateArray;
    NSString * _dateString;
    NSString * _hourString;

    
    UIButton * _resignBtn;
}

@end

@implementation YHModifyPickTimeViewController

@synthesize time_id = _time_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _sevenWeekDayArray = [[NSMutableArray alloc]init ];
        _sevenDayArray = [[NSMutableArray alloc]init ];
        _sevenDateArray = [[NSMutableArray alloc]init ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"修改自提时间";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTime) name:@"changeTime" object:nil];
    
    // 选择自提时间
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 300, 25);
    [btn setTitle:@"  请选择自提时间" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn addTarget:self action:@selector(showPickupTimeView) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:btn];

    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10, 65, 300, 42);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    [confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 0.0)];
//    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"cart_Confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    
    _resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_yhTimeView.frame.size.height);
    _resignBtn.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.5];
    [_resignBtn addTarget:self action:@selector(resignTimeView:) forControlEvents:UIControlEventTouchUpInside];
    
    //自提时间列表
    [[PSNetTrans getInstance] get_PickUp_Time:self ReginId:[UserAccount instance].region_id];
}

/*确认修改*/
- (void)confirmBtnClicked:(id)sender{
    if (self.showTimeString.length == 0)
    {
        [self showNotice:@"请选择修改时间"];
        return;
    }

    [[NetTrans getInstance] buy_modifyOrderTime:self Bu_id:self.order_list_id Time:self.time_id];
}

// 传入时间－转换时间戳
//- (NSString * )NSStringToNSDate: (NSString * )string
//{
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
//    NSDate *date1 = [formatter dateFromString :string];
//    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
//    selectInterval = (long)[date1 timeIntervalSince1970];
//    NSLog(@"date is %@",date1);
//    return timeStamp;
//}

- (void)back:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showPickupTimeView{
    //自提时间
    NSInteger totalHeight = 0;
    if (_hourMinuteArray.count == 0) {
        totalHeight = 0;
    }
    else{
        if (_hourMinuteArray.count %5 ==0) {
            totalHeight = (_hourMinuteArray.count/5)* 40 + 1* (_hourMinuteArray.count/5 -1);
        }else{
            totalHeight = (_hourMinuteArray.count/5 + 1)* 40 + 1* (_hourMinuteArray.count/5);
        }
    }
    _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - totalHeight, SCREEN_WIDTH, 94 + totalHeight)];
    //给week,day赋值，以及状态颜色
    [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:nil canSelectDays:_support_days psModel:Fetch isToday:YES];
    NSLog(@"time_id:%@",_dateString);
    //具体日期显示
    if (_support_days <4) {
        [_yhTimeView setDateLabelText:[NSString stringWithFormat:@"%@",[_sevenDateArray objectAtIndex:3]]];
    }else{
        [_yhTimeView setDateLabelText:[NSString stringWithFormat:@"%@",[_sevenDateArray objectAtIndex:7-_support_days]]];
    }
    BOOL today = YES;
    if(_select_days == _support_days){
        today = NO;
    }else{
        today = YES;
    }
    [_yhTimeView addHourViewWithArray:_hourMinuteArray height:totalHeight fastestPickUpTime:[self calculatorFpTime:_selectTime] selectTime:[self selectTimeForCompareA:[_hourMinuteArray objectAtIndex:0] withB:_selectTime]
                        selectDay:_select_days supportDay:_support_days calumnNumber:5];
    _yhTimeView.sevenDateArray = [NSMutableArray arrayWithArray:_sevenDateArray];
    _yhTimeView.target  = self;
    _yhTimeView.action = @selector(resignTimeView:);
    YHModifyPickTimeViewController * vc = self;
    _yhTimeView.hourSelectCB = ^(YHTimeView * view){
        vc->_yhTimeView.hourString = view.string;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTime" object:nil];
        [vc changeTime];
        [vc resignTimeView:nil];
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_yhTimeView];
    
    _resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_yhTimeView.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:_resignBtn];
}
- (void)resignTimeView:(UIButton *)btn{
    if (_yhTimeView.hourString) {
        
        [_yhTimeView removeFromSuperview];
        [_resignBtn removeFromSuperview];
    }else{
        [self showNotice :@"请选择自体时间"];
    }
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
    if ([[arr objectAtIndex:1] integerValue]>0 &&[[arr objectAtIndex:1] integerValue] <=30) {
        f = [NSString stringWithFormat:@"%@:%d",[arr objectAtIndex:0],30];
    }else if([[arr objectAtIndex:1] integerValue]==0){
        f = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],@"00"];
    }else{
        f = [NSString stringWithFormat:@"%ld:%@",(long)[[arr objectAtIndex:0] integerValue]+1,@"00"];
    }
    return f;
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
            self.showTimeString = [NSString stringWithFormat:@"今天（%@月%@日）%@",month,day,_yhTimeView.hourString];
        }else if ([string hasSuffix:@"明天"]) {
            self.showTimeString = [NSString stringWithFormat:@"明天（%@月%@日）%@",month,day,_yhTimeView.hourString];
        }else{
            self.showTimeString = [NSString stringWithFormat:@"%@月%@日 %@",month,day,_yhTimeView.hourString];
        }
        NSString * time = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,_yhTimeView.hourString];
        [btn setTitle:self.showTimeString forState:UIControlStateNormal];
        _time_id = [PublicMethod NSStringToNSDate:time];
    }
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if (nTag == t_API_BUY_PLATFORM_ORDER_UPDATE)
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
    else if (nTag == t_API_PS_PICK_UP_TIME_INFO)
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

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_BUY_PLATFORM_ORDER_UPDATE) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.pickTimeBlock) {
            self.pickTimeBlock(self.showTimeString);
        }

    } else if (t_API_PS_PICK_UP_TIME_INFO == nTag) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSMutableArray *data = (NSMutableArray *)netTransObj;
            NSMutableDictionary *dic = [data objectAtIndex:0];
            
            PickUpTimeEntity *entity = [[PickUpTimeEntity alloc] init];
            entity.start_time = [dic objectForKey:@"start_time"];
            entity.end_time = [dic objectForKey:@"end_time"];
            entity.support_days = [dic objectForKey:@"support_days"];
            entity.fastest_pick_up_time = [dic objectForKey:@"fastest_pick_up_time"];
            entity.fastest_pick_up_time_min = [dic objectForKey:@"fastest_pick_up_time_min"];
            entity.date = [dic objectForKey:@"date"];
            
            /*时间小时分钟数组生成方法*/
            NSArray *start_time = [entity.start_time componentsSeparatedByString:@":"];
            NSArray *end_time = [entity.end_time componentsSeparatedByString:@":"];
            
            
            
            _fastest_pick_up_time =  [entity.fastest_pick_up_time integerValue];
            _fastest_pick_up_time_min =  [entity.fastest_pick_up_time_min integerValue];
            
            
            _startHour = [[start_time objectAtIndex:0] integerValue];
            _endHour = [[end_time objectAtIndex:0] integerValue];
            //开始与结束时间不为整点和半点时的处理
            if ([[start_time objectAtIndex:1] integerValue] <= 30){
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
            _support_days = [entity.support_days integerValue];
            
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
            long time = (long)[[PublicMethod NSStringToNSDateToSS:entity.date] longLongValue];
            //可选的自提开始时间--总的秒数
            NSString  *time_id;
            if ((time +60*_fastest_pick_up_time_min)%(60*30) == 0) {
                time_id = [[NSNumber numberWithLong:(time+60*_fastest_pick_up_time_min)]stringValue];
            }else{
                time_id = [[NSNumber numberWithLong:(time+60*_fastest_pick_up_time_min + 60*30-(time +60*_fastest_pick_up_time_min)%(60*30))]stringValue];
            }

            NSDate * defaultDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:time_id]];
            NSDate * firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:[[NSNumber numberWithLong:time]stringValue]]];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:[time_id longLongValue]]];
            
            
            
            //时间显示格式调整
            NSDateFormatter *showDateFormatter = [[NSDateFormatter alloc] init];
            [showDateFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSDateFormatter *showDayFormatter = [[NSDateFormatter alloc] init];
            [showDayFormatter setDateFormat:@"yyyyMMdd"];
           
            _dateArray = [[NSMutableArray alloc]init];
            
            
            /*年月日数组生成方法*/
            NSTimeInterval secondsPerDay = 24 * 60 * 60;
            
            NSDateFormatter *storeDateFormatter = [[NSDateFormatter alloc] init];
            [storeDateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            if ([comps day] == [[entity.date substringWithRange:NSMakeRange(8, 2)] integerValue]) {
                _select_days = _support_days;
            }else{
                if ([comps month] == [[entity.date substringWithRange:NSMakeRange(5, 2)] integerValue]) {
                    _select_days = _support_days - ([comps day] - [[entity.date substringWithRange:NSMakeRange(8, 2)] integerValue]);
                }else{
                    NSInteger days = 0;
                    NSInteger month = [[entity.date substringWithRange:NSMakeRange(5, 2)] integerValue];
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
                    _select_days = _support_days - (days + [comps day] - [[entity.date substringWithRange:NSMakeRange(8, 2)] integerValue]);
                    
                }
            }
            
            
            if ([comps minute]== 0) {
                _selectTime = [NSString stringWithFormat:@"%ld:%ld0",(long)[comps hour], (long)[comps minute]];
            }else{
                _selectTime = [NSString stringWithFormat:@"%ld:%ld",(long)[comps hour], (long)[comps minute]];
            }
            if (_select_days < 0) {
                _select_days = 0;
            }
            
            //七天显示时间计算
            
            
            if ([comps hour]>_endHour || (([comps hour]==_endHour) && ([comps minute]>[[end_time objectAtIndex:1] integerValue]))) {//不在自提时间内,结束时间-->24
                if (_support_days <= 4) {
                    for (int i = -3 ; i < 4; i ++ ) {
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
                }
                
                
            }


//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showAlert:@"抱歉,无自提时间可选择!"];
//                });
//            }
        
            
        });
        
        
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
