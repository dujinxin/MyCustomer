//
//  YHPSDeliveryDoorViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-3-27.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  送货上门

#import "YHPSDeliveryDoorViewController.h"
#import "YHDeliveryTimeViewController.h"
#import "YHTimeView.h"

@interface YHPSDeliveryDoorViewController (){
    UIView   *headerView;
    UIButton *btn;
    NSTimeInterval selectInterval;
    
    UIButton        *phoneConfirmBtn;       // 电话确认
    UIButton        *phoneNoConfirmBtn;     // 不确认
    
    YHTimeView * _yhTimeView;
    PSModel model;
    int _support_days;
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
    UIButton *_resignBtn;
    
    LogisticModelEntity * halfDayEntity ;
    LogisticModelEntity * flySpeedEntity ;
    
    NSInteger  selectRow;
    
    
    NSIndexPath * selectIndexPath;
}

@property (nonatomic, strong) NSMutableArray *monthDayArray;
@property (nonatomic, strong) NSMutableArray *storeTimeArray;

@property (nonatomic, strong) NSString *monthStr;
@property (nonatomic, strong) NSString *monthDayStr;
@property (nonatomic, strong) NSString *uploadTimeStr;
@property (nonatomic, strong) NSString *hourMinuteStr;
@property (nonatomic, strong) NSString *pickTimeLabel;
@property (nonatomic, strong) NSMutableArray *hourMinuteArray;
@property (nonatomic,copy)NSString * showString;
@end

@implementation YHPSDeliveryDoorViewController

@synthesize monthDayArray,storeTimeArray,uploadTimeStr,hourMinuteArray;
@synthesize order_list_id;
@synthesize buEntity;
@synthesize dataArray;
@synthesize timeArray;
@synthesize lm_time_id;
@synthesize lm_name;
@synthesize lm_time_name;
@synthesize isTel,fromPayment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        timeArray = [[NSMutableArray alloc] init];
        buEntity = [[LogisticModelEntity alloc] init];
        
        _sevenWeekDayArray = [[NSMutableArray alloc]init ];
        _sevenDayArray = [[NSMutableArray alloc]init ];
        _sevenDateArray = [[NSMutableArray alloc]init ];
        selectRow = 0;
        
        _nSevenDateArray = [[NSMutableArray alloc]init ];
    }
    return self;
}


