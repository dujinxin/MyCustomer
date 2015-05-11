//
//  YHShakeAddressViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-11-17.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHShakeAddressViewController.h"
#import "ShakeEntity.h"

@interface YHShakeAddressViewController ()<UIAlertViewDelegate>
{
    BOOL isRoll;
    UIScrollView * _scrollView;
    UIPickerView * _pickerView;
    UITextField  * _txtfName;       // 姓名的编辑框
    UITextField  * _txtfMobile;
    UITextField  * _txtfStreet;
    
    UIButton     *_btnCity;         // 省
    UIButton     *_cityNameBtn;     // 市
    UIButton     *_areaBtn;         // 区域
    UIButton     *_streetBtn;       // 街道
    
    NSMutableArray *_provinceArray; // 省份数组
    NSMutableArray *_cityArray;     // 城市数组
    NSMutableArray *_areaArray;     // 区域数组
    NSMutableArray *_streetArray;   // 街道数组
    RequestType     _requestType;   // 请求类型
    
    AddressEntity  *_addressEntity;
}
@end

@implementation YHShakeAddressViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        _addressEntity = [[AddressEntity alloc]init ];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar];
    [self addMainView];
    [self addCityPicker];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitUI
- (void)addNavigationBar{
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(back:));
    self.navigationItem.title = @"填写收货地址";
    
}
- (void)addMainView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenSize.height)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(ScreenSize.width, ScreenSize.height + 60)];
    [self.view addSubview:_scrollView];
    
    UIView *bgWhiteView = [PublicMethod addBackView:CGRectMake(0, 10, 320, 360) setBackColor:[UIColor whiteColor]];
    [_scrollView addSubview:bgWhiteView];
    
    //名字
    UITextField *txtfName = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 40)];
    CALayer *layer = [txtfName layer];
    //    layer.masksToBounds = YES;
    //    layer.cornerRadius = 5.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    txtfName.tag = ENUM_TEXTFIELD_NAME;
    txtfName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    txtfName.leftViewMode = UITextFieldViewModeAlways;
    txtfName.backgroundColor = [UIColor whiteColor];
    txtfName.autocorrectionType = UITextAutocorrectionTypeNo;
    txtfName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtfName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfName.returnKeyType = UIReturnKeyDone;
    txtfName.placeholder = @"请输入收货人姓名";
    txtfName.delegate = self;
    _txtfName = txtfName;
    [_scrollView addSubview:txtfName];

    
    //电话 手机
    _txtfMobile = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 40)];
    CALayer *layerM = [_txtfMobile layer];
    //    layerM.masksToBounds = YES;
    //    layerM.cornerRadius = 5.0;
    layerM.borderWidth = 1.0;
    layerM.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    _txtfMobile.tag = ENUM_TEXTFIELD_MOBILE;
    _txtfMobile.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    _txtfMobile.leftViewMode = UITextFieldViewModeAlways;
    _txtfMobile.backgroundColor = [UIColor whiteColor];
    _txtfMobile.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtfMobile.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _txtfMobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtfMobile.returnKeyType = UIReturnKeyDone;
    _txtfMobile.placeholder = @"请输入联系人手机号";
    _txtfMobile.keyboardType = UIKeyboardTypeNumberPad;
    _txtfMobile.delegate = self;
    [_scrollView addSubview:_txtfMobile];

    
    UIImageView *accessDownImg = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *btncity = [[UIButton alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, 40)];
    btncity.titleLabel.font = [UIFont systemFontOfSize:18];
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
    [_scrollView addSubview:btncity];
    _btnCity = btncity;
    
    // 城市
    UIImageView *accessDownImg0 = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *city = [[UIButton alloc]initWithFrame:CGRectMake(10, 170, self.view.frame.size.width-20, 40)];
    city.titleLabel.font = [UIFont systemFontOfSize:18];
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
    [_scrollView addSubview:city];
    _cityNameBtn = city;
    
    // 区域
    UIImageView *accessDownImg1 = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *areaCity = [[UIButton alloc]initWithFrame:CGRectMake(10, 220, self.view.frame.size.width-20, 40)];
    areaCity.titleLabel.font = [UIFont systemFontOfSize:18];
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
    [_scrollView addSubview:areaCity];
    _areaBtn = areaCity;
    
    // 街道
    UIImageView *accessDownImg2 = [PublicMethod addImageView:CGRectMake(280, 13, 10, 10) setImage:@"icon_arrow-ddd.png"];
    UIButton *streetCity = [[UIButton alloc]initWithFrame:CGRectMake(10, 270, self.view.frame.size.width-20, 40)];
    streetCity.titleLabel.font = [UIFont systemFontOfSize:18];
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
    [_scrollView addSubview:streetCity];
    _streetBtn = streetCity;
    
    //详细街道地址
    UITextField *txtfStreet = [[UITextField alloc]initWithFrame:CGRectMake(10, 320, self.view.frame.size.width-20, 40)];
    CALayer *layerS = [txtfStreet layer];
    //    layerS.masksToBounds = YES;
    //    layerS.cornerRadius = 5.0;
    layerS.borderWidth = 1.0;
    layerS.borderColor = [RGBCOLOR(204, 204, 204) CGColor];
    
    txtfStreet.tag = ENUM_TEXTFIELD_STREET;
    txtfStreet.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    txtfStreet.leftViewMode = UITextFieldViewModeAlways;
    txtfStreet.backgroundColor = [UIColor whiteColor];
    txtfStreet.autocorrectionType = UITextAutocorrectionTypeNo;
    txtfStreet.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtfStreet.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtfStreet.returnKeyType = UIReturnKeyDone;
    txtfStreet.placeholder = @"请输入详细地址";
    txtfStreet.delegate = self;
    _txtfStreet = txtfStreet;
    [_scrollView addSubview:txtfStreet];
    
    CGFloat originAddY = 0.0f;
    if (iPhone5) {
        originAddY = 70.0f;
    }
    
    // 确定按钮
    UIButton *btnCom = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCom.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.f];
    btnCom.frame = CGRectMake(10, 390, 300, 44);
    
    btnCom.titleLabel.font =[UIFont boldSystemFontOfSize:20];
    [btnCom setTitle:@"保存" forState:UIControlStateNormal];
    [btnCom addTarget:self action:@selector(commitAddressButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnCom];
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
    _pickerView = pickV;
    
    //toolbar确定选择地址
    UIToolbar *toolsBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolsBar setBarStyle:UIBarStyleBlackTranslucent];
    NSMutableArray *myToolBarItems = [NSMutableArray array];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(cancelToolsButtonClick:)];
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"确定"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(selectToolsButtonClick:)];
    
    /* space button */
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [myToolBarItems addObject:cancelButton];
    [myToolBarItems addObject:flexibleSpace];
    [myToolBarItems addObject:selectButton];
    [toolsBar setItems:myToolBarItems animated:YES];
    [bgv addSubview:toolsBar];
    
    [self.view addSubview:bgv];
    [bgv setHidden:YES];
}
#pragma mark - BtnClick
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    [_txtfName resignFirstResponder];
    [_txtfMobile resignFirstResponder];
    [_txtfStreet resignFirstResponder];
    
    _addressEntity.name = _txtfName.text;
    _addressEntity.mobile = _txtfMobile.text;
    _addressEntity.detail = _txtfStreet.text;
    
    
    if (_addressEntity.province.length == 0) {
        [self showNotice:@"请选择省份"];
        return;
    }
    if (_addressEntity.city.length == 0) {
        [self showNotice:@"请选择城市"];
        return;
    }
    if (_addressEntity.area.length == 0) {
        [self showNotice:@"请选择区域"];
        return;
    }
    if (_addressEntity.street.length == 0) {
        [self showNotice:@"请选择街道"];
        return;
    }
    if (_addressEntity.detail.length < 5) {
        [self showNotice:@"您的地址长度不够，请重新输入！"];
        return;
    }
    
    // 详细地址中是否包含字符串
    if ([PublicMethod isHasHanZiBool:_addressEntity.detail] == NO) {
        [self showNotice:@"您在地址中没有输入汉字，请重新输入！"];
        return;
    }
    // 手机号
    NSString *mobileStr= @"";
    if (![_addressEntity.mobile hasPrefix:@"1"] || _addressEntity.mobile.length != 11) {
        [self showNotice:@"请输入正确电话号码!"];
        return;
    }
    mobileStr = _addressEntity.mobile;
    
    if (_addressEntity.name.length == 0
        || _addressEntity.mobile.length == 0
        || _addressEntity.detail.length == 0
        || (_addressEntity.province.length==0 && _addressEntity.city.length == 0 && _addressEntity.area.length ==0 && _addressEntity.street.length ==0)
        ) {
        [[iToast makeText:@"请完善地址信息"]show];
        return;
    }
    NSString *finalAddress = [NSString stringWithFormat:@"%@",_addressEntity.detail];
    NSString *strcity = [NSString stringWithFormat:@"%@%@%@%@",_addressEntity.province,_addressEntity.city, _addressEntity.area,_addressEntity.street];
    
    [[NetTrans getInstance] shake_express_area:strcity address:finalAddress name:_addressEntity.name mobile:_addressEntity.mobile activityId:_activityId transdel:self];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)cityButtonClickEventHandler:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_txtfMobile resignFirstResponder];
    [_txtfName resignFirstResponder];
    [_txtfStreet resignFirstResponder];
    if (btn.tag == ADDRESS_PROVINCE_BTN) {
        _requestType = REQUSET_TYPE_PROVINCE;
        [_scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
        [_provinceArray removeAllObjects];

        [[NetTrans getInstance] shake_address_list:self level:@"1" pid:@"0"];
    }
    
    if (btn.tag == ADDRESS_CITY_BTN) {
        if (_addressEntity.province.length == 0) {
            [self showNotice:@"请选择省份!"];
            return;
        }
        _requestType = REQUSET_TYPE_CITY;
        [_cityArray removeAllObjects];
        [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        [[NetTrans getInstance] shake_address_list:self level:@"2" pid:_addressEntity.provinceId];
    }
    if (btn.tag == ADDRESS_AREA_BTN) {
        if (_addressEntity.city.length == 0) {
            [self showNotice:@"请选择城市"];
            return;
        }
        _requestType = REQUSET_TYPE_AREA;
        [_cityArray removeAllObjects];
        [_scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
        [[NetTrans getInstance] shake_address_list:self level:@"3" pid:_addressEntity.cityId];
    }
    if (btn.tag == ADDRESS_STREET_BTN) {
        if (_addressEntity.area.length == 0) {
            [self showNotice:@"请选择区域"];
            return;
        }
        _requestType = REQUSET_TYPE_STREET;
        [_scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
        [_streetArray removeAllObjects];
        [[NetTrans getInstance] shake_address_list:self level:@"4" pid:_addressEntity.areaId];
    }
    [_pickerView.superview setHidden:NO];
}
-(void)BackButtonClickEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancelToolsButtonClick:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_pickerView.superview setHidden:YES];
}
-(void)selectToolsButtonClick:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    switch (_requestType) {
        case 0:
        {
            // 省
            [_btnCity setTitle:_addressEntity.province forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            // 市
            [_cityNameBtn setTitle: _addressEntity.city forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            // 区
            [_areaBtn setTitle:_addressEntity.area forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            // 街道
            [_streetBtn setTitle:_addressEntity.street forState:UIControlStateNormal];
            if (_streetArray.count == 0) {
                [_streetBtn setTitle:@"请选择乡镇街道" forState:UIControlStateNormal];
                [_streetBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    [_pickerView.superview setHidden:YES];
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
        [_txtfName becomeFirstResponder];
        [_pickerView.superview setHidden:YES];
    }
    else if (textField.tag == ENUM_TEXTFIELD_MOBILE)
    {
        [_txtfMobile becomeFirstResponder];
        [_pickerView.superview setHidden:YES];
    }
    else if (textField.tag == ENUM_TEXTFIELD_STREET)
    {
        [_scrollView setContentOffset:CGPointMake(0, 210) animated:YES];
        [_txtfStreet becomeFirstResponder];
        [_pickerView.superview setHidden:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == ENUM_TEXTFIELD_NAME)
    {
        _addressEntity.name = textField.text;
    }
    else if (textField.tag == ENUM_TEXTFIELD_MOBILE)
    {
        _addressEntity.mobile = textField.text;
    }
    else if (textField.tag == ENUM_TEXTFIELD_STREET)
    {
        _addressEntity.detail = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField becomeFirstResponder];
    [textField resignFirstResponder];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if (textField.tag == ENUM_TEXTFIELD_NAME)
    {
        [_txtfMobile becomeFirstResponder];
    }
    else if (textField.tag == ENUM_TEXTFIELD_CITY)
    {
        [_txtfStreet becomeFirstResponder];
    }
    else if (textField.tag == ENUM_TEXTFIELD_STREET)
    {
        [_txtfStreet resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_txtfStreet isEqual:textField]) {
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
    switch (_requestType) {
        case 0:
            if (_provinceArray.count >0) {
                _pickerView.userInteractionEnabled=YES;
                return _provinceArray.count;
            }
            break;
        case 1:
            if (_cityArray.count>0) {
                _pickerView.userInteractionEnabled=YES;
                return _cityArray.count;
            }
            break;
        case 2:
            if (_areaArray.count > 0) {
                _pickerView.userInteractionEnabled=YES;
                return _areaArray.count;
            }
            break;
        case 3:
            if (_streetArray.count>0) {
                _pickerView.userInteractionEnabled=YES;
                return _streetArray.count;
            }else{
                _pickerView.userInteractionEnabled=NO;
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
    switch (_requestType) {
        case 0:
            if (_provinceArray.count >0) {
                return [[_provinceArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        case 1:
            if (_cityArray.count >0) {
                return [[_cityArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        case 2:
            if (_areaArray.count >0) {
                return [[_areaArray objectAtIndex:row] objectForKey:@"region_name"];
            }
            break;
        case 3:
            if (_streetArray.count > 0) {
                return [[_streetArray objectAtIndex:row] objectForKey:@"region_name"];
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
    switch (_requestType) {
        case 0:
        {
            // 省
            _addressEntity.province = [NSString stringWithFormat:@"%@", [[_provinceArray objectAtIndex:row] objectForKey:@"region_name"]];
            _addressEntity.provinceId = [[_provinceArray objectAtIndex:row] objectForKey:@"region_id"];
            [_btnCity setTitle:_addressEntity.province forState:UIControlStateNormal];
            [_cityNameBtn setTitle:@"请选择城市" forState:UIControlStateNormal];
            [_cityNameBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            // 市
            _addressEntity.city = [[_cityArray objectAtIndex:row] objectForKey:@"region_name"];
            _addressEntity.cityId = [[_cityArray objectAtIndex:row] objectForKey:@"region_id"];
            [_cityNameBtn setTitle: _addressEntity.city forState:UIControlStateNormal];
            
            [_areaBtn setTitle:@"选择送货区域" forState:UIControlStateNormal];
            [_areaBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        {
            // 区
            _addressEntity.area = [[_areaArray objectAtIndex:row] objectForKey:@"region_name"];
            _addressEntity.areaId = [[_areaArray objectAtIndex:row] objectForKey:@"region_id"];
            [_areaBtn setTitle:_addressEntity.area forState:UIControlStateNormal];
            
            [_streetBtn setTitle:@"请选择乡镇街道" forState:UIControlStateNormal];
            [_streetBtn setTitleColor:[PublicMethod colorWithHexValue:0xc7c7cd alpha:1.0] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            // 街道
            _addressEntity.street = [[_streetArray objectAtIndex:row] objectForKey:@"region_name"];
            _addressEntity.streetId = [[_streetArray objectAtIndex:row] objectForKey:@"region_id"];
            [_streetBtn setTitle:_addressEntity.street forState:UIControlStateNormal];
        }
            break;
        default:
            break;
            
    }
}
#pragma mark --------------------------外部变量

#pragma mark --------------------requestData(省市区请求接口)
//- (void)requestProvinceCityAreaWithType:(RequstType)type ProvinceId:(NSString *)provId AreaId:(NSString *)areaId{
//    self.requestType = type;
//    [[PSNetTrans getInstance] API_areaList:self AreaType:provId AreaId:areaId ];
//}

/*保存省｜市｜区 函数*/
- (void)reloadData:(NSMutableArray *)array{
    
    switch (_requestType) {
        case REQUSET_TYPE_PROVINCE:
        {
            [_provinceArray removeAllObjects];
            _provinceArray = [NSMutableArray arrayWithArray:array];
            // 获取省列表
            _addressEntity.province = [[_provinceArray objectAtIndex:0] objectForKey:@"region_name"];
            _addressEntity.provinceId = [[_provinceArray objectAtIndex:0] objectForKey:@"region_id"];
            [_btnCity setTitle:_addressEntity.province forState:UIControlStateNormal];
            [_btnCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
            break;
        case REQUSET_TYPE_CITY:{
            [_cityArray removeAllObjects];
            _cityArray = [NSMutableArray arrayWithArray:array];
            _addressEntity.city = [[_cityArray objectAtIndex:0] objectForKey:@"region_name"];
            _addressEntity.cityId = [[_cityArray objectAtIndex:0] objectForKey:@"region_id"];
            [_cityNameBtn setTitle: _addressEntity.city forState:UIControlStateNormal];
            [_cityNameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case REQUSET_TYPE_AREA:{
            [_areaArray removeAllObjects];
            _areaArray = [NSMutableArray arrayWithArray:array];
            _addressEntity.area = [[_areaArray objectAtIndex:0] objectForKey:@"region_name"];
            _addressEntity.areaId = [[_areaArray objectAtIndex:0] objectForKey:@"region_id"];
            [_areaBtn setTitle:_addressEntity.area forState:UIControlStateNormal];
            [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
            break;
        case REQUSET_TYPE_STREET:{
            [_streetArray removeAllObjects];
            _streetArray = [NSMutableArray arrayWithArray:array];
            _addressEntity.street = [[_streetArray objectAtIndex:0] objectForKey:@"region_name"];
            _addressEntity.streetId = [[_streetArray objectAtIndex:0] objectForKey:@"region_id"];
            [_streetBtn setTitle: _addressEntity.street forState:UIControlStateNormal];
            [_streetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    [_pickerView reloadAllComponents];
}

#pragma mark ----------------------------------------------------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag;
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (t_API_SHAKE_ADDRESS_LIST == nTag)
    {
        NSMutableArray *array = (NSMutableArray *)netTransObj;
        [self reloadData:array];
        
    }else if(t_API_SHAKE_EXPRESS_ADDRESS == nTag){
        NSLog(@"提交成功");
        if (_block) {
            NSString * address = [NSString stringWithFormat:@"%@%@%@%@%@",_addressEntity.province,_addressEntity.city, _addressEntity.area,_addressEntity.street,_addressEntity.detail];
            self.block(_addressEntity.name,_addressEntity.mobile,address);
        }
        [self showAlert:self Message:@"添加地址成功"];
    }
    // 请求省市区成功回调
    if (nTag == t_API_ORDER_AREA_LIST) {
        NSMutableArray *array = (NSMutableArray *)netTransObj;
        [self reloadData:array];
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
@end

