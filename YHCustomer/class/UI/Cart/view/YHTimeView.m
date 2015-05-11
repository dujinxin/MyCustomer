//
//  YHTimeView.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-5.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHTimeView.h"
#import "YHButtonInfo.h"

#define kSwitchTime
typedef enum {
    SwitchTimeDefault = 0,
    SwitchTimeSwipeLeftStyle,
    SwitchTimeSwipeRightStyle,
}SwitchTimeStyle;

@interface YHTimeView ()
{
    BOOL _swipeLeft;
    UIView * weekBgView;
    NSInteger fpHour;
    NSInteger fpDay;
    NSInteger supportday;
    NSInteger canSelectDay;
}

@end
@implementation YHTimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
        //    self.userInteractionEnabled = YES;
        [self initData];
        [self initDateView];
        [self initView];
        
        
    }
    return self;
}
#pragma mark - 数据初始化
- (void)initData
{
    _hourArray = [[NSMutableArray alloc] initWithObjects:@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00", nil];
    _btnArray = [[NSMutableArray alloc]init];
    
    fpHour = 9999;
    fpDay = 888;
    _selectHourTag = 88;
    self.sevenDateArray = [[NSMutableArray alloc]init];
    self.hourString = [[NSString alloc]init];
    self.string = [[NSString alloc]init];
}

#pragma mark - 初始化Date子控件
-(void)initDateView
{
    [self addWeekLabel];
    [self addDayScrollView];
    [self addDateLabel];
//    [self addHourView];
    
    
}
- (void)addWeekLabel
{
    //日期label（星期）
    weekBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
    weekBgView.backgroundColor = [PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0];
    [self addSubview:weekBgView];
    
//    CGFloat width = 35,height = 15;
//    CGFloat space = (320-35*7)/8;
//    for (int i = 0; i < 7; i++)
//    {
//        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(space + (space + width)* i, 10, width, height)];
//        lab.font = [UIFont boldSystemFontOfSize:9];
//        lab.backgroundColor = [UIColor clearColor];
//        lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
//        lab.text = [array objectAtIndex:i];
//        lab.textAlignment = NSTextAlignmentCenter;
//        [weekBgView addSubview:lab];
//    }
}
- (void)addDayScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 25, 320, 40)];
    _scrollView.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
    _scrollView.contentSize = CGSizeMake(320, 40);
    //    _scrollView.pagingEnabled = YES;
    //    _scrollView.userInteractionEnabled = YES; // 是否滑动
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _dayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    _dayBgView.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
//    [self addDayScrollViewWithSubViewWithDayArray:_dayArray];
}
- (void)addDayScrollViewAndSubViewsWithDays:(NSArray *)dayArray weekDays:(NSArray *)weekArray otherArray:(NSArray *)otherArray canSelectDays:(NSInteger)canSelectday psModel:(PSModel)model isToday:(BOOL)isToday
{
    //日期按钮（day）
    CGFloat width = 35,height = 35;
    CGFloat space = (320-35*7)/8;
    BOOL isLimited = YES;
    supportday = canSelectday;
    _model = model;
    _dayNumber = 3;

        for (int j = 0; j < dayArray.count; j++)
        {
            UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(space + (space + width)* j, 10, width, height -20)];
            lab.font = [UIFont boldSystemFontOfSize:10];
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = [PublicMethod colorWithHexValue:0xb1b1b1 alpha:1.0];
            lab.text = [weekArray objectAtIndex:j];
            if ([lab.text isEqualToString:@"六"] || [lab.text isEqualToString:@"日"]) {
                lab.textColor = [PublicMethod colorWithHexValue:0xb1b1b1 alpha:1.0];
            }else{
                lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
            }
            lab.textAlignment = NSTextAlignmentCenter;
            [weekBgView addSubview:lab];
            
            
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(space + (space + width)* j, 5, width, height)];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            btn.layer.cornerRadius = 35.f/2;
            btn.tag = 1 + j;
            btn.backgroundColor = [UIColor clearColor];
            [btn setEnabled:NO];
            [btn setTitleColor:[PublicMethod colorWithHexValue:0xa2a2a2 alpha:1.0] forState:UIControlStateNormal];
            if (canSelectday > 0 && canSelectday <=4)
            {
                if (canSelectday == 1)
                {
                    if (isToday) {
                        if (j == 3)
                        {
                            //                        lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
                            [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
                            [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                            [btn setEnabled:YES];
                            [btn setSelected:YES];
                            _selectDayTag = btn.tag;
                        }
                    }else{
                        if (model == Deliver) {
                            if (j == 4)
                            {
                                //                        lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setEnabled:YES];
                                [btn setSelected:YES];
                            }
                        }
                    }
                
                }else if (canSelectday >1){
                    if (j == 3) {
//                        lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
                        [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
                        [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                        [btn setEnabled:YES];
                        [btn setSelected:YES];
                        _selectDayTag = btn.tag;
                    }else if (j>3&& j-3 +1 <=canSelectday){
//                        lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
                        [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                        [btn setEnabled:YES];
                    }
                }
                
            }else {
                if (j == 7-canSelectday) {
//                    lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
                    [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
                    [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                    [btn setEnabled:YES];
                    [btn setSelected:YES];
                    _selectDayTag = btn.tag;
                }else if(j> 7-canSelectday){
//                    lab.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
                    [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                    [btn setEnabled:YES];
                }else{
                    [btn setTitleColor:[PublicMethod colorWithHexValue:0xa2a2a2 alpha:1.0] forState:UIControlStateNormal];
                    [btn setEnabled:NO];
                }
                
            }
            
            [btn setTitle:[dayArray objectAtIndex:j] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pickUpDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_dayBgView addSubview:btn];
            [_btnArray addObject:btn];
//            if ([btn.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",[CalendarDateUtil getCurrentDay]]])
//            {
//                isLimited = NO;
//                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
//                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
//                if (i == 0) {
//                    btn.tag = 0;
//                    _btnSelectDate = j;
//                }
//            }
            if(isLimited == NO){
                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                [btn setEnabled:YES];
            }
        }
        

    [_scrollView addSubview:_dayBgView];
}
- (void)addDateLabel
{
    //    NSDateFormatter *dateformat1=[[NSDateFormatter  alloc]init];
    //    [dateformat1 setDateFormat:@"yyyy年MM月dd日"];
    //    NSString* dateStr = [dateformat1 stringFromDate:[CalendarDateUtil dateSinceNowWithInterval:_scrollDate + _btnDate]];
    
    //当前选择的日期显示Label
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _scrollView.bottom, 320, 27)];
    //    dateLable.text = [NSString stringWithFormat:@"%@ 今天", dateStr];
//    dateLable.text = dateString;
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
    _dateLabel.backgroundColor = [PublicMethod colorWithHexValue:0xf7f7f7 alpha:1.0];
    _dateLabel.center = CGPointMake(160, _dateLabel.center.y);
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, _dateLabel.bottom, 320, 1)];
    view.backgroundColor = [PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0 ];
    [self addSubview:view];
}
- (void)addHourViewWithArray:(NSArray *)hourArray height:(NSInteger)totalHeight fastestPickUpTime:(NSString *)fpTimeString selectTime:(NSString *)selectTime selectDay:(NSInteger)selectDay supportDay:(NSInteger)supportDay calumnNumber:(NSInteger)number
{
    //时间选择按钮（hour）
    CGFloat space = 1.0f;
    CGFloat width = (320.f - (number -1)*space )/number;
    CGFloat height = 50.f;
    _hourBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _dateLabel.bottom + 1, 320, totalHeight)];
    _hourBgView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
//    [self addSubview:_hourBgView];
    
    NSUInteger index = [hourArray indexOfObject:[self calculatorFpTime:selectTime]];
    NSArray * fpArray = [fpTimeString componentsSeparatedByString:@":"];
    NSInteger hour = [[fpArray objectAtIndex:0] integerValue];
    NSInteger minute = [[fpArray objectAtIndex:1] integerValue];
    
    NSString * startString = [hourArray objectAtIndex:0];
    NSString * endString = [hourArray lastObject];
    NSInteger startHour = [[startString substringToIndex:2] integerValue];
    NSInteger startMinute = [[startString substringFromIndex:3] integerValue];
    NSInteger endHour = [[endString substringToIndex:2] integerValue];
    NSInteger endMinute = [[endString substringFromIndex:3] integerValue];
    canSelectDay = selectDay;
    supportday = supportDay;
    if (supportday >=canSelectDay) {
        fpDay = supportday - canSelectDay;
    }else{
        fpDay = supportday;
    }
    
    if (index == NSNotFound) {
        if (hour < startHour || (hour == startHour && minute < startMinute)) {
            fpTimeString = [hourArray objectAtIndex:0];
        }else if(hour > endHour || (hour == endHour && minute > endMinute)){
            fpTimeString = @"设置一个不匹配的时间达到不能匹配的效果";
        }
        
    }else{
        fpTimeString = [self calculatorFpTime:selectTime];
    }
    
    for (int i = 0; i < hourArray.count ; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 + (width + space) * (i%number), (height +space)* (i/number), width, height);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitle:[hourArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = i + 10;
        [btn setEnabled:NO];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
        btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //选中后的效果
        [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"选择时间背景-可拉伸小方块-从第8像素处拉伸"] forState:UIControlStateHighlighted];
        if (supportday == canSelectDay) {
            if ([[hourArray objectAtIndex:i]isEqualToString:fpTimeString]) {
                self.string = fpTimeString;
                fpHour = i + 10;
//                _selectHourTag = (fpDay + 1) * 100 + fpHour;
                //            btn.selected = YES;
                [btn setEnabled:YES];
                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                self.hourString = btn.currentTitle;
                
//                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
//                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
            }
            if (i > fpHour -10) {
                [btn setEnabled:YES];
                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
            }
        }else{
            if ([[hourArray objectAtIndex:i]isEqualToString:fpTimeString]) {
                fpHour = i + 10;
//                _selectHourTag = (fpDay + 1) * 100 + fpHour;
            }
            self.string = fpTimeString;
            self.hourString = btn.currentTitle;
        }
        
        NSLog(@"selectTag = %ld",(long)_selectHourTag);
        [btn addTarget:self action:@selector(pickupSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_hourBgView addSubview:btn];
    }
    [self addSubview:_hourBgView];
}
- (void)addHourViewWithArray:(NSArray *)hourArray height:(NSInteger)totalHeight selectTime:(NSString *)selectTime calumnNumber:(NSInteger)number
{
    //时间选择按钮（hour）
    CGFloat space = 1.0f;
    CGFloat width = (320.f - (number -1)*space )/number;
    CGFloat height = 50.f;
    _hourBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _dateLabel.bottom + 1, 320, totalHeight)];
    _hourBgView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
