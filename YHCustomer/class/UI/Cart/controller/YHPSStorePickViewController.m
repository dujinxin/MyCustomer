//
//  YHPSStorePickViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-3-28.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  门店自提

#import "YHPSStorePickViewController.h"
#import "POPDViewController.h"


@interface YHPSStorePickViewController ()<POPDDelegate>{
    
    UIButton *btn;
    NSTimeInterval selectInterval;
    UIButton        *phoneConfirmBtn;       // 电话确认
    UIButton        *phoneNoConfirmBtn;     // 不确认

}


@end

@implementation YHPSStorePickViewController
@synthesize firstDayHMArray,ymdArray,uploadTimeStr,monthDayStr,hourMinuteArray;
@synthesize order_list_id;
@synthesize listEntity;
@synthesize myTimeStamp;
@synthesize dateStringDefault;
@synthesize storeDic,popArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        ymdArray = [[NSMutableArray alloc] init];
        hourMinuteArray = [[NSMutableArray alloc]init];
        firstDayHMArray = [[NSMutableArray alloc]init];
        tempMY = [[NSMutableArray alloc]init];;
        popArray = [[NSMutableArray alloc] init];
        uploadTimeStr = [[NSString alloc] init];
        isShow = YES;
        
        long today_time=(long)[[NSDate date] timeIntervalSince1970];
        long tomorrow_time = today_time + 24*3600;
        NSString *today_date = [PublicMethod timeStampConvertToFullTime:[NSString stringWithFormat:@"%ld",today_time]];
        NSString *tomorrow_date = [PublicMethod timeStampConvertToFullTime:[NSString stringWithFormat:@"%ld",tomorrow_time]];
        today = [today_date substringToIndex:10];
        tomorrow = [tomorrow_date substringToIndex:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"门店自提";
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    //  tableview
    popMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenSize.height-NAVBAR_HEIGHT) style:UITableViewStylePlain];
    popMenu.delegate = self;
    popMenu.dataSource = self;
    popMenu.showsVerticalScrollIndicator = NO;
    popMenu.backgroundColor =[PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0f];
    popMenu.backgroundView = nil;
    
    [popMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:popMenu];
    
    // 获取门店列表
    [[NetTrans getInstance] getBuList:self Page:@"1" Limit:@"10"];
    
    
    //自提时间列表
    [[PSNetTrans getInstance] get_PickUp_Time:self ReginId:[UserAccount instance].region_id];
}

#pragma mark  -----------------  UI
//红色按钮（时间和确定）
- (UIView *)tableViewFootView{
    bgPopView = [PublicMethod addBackView:CGRectMake(0,0, 320, 150) setBackColor:[UIColor whiteColor]];
    
    UIView *bgView = [PublicMethod addBackView:CGRectMake(0, 0, 320, 10) setBackColor:LIGHT_GRAY_COLOR];
    [bgPopView addSubview:bgView];
    
    // 选择自提时间
    pickTime = [PublicMethod addLabel:CGRectMake(10, 10, 230, 40) setTitle:@"选择自提时间" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    [bgPopView addSubview:pickTime];
    
    bgPickTime = [PublicMethod addBackView:CGRectMake(0, 50, 320, 48) setBackColor:[PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0f]];
    [bgPopView addSubview:bgPickTime];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 61, 300, 28);
    
    NSString *btnTimeStart = [self.dateStringDefault substringToIndex:10];
    NSString *btnTimeEnd = [self.dateStringDefault substringFromIndex:11];
    
    
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    ;
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[PublicMethod NSStringToNSDate:self.dateStringDefault] integerValue]];
    
    NSString *date_ = [NSString stringWithFormat:@"(%@)",[[PublicMethod nsdateConvertToTimeString:date] substringWithRange:NSMakeRange(5, 6)]];
    
    
    if ([btnTimeStart isEqualToString:today]) {
        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"今天",date_,btnTimeEnd];
    } else if ([btnTimeStart isEqualToString:tomorrow]) {
        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"明天",date_,btnTimeEnd];
    } else {
        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
    }
    
