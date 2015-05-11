//
//  YHSignInViewController.m
//  YHCustomer
//
//  Created by 白利伟 on 14/11/12.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHSignInViewController.h"
#import "NSDate+convenience.h"
#import "SignInEntity.h"

@interface YHSignInViewController ()
{
    UIButton * btn;
    VRGCalendarView *calendar;
    UILabel * myTextView;
    UILabel * lab_1;
    UIScrollView * myScrollView;
    NSMutableDictionary * dicDate;
    NSMutableArray * arrDate;
    SignInEntity * siginE ;
    BOOL isBtn;
    UIView * myView;
}
@end

@implementation YHSignInViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(IOS_VERSION>=7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.navigationItem.title = @"签到";
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)loadView
{
    [super loadView];
//    NSArray * arr = [NSArray arrayWithArray:<#(NSArray *)#>];
//    dicDate = [[NSMutableDictionary alloc] initWithObjects:@[@[[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5]] , @[[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8]] , @[[NSNumber numberWithInt:9] , [NSNumber numberWithInt:10] , [NSNumber numberWithInt:11] ] ] forKeys:@[@"201411" , @"201410" , @"201409"]];
//    [self addUI];
    [self addNavRightButton];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[NetTrans getInstance] user_getPersonInfo:self setUserId:[UserAccount instance].user_id];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_Sign_Info:self block:^(NSString *someThing)
    {
        if ([someThing isEqualToString:WEB_STATUS_4])
        {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
   
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillAppear:animated];
//    [calendar selectDate:<#(int)#>]
    [MTA trackPageViewBegin:PAGE100];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    //    [self setHidesBottomBarWhenPushed:NO];
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:PAGE100];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [[NetTrans getInstance] cancelRequestByUI:self];
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
-(void)addNavRightButton
{
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];//0xeeeeee
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
//    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//    [btn1 setTitle:@"今天" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(ToDay:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = BARBUTTON(@"今天", @selector(ToDay:));
//    UIBarButtonItem * rigBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//    self.navigationItem.rightBarButtonItem = rigBtn;
}

-(void)addUI
{
    if (myScrollView)
    {
        [myScrollView removeFromSuperview];
        myScrollView = nil;
    }
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT-20)];
    myScrollView.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
    [self.view addSubview:myScrollView];
    SignInEntity * tem = [arrDate lastObject];
    if (calendar)
    {
        [calendar removeFromSuperview];
        calendar = nil;
    }
   calendar = [[VRGCalendarView alloc] initDate:tem.date];
    calendar.delegate=self;
    [myScrollView addSubview:calendar];
}