//    [self addSubview:_hourBgView];
//    if (_todayArray.count == 0) {
//        _todayArray = [NSMutableArray arrayWithArray:hourArray];
//    }
    
    for (int i = 0; i < hourArray.count ; i ++) {
        NSDictionary * dict = [hourArray objectAtIndex:i];
        /*
         "id": "2",//送货时间编码提交订单会用到
         "lm_id": "2",
         "title": "08点至10点",//送货选项名称
         "date_type": "1",//当日、次日标识 1当日 2次日
         "delivery_start_time": "00:00:00",
         "delivery_end_time": "09:30:00",
         "type": 0,//提示标识：1 提示 ，0 不提示
         "msg": "",//如果提示标识为1 ，则提示此字段的内容
         "is_use": 1//是否可用 1不可用 0可用
         */
        
        
        YHButtonInfo * btn = [YHButtonInfo buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 + (width + space) * (i%number), (height +space)* (i/number), width, height);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.titleLabel.numberOfLines = 0;
        [btn setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        btn.payId = [dict objectForKey:@"id"];
        btn.type = [dict objectForKey:@"type"];
        btn.msg = [dict objectForKey:@"msg"];
        
        if ([[dict objectForKey:@"is_use"]integerValue] ==1) {
            [btn setEnabled:NO];
            [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
        }else{
            [btn setEnabled:YES];
            [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
        }
        btn.tag = i;
        btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //选中后的效果
        [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"选择时间背景-可拉伸小方块-从第8像素处拉伸"] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(deliverySelect:) forControlEvents:UIControlEventTouchUpInside];
        [_hourBgView addSubview:btn];
    }
    [self addSubview:_hourBgView];
}

#pragma mark - 初始化手势
-(void)initView
{
    
    [self initSwipeGestureRecognizerLeft];
    [self initSwipeGestureRecognizerRight];
    
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];
    _timeString = [dateformat stringFromDate:[NSDate date]];
    //    _timeString = [dateformat stringFromDate:[CalendarDateUtil dateSinceNowWithInterval:_scrollDate + _btnDate]];
    [self httpFuction];
}

