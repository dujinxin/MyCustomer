//
//  HotCityView.h
//  YHCustomer
//
//  Created by lichentao on 14-5-16.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HotCityViewBlock)(UIButton *hotBtn);

@interface HotCityView : UIView

//+ (HotCityView *)instance;
@property (nonatomic, strong) HotCityViewBlock cityBlock;
@property (nonatomic, strong) NSMutableArray  *hotDataArray;
- (void)setHotCityArray:(NSMutableArray *)hotCityArray HotCityViewBlock:(HotCityViewBlock)hotCityBlock;
@end
