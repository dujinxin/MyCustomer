//
//  YHPSCityListViewController.m
//  YHCustomer
//
//  Created by lichentao on 14-5-15.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  城市列表

#import "YHPSCityListViewController.h"
#import "PinYinForObjc.h"
#import "HotCityView.h"
#import "ChineseToPinyin.h"
#import "YHPSPatternViewController.h"

#define REGION_NAME @"region_name"
@interface YHPSCityListViewController ()
{
    NSMutableArray              *dataArray;              // 原始数据
    NSMutableArray              *filterDataArray;        // 过滤数组
    NSMutableArray              *sectionArray;           // 格式化后数据数组
    NSMutableArray              *hotArray;
    CLLocationManager * location;
    
    
    NSString                    *selectRegion_id;        //517 new process
    NSString                    *selectRegion_name;
}

@end

@implementation YHPSCityListViewController
@synthesize cityId,locationCityName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cityDic = [NSMutableDictionary dictionary];
    }
    return self;
}


- (UIView *)cityListTitleView
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    BOOL isHasShow = [standard boolForKey:@"RegionCityTitle"];
    if (!isHasShow) {
        [standard setBool:YES forKey:@"RegionCityTitle"];
        [standard synchronize];
    
        UIView *cityViewHeader = [PublicMethod addBackView:CGRectMake(0, 0, ScreenSize.width, 50) setBackColor:[PublicMethod colorWithHexValue:0xfff6c6 alpha:1.0f]];
        UIImageView *iconImg = [PublicMethod addImageView:CGRectMake(10, 10, 24, 24) setImage:@"my_Icon_City.png"];
        UILabel *titlLabel = [PublicMethod addLabel:CGRectMake(44, 7, 240, 36) setTitle:@"因各省市所售商品不同,请根据您的收货地址选择相应的城市." setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0f] setFont:[UIFont systemFontOfSize:12]];
        titlLabel.numberOfLines = 2;
        
        [cityViewHeader addSubview:iconImg];
        [cityViewHeader addSubview:titlLabel];
        return cityViewHeader;
    }
    return nil;
}

- (void)initData:(NSArray *)hotArray1 CityList:(NSMutableArray *)cityListArray{
    // 原始数据
    dataArray = [[NSMutableArray alloc] initWithArray:cityListArray];
    filterDataArray= [[NSMutableArray alloc] initWithArray:cityListArray];
    // 热门城市
    hotArray = [[NSMutableArray alloc] initWithArray:hotArray1];
    // sectionArray
    sectionArray = [PublicMethod convertToSectionArray:dataArray HotCityArray:hotArray];
    [cityListTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    tableStyle = TABLEVIEW_LIST;        // section list
    locationStyle = Location_START;     // 定位为开始定位
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[PSNetTrans getInstance] API_RegionCityList:self];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_location"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"first_location"];
    }
    else
    {
        if ([CLLocationManager locationServicesEnabled]==NO  || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启永辉微店)" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

//iOS8 新代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:{
            if ([location respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [location requestAlwaysAuthorization];
            }
            if ([location respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [location requestWhenInUseAuthorization];
            }
        }
            
            break;
        default:
            break;
    } 
}

