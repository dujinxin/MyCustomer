//
//  AddNewAddressViewController.m
//  THCustomer
//
//  Created by ioswang on 13-9-28.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "AddNewAddressViewController.h"
#define ADDRESS_PROVINCE_BTN 10000
#define ADDRESS_CITY_BTN 10001
#define ADDRESS_AREA_BTN 10002
#define ADDRESS_STREET_BTN 10003

enum {
    ENUM_TEXTFIELD_NAME = 100,
    ENUM_TEXTFIELD_MOBILE,
    ENUM_TEXTFIELD_CITY,
    ENUM_TEXTFIELD_STREET,
};

#pragma mark######################################## 地址的entity
@implementation LocationString
@synthesize _strName;
@synthesize _strMobile;
@synthesize _strDetailStreet;
@synthesize _strProvince;
@synthesize _strArea;
@synthesize _strCity;
@synthesize _codeProvince;
@synthesize _codeArea;
@synthesize _codeCity;

-(void)dealloc
{
    self._strName = nil;
    self._strMobile = nil;
    self._strDetailStreet = nil;
    self._strProvince = nil;
    self._strCity = nil;
    self._strArea = nil;
    self._codeCity = nil;
    self._codeArea = nil;
    self._codeProvince = nil;
    [super dealloc];
}
@end
#pragma mark######################################## 地址的entity

@interface AddNewAddressViewController ()

@end

@implementation AddNewAddressViewController
@synthesize _isNewOrEdit;
@synthesize _txtfName;
@synthesize _txtfMobile;
@synthesize _btnCity;
@synthesize _txtfStreet;
@synthesize _pickerView;
@synthesize _location;
@synthesize requestType;
@synthesize areaArray;
@synthesize cityArray;
@synthesize streetArray;
@synthesize provinceArray;
@synthesize addressEntity;

#pragma mark-----------------------释放资源
-(void)dealloc{
    [_txtfName      release];
    [_txtfMobile    release];
    [_btnCity       release];
    [_txtfStreet    release];
    [_pickerView    release];
    [_location      release];
    [provinceArray  release];
    [cityArray      release];
    [areaArray      release];
    [addressEntity  release];
    [streetArray    release];
    //取消网络请求
    //[[NetTrans getInstance] cancelRequestByUI:self];
    [super dealloc];
}

#pragma mark----------------------初始化
-(void)setAddressEditEntity:(OrderAddressEntity*)entity{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        if(IOS_VERSION>=7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        isRoll = NO;
        self._location = [[LocationString alloc]init];
        // 省份（province）
        NSMutableArray *tmpProvinceArray = [[[NSMutableArray alloc] init] autorelease];
        self.provinceArray = tmpProvinceArray;
        // 城市
        NSMutableArray *tmpCityArray = [[NSMutableArray alloc] init];
        self.cityArray = tmpCityArray;
        [tmpCityArray release];
        // 区域
        NSMutableArray *tmpAreaArray = [[NSMutableArray alloc] init];
        self.areaArray = tmpAreaArray;
        [tmpAreaArray release];
        
        NSMutableArray *tmpStreetArray = [[NSMutableArray alloc] init];
        self.streetArray = tmpStreetArray;
        [tmpStreetArray release];
        
        // 地址信息实体
        OrderAddressEntity *tmpAddressEntity = [[OrderAddressEntity alloc] init];
        self.addressEntity = tmpAddressEntity;
        [tmpAddressEntity release];
        [self addNavigationBackButton];
        [self addTextFieldForNewAddress];
        [self addCityPicker];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    // Custom initialization
    if(IOS_VERSION>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self requestProvinceCityAreaWithType:REQUSET_TYPE_PROVINCE ProvinceId:@"1" AreaId:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_isNewOrEdit) {
        self.navigationItem.title = @"新增地址";
    }else{
        self.navigationItem.title = @"编辑地址";
        [self setEditAddress];
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"删除", @selector(deleteAddressButtonClickEvent:));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark --------------------------添加UI
-(void)addNavigationBackButton
{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(BackButtonClickEvent:));
}
- (void)addTextFieldForNewAddress
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenSize.height)];
    _scrollview.alwaysBounceVertical = YES;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    _scrollview.delegate = self;
    [_scrollview setContentSize:CGSizeMake(ScreenSize.width, ScreenSize.height + 60)];
    [self.view addSubview:_scrollview];
    
    UIView *bgWhiteView = [PublicMethod addBackView:CGRectMake(0, 10, 320, 360) setBackColor:[UIColor whiteColor]];
    [_scrollview addSubview:bgWhiteView];
    
    //名字
    UITextField *txtfName = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 40)];
    CALayer *layer = [txtfName layer];