- (void)addGetMoreFootView{

}
- (void)addRefreshTableHeaderView{

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (fromPayment) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[PSNetTrans getInstance] ps_getLogisticStyle:self goods_id:self.goods_id];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"送货上门";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self._tableView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-NAVBAR_HEIGHT);
    [self._tableView setBackgroundColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addGetMoreFootView];
    [self addRefreshTableHeaderView];
    
    headerView = [PublicMethod addBackView:CGRectMake(0, 0, 320, 50) setBackColor:[UIColor whiteColor]];
    
    UIView *bgLine = [PublicMethod addBackView:CGRectMake(0, 0, 320, 10) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    [headerView addSubview:bgLine];
    // 选择自提时间
    UILabel *pickTime = [PublicMethod addLabel:CGRectMake(0, 18, 320, 20) setTitle:@"  选择送货方式" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    pickTime.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:pickTime];

    UIView *cellLine = [PublicMethod addBackView:CGRectMake(0, 46, 320, 1) setBackColor:[UIColor lightGrayColor]];
    cellLine.alpha = .2f;
    [headerView addSubview:cellLine];
//    self._tableView.tableHeaderView = headerView;
    
    // tableview-footview
    popView = [PublicMethod addBackView:CGRectMake(0, 0, 320, 220) setBackColor:[UIColor clearColor]];
    UIView *cellLine1 = [PublicMethod addBackView:CGRectMake(0, 0, 320, 10) setBackColor:[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0]];
    [popView addSubview:cellLine1];
    
    // title
    UILabel *titlePop = [PublicMethod addLabel:CGRectMake(0, 10, 320, 40) setTitle:@"   选择送货时间" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    [titlePop setBackgroundColor:[UIColor whiteColor]];
    [popView addSubview:titlePop];
    // bg
    UIView *bgButton = [PublicMethod addBackView:CGRectMake(0, 50, 320, 40) setBackColor:[PublicMethod colorWithHexValue:0xfcffe2 alpha:1.0f]];
    [popView addSubview:bgButton];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 57.5, 300, 25);
    [btn setTitle:@"请选择送货时间" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn addTarget:self action:@selector(chooseDeliveryTime) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [popView addSubview:btn];

    // 电话确认
    UILabel *confirmTitle = [PublicMethod addLabel:CGRectMake(0, 105, 320, 40) setTitle:@"   是否需要送货前电话通知" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
    confirmTitle.backgroundColor = [UIColor whiteColor];
    [popView addSubview:confirmTitle];

    phoneConfirmBtn = [PublicMethod addButton:CGRectMake(255, 110, 25, 25) title:nil backGround:nil setTag:1000 setId:self selector:@selector(telephoneConfirmOrNot:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor whiteColor]];
    
    phoneConfirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    [phoneConfirmBtn setTitle:@"是" forState:UIControlStateNormal];
    [popView addSubview:phoneConfirmBtn];
    
    phoneNoConfirmBtn = [PublicMethod addButton:CGRectMake(290, 110, 25, 25) title:nil backGround:nil setTag:1001 setId:self selector:@selector(telephoneConfirmOrNot:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor whiteColor]];
    [phoneNoConfirmBtn setTitle:@"否" forState:UIControlStateNormal];
    phoneNoConfirmBtn.backgroundColor = [UIColor lightGrayColor];
    
    [popView addSubview:phoneNoConfirmBtn];
    
    isTel = YES;
    if (isTel) {
        phoneNoConfirmBtn.backgroundColor = [UIColor lightGrayColor];
        phoneConfirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    }
    
    // 确认按钮
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10,155, 300, 40);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    [confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 0.0)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:confirmBtn];
    
    //先不加载popView
//    self._tableView.tableFooterView = popView;
    if (! fromPayment) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[PSNetTrans getInstance] ps_getLogisticStyle:self goods_id:self.goods_id];
    }
   
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
- (void)changeDeliveryTime:(NSString *)hourString date:(NSString *)dateString{
//    NSString * string = _yhTimeView.dateLabel.text;
    NSString * string = dateString;
    NSString *character;
    NSString *strNum=@"";
    
    //没有选择时间
    if (hourString ==nil || hourString.length == 0 || hourString == NULL) {
        return;
    }
    
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
//    NSString * year = [strNum substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [strNum substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [strNum substringWithRange:NSMakeRange(6, 2)];
    NSUInteger index = [_nSevenDateArray indexOfObject:string];
    
    if (index != NSNotFound) {
        if ([string hasSuffix:@"今天"]) {
            [btn setTitle:[NSString stringWithFormat:@"今天（%@月%@日）%@",month,day,hourString] forState:UIControlStateNormal];
        }else if ([string hasSuffix:@"明天"]) {
            [btn setTitle:[NSString stringWithFormat:@"明天（%@月%@日）%@",month,day,hourString] forState:UIControlStateNormal];
        }else{
            [btn setTitle:[NSString stringWithFormat:@"%@月%@日 %@",month,day,hourString] forState:UIControlStateNormal];
        }
//        LogisticModelEntity * entity = [self.dataArray objectAtIndex:selectRow];
        self.showDeliveryTime = btn.currentTitle;
        self.deliveryTime = btn.currentTitle;
//        self.deliveryType = entity.title;
//        self.deliveryId = entity.logisId;
//        self.type = _yhTimeView.type;
//        self.msg = _yhTimeView.msg;
//        self.payId = _yhTimeView.payId;
//        _time_id = [PublicMethod NSStringToNSDate:time];
    }

}
- (void)changeDeliveryTime{
    //    NSString * string = _yhTimeView.dateLabel.text;
    NSString * string = self.selectDateString;
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
    //    NSString * year = [strNum substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [strNum substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [strNum substringWithRange:NSMakeRange(6, 2)];
    NSUInteger index = [_sevenDateArray indexOfObject:string];
    
    if (index != NSNotFound) {
        if ([string hasSuffix:@"今天"]) {
            [btn setTitle:[NSString stringWithFormat:@"今天（%@月%@日）%@",month,day,_yhTimeView.hourString] forState:UIControlStateNormal];
        }else if ([string hasSuffix:@"明天"]) {
            [btn setTitle:[NSString stringWithFormat:@"明天（%@月%@日）%@",month,day,_yhTimeView.hourString] forState:UIControlStateNormal];
        }else{
            [btn setTitle:[NSString stringWithFormat:@"%@月%@日 %@",month,day,_yhTimeView.hourString] forState:UIControlStateNormal];
        }
        //        NSString * time = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,_yhTimeView.hourString];
        LogisticModelEntity * entity = [self.dataArray objectAtIndex:selectRow];
        self.showDeliveryTime = btn.currentTitle;
        //        self.deliveryTime = _yhTimeView.hourString;
        self.deliveryTime = btn.currentTitle;
        self.deliveryType = entity.title;
        self.deliveryId = entity.logisId;
        self.type = _yhTimeView.type;
        self.msg = _yhTimeView.msg;
        self.payId = _yhTimeView.payId;
        //        _time_id = [PublicMethod NSStringToNSDate:time];
    }
    
}
#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cellArray = [tableView visibleCells];
    for (UITableViewCell *allCell in cellArray) {
        UIImageView *cellImg = (UIImageView *)[allCell.contentView viewWithTag:1000];
        cellImg.image = [UIImage imageNamed:@"yes-2.png"];
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImage = (UIImageView *)[cell.contentView viewWithTag:1000];
    selectImage.image = [UIImage imageNamed:@"yes-1.png"];
    
    selectIndexPath = indexPath;
    
    if (self.dataArray.count > 0) {
        [btn setEnabled:YES];
        [btn setTitle:@"请选择送货时间" forState:UIControlStateNormal];
        self.deliveryId = nil;
        self.deliveryTime = nil;
        self.deliveryType = nil;
        self.payId = nil;
        self.type = nil;
        self.msg =nil;
        selectRow = indexPath.row;
        
        LogisticModelEntity * entity = [self.dataArray objectAtIndex:indexPath.row];
        self.deliveryType = entity.title;
        self.deliveryId = entity.logisId;
    }
    
    
    self._tableView.tableFooterView = popView;
    // 切换送货状态初始化picker数据
    //    [self setPickTime:0];
}
- (void)tableView22:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cellArray = [tableView visibleCells];
    for (UITableViewCell *allCell in cellArray) {
       UIImageView *cellImg = (UIImageView *)[allCell.contentView viewWithTag:1000];
        cellImg.image = [UIImage imageNamed:@"yes-2.png"];
    }

    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectImage = (UIImageView *)[cell.contentView viewWithTag:1000];
    selectImage.image = [UIImage imageNamed:@"yes-1.png"];
    
