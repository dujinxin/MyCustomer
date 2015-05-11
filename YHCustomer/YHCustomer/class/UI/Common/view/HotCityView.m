//
//  HotCityView.m
//  YHCustomer
//
//  Created by lichentao on 14-5-16.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  热门城市View

#import "HotCityView.h"
#define HOT_CITY_BTN_WIDTH 50.f
#define HOT_CITY_BTN_HEIGHT 40.f
@implementation HotCityView
@synthesize hotDataArray;
+ (HotCityView *)instance{
    static HotCityView *_pickerView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pickerView = [[HotCityView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    });
    return _pickerView;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setHotCityArray:(NSMutableArray *)hotCityArray HotCityViewBlock:(HotCityViewBlock)hotCityBlock
{
    _cityBlock = hotCityBlock;
    
    // Initialization code
    int j = 0;

    for (int i = 0; i < hotCityArray.count; i ++) {
        NSDictionary *dic = [hotCityArray objectAtIndex:i];
        UIButton *hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        j ++;
        if (i % 4 == 0) {
            j = 0;
        }
        hotBtn.frame = CGRectMake(j*60+10, (i/4)* 50, 50, 35);
        hotBtn.tag = i+ 1000;
        hotBtn.layer.borderColor = LIGHT_GRAY_COLOR.CGColor;
        hotBtn.layer.borderWidth = 1.0f;
        [hotBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [hotBtn setTitle:[dic objectForKey:@"region_name"] forState:UIControlStateNormal];
        hotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:hotBtn];
    }
}

- (void)buttonClicked:(UIButton *)btn{
    if (_cityBlock) {
        _cityBlock(btn);
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