- (void)startLocation
{
    // 定位success以后返回城市name
    [[MMLocationManager shareLocation] getCity:^(NSString *cityString,NSString *cityId1) {
//        cityString = @"fuzhou";cityId1 = @"300";
        NSLog(@"cityString %@",cityString);
        if (cityString.length == 0 || !cityString ||cityId1.length == 0 || !cityId1)
        {
            locationStyle = Location_FAIL;
            [cityListTable reloadData];
        }
        else
        {
            //根据城市名获取城市信息，得到cityID
            self.cityId =  cityId1;
            cityDic = (NSMutableDictionary *)[self getLocationCity:self.cityId];
            if (cityDic != nil) {//在开通服务的城市里
                [[sectionArray objectAtIndex:0] removeAllObjects];
                [[sectionArray objectAtIndex:0] addObject:cityDic];
                locationStyle = Location_SUCESS;
                self.locationCityName = cityString;
                if (![[cityDic objectForKey:@"region_id"] isEqualToString:[UserAccount instance].region_id])
                {
                     [cityListTable reloadData];
                    //
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:    [NSString stringWithFormat:@"需要切换到当前定位的城市'%@'吗?",cityString] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                    alert.tag =1004;
                    if ([self isVisible])
                    {
//                        [alert show];
                    }
                }
                else
                {
                    [self restoreCityReloadData:cityDic];
//                    _cityBlock(cityString);
                }
            }else{
                locationStyle = Location_NOEXSIT;
//                if (![UserAccount instance].region_id) {
//                    _cityBlock(cityString);
//                }
                [cityListTable reloadData];
            }
             self.locationCityName = cityString;
        }

    } WithLocationError:^(NSError *error){
        //根据城市名获取城市信息，得到cityID
        [self showNotice:@"定位失败!"];
        locationStyle = Location_FAIL;
        [cityListTable reloadData];
    }];
}

// 匹配城市列表
- (NSDictionary *)getLocationCity:(NSString *)cityId1
{
    BOOL isLocation = NO;
    for (NSDictionary *dic in dataArray)
    {
        NSString *dicCityCode = [dic objectForKey:@"lbs_city_code"];
        if ([dicCityCode isEqualToString:cityId1])
        {
            isLocation = YES;
            return dic;
        }
    }
    if (isLocation == NO)
    {
        locationStyle = Location_NOEXSIT;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([UserAccount instance].location_CityName)
    {
          self.navigationItem.title = [UserAccount instance].location_CityName;
    }
    else
    {
        self.navigationItem.title = @"选择城市";
    }

    
    if (IOS_VERSION >=8) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        btn.backgroundColor = [UIColor clearColor];
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
        self.navigationItem.hidesBackButton = YES;

    }else{
        self.navigationItem.hidesBackButton = YES;
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float originY1 = 0.f;
    UIView *headView = [self cityListTitleView];
    if (headView) {
        originY1 = 50.f;
        [self.view addSubview:headView];
    }else {
        if (([[NSUserDefaults standardUserDefaults]objectForKey:@"region_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"country_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"street_id"]) || [[NSUserDefaults standardUserDefaults]objectForKey:@"bu_code"]) {
            self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"", @selector(back:));
        }
    }
    [self addSearchField:originY1];

    searchTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenSize.width, ScreenSize.height - 50 - NAVBAR_HEIGHT-originY1) style:UITableViewStylePlain];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.tableHeaderView = [self searchTableViewHeader];
    [self.view addSubview:searchTableView];
    searchTableView.hidden = YES;
    
    cityListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+originY1, ScreenSize.width, ScreenSize.height - 50 - NAVBAR_HEIGHT-originY1) style:UITableViewStylePlain];
    cityListTable.delegate = self;
    cityListTable.dataSource = self;
	cityListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cityListTable];
    
    
    location = [[CLLocationManager alloc]init];
    location.delegate = self;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_location"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"first_location"];
        if (IOS_VERSION >=8)
        {
            if ([CLLocationManager locationServicesEnabled]==NO||[CLLocationManager authorizationStatus] ==kCLAuthorizationStatusNotDetermined) {
//                location = [[CLLocationManager alloc]init ];
//                location.delegate = self;
                if ([location respondsToSelector:@selector(requestAlwaysAuthorization)])
                {
                    [location requestAlwaysAuthorization];
                }
            }
        }
    }
    
}

- (UIView *)searchTableViewHeader
{
    UILabel *bgView  = [PublicMethod addLabel:CGRectMake(0, 0, ScreenSize.width, 30) setTitle:@"   找到的城市" setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] setFont:[UIFont systemFontOfSize:14]];
    bgView.backgroundColor = LIGHT_GRAY_COLOR;
    return bgView;
}