//    
//    if ([btnTimeStart isEqualToString:today]) {
//        dateString = [NSString stringWithFormat:@"%@ %@ %@",btnTimeStart,@"(今天)",btnTimeEnd];
//    } else if ([btnTimeStart isEqualToString:tomorrow]) {
//        dateString = [NSString stringWithFormat:@"%@ %@ %@",btnTimeStart,@"(明天)",btnTimeEnd];
//    } else {
//        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
//    }
    
    [btn setTitle:dateString forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn addTarget:self action:@selector(showActionSheetView) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [bgPopView addSubview:btn];
    
    // 确认按钮
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10,105, 300, 40);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    [confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 0.0)];
    confirmBtn.userInteractionEnabled = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgPopView addSubview:confirmBtn];
    
    bgPopView.userInteractionEnabled = YES;
    [bgPopView.superview setUserInteractionEnabled:YES];
    
    return bgPopView;
}

/**
 @brief 弹出ActionSheet
 */
- (void)showActionSheetView{
    
    UIPickerView  *pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 100)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    
    [tempMY removeAllObjects];
    for (NSString *ymd in self.ymdArray) {
        NSString *mouth_ = [ymd substringWithRange:NSMakeRange(5, 2)];
        NSString *day_ = [ymd substringWithRange:NSMakeRange(8, 2)];
        
        if ([ymd isEqualToString:today]) {
            [tempMY addObject:[NSString stringWithFormat:@"今天(%@月%@日)",mouth_,day_]];
        } else if ([ymd isEqualToString:tomorrow]) {
            [tempMY addObject:[NSString stringWithFormat:@"明天(%@月%@日)",mouth_,day_]];
        } else {
            [tempMY addObject:[NSString stringWithFormat:@"%@月%@日",mouth_,day_]];
        }
        
        
    }
    
    for (int i=0;i<[self.ymdArray count];i++) {
        NSString *day = [self.ymdArray objectAtIndex:i];
        if ([day isEqualToString:self.monthDayStr]) {
            [pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    if ([pickerView selectedRowInComponent:0] == 0) {
        for (int i=0;i<[self.firstDayHMArray count];i++) {
            NSString *time = [self.firstDayHMArray objectAtIndex:i];
            if ([time isEqualToString:self.hourMinuteStr]) {
                [pickerView selectRow:i inComponent:1 animated:NO];
                break;
            }
        }
    } else {
        for (int i=0;i<[self.hourMinuteArray count];i++) {
            NSString *time = [self.hourMinuteArray objectAtIndex:i];
            if ([time isEqualToString:self.hourMinuteStr]) {
                [pickerView reloadComponent:1];
                [pickerView selectRow:i inComponent:1 animated:NO];
                break;
            }
        }
    }

    
    
    if (IOS_VERSION < 8) {
        // actionsheet
        as=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [as setActionSheetStyle:UIActionSheetStyleDefault];
        as.backgroundColor = [UIColor whiteColor];
        as.userInteractionEnabled=YES;
        
        NSLog(@"as %@",as);
        UIButton *toolbar = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        [toolbar addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolbar setBackgroundColor:[UIColor lightGrayColor]];
        [toolbar setTitle:@"完成" forState:UIControlStateNormal];
        [as addSubview:toolbar];
        [as addSubview:pickerView];
        [as showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        NSLog(@"as %f",IOS_VERSION);
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [alertC dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alertC addAction:destructiveAction];
        
        pickerView.frame = CGRectMake(0, 0, 304, 105);
        
        [alertC.view addSubview:pickerView];
        
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }
    
}
- (void)showOldActionSheetView{
    // actionsheet
    as=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [as setActionSheetStyle:UIActionSheetStyleDefault];
    as.backgroundColor = [UIColor whiteColor];
    as.userInteractionEnabled=YES;
    
    NSLog(@"as %@",as);
    UIButton *toolbar = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [toolbar addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar setBackgroundColor:[UIColor lightGrayColor]];
    [toolbar setTitle:@"完成" forState:UIControlStateNormal];
    [as addSubview:toolbar];
    
    UIPickerView  *pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 100)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
    
    [tempMY removeAllObjects];
    for (NSString *ymd in self.ymdArray) {
        NSString *mouth_ = [ymd substringWithRange:NSMakeRange(5, 2)];
        NSString *day_ = [ymd substringWithRange:NSMakeRange(8, 2)];
        
        if ([ymd isEqualToString:today]) {
            [tempMY addObject:[NSString stringWithFormat:@"今天(%@月%@日)",mouth_,day_]];
        } else if ([ymd isEqualToString:tomorrow]) {
            [tempMY addObject:[NSString stringWithFormat:@"明天(%@月%@日)",mouth_,day_]];
        } else {
            [tempMY addObject:[NSString stringWithFormat:@"%@月%@日",mouth_,day_]];
        }
        
  
    }
    
    for (int i=0;i<[self.ymdArray count];i++) {
        NSString *day = [self.ymdArray objectAtIndex:i];
        if ([day isEqualToString:self.monthDayStr]) {
            [pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
    
    if ([pickerView selectedRowInComponent:0] == 0) {
        for (int i=0;i<[self.firstDayHMArray count];i++) {
            NSString *time = [self.firstDayHMArray objectAtIndex:i];
            if ([time isEqualToString:self.hourMinuteStr]) {
                [pickerView selectRow:i inComponent:1 animated:NO];
                break;
            }
        }
    } else {
        for (int i=0;i<[self.hourMinuteArray count];i++) {
            NSString *time = [self.hourMinuteArray objectAtIndex:i];
            if ([time isEqualToString:self.hourMinuteStr]) {
                [pickerView reloadComponent:1];
                [pickerView selectRow:i inComponent:1 animated:NO];
                break;
            }
        }
    }



    [as addSubview:toolbar];
    [as addSubview:pickerView];
    [as showInView:[UIApplication sharedApplication].keyWindow];
    
}


#pragma mark -----------  action
// 门店选择headerview －select
- (void)selectStoreClicked:(id)sender{
    isShow = !isShow;
    [popMenu reloadData];
}

- (void)segmentAction:(id)sender{
    [as dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -
#pragma mark ----------------------------------------------UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 15;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.ymdArray.count;
        case 1:
            if ([pickerView selectedRowInComponent:0] == 0) {//如果第一列选择的是第一天
                return [firstDayHMArray count];
            }
            return self.hourMinuteArray.count;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
//            return [ymdArray objectAtIndex:row];
            return [tempMY objectAtIndex:row];
        case 1:
            if ([pickerView selectedRowInComponent:0] == 0) {//如果第一列选择的是第一天
                return [firstDayHMArray objectAtIndex:row];
            }
            return [hourMinuteArray objectAtIndex:row];
        default:
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            
            self.monthDayStr = [ymdArray objectAtIndex:row];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            if ([pickerView selectedRowInComponent:0] == 0) {//如果第一列选择的是第一天
                self.hourMinuteStr = [firstDayHMArray objectAtIndex:0];
            } else {
                self.hourMinuteStr = [hourMinuteArray objectAtIndex:0];
            }
            
            break;
        case 1:
            if ([pickerView selectedRowInComponent:0] == 0) {//如果第一列选择的是第一天
                self.hourMinuteStr = [firstDayHMArray objectAtIndex:row];
            } else {
                self.hourMinuteStr = [hourMinuteArray objectAtIndex:row];
            }
            
            break;
        default:
            break;
    }
    
    // 展示用的没有年份的时间
    NSString *btnTimeStart = self.monthDayStr;
    NSString *btnTimeEnd = self.hourMinuteStr;
    
    
    // 上传时间时间戳
    self.uploadTimeStr = [self NSStringToNSDate:[NSString stringWithFormat:@"%@ %@",self.monthDayStr,self.hourMinuteStr]];
    // 保存时间 2013年12月20日
    self.dateStringDefault = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
    
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    ;
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[PublicMethod NSStringToNSDate:self.dateStringDefault] integerValue]];
    
    NSString *date_ = [NSString stringWithFormat:@"(%@)",[[PublicMethod nsdateConvertToTimeString:date] substringWithRange:NSMakeRange(5, 6)]];

    
    if ([btnTimeStart isEqualToString:today]) {
        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"今天",date_,btnTimeEnd];
    } else if ([btnTimeStart isEqualToString:tomorrow]) {
        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"明天",date_,btnTimeEnd];
    } else {
        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
    }
    

    [btn setTitle:dateString forState:UIControlStateNormal];

}

// 传入时间－转换时间戳
- (NSString * )NSStringToNSDate: (NSString * )string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
    NSDate *date1 = [formatter dateFromString :string];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
    selectInterval = (long)[date1 timeIntervalSince1970];
    NSLog(@"date is %@",date1);
    return timeStamp;
}