//    layer.masksToBounds = YES;
//    layer.cornerRadius = 5.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    txtfName.tag = ENUM_TEXTFIELD_NAME;
    txtfName.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)]autorelease];
    txtfName.leftViewMode = UITextFieldViewModeAlways;
    txtfName.backgroundColor = [UIColor whiteColor];
    txtfName.autocorrectionType = UITextAutocorrectionTypeNo;
    txtfName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtfName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfName.returnKeyType = UIReturnKeyDone;
    txtfName.placeholder = @"请输入收货人姓名";
    txtfName.font = [UIFont systemFontOfSize:15];
    txtfName.delegate = self;
    self._txtfName = txtfName;
    [_scrollview addSubview:txtfName];
    [txtfName release];
    
    //电话 手机
    UITextField *txtfMobile = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 40)];
    CALayer *layerM = [txtfMobile layer];
//    layerM.masksToBounds = YES;
//    layerM.cornerRadius = 5.0;
    layerM.borderWidth = 1.0;
    layerM.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    txtfMobile.tag = ENUM_TEXTFIELD_MOBILE;
    txtfMobile.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)]autorelease];
    txtfMobile.leftViewMode = UITextFieldViewModeAlways;
    txtfMobile.backgroundColor = [UIColor whiteColor];
    txtfMobile.autocorrectionType = UITextAutocorrectionTypeNo;
    txtfMobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtfMobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfMobile.returnKeyType = UIReturnKeyDone;
    txtfMobile.placeholder = @"请输入联系人手机号";
    txtfMobile.font = [UIFont systemFontOfSize:15];
    txtfMobile.keyboardType = UIKeyboardTypeNumberPad;
    txtfMobile.delegate = self;
    self._txtfMobile = txtfMobile;
    [_scrollview addSubview:txtfMobile];
    [txtfMobile release];
    
    UIImageView *accessDownImg = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *btncity = [[UIButton alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, 40)];
    btncity.titleLabel.font = [UIFont systemFontOfSize:15];
    [btncity setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0]  forState:UIControlStateNormal];
    btncity.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    btncity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btncity setTitle:@"请选择省份" forState:UIControlStateNormal];
    btncity.tag = ADDRESS_PROVINCE_BTN;
    [btncity addTarget:self action:@selector(cityButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    btncity.backgroundColor = [UIColor whiteColor];
    [btncity addSubview:accessDownImg];
    CALayer *layerC = [btncity layer];
//    layerC.masksToBounds = YES;
//    layerC.cornerRadius = 5.0;
    layerC.borderWidth = 1.0;
    layerC.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    [_scrollview addSubview:btncity];
    self._btnCity = btncity;
    [btncity release];
    
    // 城市
    UIImageView *accessDownImg0 = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *city = [[UIButton alloc]initWithFrame:CGRectMake(10, 170, self.view.frame.size.width-20, 40)];
    city.titleLabel.font = [UIFont systemFontOfSize:15];
    [city setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
    city.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    city.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [city setTitle:@"请选择城市" forState:UIControlStateNormal];
    city.tag = ADDRESS_CITY_BTN;
    [city addTarget:self action:@selector(cityButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    city.backgroundColor = [UIColor whiteColor];
    [city addSubview:accessDownImg0];
    CALayer *cityLayer = [city layer];
//    cityLayer.masksToBounds = YES;
//    cityLayer.cornerRadius = 5.0;
    cityLayer.borderWidth = 1.0;
    cityLayer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    [_scrollview addSubview:city];
    self.cityNameBtn = city;
    [city release];
    
    // 区域
    UIImageView *accessDownImg1 = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *areaCity = [[UIButton alloc]initWithFrame:CGRectMake(10, 220, self.view.frame.size.width-20, 40)];
    areaCity.titleLabel.font = [UIFont systemFontOfSize:15];
    [areaCity setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
    areaCity.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    areaCity.tag = ADDRESS_AREA_BTN;
    areaCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [areaCity setTitle:@"选择送货区域" forState:UIControlStateNormal];
    [areaCity addTarget:self action:@selector(cityButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    areaCity.backgroundColor = [UIColor whiteColor];
    [areaCity addSubview:accessDownImg1];
    CALayer *areaLayer = [areaCity layer];
//    areaLayer.masksToBounds = YES;
//    areaLayer.cornerRadius = 5.0;
    areaLayer.borderWidth = 1.0;
    areaLayer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    [_scrollview addSubview:areaCity];
    self.areaBtn = areaCity;
    [areaCity release];
    
    // 街道
    UIImageView *accessDownImg2 = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *streetCity = [[UIButton alloc]initWithFrame:CGRectMake(10, 270, self.view.frame.size.width-20, 40)];
    streetCity.titleLabel.font = [UIFont systemFontOfSize:15];
    [streetCity setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0]  forState:UIControlStateNormal];
    streetCity.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    streetCity.tag = ADDRESS_STREET_BTN;
    streetCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [streetCity setTitle:@"请选择乡镇街道" forState:UIControlStateNormal];
    [streetCity addTarget:self action:@selector(cityButtonClickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    streetCity.backgroundColor = [UIColor whiteColor];
    [streetCity addSubview:accessDownImg2];
    CALayer *streetLayer = [streetCity layer];
//    streetLayer.masksToBounds = YES;
//    streetLayer.cornerRadius = 5.0;
    streetLayer.borderWidth = 1.0;
    streetLayer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    [_scrollview addSubview:streetCity];
    self.streetBtn = streetCity;
    [streetCity release];
    
    //15-0517新增
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"region_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"region_name"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"country_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"]&& [[NSUserDefaults standardUserDefaults]objectForKey:@"street_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"]){
        
        [self.cityNameBtn setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"region_name"] forState:UIControlStateNormal];
        [self.areaBtn setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"] forState:UIControlStateNormal];
        [self.streetBtn setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"] forState:UIControlStateNormal];
        
        [self.cityNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.streetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self._location._strCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"region_name"];
        self._location._strArea = [[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"];
        self._location._strSreet = [[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"];
        
        self._location._codeCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"region_id"];
        self._location._codeArea = [[NSUserDefaults standardUserDefaults]objectForKey:@"country_id"];
        self._location._codeSreet = [[NSUserDefaults standardUserDefaults]objectForKey:@"street_id"];
    }

    //详细街道地址
    UITextField *txtfStreet = [[UITextField alloc]initWithFrame:CGRectMake(10, 320, self.view.frame.size.width-20, 40)];
    CALayer *layerS = [txtfStreet layer];
//    layerS.masksToBounds = YES;
//    layerS.cornerRadius = 5.0;
    layerS.borderWidth = 1.0;
    layerS.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    txtfStreet.tag = ENUM_TEXTFIELD_STREET;
    txtfStreet.leftView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)]autorelease];
    txtfStreet.leftViewMode = UITextFieldViewModeAlways;
    txtfStreet.backgroundColor = [UIColor whiteColor];
    txtfStreet.autocorrectionType = UITextAutocorrectionTypeNo;
    txtfStreet.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtfStreet.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfStreet.returnKeyType = UIReturnKeyDone;
    txtfStreet.placeholder = @"请输入详细地址";
    txtfStreet.font = [UIFont systemFontOfSize:15];
    txtfStreet.delegate = self;
    self._txtfStreet = txtfStreet;
    [_scrollview addSubview:txtfStreet];
    [txtfStreet release];
    
    CGFloat originAddY = 0.0f;
    if (iPhone5) {
        originAddY = 70.0f;
    }
    
    // 是否设置为常用title
    UILabel *setDefaultLabel = [PublicMethod addLabel:CGRectMake(10, ScreenSize.height - 80-originAddY, 200, 20) setTitle:@" 是否设为常用地址" setBackColor:[UIColor grayColor] setFont:[UIFont systemFontOfSize:16]];
    [_scrollview addSubview:setDefaultLabel];
    
    // 电话确认－是 改为 是否设为常用地址
    phoneConfirmBtn = [PublicMethod addButton:CGRectMake(240, ScreenSize.height - 85-originAddY, 25, 25) title:@"是" backGround:nil setTag:10001 setId:self selector:@selector(telephoneConfirmOrNot:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor whiteColor]];
    phoneConfirmBtn.backgroundColor = [UIColor lightGrayColor];
    
    phoneNoConfirmBtn = [PublicMethod addButton:CGRectMake(280, ScreenSize.height - 85-originAddY, 25, 25) title:@"否" backGround:nil setTag:10001 setId:self selector:@selector(telephoneConfirmOrNot:) setFont:[UIFont systemFontOfSize:14] setTextColor:[UIColor whiteColor]];
    phoneNoConfirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    
    [_scrollview addSubview:phoneConfirmBtn];
    [_scrollview addSubview:phoneNoConfirmBtn];
    
    // 确定按钮
    UIButton *btnCom = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCom.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    btnCom.frame = CGRectMake(10, ScreenSize.height - 50-originAddY, 300, 44);

    btnCom.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    [btnCom setTitle:@"保存" forState:UIControlStateNormal];
    [btnCom addTarget:self action:@selector(commitAddressButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:btnCom];
}

- (void)telephoneConfirmOrNot:(id)sender{
    if ([(UIButton *)sender isEqual:phoneConfirmBtn]) {
        isSetDefault = YES;
        [phoneConfirmBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.f]];
        [phoneNoConfirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        isSetDefault = NO;
        [phoneNoConfirmBtn setBackgroundColor:[PublicMethod colorWithHexValue:0xfc5860 alpha:1.f]];
        [phoneConfirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
}

-(void)addCityPicker
{
    UIView *bgv = [[UIView alloc]init];
    if (IOS_VERSION >= 7) {
        bgv.frame = CGRectMake(0, self.view.frame.size.height-200-NAVBAR_HEIGHT-44, self.view.frame.size.width, 244);
    }else{
        bgv.frame = CGRectMake(0, self.view.frame.size.height-200-44, self.view.frame.size.width, 244);
    }
    //地址选择器
    UIPickerView *pickV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 200)];
    pickV.backgroundColor = [UIColor lightGrayColor];
    pickV.delegate = self;
    pickV.dataSource = self;
    pickV.showsSelectionIndicator = YES;
    [bgv addSubview:pickV];
    self._pickerView = pickV;
    [pickV release];
    
    //toolbar确定选择地址
    UIToolbar *toolsBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolsBar setBarStyle:UIBarStyleBlackTranslucent];
    NSMutableArray *myToolBarItems = [NSMutableArray array];
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]
                                      initWithTitle:@"取消"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(cancelToolsButtonClick:)]autorelease];
    UIBarButtonItem *selectButton = [[[UIBarButtonItem alloc]
                                      initWithTitle:@"确定"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(selectToolsButtonClick:)]autorelease];
    
    /* space button */
    UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [myToolBarItems addObject:cancelButton];
    [myToolBarItems addObject:flexibleSpace];
    [myToolBarItems addObject:selectButton];
    [toolsBar setItems:myToolBarItems animated:YES];
    [bgv addSubview:toolsBar];
    [toolsBar release];
    
    [self.view addSubview:bgv];
    [bgv setHidden:YES];
    [bgv release];
}
#pragma mark --------------------------button Action
-(void)deleteAddressButtonClickEvent:(id)sender
{
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除该地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"否",@"是", nil];
    deleteAlert.tag = 1003;
    [deleteAlert show];
    
}

-(void)commitAddressButtonClickEvent:(id)sender
{
    [self._txtfName resignFirstResponder];
    [self._txtfMobile resignFirstResponder];
    [self._txtfStreet resignFirstResponder];
    
    self._location._strName = self._txtfName.text;
    self._location._strMobile = self._txtfMobile.text;
    self._location._strDetailStreet = self._txtfStreet.text;
    

    if ( self._location._strProvince.length == 0) {
        [self showNotice:@"请选择省份"];
        return;
    }
    if (self._location._strCity.length == 0) {
        [self showNotice:@"请选择城市"];
        return;
    }
    if (self._location._strArea.length == 0) {
        [self showNotice:@"请选择区域"];
        return;
    }
    if (self._location._strSreet.length == 0) {
        [self showNotice:@"请选择街道"];
        return;
    }
    if (self._location._strDetailStreet.length < 5) {
        [self showNotice:@"您的地址长度不够，请重新输入！"];
        return;
    }
    
    // 详细地址中是否包含字符串
    if ([PublicMethod isHasHanZiBool:self._location._strDetailStreet] == NO) {
        [self showNotice:@"您在地址中没有输入汉字，请重新输入！"];
        return;
    }
    // 手机号
    NSString *mobileStr= @"";
    if (![self._location._strMobile hasPrefix:@"1"] || self._location._strMobile.length != 11) {
        [self showNotice:@"请输入正确电话号码!"];
        return;
    }
    mobileStr = self._location._strMobile;

    // 是否设置默认
    NSString *setDefault;
    if (isSetDefault) {
        setDefault = @"1";
    }else{
        setDefault = @"0";
    }
    
    //新增时候的流程
    if (self._isNewOrEdit) {
        if (self._location._strName.length == 0
            || self._location._strMobile.length == 0
            || self._location._strDetailStreet.length == 0
            || (self._location._strProvince.length==0 && self._location._strCity.length == 0 && self._location._strArea.length ==0)
            ) {
            [[iToast makeText:@"请完善地址信息"]show];
            return;
        }
        else
        {
            NSString *finalAddress = [NSString stringWithFormat:@"%@",self._location._strDetailStreet];
            NSString *strcity = [NSString stringWithFormat:@"%@-%@-%@-%@",self._location._codeProvince,self._location._codeCity, self._location._codeArea,self._location._codeSreet];
            
            [[PSNetTrans getInstance] API_order_address_add_func:self
                                                        TrueName:self._location._strName
                                                          Mobile:mobileStr
                                                       Telephone:@""
                                                         ZipCode:@"000000"
                                                   LogisticsArea:strcity
                                                LogisticsAddress:finalAddress IsDefault:setDefault goods_id:self.goods_id];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    }
    //编辑时候的流程
    else
    {
       NSString *strcity = [NSString stringWithFormat:@"%@-%@-%@-%@",self._location._codeProvince,self._location._codeCity, self._location._codeArea,self._location._codeSreet];
        
        if (self._location._strName == nil
            || self._location._strMobile == nil
            || self._location._strDetailStreet == nil
            || strcity==nil)
        {
            [[iToast makeText:@"请完善地址信息"]show];
        }
        else
        {
            NSString *finalAddress = [NSString stringWithFormat:@"%@",self._location._strDetailStreet];
            [[PSNetTrans getInstance] API_order_address_update_func:self
                                                                 ID:self._location._id
                                                           TrueName:self._location._strName
                                                             Mobile:mobileStr
                                                          Telephone:@""
                                                            ZipCode:@"000000"
                                                      LogisticsArea:strcity
                                                   LogisticsAddress:finalAddress sDefault:setDefault];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    }
}

-(void)cityButtonClickEventHandler:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_txtfMobile resignFirstResponder];
    [_txtfName resignFirstResponder];
    [_txtfStreet resignFirstResponder];
    if (btn.tag == ADDRESS_PROVINCE_BTN) {
        requestType = REQUSET_TYPE_PROVINCE;
        [_scrollview setContentOffset:CGPointMake(0, 50) animated:YES];
        [provinceArray removeAllObjects];
        [self requestProvinceCityAreaWithType:requestType ProvinceId:@"1" AreaId:nil];
    }
    
    if (btn.tag == ADDRESS_CITY_BTN) {
        if (self._location._strProvince.length == 0) {
            [self showNotice:@"请选择省份!"];
            return;
        }
        
        requestType = REQUSET_TYPE_CITY;
        [cityArray removeAllObjects];
        [_scrollview setContentOffset:CGPointMake(0, 100) animated:YES];
        [self requestProvinceCityAreaWithType:requestType ProvinceId:@"2" AreaId:self._location._codeProvince];
    }
    if (btn.tag == ADDRESS_AREA_BTN) {
        if (self._location._strCity.length == 0) {
            [self showNotice:@"请选择城市"];
            return;
        }
        requestType = REQUSET_TYPE_AREA;
        [areaArray removeAllObjects];
        [_scrollview setContentOffset:CGPointMake(0, 150) animated:YES];
        [self requestProvinceCityAreaWithType:requestType ProvinceId:@"3" AreaId:self._location._codeCity];
    }
    if (btn.tag == ADDRESS_STREET_BTN) {
        if (self._location._strArea.length == 0) {
            [self showNotice:@"请选择区域"];
            return;
        }
        requestType = REQUSET_TYPE_STREET;
        [_scrollview setContentOffset:CGPointMake(0, 200) animated:YES];
        [streetArray removeAllObjects];
        [self requestProvinceCityAreaWithType:requestType ProvinceId:@"4" AreaId:self._location._codeArea];
    }
    [self._pickerView.superview setHidden:NO];
}
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancelToolsButtonClick:(id)sender
{
    [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    [self._pickerView.superview setHidden:YES];
}
-(void)selectToolsButtonClick:(id)sender
{
    [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    switch (requestType) {
        case 0:
        {
            // 省
            [_btnCity setTitle:self._location._strProvince forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            // 市
            [self.cityNameBtn setTitle: self._location._strCity forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            // 区
            [self.areaBtn setTitle:self._location._strArea forState:UIControlStateNormal];
            self._location._strSreet = nil;
            self._location._codeSreet = nil;
        }
            break;
        case 3:
        {
            // 街道
            [self.streetBtn setTitle:self._location._strSreet forState:UIControlStateNormal];
            if (streetArray.count == 0) {
                [self.streetBtn setTitle:@"请选择乡镇街道" forState:UIControlStateNormal];
                [self.streetBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    [self._pickerView.superview setHidden:YES];
}

#pragma -
#pragma - mark -------------------UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_txtfName resignFirstResponder];
    [_txtfMobile resignFirstResponder];
}

#pragma mark --------------------------uitextfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == ENUM_TEXTFIELD_NAME)
    {
        [self._txtfName becomeFirstResponder];
        [self._pickerView.superview setHidden:YES];
    }
    else if (textField.tag == ENUM_TEXTFIELD_MOBILE)
    {
        [self._txtfMobile becomeFirstResponder];
        [self._pickerView.superview setHidden:YES];
    }
    else if (textField.tag == ENUM_TEXTFIELD_STREET)
    {
        [_scrollview setContentOffset:CGPointMake(0, 210) animated:YES];
        [self._txtfStreet becomeFirstResponder];
        [self._pickerView.superview setHidden:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == ENUM_TEXTFIELD_NAME)
    {
        self._location._strName = textField.text;
    }
    else if (textField.tag == ENUM_TEXTFIELD_MOBILE)
    {
        self._location._strMobile = textField.text;
    }
    else if (textField.tag == ENUM_TEXTFIELD_STREET)
    {
        self._location._strDetailStreet = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
    [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];

    if (textField.tag == ENUM_TEXTFIELD_NAME)
    {
        [self._txtfMobile becomeFirstResponder];
    }
    else if (textField.tag == ENUM_TEXTFIELD_CITY)
    {
        [self._txtfStreet becomeFirstResponder];
    }
    else if (textField.tag == ENUM_TEXTFIELD_STREET)
    {
        [self._txtfStreet resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self._txtfStreet isEqual:textField]) {
        if (range.location >= 24)
            return NO; // return NO to not change text
        return YES;
    }
    return YES;
}

#pragma mark --------------------------uipicker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (requestType) {
        case 0:
            if (self.provinceArray.count >0) {
                self._pickerView.userInteractionEnabled=YES;
                return self.provinceArray.count;
            }
            break;
        case 1:
            if (self.cityArray.count>0) {
                self._pickerView.userInteractionEnabled=YES;
                return self.cityArray.count;
            }
            break;
        case 2:
            if (self.areaArray.count > 0) {
                self._pickerView.userInteractionEnabled=YES;
                return self.areaArray.count;
            }
            break;
        case 3:
            if (self.streetArray.count>0) {
                self._pickerView.userInteractionEnabled=YES;
                return self.streetArray.count;
            }else{
                self._pickerView.userInteractionEnabled=NO;
            }
            break;
        default:
            break;
    }
    return 0;
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
    switch (requestType) {
        case 0:
            if (self.provinceArray.count >0) {
                return [[self.provinceArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        case 1:
            if (self.cityArray.count >0) {
                return [[self.cityArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        case 2:
            if (self.areaArray.count >0) {
                return [[self.areaArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        case 3:
            if (self.streetArray.count > 0) {
                return [[self.streetArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        default:
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    isRoll = YES;
    switch (requestType) {
        case 0:
        {
            // 省
            self._location._strProvince = [[provinceArray objectAtIndex:row] objectForKey:@"region_name"];
            self._location._codeProvince = [[provinceArray objectAtIndex:row] objectForKey:@"region_id"];
            [_btnCity setTitle:self._location._strProvince forState:UIControlStateNormal];
            [self.cityNameBtn setTitle:@"请选择城市" forState:UIControlStateNormal];
            [self.cityNameBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            // 市
            self._location._strCity = [[cityArray objectAtIndex:row] objectForKey:@"region_name"];
            self._location._codeCity = [[cityArray objectAtIndex:row] objectForKey:@"region_id"];
            [self.cityNameBtn setTitle: self._location._strCity forState:UIControlStateNormal];
            
            [self.areaBtn setTitle:@"选择送货区域" forState:UIControlStateNormal];
            [self.areaBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];

        }
            break;
        case 2:
        {
            // 区
            self._location._codeArea = [[areaArray objectAtIndex:row] objectForKey:@"region_id"];
            self._location._strArea = [[areaArray objectAtIndex:row] objectForKey:@"region_name"];
            [self.areaBtn setTitle:self._location._strArea forState:UIControlStateNormal];
            
            [self.streetBtn setTitle:@"请选择乡镇街道" forState:UIControlStateNormal];
            [self.streetBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            // 街道
            self._location._codeSreet = [[self.streetArray objectAtIndex:row] objectForKey:@"region_id"];
            self._location._strSreet = [[self.streetArray objectAtIndex:row] objectForKey:@"region_name"];
            [self.streetBtn setTitle:self._location._strSreet forState:UIControlStateNormal];
        }
            break;
        default:
            break;
            
    }
}
#pragma mark --------------------------外部变量
- (void)setEditAddress{
    //非新增模式
    self._location._id = addressEntity.ID;
    self._txtfName.text = self.addressEntity.true_name;
    if (self.addressEntity.mobile.length > 0) {
        self._txtfMobile.text = self.addressEntity.mobile;
    }else{
        self._txtfMobile.text = self.addressEntity.telephone;
    }
    // 详细地址
    self._txtfStreet.text = self.addressEntity.logistics_address;
    
    // 省市区街道拆分
    NSArray *areaListArray = [self.addressEntity.logistics_area_list componentsSeparatedByString:@"-"];
    NSArray *areaCodeArray = [self.addressEntity.logistics_area componentsSeparatedByString:@"-"];

    if (areaListArray.count >=1) {
        // 省
        [self._btnCity setTitle:[areaListArray objectAtIndex:0] forState:UIControlStateNormal];
        [self._btnCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        self._location._strProvince = [areaListArray objectAtIndex:0];
        self._location._codeProvince = [areaCodeArray objectAtIndex:0];
    }

    if (areaListArray.count >=2) {
        // 市
        [self.cityNameBtn setTitle:[areaListArray objectAtIndex:1] forState:UIControlStateNormal];
        [self.cityNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self._location._strCity = [areaListArray objectAtIndex:1];
        self._location._codeCity = [areaCodeArray objectAtIndex:1];
    }

    if (areaListArray.count >=3) {
        // 区
        [self.areaBtn setTitle:[areaListArray objectAtIndex:2] forState:UIControlStateNormal];
        [self.areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self._location._strArea = [areaListArray objectAtIndex:2];
        self._location._codeArea = [areaCodeArray objectAtIndex:2];
    }
    if (areaListArray.count >= 4) {
        // 街道
        [self.streetBtn setTitle:[areaListArray objectAtIndex:3] forState:UIControlStateNormal];
        [self.streetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self._location._strSreet = [areaListArray objectAtIndex:3];
        self._location._codeSreet = [areaCodeArray objectAtIndex:3];
    }
    
    if (self.addressEntity.is_default){
        phoneConfirmBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
        phoneNoConfirmBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark --------------------------requestData(省市区请求接口)
- (void)requestProvinceCityAreaWithType:(RequstType)type ProvinceId:(NSString *)provId AreaId:(NSString *)areaId{
    self.requestType = type;
    [[PSNetTrans getInstance] API_areaList:self AreaType:provId AreaId:areaId ];
}

/*保存省｜市｜区 函数*/
- (void)reloadProviceCityAreaData:(NSMutableArray *)array{

    switch (requestType) {
        case REQUSET_TYPE_PROVINCE:
        {
            [self.provinceArray removeAllObjects];
            [self.provinceArray addObjectsFromArray:array];
            // 获取省列表
            self._location._codeProvince = [[provinceArray objectAtIndex:0] objectForKey:@"region_id"];
            self._location._strProvince = [[provinceArray objectAtIndex:0] objectForKey:@"region_name"];
            [_btnCity setTitle:self._location._strProvince forState:UIControlStateNormal];
            [_btnCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
            break;
        case REQUSET_TYPE_CITY:{
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:array];
            self._location._strCity = [[cityArray objectAtIndex:0] objectForKey:@"region_name"];
            self._location._codeCity = [[cityArray objectAtIndex:0] objectForKey:@"region_id"];
            [self.cityNameBtn setTitle: self._location._strCity forState:UIControlStateNormal];
            [self.cityNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case REQUSET_TYPE_AREA:{
            [self.areaArray removeAllObjects];
            [self.areaArray addObjectsFromArray:array];
            if (!(array && array.count)) {
                self._location._strArea = nil;
                self._location._codeArea = nil;
                [self.areaBtn setTitle:nil forState:UIControlStateNormal];
                break;
            }
            
            self._location._strArea = [[areaArray objectAtIndex:0] objectForKey:@"region_name"];
            self._location._codeArea = [[areaArray objectAtIndex:0] objectForKey:@"region_id"];
            [self.areaBtn setTitle:self._location._strArea forState:UIControlStateNormal];
            [self.areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
            break;
        case REQUSET_TYPE_STREET:{
            [self.streetArray removeAllObjects];
            [self.streetArray addObjectsFromArray:array];
            if (!(array && array.count)) {
                self._location._strSreet = nil;
                self._location._codeSreet = nil;
                [self.streetBtn setTitle:nil forState:UIControlStateNormal];
                break;
            }
            self._location._strSreet = [[streetArray objectAtIndex:0] objectForKey:@"region_name"];
            self._location._codeSreet = [[streetArray objectAtIndex:0] objectForKey:@"region_id"];
            [self.streetBtn setTitle:  self._location._strSreet forState:UIControlStateNormal];
            [self.streetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    [_pickerView reloadAllComponents];
}

-(void)restoreDeliveryInfo:(NewAddressEntity *)entity{
    //        [self showAlert:@"库存可能不足"];
    //保存配送信息
    [[NSUserDefaults standardUserDefaults] setObject:entity.city_code forKey:@"region_id"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.city_name forKey:@"region_name"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.area_code forKey:@"country_id"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.street_code forKey:@"street_id"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.area_name forKey:@"country_name"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.street_name forKey:@"street_name"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.bu_code forKey:@"bu_code"];
    //        [[NSUserDefaults standardUserDefaults] setObject:[[array lastObject] objectForKey:@"type"] forKey:@"bu_type"];//实体店，虚拟店
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"psStyle"];
    //清除自提信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_address"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
}
#pragma mark ----------------------------------------------------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1003 && buttonIndex == 1) {
        [[PSNetTrans getInstance] API_order_address_delete_func:self ID:addressEntity.ID];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}


#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag;
{
    if (t_API_ORDER_ADDRESS_ADD == nTag)
    {
        [[iToast makeText:@"添加新地址成功"] show];
        //设置默认地址成功后刷新列表
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(t_API_UPDATE_ADDRESS == nTag)
    {
        [[iToast makeText:@"更新地址成功"] show];
        //设置默认地址成功后刷新列表
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(t_API_DELETE_ADDRESS == nTag)
    {
        [[iToast makeText:@"删除地址成功"] show];
        //设置默认地址成功后刷新列表
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        
        NSDictionary *storeAddressDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeAddress"];
        if ([[storeAddressDic objectForKey:@"id"] isEqualToString:addressEntity.ID]) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeAddress"];
        }
        
    }
    else if (t_API_ADD_ADDRESS == nTag) {
        [[iToast makeText:@"添加新地址成功"] show];
        //设置默认地址成功后刷新列表
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.block) {
            NewAddressEntity * entity = (NewAddressEntity *)netTransObj;
            [self restoreDeliveryInfo:entity];
            self.block(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    // 请求省市区成功回调
    if (nTag == t_API_ORDER_AREA_LIST) {
        NSMutableArray *array = (NSMutableArray *)netTransObj;
        [self reloadProviceCityAreaData:array];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (nTag != t_API_ORDER_AREA_LIST)
    {
        if (nTag == t_API_ADD_ADDRESS)
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
        else if (nTag == t_API_UPDATE_ADDRESS)
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
        else if (nTag == t_API_DELETE_ADDRESS)
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
        [[iToast makeText:errMsg] show];
    }else{
        if (requestType == REQUSET_TYPE_CITY) {
            [cityArray removeAllObjects];
            self._location._strCity = nil;
        }else if(requestType == REQUSET_TYPE_AREA){
            [areaArray removeAllObjects];
            self._location._strArea = nil;
        }else if (requestType == REQUSET_TYPE_STREET){
            [streetArray removeAllObjects];
            self._location._strSreet = nil;
        }else if(requestType == REQUSET_TYPE_PROVINCE){
            self._location._strProvince = nil;
            [provinceArray removeAllObjects];
        }
        [self._pickerView reloadAllComponents];
    }

}
@end