//    self.buEntity = [self.dataArray objectAtIndex:indexPath.row];
//    self.timeArray = self.buEntity.delivery_time;
//    self.lm_name = self.buEntity.title;
    if (self.dataArray.count > 1) {
        if (indexPath.row == 0) {
            [btn setEnabled:YES];
            [btn setTitle:@"请选择送货时间" forState:UIControlStateNormal];
            self.deliveryId = nil;
            self.deliveryTime = nil;
            self.deliveryType = nil;
            self.payId = nil;
            self.type = nil;
            self.msg =nil;
            
        }else{
            [btn setEnabled:NO];
            NSDictionary * todayDic = [NSDictionary dictionaryWithDictionary:flySpeedEntity.delivery_time];
            NSArray * todayArray = [todayDic objectForKey:@"today"];
            for (NSDictionary *dic in todayArray) {
                if ([dic objectForKey:@"title"]) {
                    [btn setTitle:[dic objectForKey:@"title"] forState:UIControlStateNormal];
                    self.deliveryTime = [dic objectForKey:@"title"];
                    self.type = [dic objectForKey:@"type"];
                    self.msg = [dic objectForKey:@"msg"];;
                    self.payId = [dic objectForKey:@"id"];;
                }
            }
            self.deliveryType = flySpeedEntity.title;
            self.deliveryId = flySpeedEntity.logisId;
            
        }
    }else{
        for (NSDictionary * dict in self.dataArray){
            if ([dict objectForKey:@"半日达"]) {
                [btn setEnabled:YES];
                [btn setTitle:@"请选择送货时间" forState:UIControlStateNormal];
                self.deliveryId = nil;
                self.deliveryTime = nil;
                self.deliveryType = nil;
                self.payId = nil;
                self.type = nil;
                self.msg =nil;
            }
            if([dict objectForKey:@"飞速达"]){
                [btn setEnabled:NO];
                NSDictionary * todayDic = [NSDictionary dictionaryWithDictionary:flySpeedEntity.delivery_time];
                NSArray * todayArray = [todayDic objectForKey:@"today"];
                for (NSDictionary *dic in todayArray) {
                    if ([dic objectForKey:@"title"]) {
                        [btn setTitle:[dic objectForKey:@"title"] forState:UIControlStateNormal];
                        self.deliveryTime = [dic objectForKey:@"title"];
                        self.type = [dic objectForKey:@"type"];
                        self.msg = [dic objectForKey:@"msg"];;
                        self.payId = [dic objectForKey:@"id"];;
                    }
                }
                self.deliveryType = flySpeedEntity.title;
                self.deliveryId = flySpeedEntity.logisId;
            }
        }
    }
    
    self._tableView.tableFooterView = popView;
    // 切换送货状态初始化picker数据