#pragma mark ----------------  click
- (void)confirmBtnClicked:(id)sender{

    if (self.uploadTimeStr.length == 0) {
        [self showNotice:@"请选择时间"];
        return;
    }
    
    //服务器当前时间
   long time = (long)[[PublicMethod NSStringToNSDateToSS:pickUpTimeEntity.date] longLongValue];
    
    if (([self.uploadTimeStr longLongValue] - (time+3600*[pickUpTimeEntity.fastest_pick_up_time integerValue])) < 0) {
        //第一个时间大<当前时间》提货时间>
        [self showNotice:[NSString stringWithFormat:@"系统支持的最早自提时间为下单后%ld小时，请重选!",(long)[pickUpTimeEntity.fastest_pick_up_time integerValue]]];
        return;
    }
    if ([[self.storeDic objectForKey:@"bu_id"] length] == 0) {
        [self showNotice:@"请选择门店"];
        return;
    }
    if ([[self.storeDic objectForKey:@"address"] length] == 0) {
        [self showNotice:@"请选择地址"];
        return;
    }
    
    _pickTimeBlock([self.storeDic objectForKey:@"bu_id"],[self.storeDic objectForKey:@"bu_name"],self.uploadTimeStr,btn.titleLabel.text, [self.storeDic objectForKey:@"address"]);
    
    // 保存门店信息
    NSDictionary *storeDic1 = @{@"bu_id": [self.storeDic objectForKey:@"bu_id"],@"bu_name":[self.storeDic objectForKey:@"bu_name"],@"timeStamp":self.dateStringDefault,@"address":[self.storeDic objectForKey:@"address"]};
    [[NSUserDefaults standardUserDefaults] setObject:storeDic1 forKey:@"storeInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------  net
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_BUY_PLATFORM_BU_LIST) {
        [self.popArray removeAllObjects];
        [self.popArray addObjectsFromArray:(NSMutableArray *)netTransObj];
        [popMenu reloadData];
    } else if (t_API_PS_PICK_UP_TIME_INFO == nTag) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSMutableArray *data = (NSMutableArray *)netTransObj;
            NSMutableDictionary *dic = [data objectAtIndex:0];
            pickUpTimeEntity = [[PickUpTimeEntity alloc] init];
            pickUpTimeEntity.start_time = [dic objectForKey:@"start_time"];
            pickUpTimeEntity.end_time = [dic objectForKey:@"end_time"];
            pickUpTimeEntity.support_days = [dic objectForKey:@"support_days"];
            pickUpTimeEntity.fastest_pick_up_time = [dic objectForKey:@"fastest_pick_up_time"];
            pickUpTimeEntity.date = [dic objectForKey:@"date"];

           
            
            /*时间小时分钟数组生成方法*/
            NSArray *start_time = [pickUpTimeEntity.start_time componentsSeparatedByString:@":"];
            NSArray *end_time = [pickUpTimeEntity.end_time componentsSeparatedByString:@":"];
     
            
            NSInteger fastest_pick_up_time =  [pickUpTimeEntity.fastest_pick_up_time integerValue];
            NSInteger startHour = [[start_time objectAtIndex:0] integerValue];
            NSInteger endHour = [[end_time objectAtIndex:0] integerValue];
            NSInteger count = endHour-startHour;
            NSInteger support_days = [pickUpTimeEntity.support_days integerValue];
            
            if ([[end_time objectAtIndex:1] integerValue]-[[start_time objectAtIndex:1] integerValue]>0) {//8:00   ----    9:30      4
                count = count*2 + 2;
            } else if ([[end_time objectAtIndex:1] integerValue]-[[start_time objectAtIndex:1] integerValue] < 0) {//8:30   ----    9:00     2
                count = count*2;
            } else {//8:00   ----    9:00        3
                count = count*2 + 1;
            }
            
            [self.hourMinuteArray removeAllObjects];
            for (int i=0; i<count; i++) {
                
                if ([[start_time objectAtIndex:1] integerValue]>0) {//开始的时间分钟大于0，也就是等于30
                    
                    if (i%2 == 0) {
                        
                        //偶数
                        NSString *time = [NSString stringWithFormat:@"%ld:30",(long)[[start_time objectAtIndex:0] integerValue]+i/2];
                        [self.hourMinuteArray addObject:time];
                    } else {
                        NSString *time = [NSString stringWithFormat:@"%ld:00",(long)[[start_time objectAtIndex:0] integerValue]+i/2 ];
                        [self.hourMinuteArray addObject:time];
                    }
                    
                } else {
                    
                    if (i%2 == 0) {//偶数
                        NSString *time = [NSString stringWithFormat:@"%ld:00",(long)[[start_time objectAtIndex:0] integerValue]+i/2];
                        [self.hourMinuteArray addObject:time];
                    } else {
                        NSString *time = [NSString stringWithFormat:@"%ld:30",(long)[[start_time objectAtIndex:0] integerValue]+i/2];
                        [self.hourMinuteArray addObject:time];
                    }
                    
                }
            }
            firstDayHMArray = [NSMutableArray arrayWithArray:self.hourMinuteArray];
            
            
            /*默认时间生成方法*/
            if (!self.defaultPickTime) {
//                self.monthDayStr = [ymdArray objectAtIndex:0];
//                self.hourMinuteStr = [hourMinuteArray objectAtIndex:0];
                
                // 默认时间＋3小时
//                long time=(long)[[NSDate date] timeIntervalSince1970];
                long time = (long)[[PublicMethod NSStringToNSDateToSS:pickUpTimeEntity.date] longLongValue];
                NSString  *_time_id = [[NSNumber numberWithLong:(time+3600*fastest_pick_up_time+60*30-time%(60*30))] stringValue];
                
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:[_time_id longLongValue]]];
                
                
                /*年月日数组生成方法*/
                NSTimeInterval secondsPerDay = 24 * 60 * 60;
                
                NSDateFormatter *storeDateFormatter = [[NSDateFormatter alloc] init];
                [storeDateFormatter setDateFormat:@"yyyy-MM-dd"];
           
                support_days = support_days - ([comps day] - [[pickUpTimeEntity.date substringWithRange:NSMakeRange(8, 2)] integerValue]);
                
                if ([comps hour]>endHour || (([comps hour]==endHour) && ([comps minute]>[[end_time objectAtIndex:1] integerValue]))) {//不在自提时间内,结束时间-->24
                    
                    NSDate *firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:_time_id]];
                    for (int i = 0; i < support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:(i+1) * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                    }
                    
                    if ([ymdArray count]>0) {
                        self.defaultPickTime = [NSString stringWithFormat:@"%@ %@",[ymdArray objectAtIndex:0],[hourMinuteArray objectAtIndex:0]];
                    }
        
                    
                } else if (([comps hour]<startHour) || (([comps hour]==startHour) && ([comps minute]<[[start_time objectAtIndex:1] integerValue]))) {//不在自提时间内,0-->开始时间
                    
                    NSDate *firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:_time_id]];
                    for (int i = 0; i < support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                    }
                    
                    if ([ymdArray count]>0) {
                         self.defaultPickTime = [NSString stringWithFormat:@"%@ %@",[ymdArray objectAtIndex:0],[hourMinuteArray objectAtIndex:0]];
                    }
            
                
                } else {
                    
                    NSDate *firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:_time_id]];
                    for (int i = 0; i < support_days; i ++) {
                        NSString *dateStore = [storeDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i * secondsPerDay]];
                        [ymdArray addObject:dateStore];
                    }
                    
                    if ([ymdArray count]>0) {
                        self.defaultPickTime = [PublicMethod timeStampConvertToFullTime:_time_id];
                    }
               
                    
                }
                
                if (!self.dateStringDefault) {
                    self.dateStringDefault = self.defaultPickTime;
                    
                    NSString *btnTimeStart = [self.dateStringDefault substringToIndex:10];
                    NSString *btnTimeEnd = [self.dateStringDefault substringFromIndex:11];
                    
                    
                    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
                    ;
                    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT_STOREPICK];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[PublicMethod NSStringToNSDate:self.dateStringDefault] integerValue]];
                    
                    NSString *date_ = [NSString stringWithFormat:@"(%@)",[[PublicMethod nsdateConvertToTimeString:date] substringWithRange:NSMakeRange(5, 6)]];
                    
                    
                    if ([btnTimeStart isEqualToString:today]) {
                        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"今天",date_,btnTimeEnd];
                    } else if ([btnTimeStart isEqualToString:tomorrow]) {
                        dateString = [NSString stringWithFormat:@"%@ %@ %@",@"明天",date_,btnTimeEnd];
                    } else {
                        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
                    }
                    
                    
