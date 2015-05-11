//
//  YHPSStoreInfoViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-3-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  自提门店

#import "YHPSStoreInfoViewController.h"
#import "YHStoreListViewController.h"
@interface YHPSStoreInfoViewController (){
    UIButton *btn;
    UIButton *pickStoreBtn;
    NSTimeInterval selectInterval;
}

@property (nonatomic, strong) NSMutableArray *monthDayArray;
@property (nonatomic, strong) NSMutableArray *storeTimeArray;

@property (nonatomic, strong) NSString *monthStr;
@property (nonatomic, strong) NSString *monthDayStr;
@property (nonatomic, strong) NSString *uploadTimeStr;
@property (nonatomic, strong) NSString *hourMinuteStr;
@property (nonatomic, strong) NSString *pickTimeLabel;
@property (nonatomic, strong) NSMutableArray *hourMinuteArray;

@end

@implementation YHPSStoreInfoViewController

@synthesize monthDayArray,storeTimeArray,uploadTimeStr,hourMinuteArray;
@synthesize order_list_id;
@synthesize buEntity;
@synthesize dateStringDefault;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        monthDayArray = [[NSMutableArray alloc] init];
        storeTimeArray = [[NSMutableArray alloc] init];
        uploadTimeStr = [[NSString alloc] init];
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate * today = [NSDate date];
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"MM月dd日"];
        
        NSDateFormatter *storeDateFormatter = [[NSDateFormatter alloc] init];
        [storeDateFormatter setDateFormat:@"yyyy年MM月dd"];
        
        for (int i = 0; i < 2; i ++) {
            NSString *dateString = [myDateFormatter stringFromDate:[today dateByAddingTimeInterval:i * secondsPerDay]];
            NSString *dateStore = [storeDateFormatter stringFromDate:[today dateByAddingTimeInterval:i * secondsPerDay]];
            [monthDayArray addObject:dateString];
            [storeTimeArray addObject:dateStore];
        }
        hourMinuteArray = [[NSMutableArray alloc] initWithObjects:@"8:00",@"8:30",@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00", nil];
        
        // 默认选择月天／时分 字符串
        self.monthStr = [monthDayArray objectAtIndex:0];
        self.monthDayStr = [storeTimeArray objectAtIndex:0];
        self.hourMinuteStr = [hourMinuteArray objectAtIndex:0];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"自提门店";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    
    UILabel *pickTitle = [PublicMethod addLabel:CGRectMake(20, 20, 230, 40) setTitle:@"选择自提门店" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:pickTitle];
    
    pickStoreBtn = [PublicMethod addButton:CGRectMake(10, 60, 300, 45) title:@"选择自提门店" backGround:@"cart_myOrderCellBg.png" setTag:1000 setId:self selector:@selector(pickStore:) setFont:[UIFont boldSystemFontOfSize:14] setTextColor:[UIColor blackColor]];
    [pickStoreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    pickStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:pickStoreBtn];
    
    UILabel *pickTime = [PublicMethod addLabel:CGRectMake(20, 110, 230, 40) setTitle:@"选择自提时间" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:pickTime];

    // 选择自提时间
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 155, 300, 45);
    [btn setTitle:@"选择自提时间" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn addTarget:self action:@selector(showActionSheetView) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setBackgroundImage:[UIImage imageNamed:@"cart_myOrderCellBg.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"cart_myOrderCellBg.png"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"cart_myOrderCellBg.png"] forState:UIControlStateSelected];
    
    [self.view addSubview:btn];
    
    UIImageView *acceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_myOrderAccess.png"]];
    acceImg.frame =CGRectMake(275, 12, 20, 20);
    [btn addSubview:acceImg];
 
    UIImageView *storeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_myOrderAccess.png"]];
    storeImage.frame =CGRectMake(275, 12, 20, 20);
    [pickStoreBtn addSubview:storeImage];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(22.5, 250, 275, 40);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, 0.0, 0.0)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"cart_Confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}


- (void)pickStore:(id)sender{
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeDic"];
    YHStoreListViewController *storeList =[[YHStoreListViewController alloc] init];
    if (storeDic) {
        storeList.buname = [storeDic objectForKey:@"buName"];
    }
    storeList.store = self.buEntity;
    storeList.storeBlock = ^(BuListEntity *buEntity1){
        self.buEntity = buEntity1;
        
        NSDictionary *storeDic = @{@"buName": self.buEntity.bu_name,@"buId":self.buEntity.bu_id};
        [[NSUserDefaults standardUserDefaults] setObject:storeDic forKey:@"storeDic"];
    };
    
    [self.navigationController pushViewController:storeList animated:YES];
}

/*确认修改*/
- (void)confirmBtnClicked:(id)sender{
    if (self.uploadTimeStr.length == 0) {
        [self showNotice:@"请选择修改时间"];
        return;
    }
    NSTimeInterval _fitstDate = (long)[[NSDate date] timeIntervalSince1970]*1;
    if ((selectInterval+1200 - (_fitstDate+3600*2)) < 0) {
        //第一个时间大<当前时间》提货时间>
        [self showNotice:@"请选择正确时间"];
        return;
    }
    [[NetTrans getInstance] buy_modifyOrderTime:self Bu_id:self.order_list_id Time:self.uploadTimeStr];
}

/**
 @brief 弹出ActionSheet
 */
- (void)showActionSheetView{
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
    [as addSubview:toolbar];
    [as addSubview:pickerView];
    [as showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)segmentAction:(id)sender{
    [as dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma -
#pragma mark ----------------------------------------------UIPickerViewDelegate
- (NSInteger)numberOfRowsInComponent:(NSInteger)component{
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.monthDayArray.count;
        case 1:
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
            return [storeTimeArray objectAtIndex:row];
        case 1:
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
            self.monthDayStr = [storeTimeArray objectAtIndex:row];
            self.monthStr = [monthDayArray objectAtIndex:row];
            break;
        case 1:
            self.hourMinuteStr = [hourMinuteArray objectAtIndex:row];
            break;
        default:
            break;
    }
    // 展示用的没有年份的时间
    [btn setTitle:[NSString stringWithFormat:@"自提时间: %@ %@",self.monthDayStr,self.hourMinuteStr] forState:UIControlStateNormal];
    // 上传时间时间戳
    self.uploadTimeStr = [self NSStringToNSDate:[NSString stringWithFormat:@"%@ %@",self.monthDayStr,self.hourMinuteStr]];
}

// 传入时间－转换时间戳
- (NSString * )NSStringToNSDate: (NSString * )string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT];
    NSDate *date1 = [formatter dateFromString :string];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
    selectInterval = (long)[date1 timeIntervalSince1970];
    NSLog(@"date is %@",date1);
    return timeStamp;
}

- (void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [[iToast makeText:errMsg]show];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_BUY_PLATFORM_ORDER_UPDATE) {
        [self.navigationController popViewControllerAnimated:YES];
//        _pickTimeBlock();
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
