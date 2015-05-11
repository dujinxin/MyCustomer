//
//  YHTimeView.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-5.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectCB)(id sender);

@interface YHTimeView : UIView


{
    NSString* _timeString;
    
    NSString* _nowDateString;
    NSMutableArray* _btnArray;
    
    UIScrollView* _scrollView;          //滑动视图
    UIView* _dayBgView;                  //滑动视图上的背景视图
    UIView* _hourBgView;
    
}
@property(nonatomic, strong)NSString* nowDateString;
@property(nonatomic, strong)NSMutableArray* btnArray;
@property(nonatomic, strong)NSMutableArray* dayArray;
@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)UILabel * dateLabel;
@property(nonatomic, strong)UIView* dateView;
@property(nonatomic, strong)UIView* workView;

@property (nonatomic ,assign)PSModel model;
@property (nonatomic, assign)NSInteger fastest_pick_up_minutes;
@property (nonatomic ,assign)NSInteger dayNumber;
@property (nonatomic ,assign)NSInteger totalHeight;
@property (nonatomic ,assign)NSInteger selectHourTag;
@property (nonatomic ,assign)NSInteger selectDayTag;
@property (nonatomic ,strong)NSMutableArray * sevenDateArray;
@property (nonatomic ,strong)NSMutableArray * hourArray;
@property (nonatomic ,strong)NSMutableArray * todayArray;
@property (nonatomic ,strong)NSMutableArray * tomorrowArray;
@property (nonatomic ,copy)NSString * hourString;
@property (nonatomic ,copy)NSString * deliveryId;
@property (nonatomic ,copy)NSString * payId;
@property (nonatomic ,copy)NSString * msg;
@property (nonatomic ,copy)NSNumber * type;
@property (nonatomic ,assign)id target;
@property (nonatomic ,assign)SEL action;
@property (nonatomic ,copy )SelectCB hourSelectCB;
@property (nonatomic ,copy )SelectCB daySelectCB;
@property (nonatomic ,copy )NSString * string;


- (void)addDayScrollViewAndSubViewsWithDays:(NSArray *)dayArray weekDays:(NSArray *)weekArray otherArray:(NSArray *)otherArray canSelectDays:(NSInteger)canSelectday psModel:(PSModel)model isToday:(BOOL)isToday;
- (void)addHourViewWithArray:(NSArray *)hourArray height:(NSInteger)totalHeight fastestPickUpTime:(NSString *)fpTimeString selectTime:(NSString *)selectTime selectDay:(NSInteger)selectDay supportDay:(NSInteger)supportDay calumnNumber:(NSInteger)number;
- (void)addHourViewWithArray:(NSArray *)hourArray height:(NSInteger)totalHeight selectTime:(NSString *)selectTime calumnNumber:(NSInteger)number;
- (void)setDateLabelText:(NSString *)dateString;


@end
