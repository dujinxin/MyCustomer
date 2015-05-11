//
//  TORSegmentControl.h
//  Torch
//
//  Created by 薛靖博 on 14/11/28.
//  Copyright (c) 2014年 wangtiansoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TORSegmentControl : UIControl
@property (nonatomic, assign) NSInteger     selectedSegmentIndex;
@property (nonatomic, strong) UIColor       *selectedTintColor;
@property (nonatomic, strong) UIColor       *tintColor;
@property (nonatomic, assign) CGFloat       tintSize;

@property (nonatomic , strong)UIColor        *tintColor_P;
@property (nonatomic, strong)UIColor         *selectedTintColor_P;
@property (nonatomic, assign)CGFloat        tintSize_P;

@property (nonatomic, assign) BOOL          haveLine;

- (instancetype)initWithItems:(NSArray *)items vertical:(BOOL)verticle;
- (instancetype)initWithItems:(NSArray *)items;
- (void)setLbTitles:(NSMutableArray *)lbTitles;

-(void)upTitles:(NSMutableArray *)lbT;

@end