#pragma mark -------------------------btn click
-(void)BackButtonClickEvent:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//签到
-(void)BtnClike:(id)sender
{
//    [calendar reset];
    [MTA trackCustomKeyValueEvent:EVENT_ID101 props:nil];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetTrans getInstance] API_Sign_In:self block:^(NSString *someThing) {
        if ([someThing isEqualToString:WEB_STATUS_4]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
    
//    [self getShowDate];
    /*
    NSString * strToday;
    if ([[NSDate date] month] < 10)
    {
        strToday = [NSString stringWithFormat:@"%d%d%d" , [[NSDate date] year] ,0, [[NSDate date] month]];
    }
    else
    {
        strToday = [NSString stringWithFormat:@"%d%d" , [[NSDate date] year] , [[NSDate date] month]];
    }
    NSArray * arr = [dicDate objectForKey:strToday];
    NSMutableArray * arr_1 = [[NSMutableArray alloc] initWithArray:arr];
    [arr_1 addObject:[NSNumber numberWithInt:[[NSDate date] day]]];
    [dicDate setValue:arr_1 forKey:strToday];
    int count = [[dicDate allKeys] count];
    for (int i = 0 ; i < count; i++)
    {
        NSRange rangeYear = NSMakeRange(0, 4);
        NSRange rangeMonth = NSMakeRange(4, 2);
        NSString * keyYearMonth = [[dicDate allKeys] objectAtIndex:i];
        NSString * yearStr = [keyYearMonth substringWithRange:rangeYear];
        NSString * monthStr = [keyYearMonth substringWithRange:rangeMonth];
        if ([calendar.currentMonth year] == [yearStr intValue])
        {
            if ([calendar.currentMonth month] == [monthStr intValue])
            {
                
                NSArray * arr = [dicDate objectForKey:keyYearMonth];
                [calendar markDates:arr];
            }
        }
    }
     */
//    [calendar markDates:@[[NSNumber numberWithInt:[[NSDate date] day]]]];
}
//返回到系统当前时间
-(void)ToDay:(id)sender
{
    [calendar reset];
}

#pragma mark -------------------------delegate

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSUInteger)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    /*
//    if ([calendarView.currentMonth year] == [[NSDate date] year])
//    {
//        if (month==[[NSDate date] month])
//        {
//            NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:13], nil];
////            NSArray *color = [NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],nil];
//            [calendarView markDates:dates];
//            //        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
//            //        [calendarView markDates:dates];
//        }
//    }
    
    
    if (siginE.date)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
        [df setDateFormat:@"yyyyMMddHHmmss"];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
        NSDate *date =[[NSDate alloc]init];
        date =[df dateFromString:siginE.date];
        if (!([date day] == [[NSDate date] day])&&([date month] == [[NSDate date] month])&&([date year]==[[NSDate date] year]))
        {
            [self showAlert:@"您的日期未与网络同步，请同步！"];
        }
    }
     */
    [myScrollView setContentOffset:CGPointMake(0, 0)];
    siginE = [arrDate lastObject];
    [self getShowDate];
    [self addBtnView:targetHeight];
    [self addTextView];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}


-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}

#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_SIGN_INFO == nTag)
    {
        arrDate = netTransObj;
        [self addUI];
    }
    else if(t_API_SIGNIN == nTag)
    {
        [self showAlert:netTransObj];
        isBtn = YES;
         [btn setTitle:@"已签到，记得明天再来哦" forState:UIControlStateNormal];
          [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
        [btn setEnabled:NO];
//        [self getNewEntity];
//        [self getShowDate];
         [[NetTrans getInstance] API_Sign_Info:self block:^(NSString *someThing) {
         }];
    }
}
-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(t_API_SIGN_INFO == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else
        {
            [[iToast makeText:errMsg]show];
        }
    }
    else if (t_API_SIGNIN == nTag)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
        }
        else
        {
            [[iToast makeText:errMsg]show];
        }
    }
}
#pragma  mark ------------------private

