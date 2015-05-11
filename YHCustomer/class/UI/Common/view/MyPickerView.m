//
//  MyPickerView.m
//  YHCustomer
//
//  Created by lichentao on 14-4-29.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  pickerView- 用于传导数据- 事件响应

#import "MyPickerView.h"

@implementation MyPickerView

@synthesize myDataArray;
@synthesize pickerBlock;
@synthesize selectString = _selectString;


- (id)init{
    if (self) {
        self = [super init];
        myDataArray = [[NSMutableArray alloc] init];
        
        
        _pickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 100)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
        

        if (IOS_VERSION<=8) {
            as=[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [as setActionSheetStyle:UIActionSheetStyleDefault];
            as.backgroundColor = [UIColor whiteColor];
            as.userInteractionEnabled=YES;
            toolbar = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            [toolbar addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
            [toolbar setBackgroundColor:[UIColor lightGrayColor]];
            [toolbar setTitle:@"完成" forState:UIControlStateNormal];

        }
        
    }
    return self;
}
- (void)initWithPickerData:(NSArray *)pickerArray MyPickerBlock:(MyPickerBlock)pikcerBlock1{
    [myDataArray removeAllObjects];
    [myDataArray addObjectsFromArray:pickerArray];
    self.pickerBlock = pikcerBlock1;
    [self showActionSheetView];
}
- (void)initWithPickerData:(NSMutableArray *)pickerArray selectString:(NSString *)selectString MyPickerBlock:(MyPickerBlock)pikcerBlock1{
    // Initialization code
    [myDataArray removeAllObjects];
    [myDataArray addObjectsFromArray:pickerArray];
    _selectString = selectString;
    self.pickerBlock = pikcerBlock1;
    [self showActionSheetView];
}

/**
 @brief 弹出ActionSheet
 */
- (void)showActionSheetView{
    if (IOS_VERSION >= 8) {
         UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
         UIAlertAction * destructiveAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [alertC dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
//        [alertC.view removeAllSubviews];
        [alertC addAction:destructiveAction];
        _pickerView.frame = CGRectMake(0, 0, 304, 100);
        [_pickerView reloadAllComponents];
        [alertC.view addSubview:_pickerView];
//        if(self.myDataArray.count > 0 && nil != self.pickerBlock){
//            pickerBlock([myDataArray objectAtIndex:0]);
//        }
        [_target presentViewController:alertC animated:YES completion:^{
            
        }];
    }else{
        // actionsheet
        [as removeAllSubviews];
        [as addSubview:toolbar];
        [_pickerView reloadAllComponents];
        [as addSubview:_pickerView];
        [as showInView:[YHAppDelegate appDelegate].mytabBarController.view];
//        if(self.myDataArray.count > 0 && nil != self.pickerBlock){
//            pickerBlock([myDataArray objectAtIndex:0]);
//        }
    }
    
}

// 确认
- (void)segmentAction:(id)sender{
   
    [as dismissWithClickedButtonIndex:0 animated:YES];
}

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
    return self.myDataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.myDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerBlock) {
        pickerBlock([self.myDataArray objectAtIndex:row]);
    }
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
