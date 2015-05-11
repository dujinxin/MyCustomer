//
//  GJGLAlertView.m
//  SJGL
//
//  Created by lichentao on 14-2-6.
//  Copyright (c) 2014年 liushunfeng. All rights reserved.
//

#import "GJGLAlertView.h"

#define HORIZITAL 65
#define  LABEL_WIDTH 240
#define  LABEL_HEIGHT 30

@implementation GJGLAlertView

+(GJGLAlertView *)shareInstance{
    static GJGLAlertView *_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _obj = [[GJGLAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, SCREEN_HEIGHT)];
    });
    return _obj;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float originY = 30.f;
        if (!iPhone5) {
            originY = 110.f;
        }
        UIView *_bgView = [PublicMethod addBackView:CGRectMake(0, 0, 320, SCREEN_HEIGHT) setBackColor:[PublicMethod colorWithHexValue:0x484850 alpha:1.0f]];
        _bgView.alpha = .5;
        UIView *_alerView = [PublicMethod addBackView:CGRectMake(30, 120-originY, 260, 190) setBackColor:[PublicMethod colorWithHexValue:0xe6e8e8 alpha:1.0f]];
        _alerView.layer.cornerRadius = 8;
        _alerView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        [self addSubview: _alerView];
        
        UILabel *title = [PublicMethod addLabel:CGRectMake(37.5, 135-originY, LABEL_WIDTH, LABEL_HEIGHT) setTitle:@"快递信息" setBackColor:[UIColor grayColor] setFont:[UIFont boldSystemFontOfSize:17]];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        // 公司名称
        companyField = [[UITextField alloc] initWithFrame:CGRectMake(40, 180-originY, LABEL_WIDTH, LABEL_HEIGHT)];
        companyField.backgroundColor = [UIColor whiteColor];
        companyField.placeholder = @"请输入快递公司";
        companyField.tag = 10001;
        companyField.delegate = self;
        [self addSubview:companyField];
        [companyField becomeFirstResponder];
        
        // 订单编号
        orderField = [[UITextField alloc] initWithFrame:CGRectMake(40, 220-originY, LABEL_WIDTH, LABEL_HEIGHT)];
        orderField.backgroundColor = [UIColor whiteColor];
        orderField.tag = 10002;
        orderField.placeholder = @"请输入快递单号";
        orderField.delegate = self;
        [self addSubview:orderField];
        
        // 横线
        UILabel *horiginLine = [PublicMethod addLabel:CGRectMake(30, 270-originY, LABEL_WIDTH+20, 1) setTitle:nil setBackColor:[UIColor redColor] setFont:nil];
        [self addSubview:horiginLine];
        
        // 取消
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(30, 272-originY, 130, 38);
        cancelButton.tag = 10001;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[PublicMethod colorWithHexValue:0x157bfb alpha:1.0f] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        // 确定
        UIButton *confrimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confrimButton.frame = CGRectMake(155, 272-originY, 130, 38);
        [confrimButton setTitle:@"确定" forState:UIControlStateNormal];
        [confrimButton setTitleColor:[PublicMethod colorWithHexValue:0x157bfb alpha:1.0f] forState:UIControlStateNormal];
        [confrimButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        confrimButton.tag = 10002;
        [self addSubview:confrimButton];
        // 竖线
        UILabel *verticalLine = [PublicMethod addLabel:CGRectMake(160, 271-originY, 1, 45) setTitle:nil setBackColor:[UIColor redColor] setFont:nil];
        
        horiginLine.backgroundColor = [UIColor lightGrayColor];
        horiginLine.alpha = .5f;
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        verticalLine.alpha =.5f;
        [self addSubview:horiginLine];
        [self addSubview:verticalLine];
    }
    return self;
}

- (void)setAlertViewBlock:(SJGLCallBackBlock)callBackBlock1 CancelBlock:(SJGLCallCancelBlock)cancelBlock1{
    _callBackBlock = callBackBlock1;
    _cancelBlock = cancelBlock1;
}

- (void)buttonClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10001) {
        if (_cancelBlock != nil) {
            _cancelBlock();
            companyField.text = nil;
            orderField.text = nil;
        }
    }else if(btn.tag == 10002){
        if (_callBackBlock != nil) {
            if (companyField.text.length == 0) {
                [self showNotice:@"请输入快递公司名字!"];
                return;
            }
            if (orderField.text.length == 0) {
                [self showNotice:@"请输入快递单号!"];
                return;
            }
            _callBackBlock(companyField.text,orderField.text);
            companyField.text = nil;
            orderField.text = nil;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 10001) {
        
    }else if (textField.tag == 10002){
    
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
