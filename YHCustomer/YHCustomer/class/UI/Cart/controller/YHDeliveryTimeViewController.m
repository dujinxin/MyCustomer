//
//  YHDeliveryTimeViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-3-11.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHDeliveryTimeViewController.h"
#import "YHTimeView.h"

@interface YHDeliveryTimeViewController (){
    UIButton *btn;

    NSTimeInterval selectInterval;
    
    UIButton        *phoneConfirmBtn;       // 电话确认
    UIButton        *phoneNoConfirmBtn;     // 不确认
    
    YHTimeView * _yhTimeView;
    PSModel model;
    NSInteger _support_days;
    NSString * currentTime;
    NSMutableArray *_hourMinuteArray;
    NSMutableArray *_sevenWeekDayArray;
    NSMutableArray *_sevenDayArray;
    NSMutableArray *_sevenDateArray;
    NSMutableArray *_dateArray;
    NSString * _dateString;
    NSString * _hourString;
    //cell 上的子控件
    UILabel *_timeLabel;
    
    NSInteger  selectRow;
}

@end

@implementation YHDeliveryTimeViewController

@synthesize time_id = _time_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _entity = [[LogisticModelEntity alloc ]init ];
        _sevenWeekDayArray = [[NSMutableArray alloc]init ];
        _sevenDayArray = [[NSMutableArray alloc]init ];
        _sevenDateArray = [[NSMutableArray alloc]init ];
        _isFromPSDeliveryOrder = NO;
        _isFromConfirmOrder = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择时间";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self chooseDeliveryTime];
//    });
    
}

- (void)back:(id)sender{
    if (_isFromPSDeliveryOrder) {
        if (self.deliveryBlock) {
            if (_yhTimeView.payId && _yhTimeView.hourString) {
                self.deliveryBlock(_yhTimeView.hourString,[ NSString stringWithFormat:@"%@", _yhTimeView.dateLabel.text],_sevenDateArray,_yhTimeView.payId,_yhTimeView.type, _yhTimeView.msg);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (_isFromConfirmOrder) {
        if (self.showTimeString.length == 0)
        {
            [self showNotice:@"您还没有选择修改时间"];
            return;
        }else{
            [[NetTrans getInstance] buy_modifyOrderTime:self Bu_id:self.order_list_id Time:self.time_id];
        }
    }
}
- (void)chooseDeliveryTime{
    
    currentTime = _entity.now_date;
    
    long time = (long)[[PublicMethod NSStringToNSDateToSS:_entity.now_date] longLongValue];
    NSString * timeStr = [[NSNumber numberWithLong:time] stringValue];
    NSDate *firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:timeStr]];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
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
    
    if (_entity.date_num.integerValue == 2 ||_entity.date_num.integerValue == 1) {
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
        
    }
    
    
    
    
    //自提时间
    NSMutableArray * todayArray ;
    NSMutableArray * tomorrowArray;
    if ([_entity.delivery_time objectForKey:@"today"]) {
        todayArray = [_entity.delivery_time objectForKey:@"today"];
    }else{
        todayArray = [[NSMutableArray alloc]init];
    }
    if ([_entity.delivery_time objectForKey:@"tomorrow"]) {
        tomorrowArray = [_entity.delivery_time objectForKey:@"tomorrow"];
    }else{
        tomorrowArray = [[NSMutableArray alloc]init];
    }
    NSInteger todayHeight = 0;
    NSInteger tomorrowHeight = 0;
    if (todayArray.count != 0) {
        if (todayArray.count %3 ==0) {
            todayHeight = (todayArray.count/3)* 50 + 1* (todayArray.count/3 -1);
        }else{
            todayHeight = (todayArray.count/3 + 1)* 50 + 1* (todayArray.count/3);
        }
    }
    if (tomorrowArray.count != 0) {
        if (tomorrowArray.count %3 ==0) {
            tomorrowHeight = (tomorrowArray.count/3)* 50 + 1* (tomorrowArray.count/3 -1);
        }else{
            tomorrowHeight = (tomorrowArray.count/3 + 1)* 50 + 1* (tomorrowArray.count/3);
        }
    }
    
    
    //给week,day赋值，以及状态颜色
    if (_entity.date_num.integerValue == 2) {
        _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, todayHeight + 92)];
        [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:2 psModel:Deliver isToday:YES];
        //具体日期显示
        [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
        [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
    }else{
        if (tomorrowHeight == 0) {
            _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, todayHeight + 92)];
            [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:nil canSelectDays:1 psModel:Deliver isToday:YES];
            //具体日期显示
            [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
            [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }else{
            _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tomorrowHeight + 92)];
            [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:1 psModel:Deliver isToday:NO];
            //具体日期显示
            [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:4]];
            [_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }
        
    }
    NSLog(@"time_id:%@",_dateString);
    
    _yhTimeView.sevenDateArray = [NSMutableArray arrayWithArray:_sevenDateArray];
    YHDeliveryTimeViewController * vc = self;
    _yhTimeView.daySelectCB = ^(YHTimeView * view){
        if (view.dayNumber == 4) {
            vc->_yhTimeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 92 + tomorrowHeight);
            [vc->_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }else{
            vc->_yhTimeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 92 + todayHeight);
            [vc->_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }
        
    };
    _yhTimeView.hourSelectCB = ^(YHTimeView * view){
        vc->_yhTimeView.hourString = view.string;
//        vc->_selectDateString =[ NSString stringWithFormat:@"%@", vc->_yhTimeView.dateLabel.text];
//        [vc changeDeliveryTime];
        
        if (view.type.integerValue == 1 && [vc->_entity.title isEqualToString:@"半日达"]&& vc->_entity.title.length != 0) {
            if (view.msg.length == 0) {
                //
            }else{
                [vc showAlert:view.msg];
            }
        }
        if (vc->_isFromPSDeliveryOrder) {
            if (vc.deliveryBlock) {
                vc.deliveryBlock(vc->_yhTimeView.hourString,[ NSString stringWithFormat:@"%@", vc->_yhTimeView.dateLabel.text],vc->_sevenDateArray,vc->_yhTimeView.payId,vc->_yhTimeView.type, vc->_yhTimeView.msg);
            }
            [vc.navigationController popViewControllerAnimated:YES];
        }
        if (vc->_isFromConfirmOrder) {
            if (vc.showTimeString.length == 0)
            {
                [vc showNotice:@"您还没有选择修改时间"];
                return;
            }else{
                [[NetTrans getInstance] buy_modifyOrderTime:vc Bu_id:vc.order_list_id Time:vc.time_id];
            }
        }
    };
    [self.view addSubview:_yhTimeView];

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
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