//签到成功后
-(void)getNewEntity
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate *date =[[NSDate alloc]init];
    date =[df dateFromString:siginE.date];
    NSString * strToday;
    if ([date month] < 10)
    {
        strToday = [NSString stringWithFormat:@"%lu%d%lu" , (unsigned long)[[NSDate date] year] ,0, (unsigned long)[[NSDate date] month]];
    }
    else
    {
        strToday = [NSString stringWithFormat:@"%lu%lu" , (unsigned long)[[NSDate date] year] , (unsigned long)[[NSDate date] month]];
    }
    NSMutableArray * arr_date = siginE.sign_record;
    NSInteger count1 = [arr_date count];
    
    NSMutableArray * arr_temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < count1; i++)
    {
        SignInEntity * tem_si = [arr_date objectAtIndex:i];
        NSString * str_temp = [[NSString alloc] initWithFormat:@"%@" , tem_si.year_month];
//        NSString * str_temp = tem_si.year_month;
        [arr_temp addObject:str_temp];
    }
    if ([arr_temp containsObject:strToday])
    {
        for (SignInEntity * temp in siginE.sign_record)
        {
            NSString * str_str = [[NSString alloc] initWithFormat:@"%@" , temp.year_month];
            if ([str_str isEqualToString:strToday])
            {
                NSString * str_tem = [NSString stringWithFormat:@"%@,%lu" , temp.sign_day , (unsigned long)[date day]];
//                [temp.sign_day stringByAppendingString:str_tem];
                temp.sign_day = str_tem;
                NSLog(@"temp.sign_day ======== %@" , temp.sign_day);
            }
        }
    }
    else
    {
        SignInEntity * temp = [[SignInEntity alloc] init];
        temp.sign_day = [NSString stringWithFormat:@"%lu" , (unsigned long)[date day]];
        temp.year_month =strToday;
        [siginE.sign_record addObject:temp];
    }
    NSLog(@"%@" , siginE.sign_record);
    for (int j = 0 ; j < [siginE.sign_record count]; j++)
    {
        SignInEntity * temp = [siginE.sign_record objectAtIndex:j];
        NSLog(@" temp.sign_day = =================%@" , temp.sign_day);
    }
}
//日历显示的数据处理
-(void)getShowDate
{
    if (dicDate)
    {
        [dicDate removeAllObjects];
        dicDate = nil;
    }
    dicDate = [[NSMutableDictionary alloc] init];
    if ([siginE.sign_record count] >0)
    {
        NSInteger count = [siginE.sign_record count];
        //        dicDate = [[NSMutableDictionary alloc] init];
        for (int i = 0 ; i < count; i++)
        {
            SignInEntity * siginE2 ;
            siginE2 = [siginE.sign_record objectAtIndex:i];
            NSArray * arr = [siginE2.sign_day componentsSeparatedByString:@","];
            NSString * str_ = [NSString stringWithFormat:@"%@" , siginE2.year_month];
            [dicDate setObject:arr forKey:str_];
        }
    }
    NSInteger count = [[dicDate allKeys] count];
    for (int i = 0 ; i < count; i++)
    {
        NSRange rangeYear = NSMakeRange(0, 4);
        NSRange rangeMonth = NSMakeRange(4, 2);
        NSString * keyYearMonth = [[dicDate allKeys] objectAtIndex:i];
        NSString * yearStr = [keyYearMonth substringWithRange:rangeYear];
        NSString * monthStr = [keyYearMonth substringWithRange:rangeMonth];
        if ([calendar.currentMonth year] == [yearStr intValue])
        {
            if ([calendar.currentMonth month] == [monthStr intValue])
            {
                NSArray * arr = [dicDate objectForKey:keyYearMonth];
                NSMutableArray * arr_a = [[NSMutableArray alloc] init];
                for (int j = 0 ; j< [arr count]; j++)
                {
                    NSString * str_int = [arr objectAtIndex:j];
                    NSNumber *a = [NSNumber numberWithInt:[str_int intValue]];
                    [arr_a addObject:a];
                }
                [calendar markDates:arr_a];
            }
        }
    }
}
//添加签到按钮
-(void)addBtnView:(float)hegit
{
    if (btn)
    {
        [btn removeFromSuperview];
        btn = nil;
    }
    btn = [[UIButton alloc] initWithFrame:CGRectMake(10, hegit+20, [UIScreen mainScreen].bounds.size.width-20, 40)];
   
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BtnClike:) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"%@" , [siginE.is_sign class]);
    NSString * str_signNum = [NSString stringWithFormat:@"%@" , siginE.is_sign];
    if ([str_signNum isEqualToString:@"1"])
    {
        [btn setEnabled:NO];
         [btn setTitle:@"已签到，记得明天再来哦" forState:UIControlStateNormal];
        [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
    }
    else
    {
        [btn setEnabled:YES];
         [btn setTitle:@"我要签到" forState:UIControlStateNormal];
        [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FC5860"]];
    }
    
    if (isBtn)
    {
        [btn setEnabled:NO];
        [btn setTitle:@"已签到，记得明天再来哦" forState:UIControlStateNormal];
        [btn setBackgroundColor:[PublicMethod colorWithHexValue1:@"#DDDDDD"]];
    }
    [myScrollView addSubview:btn];
}
//添加说明框
-(void)addTextView
{
    if (![siginE.content isEqualToString:@""] &&siginE.content)
    {
        if (myView)
        {
            [myView removeFromSuperview];
            myView= nil;
        }
        myView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+20, SCREEN_WIDTH, 0)];
        [myView setBackgroundColor:[PublicMethod colorWithHexValue1:@"#FFFFFF"]];
        [myScrollView addSubview:myView];
        if (lab_1)
        {
            [lab_1 removeFromSuperview];
            lab_1 = nil;
        }
        lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btn.frame)+20, SCREEN_WIDTH-20, 35)];
        lab_1.font = [UIFont systemFontOfSize:17];
        lab_1.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        lab_1.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