#pragma mark Push
-(void)pushBS
{
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark - 获取当前的时间----年，月，日，星期

#pragma mark - dayBtnClick
-(void)pickUpDayBtnClick:(id)sender
{
    UIButton* sendBtn = sender;
    _selectDayTag = sendBtn.tag;
    NSLog(@"_selectHourTag:%ld",(long)
          _selectHourTag);
    NSLog(@"_selectHourTag、100:%ld",
          (long)_selectHourTag% 100);
    NSLog(@"btn = %@", sendBtn.titleLabel.text);
    NSLog(@"btn.tag = %ld", (long)sendBtn.tag);
    NSLog(@"supportday = %ld",(long)supportday);
    NSLog(@"canSelectDay = %ld",(long)canSelectDay);
    NSLog(@"_fastest_pick_up_minutes = %ld",(long)(_fastest_pick_up_minutes % (24 *60) ? (_fastest_pick_up_minutes / (24 *60) +1):_fastest_pick_up_minutes / (24 *60)));
    NSLog(@"_fastest_pick_up_minutes = %ld",(long)_fastest_pick_up_minutes % (24 *60));
    NSLog(@"fpHour:%ld",(long)fpHour);
    NSLog(@"fpDay:%ld",(long)fpDay);

    for (int i = 0; i < [_btnArray count]; i++)
    {
        UIButton* tmpBtn = [_btnArray objectAtIndex:i];
        tmpBtn.backgroundColor = [UIColor clearColor];
        if (tmpBtn.tag == sendBtn.tag)
        {
            tmpBtn.selected = YES;
            [tmpBtn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
            [tmpBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
            //详细日期显示的切换
            [self setDateLabelText:[self.sevenDateArray objectAtIndex:tmpBtn.tag -1]];
        }else {
            if(tmpBtn.enabled == YES){
                [tmpBtn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
            }
            [tmpBtn setBackgroundColor:[UIColor clearColor]];
            tmpBtn.selected = NO;
        }
        
        if (_model == Fetch) {
            //下边小时的切换
            if (supportday>4) {
                if (fpDay + 1 + 7- supportday> sendBtn.tag) {
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            [btn setEnabled:NO];
                            [btn setSelected:NO];
                            [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
                            btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            if (btn.tag == _selectHourTag - sendBtn.tag * 100) {
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
                            }
                        }
                    }
                }else if (fpDay + 1 + 7- supportday == sendBtn.tag){
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            if (btn.tag  >= fpHour) {
                                [btn setEnabled:YES];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }else{
                                [btn setEnabled:NO];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                            if (btn.tag == _selectHourTag - sendBtn.tag * 100) {
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
                            }
                        }
                    }
                }else{
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            [btn setEnabled:YES];
                            [btn setSelected:NO];
                            [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                            btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            if (btn.tag == _selectHourTag - sendBtn.tag * 100) {
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
                            }
                        }
                    }
                }

                /*
                if (i> 7- supportday && tmpBtn.enabled && tmpBtn.selected) {
                    //                self.hourString = [[_hourBgView.subviews objectAtIndex:0]currentTitle];
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            [btn setEnabled:YES];
                            if (btn.tag == 0) {
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                            }else{
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                            
                        }
                    }
                }
                else if(i == 7 -supportday && tmpBtn.enabled && tmpBtn.selected){
                    //                self.hourString = self.string;
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            if (btn.tag > fpHour) {
                                [btn setEnabled:YES];
                                //                            [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }else if (btn.tag == fpHour) {
                                btn.selected =YES;
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                //                            [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
                                //                            btn.backgroundColor = [PublicMethod colorWithHexValue:0xff3b30 alpha:1.0];
                            }else{
                                [btn setEnabled:NO];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                        }
                    }
                }
                */
            }else{
                
                if (fpDay + 4 > sendBtn.tag) {
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            [btn setEnabled:NO];
                            [btn setSelected:NO];
                            [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
                            btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            if (btn.tag == _selectHourTag - sendBtn.tag * 100) {
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
                            }
                        }
                    }
                }else if (fpDay + 4 == sendBtn.tag){
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            if (btn.tag  >= fpHour) {
                                [btn setEnabled:YES];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }else{
                                [btn setEnabled:NO];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                            if (btn.tag == _selectHourTag - sendBtn.tag * 100) {
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
                            }
                        }
                    }
                }else{
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            [btn setEnabled:YES];
                            [btn setSelected:NO];
                            [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                            btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            if (btn.tag == _selectHourTag - sendBtn.tag * 100) {
                                [btn setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
                            }
                        }
                        
                    }
                }
                
                /*
                if (i > 3 && tmpBtn.enabled && tmpBtn.selected) {
                    //                self.hourString = [[_hourBgView.subviews objectAtIndex:0]currentTitle];
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            
                            if (canSelectDay == supportday) {
                                [btn setEnabled:YES];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                            
                            
                            [btn setEnabled:YES];
                            if (btn.tag == 0) {
                                //                            btn.selected =YES;
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                            }else{
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                            
                        }
                    }
                }
                else if(i == 3 && tmpBtn.enabled && tmpBtn.selected){
                    //                self.hourString = self.string;
                    for (UIView * view in _hourBgView.subviews){
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton * btn = (UIButton *)view;
                            if (btn.tag > fpHour) {
                                [btn setEnabled:YES];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }else if (btn.tag == fpHour) {
                                //                            btn.selected =YES;
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState:UIControlStateNormal];
                            }else{
                                [btn setEnabled:NO];
                                [btn setSelected:NO];
                                [btn setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState:UIControlStateNormal];
                                btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                            }
                        }
                    }
                }
                 */
            }
            
        }else{
            //配送切换
            if ( i == sendBtn.tag -1 && i == 3) {
                self.dayNumber = 3;
//                _totalHeight = 0;
//                if (self.tomorrowArray.count %3 ==0) {
//                    _totalHeight = (self.tomorrowArray.count/3)* 40 + 1* (self.tomorrowArray.count/3 -1);
//                }else{
//                    _totalHeight = (self.tomorrowArray.count/3 + 1)* 40 + 1* (self.tomorrowArray.count/3);
//                }
                [_hourBgView removeAllSubviews];
                [_hourBgView removeFromSuperview];
                _hourBgView = nil;
                if (_daySelectCB) {
                    _daySelectCB(self);
                }
                //            [self addHourViewWithArray:self.tomorrowArray height:totalHeight selectTime:nil calumnNumber:3];
            }else if ( i == sendBtn.tag -1 && i == 4){
                self.dayNumber = 4;
                
                [_hourBgView removeAllSubviews];
                [_hourBgView removeFromSuperview];
                _hourBgView = nil;
                if (_daySelectCB) {
                    _daySelectCB(self);
                }
                //            [self addHourViewWithArray:self.todayArray height:totalHeight selectTime:nil calumnNumber:3];
            }
        }

    }

}