//    [self setPickTime:0];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    [cell.contentView removeAllSubviews];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *img = [PublicMethod addImageView:CGRectMake(10, 22, 23, 23) setImage:@"yes-2.png"];
    img.tag = 1000;
    if (selectIndexPath != nil) {
        if (selectIndexPath.row == indexPath.row) {
            img.image = [UIImage imageNamed:@"yes-1.png"];
        }
    }
    [cell.contentView addSubview:img];
    
    
    LogisticModelEntity * entity = [self.dataArray objectAtIndex:indexPath.row];
    UILabel *banrida = [PublicMethod addLabel:CGRectMake(40, 10, 230, 15) setTitle:entity.title setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:banrida];
    UILabel *banridaContext= [PublicMethod addLabel:CGRectMake(40, 30, 270, 36) setTitle:entity.info setBackColor:[UIColor lightGrayColor] setFont:[UIFont systemFontOfSize:12]];
    banridaContext.numberOfLines = 3;
    [cell.contentView addSubview:banridaContext];
    UIView *cellLine = [PublicMethod addBackView:CGRectMake(0, 69, 320, 1) setBackColor:[UIColor lightGrayColor]];
    cellLine.alpha = .2f;
    [cell.contentView addSubview:cellLine];

    /*
    if (self.dataArray.count>1) {
        if (indexPath.row < self.dataArray.count) {
            UIImageView *img = [PublicMethod addImageView:CGRectMake(10, 22, 23, 23) setImage:@"yes-2.png"];
            img.tag = 1000;
            [cell.contentView addSubview:img];
            UILabel *banrida = [PublicMethod addLabel:CGRectMake(40, 10, 230, 15) setTitle:halfDayEntity.title setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
            [cell.contentView addSubview:banrida];
            UILabel *banridaContext= [PublicMethod addLabel:CGRectMake(40, 30, 270, 36) setTitle:halfDayEntity.info setBackColor:[UIColor lightGrayColor] setFont:[UIFont systemFontOfSize:12]];
            banridaContext.numberOfLines = 3;
            [cell.contentView addSubview:banridaContext];
            UIView *cellLine = [PublicMethod addBackView:CGRectMake(0, 69, 320, 1) setBackColor:[UIColor lightGrayColor]];
            cellLine.alpha = .2f;
            [cell.contentView addSubview:cellLine];
        }else{
            UIImageView *img = [PublicMethod addImageView:CGRectMake(10, 22, 23, 23) setImage:@"yes-2.png"];
            img.tag = 1000;
            [cell.contentView addSubview:img];
            UILabel *banrida = [PublicMethod addLabel:CGRectMake(40, 10, 230, 15) setTitle:flySpeedEntity.title setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
            [cell.contentView addSubview:banrida];
            UILabel *banridaContext= [PublicMethod addLabel:CGRectMake(40, 30, 270, 36) setTitle:flySpeedEntity.info setBackColor:[UIColor lightGrayColor] setFont:[UIFont systemFontOfSize:12]];
            banridaContext.numberOfLines = 3;
            [cell.contentView addSubview:banridaContext];
            UIView *cellLine = [PublicMethod addBackView:CGRectMake(0, 69, 320, 1) setBackColor:[UIColor lightGrayColor]];
            cellLine.alpha = .2f;
            [cell.contentView addSubview:cellLine];
        }
    }else{
        for (NSDictionary * dict in self.dataArray){
            if ([dict objectForKey:@"半日达"]) {
                if (indexPath.row == 0) {
                    UIImageView *img = [PublicMethod addImageView:CGRectMake(10, 22, 23, 23) setImage:@"yes-2.png"];
                    img.tag = 1000;
                    [cell.contentView addSubview:img];
                    UILabel *banrida = [PublicMethod addLabel:CGRectMake(40, 10, 230, 15) setTitle:halfDayEntity.title setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
                    [cell.contentView addSubview:banrida];
                    UILabel *banridaContext= [PublicMethod addLabel:CGRectMake(40, 30, 270, 36) setTitle:halfDayEntity.info setBackColor:[UIColor lightGrayColor] setFont:[UIFont systemFontOfSize:12]];
                    banridaContext.numberOfLines = 3;
                    [cell.contentView addSubview:banridaContext];
                    UIView *cellLine = [PublicMethod addBackView:CGRectMake(0, 69, 320, 1) setBackColor:[UIColor lightGrayColor]];
                    cellLine.alpha = .2f;
                    [cell.contentView addSubview:cellLine];
                }
            }
            if([dict objectForKey:@"飞速达"]){
                if (indexPath.row == 0) {
                    UIImageView *img = [PublicMethod addImageView:CGRectMake(10, 22, 23, 23) setImage:@"yes-2.png"];
                    img.tag = 1000;
                    [cell.contentView addSubview:img];
                    UILabel *banrida = [PublicMethod addLabel:CGRectMake(40, 10, 230, 15) setTitle:flySpeedEntity.title setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
                    [cell.contentView addSubview:banrida];
                    UILabel *banridaContext= [PublicMethod addLabel:CGRectMake(40, 30, 270, 36) setTitle:flySpeedEntity.info setBackColor:[UIColor lightGrayColor] setFont:[UIFont systemFontOfSize:12]];
                    banridaContext.numberOfLines = 3;
                    [cell.contentView addSubview:banridaContext];
                    UIView *cellLine = [PublicMethod addBackView:CGRectMake(0, 69, 320, 1) setBackColor:[UIColor lightGrayColor]];
                    cellLine.alpha = .2f;
                    [cell.contentView addSubview:cellLine];
                }
            }
            
        }
    }
     */
    
    return cell;
}