- (void)addGetMoreFootView{
    
}
- (void)addRefreshTableHeaderView{
    
}
// searchField
- (void)addSearchField:(float)originY2
{
    UIButton *toolbar = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [toolbar addTarget:self action:@selector(chooseCityListTableView) forControlEvents:UIControlEventTouchUpInside];
    [toolbar setBackgroundColor:[UIColor lightGrayColor]];
    [toolbar setTitle:@"取消" forState:UIControlStateNormal];
    
    searchField= [[UITextField alloc] initWithFrame:CGRectMake(10, 10+originY2, SCREEN_WIDTH-20, 30)];
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.placeholder = @"请输入城市名或拼音";
    searchField.inputAccessoryView  = toolbar;
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 40, 30)];
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 24, 24)];
    [leftView setImage:[UIImage imageNamed:@"icon_seach.png"]];
    [left addSubview:leftView];
    searchField.leftView = left;
    searchField.delegate = self;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.layer.borderWidth = 0.5;
    searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchField.layer.cornerRadius = 3;
    [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged]; // textField的文本发生变化时相应事件
    [self.view addSubview:searchField];
}


- (void)back:(id)sender{
    if ([[UserAccount instance].location_CityName isEqualToString:@""] || [UserAccount instance].location_CityName == nil)
    {
        [self showAlert:@"未定位到城市,请选择"];
    }
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
   
}

#pragma -
#pragma -mark --------------------------------------------------------UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableStyle == TABLEVIEW_SEARCH){
        return  40.f;
    }else{
        if (indexPath.section== 0)
        {
            if ([[sectionArray objectAtIndex:0] count] == 0)
                return 60.0f;
            return 60.f;
        }
        else if (indexPath.section== 1){
            if ([[sectionArray objectAtIndex:1] count] == 0){
                return 0.0f;
            }else{
                if (hotArray.count < 4) {
                    return 50.f + 15;
                }else{
                    float hotcityHeight =  (hotArray.count/4) == 0? (hotArray.count/4) * 50 + 15: (hotArray.count/4) * 50 + 50 + 15;
                    return  hotcityHeight;
                }
            }
        }
        else{
            return 40.f;
        }
    }
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic;
    if (tableStyle == TABLEVIEW_SEARCH)
    {
        dic = [dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        if ((indexPath.section == 1 && indexPath.row == 0 && hotArray.count > 0) || indexPath.section == 0)
        {
            return;
        }
        NSMutableArray *sectionArray1 = [sectionArray objectAtIndex:indexPath.section];
        dic = [sectionArray1 objectAtIndex:indexPath.row];
    }

    /*
     *517 old process
     *
     YHPSPatternViewController * psPattern = [[YHPSPatternViewController alloc]init ];
     psPattern.regionDic = [NSMutableDictionary dictionaryWithDictionary:dic];
     [self.navigationController pushViewController:psPattern animated:YES];
     */
    
    /*
     *517 new process
     */
    if (dic) {
        [self selectCityWithRegionDic:dic];
    }
//    [self restoreCityReloadData:dic];
//    if(_cityBlock){
//        _cityBlock([dic objectForKey:@"region_name"]);
//        [self popViewControllerAndSelectTabOne];
//    }
    
}