//                    if ([btnTimeStart isEqualToString:today]) {
//                        dateString = [NSString stringWithFormat:@"%@ %@ %@",btnTimeStart,@"(今天)",btnTimeEnd];
//                    } else if ([btnTimeStart isEqualToString:tomorrow]) {
//                        dateString = [NSString stringWithFormat:@"%@ %@ %@",btnTimeStart,@"(明天)",btnTimeEnd];
//                    } else {
//                        dateString = [NSString stringWithFormat:@"%@ %@",btnTimeStart,btnTimeEnd];
//                    }
                }
          
            }
            
            
  
            
            
            if ([ymdArray count]>0) {
                
                self.monthDayStr = [self.dateStringDefault substringToIndex:10];
                self.hourMinuteStr = [self.dateStringDefault substringFromIndex:11];
                
                for (int i=0; i<[self.hourMinuteArray count]; i++) {
                    NSString *hmStr = [self.hourMinuteArray objectAtIndex:i];
                    if ([[self.defaultPickTime substringFromIndex:11] isEqualToString:hmStr]) {
                        firstDayHMArray =(NSMutableArray *) [firstDayHMArray subarrayWithRange:NSMakeRange(i, [firstDayHMArray count]-i)];
                        break;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    popMenu.tableFooterView = [self tableViewFootView];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAlert:@"抱歉,无自提时间可选择!"];
//                    pickTime = [PublicMethod addLabel:CGRectMake(10, 10, 230, 40) setTitle:@"暂无自提时间" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
//                    popMenu.tableFooterView = pickTime;
                });
            }
    
   
            
            
            // 上传默认时间戳
            self.uploadTimeStr = [PublicMethod NSStringToNSDate:self.dateStringDefault];
            NSLog(@"%lld",[self.uploadTimeStr longLongValue]);
            selectInterval = [self.uploadTimeStr longLongValue];
            // 存储得门店
            storeDic = [[NSDictionary alloc] init];
            self.storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeInfo"];
            
        });
        
        
  
        
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    if(t_API_PS_PICK_UP_TIME_INFO)
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