// 送货之前电话是否确认
- (void)telephoneConfirmOrNot:(id)sender{
    UIButton * button = (UIButton *)sender;
    if (button.tag == 1000) {
        isTel = YES;
        [phoneConfirmBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.f]];
        [phoneNoConfirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        isTel = NO;
        [phoneNoConfirmBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.f]];
        [phoneConfirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

/*确认修改*/
- (void)confirmBtnClicked:(id)sender{
//    if (self.lm_time_id.length == 0) {
//        [self showNotice:@"请选择送货时间"];
//        return;
//    }
//    if (self.buEntity.logisId.length == 0) {
//        [self showNotice:@"请选择物流信息"];
//        return;
//    }
    if (self.deliveryTime.length == 0) {
        [self showNotice:@"请选择送货时间"];
        return;
    }
    if (self.deliveryId.length == 0) {
        [self showNotice:@"请选择物流信息"];
        return;
    }
    
    if (fromPayment) {
//        [[PSNetTrans getInstance] API_order_modifyDelivery_time_func:self order_list_id:self.order_list_id lm_id:self.buEntity.logisId lm_time_id:self.lm_time_id IsTel:isTel];
        [[PSNetTrans getInstance] API_order_modifyDelivery_time_func:self order_list_id:self.order_list_id lm_id:self.deliveryId lm_time_id:self.payId IsTel:isTel];
    }else{
//        _pickTimeBlock(self.buEntity.logisId,self.lm_name,self.lm_time_name,self.lm_time_id,isTel);
        NSDictionary *dic;
        if ([self.deliveryType isEqualToString:@"半日达"]) {
            if (_pickTimeBlock) {
                _pickTimeBlock(self.deliveryId,self.deliveryType,self.showDeliveryTime,self.payId,isTel);
            }
            if (self.deliveryId && self.payId && self.deliveryType && self.showDeliveryTime ) {
                dic = @{@"logisId": self.deliveryId,@"lm_time_id":self.payId,@"lm_time_name":self.showDeliveryTime, @"lm_name":self.deliveryType,@"isTel":[NSNumber numberWithBool:isTel]};
            }
        }else{
            if (_pickTimeBlock) {
                _pickTimeBlock(self.deliveryId,self.deliveryType,self.deliveryTime,self.payId,isTel);
            }
            if (self.deliveryId && self.payId && self.deliveryType && self.deliveryTime ) {
                dic = @{@"logisId": self.deliveryId,@"lm_time_id":self.payId,@"lm_time_name":self.deliveryTime, @"lm_name":self.deliveryType,@"isTel":[NSNumber numberWithBool:isTel]};
            }
        }
        
        
//        NSDictionary *dic = @{@"logisId": self.buEntity.logisId,@"lm_time_id":self.lm_time_id,@"lm_time_name":self.lm_time_name, @"lm_name":self.lm_name,@"isTel":[NSNumber numberWithBool:isTel]};
        
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"delivery"];
    }
    
    [self back:nil];

}
- (void)chooseDeliveryTime{

    YHDeliveryTimeViewController * deliveryTime = [[YHDeliveryTimeViewController alloc]init ];
    deliveryTime.isFromPSDeliveryOrder = YES;
    deliveryTime.entity = [self.dataArray objectAtIndex:selectRow];
    deliveryTime.deliveryBlock = ^(NSString * timeString, NSString * paramString,NSMutableArray * array,NSString * payId,NSNumber * type, NSString * msg){
        _nSevenDateArray = [NSMutableArray arrayWithArray:array];
        [self changeDeliveryTime:timeString date:paramString];
        self.payId = payId;
        self.type = type;
        self.msg = msg;
        [self._tableView reloadData];
    };
    [self.navigationController pushViewController:deliveryTime animated:YES];
    /*
    LogisticModelEntity * entity = [self.dataArray objectAtIndex:selectRow];
    currentTime = entity.now_date;
    
    long time = (long)[[PublicMethod NSStringToNSDateToSS:entity.now_date] longLongValue];
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
    
    if (entity.date_num.integerValue == 2 ||entity.date_num.integerValue == 1) {
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
    if ([entity.delivery_time objectForKey:@"today"]) {
        todayArray = [entity.delivery_time objectForKey:@"today"];
    }else{
        todayArray = [[NSMutableArray alloc]init];
    }
    if ([entity.delivery_time objectForKey:@"tomorrow"]) {
        tomorrowArray = [entity.delivery_time objectForKey:@"tomorrow"];
    }else{
        tomorrowArray = [[NSMutableArray alloc]init];
    }
    NSInteger todayHeight = 0;
    NSInteger tomorrowHeight = 0;
    if (todayArray.count != 0) {
        if (todayArray.count %3 ==0) {
            todayHeight = (todayArray.count/3)* 40 + 1* (todayArray.count/3 -1);
        }else{
            todayHeight = (todayArray.count/3 + 1)* 40 + 1* (todayArray.count/3);
        }
    }
    if (tomorrowArray.count != 0) {
        if (tomorrowArray.count %3 ==0) {
            tomorrowHeight = (tomorrowArray.count/3)* 40 + 1* (tomorrowArray.count/3 -1);
        }else{
            tomorrowHeight = (tomorrowArray.count/3 + 1)* 40 + 1* (tomorrowArray.count/3);
        }
    }
    
    
    //给week,day赋值，以及状态颜色
    if (entity.date_num.integerValue == 2) {
        _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight)];
        [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:2 psModel:Deliver isToday:YES];
        //具体日期显示
        [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
        [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
    }else{
        if (tomorrowHeight == 0) {
            _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight)];
            [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:nil canSelectDays:1 psModel:Deliver isToday:YES];
            //具体日期显示
            [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
            [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }else{
            _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - tomorrowHeight, SCREEN_WIDTH, 94 + tomorrowHeight)];
            [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:1 psModel:Deliver isToday:NO];
            //具体日期显示
            [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:4]];
            [_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }
        
    }
    
    NSLog(@"time_id:%@",_dateString);
    
    _yhTimeView.sevenDateArray = [NSMutableArray arrayWithArray:_sevenDateArray];
    _yhTimeView.target  = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_yhTimeView];
    //    _yhTimeView.action = @selector(selectHour:);
    YHPSDeliveryDoorViewController * vc = self;
    _yhTimeView.daySelectCB = ^(YHTimeView * view){
        if (view.dayNumber == 4) {
            vc->_yhTimeView.frame = CGRectMake(0, SCREEN_HEIGHT - 94 - tomorrowHeight, SCREEN_WIDTH, 94 + tomorrowHeight);
            vc->_resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-vc->_yhTimeView.frame.size.height);
            [vc->_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }else{
            vc->_yhTimeView.frame = CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight);
            vc->_resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-vc->_yhTimeView.frame.size.height);
            [vc->_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }
        
    };
    _yhTimeView.hourSelectCB = ^(YHTimeView * view){
        vc->_yhTimeView.hourString = view.string;
        vc->_selectDateString =[ NSString stringWithFormat:@"%@", vc->_yhTimeView.dateLabel.text];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectTime" object:nil];
        [vc changeDeliveryTime];
        [vc resignTimeView:nil];
        
    };
    
    _resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_yhTimeView.frame.size.height);
    _resignBtn.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.5];
    [_resignBtn addTarget:self action:@selector(resignTimeView:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_resignBtn];
     */
}
- (void)chooseDeliveryTime2{
    //自提时间
    NSMutableArray * todayArray ;
    NSMutableArray * tomorrowArray;
    if ([halfDayEntity.delivery_time objectForKey:@"today"]) {
        todayArray = [halfDayEntity.delivery_time objectForKey:@"today"];
    }else{
        todayArray = [[NSMutableArray alloc]init];
    }
    if ([halfDayEntity.delivery_time objectForKey:@"tomorrow"]) {
        tomorrowArray = [halfDayEntity.delivery_time objectForKey:@"tomorrow"];
    }else{
        tomorrowArray = [[NSMutableArray alloc]init];
    }
    NSInteger todayHeight = 0;
    NSInteger tomorrowHeight = 0;
    if (todayArray.count != 0) {
        if (todayArray.count %3 ==0) {
            todayHeight = (todayArray.count/3)* 40 + 1* (todayArray.count/3 -1);
        }else{
            todayHeight = (todayArray.count/3 + 1)* 40 + 1* (todayArray.count/3);
        }
    }
    if (tomorrowArray.count != 0) {
        if (tomorrowArray.count %3 ==0) {
            tomorrowHeight = (tomorrowArray.count/3)* 40 + 1* (tomorrowArray.count/3 -1);
        }else{
            tomorrowHeight = (tomorrowArray.count/3 + 1)* 40 + 1* (tomorrowArray.count/3);
        }
    }
    
    
    //给week,day赋值，以及状态颜色
    if (halfDayEntity.date_num.integerValue == 2) {
        _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight)];
        [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:2 psModel:Deliver isToday:YES];
        //具体日期显示
        [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
        [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
    }else{
        if (tomorrowHeight == 0) {
            _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight)];
            [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:nil canSelectDays:1 psModel:Deliver isToday:YES];
            //具体日期显示
            [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
            [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }else{
            _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - tomorrowHeight, SCREEN_WIDTH, 94 + tomorrowHeight)];
            [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:1 psModel:Deliver isToday:NO];
            //具体日期显示
            [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:4]];
            [_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }
        
    }
    
    NSLog(@"time_id:%@",_dateString);
    
    _yhTimeView.sevenDateArray = [NSMutableArray arrayWithArray:_sevenDateArray];
    _yhTimeView.target  = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_yhTimeView];
    _yhTimeView.target = self;
