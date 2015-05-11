//
//  MyPickerView.h
//  YHCustomer
//
//  Created by lichentao on 14-4-29.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyPickerBlock)(NSString *selectRow);

@interface MyPickerView : NSObject<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    UIActionSheet       *as;
    UIPickerView        *_pickerView;
    UIButton            *toolbar;
}

@property(nonatomic, strong) MyPickerBlock  pickerBlock;
@property(nonatomic, strong) NSMutableArray *myDataArray;
@property(nonatomic, copy) NSString * selectString;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL action;




/**
 * @brief:pickerArray:传入的数据数组
 * @brief:pikcerBlock1:点击pickerrow的响应事件
 */
- (void)initWithPickerData:(NSArray *)pickerArray MyPickerBlock:(MyPickerBlock)pikcerBlock1;
- (void)initWithPickerData:(NSArray *)pickerArray selectString:(NSString *)selectString MyPickerBlock:(MyPickerBlock)pikcerBlock1;

@end
