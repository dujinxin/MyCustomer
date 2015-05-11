//
//  AddNewAddressViewController.h
//  THCustomer
//
//  Created by ioswang on 13-9-28.
//  Copyright (c) 2013年 efuture. All rights reserved.
//
//  添加新地址和编辑地址

#import <UIKit/UIKit.h>
#import "OrderAddressEntity.h"
typedef void (^addBlock)(id block);
typedef enum{
    REQUSET_TYPE_PROVINCE,
    REQUSET_TYPE_CITY,
    REQUSET_TYPE_AREA,
    REQUSET_TYPE_STREET,
}RequstType;

@interface LocationString : NSObject
@property (nonatomic, copy) NSString    *_id;          //id,在编辑的时候用到
@property (nonatomic, copy) NSString    *_strName;     //姓名
@property (nonatomic, copy) NSString    *_strMobile;   //手机号
@property (nonatomic, copy) NSString    *_strDetailStreet;   //详细地址
@property (nonatomic, copy) NSString    *_strProvince; //省
@property (nonatomic, copy) NSString    *_strCity;     //市
@property (nonatomic, copy) NSString    *_strArea;     //区
@property (nonatomic, copy) NSString    *_strSreet;    // 街道
@property (nonatomic, copy) NSString    *_codeProvince; // 省编号
@property (nonatomic, copy) NSString    *_codeCity;     // 市编号
@property (nonatomic, copy) NSString    *_codeArea;     // 区编号
@property (nonatomic, copy) NSString    *_codeSreet;    // 街道编号

@end


@interface AddNewAddressViewController : YHRootViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>{
    BOOL isRoll;
    UIScrollView        *_scrollview;
    BOOL                isSetDefault;
    UIButton            *phoneConfirmBtn;   // 是否设置为常用 －是
    UIButton            *phoneNoConfirmBtn; // 否
}

@property (nonatomic, assign) BOOL         _isNewOrEdit;   // yes表示新增，no表示编辑
@property (nonatomic, strong) UITextField  *_txtfName;     // 姓名的编辑框
@property (nonatomic, strong) UITextField  *_txtfMobile;   // 电话号码的编辑框
@property (nonatomic, strong) UIButton     *_btnCity;      // 省
@property (nonatomic, strong) UIButton      *cityNameBtn;  // 市
// 选择城市
@property (nonatomic, strong) UIButton  *areaBtn;               // 区域
@property (nonatomic, strong) UIButton  *streetBtn;             // 街道
@property (nonatomic, strong) UITextField  *_txtfStreet;        //街道地址的编辑框
@property (nonatomic, strong) UIPickerView *_pickerView;        //地址选择器
@property (nonatomic, strong) LocationString *_location;        //整个地址信息的变量
@property (nonatomic, strong) OrderAddressEntity *addressEntity; // 地址信息实体
// 省－市－区 array
@property (nonatomic, strong) NSMutableArray *provinceArray; // 省份数组
@property (nonatomic, strong) NSMutableArray *cityArray;     // 城市数组
@property (nonatomic, strong) NSMutableArray *areaArray;     // 区域数组
@property (nonatomic, strong) NSMutableArray *streetArray;   // 街道数组
@property (nonatomic, assign) RequstType     requestType;    // 请求类型

@property (nonatomic, strong) addBlock block;

@property (nonatomic, copy) NSString    *goods_id;      //立即购用到
-(void)setAddressEditEntity:(OrderAddressEntity*)entity;
@end