//    _yhTimeView.action = @selector(selectHour:);
    YHPSDeliveryDoorViewController * vc = self;
    _yhTimeView.daySelectCB = ^(YHTimeView * view){
        if (view.dayNumber == 4) {
            vc->_yhTimeView.frame = CGRectMake(0, SCREEN_HEIGHT - 94 - tomorrowHeight, SCREEN_WIDTH, 94 + tomorrowHeight);
            vc->_resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-vc->_yhTimeView.frame.size.height);
            [vc->_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }else{
            vc->_yhTimeView.frame = CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight);
            vc->_resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-vc->_yhTimeView.frame.size.height);
            [vc->_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }
        
    };
    _yhTimeView.hourSelectCB = ^(YHTimeView * view){
        vc->_yhTimeView.hourString = view.string;
        vc->_selectDateString =[ NSString stringWithFormat:@"%@", vc->_yhTimeView.dateLabel.text];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectTime" object:nil];
        [vc changeDeliveryTime];
        [vc resignTimeView:nil];

    };
    
    _resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_yhTimeView.frame.size.height);
    _resignBtn.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.5];
    [_resignBtn addTarget:self action:@selector(resignTimeView:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_resignBtn];
}
- (void)chooseDeliveryTime1{
    //自提时间
    NSMutableArray * todayArray ;
    NSMutableArray * tomorrowArray;
    if ([halfDayEntity.delivery_time objectForKey:@"today"]) {
        todayArray = [halfDayEntity.delivery_time objectForKey:@"today"];
    }else{
        todayArray = [[NSMutableArray alloc]init];
    }
    
    NSInteger todayHeight = 0;
    NSInteger tomorrowHeight = 0;
    if (todayArray.count == 0) {
        todayHeight = 0;
    }else{
        if (todayArray.count %3 ==0) {
            todayHeight = (todayArray.count/3)* 40 + 1* (todayArray.count/3 -1);
        }else{
            todayHeight = (todayArray.count/3 + 1)* 40 + 1* (todayArray.count/3);
        }
    }
    
    _yhTimeView = [[YHTimeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight)];
    //给week,day赋值，以及状态颜色
    if (halfDayEntity.date_num.integerValue == 2 || halfDayEntity.date_num.integerValue == 1) {
        tomorrowArray = [halfDayEntity.delivery_time objectForKey:@"tomorrow"];
        if (tomorrowArray.count %3 ==0) {
            tomorrowHeight = (tomorrowArray.count/3)* 40 + 1* (tomorrowArray.count/3 -1);
        }else{
            tomorrowHeight = (tomorrowArray.count/3 + 1)* 40 + 1* (tomorrowArray.count/3);
        }
        [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:tomorrowArray canSelectDays:2 psModel:Deliver isToday:YES];
    }else{
        [_yhTimeView addDayScrollViewAndSubViewsWithDays:_sevenDayArray weekDays:_sevenWeekDayArray otherArray:nil canSelectDays:halfDayEntity.date_num.integerValue psModel:Deliver isToday:YES];
    }
    
    NSLog(@"time_id:%@",_dateString);
    //具体日期显示
    [_yhTimeView setDateLabelText:[_sevenDateArray objectAtIndex:3]];
    [_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
    _yhTimeView.sevenDateArray = [NSMutableArray arrayWithArray:_sevenDateArray];
    _yhTimeView.target  = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_yhTimeView];
    _yhTimeView.target = self;
    //    _yhTimeView.action = @selector(selectHour:);
    YHPSDeliveryDoorViewController * vc = self;
    _yhTimeView.daySelectCB = ^(YHTimeView * view){
        if (view.dayNumber == 4) {
            vc->_yhTimeView.frame = CGRectMake(0, SCREEN_HEIGHT - 94 - tomorrowHeight, SCREEN_WIDTH, 94 + tomorrowHeight);
            vc->_resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-vc->_yhTimeView.frame.size.height);
            [vc->_yhTimeView addHourViewWithArray:tomorrowArray height:tomorrowHeight selectTime:nil calumnNumber:3];
        }else{
            vc->_yhTimeView.frame = CGRectMake(0, SCREEN_HEIGHT - 94 - todayHeight, SCREEN_WIDTH, 94 + todayHeight);
            vc->_resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-vc->_yhTimeView.frame.size.height);
            [vc->_yhTimeView addHourViewWithArray:todayArray height:todayHeight selectTime:nil calumnNumber:3];
        }
        
    };
    _yhTimeView.hourSelectCB = ^(YHTimeView * view){
        vc->_yhTimeView.hourString = view.string;
        vc->_selectDateString =[ NSString stringWithFormat:@"%@", vc->_yhTimeView.dateLabel.text];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectTime" object:nil];
        [vc changeDeliveryTime];
        [vc resignTimeView:nil];
        
    };
    
    _resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resignBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_yhTimeView.frame.size.height);
    _resignBtn.backgroundColor = [PublicMethod colorWithHexValue:0x000000 alpha:0.5];
    [_resignBtn addTarget:self action:@selector(resignTimeView:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:_resignBtn];
}