#pragma mark -
#pragma mark UITableView DataSource
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableStyle == TABLEVIEW_SEARCH)
        return  1;
    return [sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableStyle == TABLEVIEW_SEARCH){
        return  dataArray.count;
    }else{
        if (section == 0 || section == 1)
            return 1;
        return [sectionArray[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableStyle == TABLEVIEW_SEARCH){
        return  0.f;
    }else{
        NSMutableArray *array = [sectionArray objectAtIndex:section];
        if (section == 0) {
            return 30.f;
        }else  if (array.count > 0) {
            return 30.f;
        }
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableStyle == TABLEVIEW_SEARCH){
        return  nil;
    }else{
        NSMutableArray *array = [sectionArray objectAtIndex:section];
        if (section == 0) {
            UILabel *label = [PublicMethod addLabel:CGRectMake(0, 0, ScreenSize.width, 30) setTitle:@"  定位城市" setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] setFont:[UIFont systemFontOfSize:14]];
            label.backgroundColor = LIGHT_GRAY_COLOR;
            return label;
        }else if (array.count > 0) {
            NSString *string;
            if (section == 1){
                string = @"  热门城市";
            }else{
                string = [NSString stringWithFormat:@"  %@", [[CITY_FIRST_LETTER substringFromIndex:section] substringToIndex:1]];
            }
            UILabel *label = [PublicMethod addLabel:CGRectMake(0, 0, ScreenSize.width, 30) setTitle:string setBackColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f] setFont:[UIFont systemFontOfSize:14]];
            label.backgroundColor = LIGHT_GRAY_COLOR;
            return label;
        }
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableStyle == TABLEVIEW_SEARCH)
        return  nil;
    NSMutableArray *indices = [NSMutableArray array];
    for (int i = 0; i < [sectionArray count]; i++){
        if ([[sectionArray objectAtIndex:i] count] || i == 0){
            NSString *indexStr = [[CITY_FIRST_LETTER substringFromIndex:i] substringToIndex:1];
            NSString *indexName ;
            if ([indexStr isEqualToString:@"定"]) {
                indexName = @"定位";
            }else if ([indexStr isEqualToString:@"热"]){
                indexName = @"热门";
            }else{
                indexName = [[CITY_FIRST_LETTER substringFromIndex:i] substringToIndex:1];
            }
            [indices addObject:indexName];
        }
    }
    return indices;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableStyle == TABLEVIEW_SEARCH){
        static NSString *cellId = @"TableViewCellSearch";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.selectedBackgroundView.backgroundColor =
        [UIColor whiteColor];
        [cell.contentView removeAllSubviews];
        
        NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
        UILabel *cityName = [PublicMethod addLabel:CGRectMake(20, 0, 300, 40) setTitle:[dic objectForKey:REGION_NAME] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:cityName];
        
        return cell;

    }else{
        static NSString *cellId = @"TableViewCellList";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView.backgroundColor =
        [UIColor whiteColor];
        
        [cell.contentView removeAllSubviews];
        
        NSMutableArray *sectionChildArray = [sectionArray objectAtIndex:indexPath.section];
        if (indexPath.section == 0) {
            if (locationStyle == Location_SUCESS) {
                if (sectionChildArray.count > 0) {
                    NSLog(@"Location_SUCESS");
                    NSDictionary *dic = [sectionChildArray objectAtIndex:indexPath.row];
                    UIButton *cityLocation = [PublicMethod addButton:CGRectMake(10,12.5 , 50, 35) title:[dic objectForKey:REGION_NAME] backGround:nil setTag:10009 setId:self selector:@selector(locationCityButtonClicked:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor blackColor]];
                    cityLocation.layer.borderWidth = 1.0f;
                    cityLocation.layer.borderColor = LIGHT_GRAY_COLOR.CGColor;
                    [cell.contentView addSubview:cityLocation];
                    
                    UIView *line = [PublicMethod addBackView:CGRectMake(0, 59, 300, 1) setBackColor:[UIColor lightGrayColor]];
                    line.alpha = 0.1f;
                    [cell.contentView addSubview:line];
                }
            }else if (locationStyle == Location_NOEXSIT){
                NSLog(@"Location_NOEXSIT");
                UILabel *locationTitle = [PublicMethod addLabel:CGRectMake(20, 15, 280, 30) setTitle:[NSString stringWithFormat:@"%@ 未开通服务,请选择城市",self.locationCityName] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:18]];
                [cell.contentView addSubview:locationTitle];
                
            }else if(locationStyle ==  Location_START){
                NSLog(@"Location_START");
                UILabel *loadingLocation = [PublicMethod addLabel:CGRectMake(20, 20, 200, 30) setTitle:@"正在定位" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:14]];
                
                UIActivityIndicatorView *acitvity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];;
                acitvity.frame = CGRectMake(240, 17, 35, 35);
                [acitvity startAnimating];
                [cell.contentView addSubview:loadingLocation];
                [cell.contentView addSubview:acitvity];
            }else{
                NSLog(@"Location_FAIL");
                UILabel *locationTitle = [PublicMethod addLabel:CGRectMake(20, 15, 180, 30) setTitle:@"未定位到城市,请选择" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:18]];
                [cell.contentView addSubview:locationTitle];
                
                UIButton *resetLocationBtn = [PublicMethod addButton:CGRectMake(210, 13, 70, 34) title:@"重新定位" backGround:nil setTag:1000 setId:self selector:@selector(startLocation) setFont:[UIFont boldSystemFontOfSize:14] setTextColor:[UIColor whiteColor]];
                resetLocationBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0f];
                [cell.contentView addSubview:resetLocationBtn];
            }
        }else if(indexPath.section == 1){
            CGFloat heightForHotView = 50.f;
            if (hotArray.count >= 4) {
                heightForHotView = (hotArray.count/4) == 0? (hotArray.count/4) * 50: (hotArray.count/4) * 50 + 50;
            }
            HotCityView *hotCityView = [[HotCityView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH - 40,heightForHotView)];
            
            [hotCityView setHotCityArray:hotArray HotCityViewBlock:^(UIButton *btn){
                NSDictionary *hotCityDic = [hotArray objectAtIndex:btn.tag-1000];
                [self hotCityButtonClicked:hotCityDic];
            }];
            [cell.contentView addSubview:hotCityView];
        }else{
            NSDictionary *dic = [sectionChildArray objectAtIndex:indexPath.row];
            
            UILabel *cityName = [PublicMethod addLabel:CGRectMake(20, 0, 300, 40) setTitle:[dic objectForKey:REGION_NAME] setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:15]];
            [cell.contentView addSubview:cityName];
            
            UIView *line = [PublicMethod addBackView:CGRectMake(0, 39, 300, 1) setBackColor:[UIColor lightGrayColor]];
            line.alpha = 0.1f;
            [cell.contentView addSubview:line];
        }
        return cell;
    }
}