//        lab_1.layer.borderWidth = 1;
        lab_1.text = @"签到奖励";
//        lab_1.layer.borderColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"].CGColor;
        [myScrollView addSubview:lab_1];
        
        UIView * view_im1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab_1.frame)+1, SCREEN_WIDTH, 1)];
        if (IOS_VERSION < 7.0)
        {
            view_im1.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
        }
        else
        {
             view_im1.backgroundColor = [PublicMethod colorWithHexValue1:@"#EEEEEE"];
        }
        [myScrollView addSubview:view_im1];
        if (myTextView)
        {
            [myTextView removeFromSuperview];
            myTextView = nil;
        }
        myTextView = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view_im1.frame)+2, SCREEN_WIDTH-20, 0)];
//         myTextView.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
        myTextView.backgroundColor = [UIColor clearColor];
        myTextView.numberOfLines = 0;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
        myTextView.font  = font;
        myTextView.text =siginE.content;
        [myScrollView addSubview:myTextView];
        CGSize size;
         size = [siginE.content sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 10000000) lineBreakMode:NSLineBreakByWordWrapping];
         myTextView.textColor = [PublicMethod colorWithHexValue1:@"#333333"];
       
        CGRect rect = myTextView.frame;
       rect.size.height = size.height+10;
        [myTextView setFrame:rect];
        CGRect rect1 = myView.frame;
        rect1.size.height = size.height+20+lab_1.height;
        [myView setFrame:rect1];
        if (CGRectGetMaxY(myTextView.frame)+10 > SCREEN_HEIGHT - NAVBAR_HEIGHT- 20)
        {
            [myScrollView setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(myTextView.frame)+10)];
        }
        else
        {
            [myScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        }
    }
//    else
//    {
//         [myScrollView setContentSize:CGSizeMake(SCREEN_WIDTH,/* CGRectGetMaxY(myTextView.frame)+10*/SCREEN_HEIGHT+320)];
//    }
//    [self addSwif];
}
-(void)addSwif
{
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view  addGestureRecognizer:recognizer];

    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:recognizer];

    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [myScrollView addGestureRecognizer:recognizer];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
//    arrDate=nil;
//    myScrollView.scrollEnabled = YES;
    CGPoint point = [recognizer locationInView:myScrollView];
    if (point.y < calendar.height && point.x > 64)
    {
        myScrollView.scrollEnabled = NO;
        if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
            
            NSLog(@"swipe down");
            [calendar showPreviousMonth];
            //执行程序
        }
        if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
            
            NSLog(@"swipe up");
            [calendar showNextMonth];
            //执行程序
        }
        
        
        
        if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
            
            NSLog(@"swipe left");
            [calendar showNextMonth];
            //执行程序
        }
        
        
        
        if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
            
            NSLog(@"swipe right");
            [calendar showPreviousMonth];
            //执行程序
        }
    }
    else if(point.y > calendar.height)
    {
        myScrollView.scrollEnabled = YES;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