- (void)resignTimeView:(UIButton *)btn
{
    if (_yhTimeView.hourString) {
    
        [_yhTimeView removeFromSuperview];
        [_resignBtn removeFromSuperview];
    }else{
        [self showNotice :@"请选择配送时间"];
    }
    
    if (self.type.integerValue == 1 && [self.deliveryType isEqualToString:@"半日达"]&& self.deliveryTime.length != 0) {
        self.showString = self.msg;
        if (self.showString.length == 0) {
            //
        }else{
            [self showAlert:self.showString];
        }
    }
    
}
/**
 @brief 弹出ActionSheet
 */
//- (void)showActionSheetView{
//    pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 100)];
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
//    pickerView.showsSelectionIndicator = YES;
//    pickerView.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
//    
//    if (IOS_VERSION < 8) {
//        // actionsheet
//        as=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//        [as setActionSheetStyle:UIActionSheetStyleDefault];
//        as.backgroundColor = [UIColor whiteColor];
//        as.userInteractionEnabled=YES;
//        
//        NSLog(@"as %@",as);
//        UIButton *toolbar = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
//        [toolbar addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
//        [toolbar setBackgroundColor:[UIColor lightGrayColor]];
//        [toolbar setTitle:@"完成" forState:UIControlStateNormal];
//        
//        [as addSubview:toolbar];
//        [as addSubview:pickerView];
//        [as showInView:[UIApplication sharedApplication].keyWindow];
//    }else{
//        NSLog(@"as %f",IOS_VERSION);
//        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [alertC dismissViewControllerAnimated:YES completion:^{
//                
//            }];
//        }];
//        [alertC addAction:destructiveAction];
//        
//        pickerView.frame = CGRectMake(0, 0, 304, 105);
//        
//        [alertC.view addSubview:pickerView];
//        
//        [self presentViewController:alertC animated:YES completion:^{
//            
//        }];
//        
//    }
//}
//
//- (void)segmentAction:(id)sender{
//    [as dismissWithClickedButtonIndex:0 animated:YES];
//}

#pragma -
#pragma mark ----------------------------------------------UIPickerViewDelegate
- (NSInteger)numberOfRowsInComponent:(NSInteger)component{
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.timeArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.timeArray objectAtIndex:row] objectForKey:@"title"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setPickTime:row];
}