// 定位－btn
- (void)locationCityButtonClicked:(id)sender
{
    /*
     *517 old process
     *
     NSDictionary *dic = [[sectionArray objectAtIndex:0] objectAtIndex:0];
     YHPSPatternViewController * psPattern = [[YHPSPatternViewController alloc]init ];
     psPattern.regionDic = [NSMutableDictionary dictionaryWithDictionary:dic];
     [self.navigationController pushViewController:psPattern animated:YES];
     */
    
    /*
     *517 new process
     */
    NSDictionary *dic = [[sectionArray objectAtIndex:0] objectAtIndex:0];
    if (dic) {
        [self selectCityWithRegionDic:dic];
    }
//    [self restoreCityReloadData:dic];
//    [self popViewControllerAndSelectTabOne];
//    _cityBlock([dic objectForKey:@"region_name"]);
}

// 热门城市－btn
- (void)hotCityButtonClicked:(NSDictionary *)hotDictionary
{
    /*
     *517 old process
     *
    YHPSPatternViewController * psPattern = [[YHPSPatternViewController alloc]init ];
    psPattern.regionDic = [NSMutableDictionary dictionaryWithDictionary:hotDictionary];
    [self.navigationController pushViewController:psPattern animated:YES];
    */
    
    /*
     *517 new process
     */
    if (hotDictionary) {
        [self selectCityWithRegionDic:hotDictionary];
    }
    
    //    [self restoreCityReloadData:hotDictionary];
    //    [self popViewControllerAndSelectTabOne];
    //    _cityBlock([hotDictionary objectForKey:@"region_name"]);
}