#pragma mark -
#pragma mark - setButtonTitle // 修改Btn的日期

#pragma mark -
#pragma mark - addSwipeGesture
-(void)initSwipeGestureRecognizerLeft
{
    UISwipeGestureRecognizer *oneFingerSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
    
    [oneFingerSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_dayBgView addGestureRecognizer:oneFingerSwipe];
}
-(void)initSwipeGestureRecognizerRight
{
    UISwipeGestureRecognizer *oneFingerSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeRight:)];
    
    [oneFingerSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [_dayBgView addGestureRecognizer:oneFingerSwipe];
}
#pragma mark - UISwipeGestureEvents
- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    
}
- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{

}
#pragma mark request delegate

-(void)httpFuction
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)deliverySelect:(YHButtonInfo *)btn
{
    self.string = [NSString stringWithString: btn.currentTitle];
    self.hourString = btn.currentTitle;
    [btn setHighlighted:YES];
    [btn setSelected:YES];
    NSLog(@"点击：%@",[NSString stringWithFormat:@"%@ %@",_dateLabel.text, btn.currentTitle]);
    
    for (UIView * view in _hourBgView.subviews) {
        if ([view isKindOfClass:[YHButtonInfo class]]) {
            YHButtonInfo * button = (YHButtonInfo * )view;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            if (button.tag == btn.tag){
                self.hourString = button.currentTitle;
                button.selected = YES;
                [button setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                [button setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
            }
            else{
                button.selected = NO;
                [button setBackgroundColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
                if(button.enabled == YES){
                    [button setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState: UIControlStateNormal];
                }else{
                    [button setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState: UIControlStateNormal];
                }
                
            }
            [UIView commitAnimations];
        }
    }
    self.deliveryId = btn.deliveryId;
    self.msg = btn.msg;
    self.type = btn.type;
    self.payId = btn.payId;
    if (self.payId) {
        if (_hourSelectCB) {
            _hourSelectCB(self);
        }
    }
}
- (void)pickupSelect:(UIButton *)btn
{
    self.string = [NSString stringWithString: btn.currentTitle];
    self.hourString = btn.currentTitle;
    [btn setHighlighted:YES];
    [btn setSelected:YES];
    _selectHourTag = _selectDayTag * 100 + btn.tag;
    NSLog(@"点击：%@",[NSString stringWithFormat:@"%@ %@",_dateLabel.text, btn.currentTitle]);

    if (_hourSelectCB) {
        _hourSelectCB(self);
    }
    for (UIView * view in _hourBgView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton * )view;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            if (button.tag == btn.tag){
                self.hourString = button.currentTitle;
                button.selected = YES;
                [button setBackgroundColor:[PublicMethod colorWithHexValue:0xff3b30 alpha:1.0]];
                [button setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState: UIControlStateNormal];
            }
            else{
                button.selected = NO;
                [button setBackgroundColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
                if(button.enabled == YES){
                    [button setTitleColor:[PublicMethod colorWithHexValue:0x000000 alpha:1.0] forState: UIControlStateNormal];
                }else{
                    [button setTitleColor:[PublicMethod colorWithHexValue:0xcccccc alpha:1.0] forState: UIControlStateNormal];
                }
                
            }
            [UIView commitAnimations];
        }
    }
}
- (NSString *)calculatorFpTime:(NSString *)timeString{
    //最快自提时间对比，计算
//    NSString * fpTimeString = [timeString substringFromIndex:11];
    NSString * f ;
    NSArray * arr = [timeString componentsSeparatedByString:@":"];
    if ([[arr objectAtIndex:1] integerValue]>0 &&[[arr objectAtIndex:1] integerValue] <=30) {
        f = [NSString stringWithFormat:@"%@:%d",[arr objectAtIndex:0],30];
    }else if([[arr objectAtIndex:1] isEqualToString:@"00"]){
        f = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],@"00"];
    }else{
        f = [NSString stringWithFormat:@"%ld:%@",(long)[[arr objectAtIndex:0] integerValue]+1,@"00"];
    }
    return f;
}
- (void)setDateLabelText:(NSString *)dateString
{
    _dateLabel.text = dateString;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