// 设置pick选择器时间
- (void)setPickTime:(NSInteger)row{

    if (self.timeArray.count == 0) {
        [self showNotice:@"不在服务时间内!"];
        btn.enabled = NO;
        confirmBtn.enabled = NO;
        btn.backgroundColor = [UIColor lightGrayColor];
        return;
    }else{
        btn.enabled = YES;
        confirmBtn.enabled = YES;
        btn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
        self.lm_time_id = [[self.timeArray objectAtIndex:row] objectForKey:@"id"];
        self.lm_time_name = [[self.timeArray objectAtIndex:row] objectForKey:@"title"];
        //提示信息
        if ([[[self.timeArray objectAtIndex:row]objectForKey:@"type"]integerValue] ==1) {
            [btn setTitle:[NSString stringWithFormat:@"%@",self.lm_time_name] forState:UIControlStateNormal];
            self.showString = [[self.timeArray objectAtIndex:row]objectForKey:@"msg"];
        }else{
            self.showString = @"";
            // 展示用的没有年份的时间
            [btn setTitle:[NSString stringWithFormat:@"%@",self.lm_time_name] forState:UIControlStateNormal];
        }
        [pickerView reloadAllComponents];
    }

}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (nTag == t_API_PS_LOGISTIC_STYLE) {
        NSLog(@"%@",(NSMutableArray *)netTransObj);
        self.dataArray = (NSMutableArray *)netTransObj;
        if (self.dataArray.count == 0) {
            [self showNotice:@"不在服务时间内!"];
            btn.enabled = NO;
            confirmBtn.enabled = NO;
            btn.backgroundColor = [UIColor lightGrayColor];
            return;
        }
        self._tableView.tableHeaderView = headerView;
        halfDayEntity = [[LogisticModelEntity alloc]init ];
        flySpeedEntity = [[LogisticModelEntity alloc]init ];
        
//        for (NSDictionary * dict in self.dataArray){
//            if ([dict objectForKey:@"半日达"]) {
//                halfDayEntity = [dict objectForKey:@"半日达"];
//            }
//            if([dict objectForKey:@"飞速达"]){
//                flySpeedEntity = [dict objectForKey:@"飞速达"];
//            }
//            
//        }
        
        
//        //......................
//        LogisticModelEntity * entity = [[LogisticModelEntity alloc]init ];
//        for (LogisticModelEntity * entity in self.dataArray){
//            currentTime = entity.now_date;
//        }
//
//        //......................
//        currentTime = halfDayEntity.now_date;
//        
//        
//        long time = (long)[[PublicMethod NSStringToNSDateToSS:halfDayEntity.now_date] longLongValue];
//        NSString * timeStr = [[NSNumber numberWithLong:time] stringValue];
//        NSDate *firstDay = [PublicMethod dateFromString:[PublicMethod timeStampConvertToFullTime:timeStr]];
//        NSTimeInterval secondsPerDay = 24 * 60 * 60;
//        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//        comps = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
//        
//        NSString *_dayNum=@"";
//        switch ([comps weekday]) {
//            case 1:{
//                _dayNum=@"日";
//                break;
//            }
//            case 2:{
//                _dayNum=@"一";
//                break;
//            }
//            case 3:{
//                _dayNum=@"二";
//                break;
//            }
//            case 4:{
//                _dayNum=@"三";
//                break;
//            }
//            case 5:{
//                _dayNum=@"四";
//                break;
//            }
//            case 6:{
//                _dayNum=@"五";
//                break;
//            }
//            case 7:{
//                _dayNum=@"六";
//                break;
//            }
//            default:
//                break;
//        }
//        
//        
//        //时间显示格式调整
//        NSDateFormatter *showDateFormatter = [[NSDateFormatter alloc] init];
//        [showDateFormatter setDateFormat:@"yyyy年MM月dd日"];
//        NSDateFormatter *showDayFormatter = [[NSDateFormatter alloc] init];
//        [showDayFormatter setDateFormat:@"yyyyMMdd"];
//        
//        if (halfDayEntity.date_num.integerValue == 2 ||halfDayEntity.date_num.integerValue == 1) {
//            for (int i = -3 ; i < 4; i ++ ) {
//                NSString * dayString = [showDayFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i*secondsPerDay]];
//                NSString * weekDayString = [self weekDay:i *secondsPerDay];
//                [_sevenDayArray addObject:[dayString substringFromIndex:6]];
//                [_sevenWeekDayArray addObject:weekDayString];
//                NSString * dateS = [showDateFormatter stringFromDate:[firstDay dateByAddingTimeInterval:i* secondsPerDay]];
//                if (i == 0) {
//                    [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 今天",dateS,weekDayString]];
//                }else if(i == 1){
//                    [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ 明天",dateS,weekDayString]];
//                }else{
//                    [_sevenDateArray addObject:[NSString stringWithFormat:@"%@ 星期%@ ",dateS,weekDayString]];
//                }
//            }
//            
//        }
        
        
        [self._tableView reloadData];
    }
    if (nTag == t_API_PS_MODIFY_DELIVERY_TIME) {
//        [self.navigationController popViewControllerAnimated:YES];
        if (self.deliveryTimeBlock) {
            self.deliveryTimeBlock(model,self.payId,self.order_list_id);
        }
        [self showNotice:@"修改成功!"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