#pragma mark --------------------UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *bgHeaderView = [PublicMethod addBackView:CGRectMake(0, 0, 320, 50) setBackColor:[PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0f]];
    
    UIView *cellBgHeader = [PublicMethod addBackView:CGRectMake(0, 0, 320, 10) setBackColor:[PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0f]];
    
    selectStoreBtn = [PublicMethod addButton:CGRectMake(0, 10, 320, 40) title:@"  选择自提门店" backGround:nil setTag:1000 setId:self selector:@selector(selectStoreClicked:) setFont:[UIFont systemFontOfSize:16] setTextColor:[UIColor blackColor]];
    selectStoreBtn.backgroundColor = [UIColor whiteColor];
    selectStoreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    selectStoreLabel = [PublicMethod addLabel:CGRectMake(135, 10, 150, 20) setTitle:[self.storeDic objectForKey:@"bu_name"] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:12]];
    selectStoreLabel.autoresizingMask = YES;
    selectStoreLabel.lineBreakMode = NSLineBreakByWordWrapping;
    selectStoreLabel.textAlignment = NSTextAlignmentRight;
    [selectStoreBtn addSubview:selectStoreLabel];
    
    NSString *imgStr=nil;
    if (isShow) {
        imgStr = @"psAccessUp.png";
    }else{
        imgStr = @"psAccessDown.png";
    }
    accessUpImg = [PublicMethod addImageView:CGRectMake(290, 12, 14, 15) setImage:imgStr];
    [selectStoreBtn addSubview:accessUpImg];
    
    [bgHeaderView addSubview:cellBgHeader];
    [bgHeaderView addSubview:selectStoreBtn];
    return bgHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isShow) {
        return  popArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *name = [PublicMethod addLabel:CGRectMake(10, 7, 300, 20) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
        name.tag = 1001;
        [cell.contentView addSubview:name];
        
        UILabel *description = [PublicMethod addLabel:CGRectMake(10, 27, 300, 19) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
        description.tag = 1002;
        [cell.contentView addSubview:description];
        
        UIView *darkLine = [PublicMethod addBackView:CGRectMake(0, 49, 320, 1) setBackColor:[UIColor lightGrayColor]];
        darkLine.alpha = .2f;
        [cell.contentView addSubview:darkLine];
    }
    
    BuListEntity *entity = [self.popArray objectAtIndex:indexPath.row];
    UILabel *name_tag = (UILabel *)[cell.contentView viewWithTag:1001];
    name_tag.text =entity.bu_name;
    
    UILabel *description_tag = (UILabel *)[cell.contentView viewWithTag:1002];
    description_tag.text =entity.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.listEntity = [popArray objectAtIndex:indexPath.row];
    storeDic = @{@"bu_id": self.listEntity.bu_id ,@"bu_name":self.listEntity.bu_name,@"address":self.listEntity.address};
    selectStoreLabel.text =[NSString stringWithFormat:@"   %@",self.listEntity.bu_name];
    isShow = !isShow;
    [popMenu reloadData];
}


@end