// section-cell Select
- (void)restoreCityReloadData:(NSDictionary *)locationDic1{
    if (nil != locationDic1)
    {
        if (![[UserAccount instance].region_id isEqualToString:[locationDic1 objectForKey:@"region_id"]]) {//切换城市，清空门店
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeInfo"];
            
            if (![[locationDic1 objectForKey:@"region_id"] isKindOfClass:[NSNull class]])
            {
                [UserAccount instance].region_id = [locationDic1 objectForKey:@"region_id"];
                [UserAccount instance].location_CityName = [locationDic1 objectForKey:@"region_name"];
                [[UserAccount instance] saveAccount];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
        }
    }
    [cityListTable reloadData];
}

- (void)popViewControllerAndSelectTabOne
{
    [self.navigationController popViewControllerAnimated:YES];
    [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
}

#pragma -mark
#pragma -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    tableStyle = TABLEVIEW_SEARCH;
    cityListTable.hidden = YES;
    searchTableView.hidden = NO;
    [searchTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)chooseCityListTableView{
    tableStyle = TABLEVIEW_LIST;
    cityListTable.hidden = NO;
    searchTableView.hidden = YES;
    [cityListTable reloadData];
    
    [searchField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (tableStyle == TABLEVIEW_SEARCH)
        [searchField resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField{
    [dataArray removeAllObjects];
    NSLog(@"textField.text is %@",textField.text);
    if (textField.text.length > 0) {
        for (NSDictionary *city_Dic in filterDataArray) {
            NSString *cityName = [city_Dic objectForKey:REGION_NAME];
            // 没有汉字-首字母匹配
            if (textField.text.length > 0 && ![PublicMethod isHasHanZiBool:textField.text]){
                NSString *tempPinYinStr = [ChineseToPinyin pinyinFromChiniseString:cityName];
                if ([tempPinYinStr hasPrefix:textField.text]) {
                    [dataArray addObject:city_Dic];
                }
            }else{
                // 有汉字-整个字符串匹配
                NSRange nameRange = [cityName rangeOfString:textField.text options:NSCaseInsensitiveSearch];
                if (nameRange.length >0 && cityName.length > 0) {
                    [dataArray addObject:city_Dic];
                }
            }
        }
    }else{
        [dataArray addObjectsFromArray:filterDataArray];
    }
    
    NSLog(@"dataArray is %@",dataArray);
    [searchTableView reloadData];
}
#pragma mark -  request api
-(void)selectCityWithRegionDic:(NSDictionary *)dict{
    selectRegion_id = [dict objectForKey:@"region_id"];
    selectRegion_name = [dict objectForKey:@"region_name"];
    
    [[PSNetTrans getInstance ] API_RegionBuCode:self region_id:selectRegion_id];
}
-(void)clearRegionInfo{
    //清除配送信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"region_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"region_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_name"];
    //                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_code"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_type"];//实体店，虚拟店
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"psStyle"];
    //清除自提信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_address"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    //
    if (![[UserAccount instance].region_id isEqualToString:selectRegion_id]) {//切换城市，清空门店
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeAddress"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeInfo"];
        [UserAccount instance].region_id = selectRegion_id;
        [UserAccount instance].location_CityName = selectRegion_name;
        [[UserAccount instance] saveAccount];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
    
}
#pragma -mark
#pragma -NetDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    [self showNotice:errMsg];

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if (nTag == t_API_PS_REGION_LIST) {
        NSDictionary *arrayDic = (NSDictionary *)netTransObj;
        NSMutableArray *hotArray1 = [arrayDic objectForKey:@"hot_region_list"];
        NSMutableArray *cityArray = [arrayDic objectForKey:@"region_list"];
        [self initData:hotArray1 CityList:cityArray];
        // 启动定位
        [self startLocation];
    }else if (nTag == t_API_PS_REGION_BUCODE){
        if ([netTransObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = (NSDictionary *)netTransObj;
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"bu_code"] forKey:@"bu_code"];
//            if (selectRegion_id && [UserAccount instance].region_id && [selectRegion_id isEqualToString:[UserAccount instance].region_id]) {
//                //相同，不需要
//            }else{
                [self clearRegionInfo];
//            }
            [self popViewControllerAndSelectTabOne];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------------------------------------------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1004 && buttonIndex == 1) {

        [self restoreCityReloadData:cityDic];
        
        self.navigationItem.title = [UserAccount instance].location_CityName;
        
        if([UserAccount instance].region_id.length != 0){
//            if (_cityBlock)
//            {
//                _cityBlock([cityDic objectForKey:@"region_name"]);
//                [self popViewControllerAndSelectTabOne];
//            }
        //定位成功，但是保存region_id失败
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"存储信息失败,请重新定位或者选择一个城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


@end
