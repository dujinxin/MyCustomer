//
//  YHAlertView.m
//  YHCustomer
//
//  Created by dujinxin on 14-11-21.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHAlertView.h"

@implementation YHAlertView
{
    UIImageView * ima_1;
    UIImageView * ima_2;
    UIImageView * ima_3;
    UIImageView * ima_4;
    UIImageView * ima_5;
    UIImageView * ima_6;
    NSString * str_Text;
}
@synthesize title = _title;
@synthesize message = _message;
@synthesize delegate = _delegate;
@synthesize textFiled = _textFiled;
@synthesize block;
@synthesize lineIn;

#pragma CustomInit
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//纯文本信息
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self) {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -40, 200);
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.tag = 9999;
        self.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        self.center = [UIApplication sharedApplication].keyWindow.center;
        if (delegate)
        {
            self.delegate = delegate;
        }
        //添加标题
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.layer.cornerRadius = 8;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        BOOL isHasTitle = NO;
        if (title)
        {
            [self addSubview:titleLabel];
            isHasTitle = YES;
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height-1, SCREEN_WIDTH -40, 1)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            [self addSubview:line];
        }
        //文本信息
        CGFloat top = isHasTitle ? titleLabel.frame.size.height +10 : 10;
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.frame.size.width -40, 40)];
        messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.text = message;
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.numberOfLines = 0;
        CGSize size ;
        if (IOS_VERSION >=7) {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
            
            CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size = rect.size;
        }else{
            size = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
        messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, size.height);
        [self addSubview:messageLabel];
        totalHeight = messageLabel.frame.size.height + top;
        //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
        CGFloat space = 10;
        CGFloat width = (self.frame.size.width - space -10*2)/2;
        CGFloat height = 40;
        CGFloat x = 0;
        CGFloat y = 0;
        for (int i = 0 ; i < buttonTitles.count; i ++) {
            x = i %2;
            y = i /2;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + (width +space) * x, messageLabel.frame.size.height + messageLabel.frame.origin.y +10 + (10 +height) *y, width, height);
            button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            button.titleLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.tag = 100 + i;
            button.layer.cornerRadius = 5;
            [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (buttonTitles.count %2 != 0){
                if (i == buttonTitles.count -1) {
                    button.frame = CGRectMake(10, messageLabel.frame.size.height + messageLabel.frame.origin.y +10 + (10 +height) *y, (self.frame.size.width -10*2), height);
                    totalHeight = button.frame.origin.y + button.frame.size.height ;
                }
            }else{
                if (i == buttonTitles.count -1) {
                    totalHeight = button.frame.origin.y + button.frame.size.height ;
                }
            }
            
        }
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -40, totalHeight +10);
        
    }
    return self;
}
//永辉钱包输入密码的警告框
//new
-(id)initWithTitle:(NSMutableAttributedString *)title message:(NSString *)message delegate:(id)delegate Left:(BOOL)yesOrNo button:(NSArray *)btnArr isPaa:(BOOL)isTextFiled
{
    self = [super init];
    if (self)
    {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        self.clipsToBounds = YES;
        self.tag = 9999;
        self.backgroundColor = [UIColor clearColor];
        UIView * showView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 200)];
        showView.layer.cornerRadius = 8;
        showView.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        showView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        [self addSubview:showView];
        if (delegate)
        {
            self.delegate = delegate;
        }
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, self.frame.size.width-60, 50)];
        if (yesOrNo)
        {
            titleLabel.textAlignment = NSTextAlignmentLeft;
             titleLabel.font = [UIFont systemFontOfSize:16];
        }
        else
        {
            titleLabel.textAlignment = NSTextAlignmentCenter;
             titleLabel.font = [UIFont systemFontOfSize:18];
        }
        titleLabel.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        titleLabel.attributedText = title;
//        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 2;
        /*
        CGSize size ;
        if (IOS_VERSION >=7)
        {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:titleLabel.font forKey:NSFontAttributeName];
            
            CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size = rect.size;
        }else{
            size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(titleLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
        if (size.height > 40)
        {
               titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, size.height+10);
        }
        else
        {
            size.height = 40;
            titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, size.height+10);
        }
     */
        if (title)
        {
            [self addSubview:titleLabel];
            lineIn = [[UIView alloc]initWithFrame:CGRectMake(20, 20+titleLabel.frame.size.height+1, SCREEN_WIDTH -40, 1)];
            lineIn.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
            [self addSubview:lineIn];
            totalHeight = CGRectGetMaxY(lineIn.frame);
        }
        else
        {
            totalHeight = 20;
        }
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 8, 30, 30)];
        //        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        btn.tag = 100;
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_永辉钱包_关闭弹出框按钮.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel * messLable = [[UILabel alloc]initWithFrame:CGRectMake(20, totalHeight+10, self.frame.size.width-40, 40)];
        messLable.textAlignment = NSTextAlignmentCenter;
        messLable.text = message;
        //        titleLabel.layer.cornerRadius = 8;
        messLable.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        if (isTextFiled)
        {
            messLable.font = [UIFont systemFontOfSize:24];
        }
        else
        {
            messLable.font = [UIFont systemFontOfSize:15];
        }
//        messLable.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        messLable.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        messLable.numberOfLines = 0;
        CGSize size1 ;
        if (IOS_VERSION >=7)
        {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:messLable.font forKey:NSFontAttributeName];
            
            CGRect rect = [messLable.text boundingRectWithSize:CGSizeMake(messLable.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size1 = rect.size;
        }else{
            size1 = [messLable.text sizeWithFont:messLable.font constrainedToSize:CGSizeMake(messLable.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
        if (size1.height > 40)
        {
            titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, size1.height);
        }
        else
        {
            size1.height = 40;
            titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, size1.height);
        }
        if (message)
        {
              messLable.frame = CGRectMake(messLable.frame.origin.x, messLable.frame.origin.y, messLable.frame.size.width, size1.height);
             [self addSubview:messLable];
            totalHeight = CGRectGetMaxY(messLable.frame);
        }
       
        if (isTextFiled)
        {
            self.textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, totalHeight+10, 1, 1)];
            self.textFiled.delegate = self;
            self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
            [self addSubview:self.textFiled];
            
            UIView * view11 = [self getView:CGRectMake(40, totalHeight+10, self.frame.size.width-80, 40)];
            [self addSubview:view11];
            
            totalHeight = CGRectGetMaxY(view11.frame)+20;
        }
        
        CGFloat space = 11;
        CGFloat width = (self.frame.size.width - space -10*2)/2;
        CGFloat height = 40;
        //        CGFloat x = 0;
        //        CGFloat y = 0;
        UIView * downLine = [[UIView alloc]initWithFrame:CGRectMake(20, totalHeight+9, SCREEN_WIDTH -40, 1)];
        downLine.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
        [self addSubview:downLine];

        if (btnArr.count == 2)
        {
            CGFloat h_h;
            for (int i = 0 ; i < 2; i ++)
            {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(5+(width +space) * i,  totalHeight +10 , width, height);
                //            button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
                button.titleLabel.textColor = [PublicMethod colorWithHexValue:0x2181F7 alpha:1.0];
                [button setTitleColor:[PublicMethod colorWithHexValue:0x2181F7 alpha:1.0] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:18];
                button.tag = 100 + i+1;
                //            button.layer.cornerRadius = 5;
                [button setTitle:[btnArr objectAtIndex:i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                if (i == 0 )
                {
                    UIView * lin_L = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+(space-1)/2, CGRectGetMaxY(downLine.frame), 1, button.frame.size.height)];
                    lin_L.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
                    [self addSubview:lin_L];
                    
                }
                h_h = CGRectGetMaxY(button.frame);
            }
             totalHeight = h_h ;
        }
        
        showView.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, totalHeight-20);
        UIImageView * im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, showView.frame.size.height)];
        im.layer.cornerRadius = 8;
        im.backgroundColor = [UIColor clearColor];
        [showView addSubview:im];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, totalHeight);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return self;
}
//手机注册弹窗
-(id)initWithMessage:(NSString *)message delegate:(id)delegate
{
    if (self = [super init])
    {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        self.clipsToBounds = YES;
        self.tag = 9999;
        self.backgroundColor = [UIColor clearColor];
        UIView * showView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 200)];
        showView.layer.cornerRadius = 8;
        showView.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        showView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        [self addSubview:showView];
        if (delegate)
        {
            self.delegate = delegate;
        }
        //关闭按钮
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 18, 30, 30)];
        //        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        btn.tag = 100;
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_永辉钱包_关闭弹出框按钮.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel * messLable = [[UILabel alloc]initWithFrame:CGRectMake(40, totalHeight+50, self.frame.size.width-80, 100)];
        messLable.textAlignment = NSTextAlignmentCenter;
        messLable.text = message;
        //        titleLabel.layer.cornerRadius = 8;
        messLable.textColor = [PublicMethod colorWithHexValue1:@"#000000"];
        messLable.font = [UIFont systemFontOfSize:15];
        //        messLable.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        messLable.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        messLable.numberOfLines = 0;
        CGSize size1 ;
        if (IOS_VERSION >=7)
        {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:messLable.font forKey:NSFontAttributeName];
            
            CGRect rect = [messLable.text boundingRectWithSize:CGSizeMake(messLable.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size1 = rect.size;
        }else{
            size1 = [messLable.text sizeWithFont:messLable.font constrainedToSize:CGSizeMake(messLable.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
       
        if (message)
        {
            messLable.frame = CGRectMake(messLable.frame.origin.x, messLable.frame.origin.y, messLable.frame.size.width, size1.height);
            [self addSubview:messLable];
            totalHeight = CGRectGetMaxY(messLable.frame);
        }
        
        showView.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, totalHeight-20);
        UIImageView * im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, showView.frame.size.height)];
        im.layer.cornerRadius = 8;
        im.backgroundColor = [UIColor clearColor];
        [showView addSubview:im];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, totalHeight+20);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
    }
    return self;
}


-(id)initWithOOTitle:(NSString *)title message:(NSString *)message  customView:(UIView *)customView delegate:(id)delegate upButtonTitle:(NSString *)buttonTitle
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        self.clipsToBounds = YES;
        self.tag = 9999;
        self.backgroundColor = [UIColor clearColor];
        
        UIView * showView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 200)];
        showView.layer.cornerRadius = 8;
        showView.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        showView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        [self addSubview:showView];
        
        if (delegate)
        {
            self.delegate = delegate;
        }
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH - 60, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
//        titleLabel.layer.cornerRadius = 8;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        BOOL isHasTitle = NO;
        if (title)
        {
            [self addSubview:titleLabel];
            isHasTitle = YES;
            lineIn = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)-1, SCREEN_WIDTH -40, 1)];
            lineIn.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
            [self addSubview:lineIn];
        }
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 8, 30, 30)];
        //        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        btn.tag = 100;
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_永辉钱包_关闭弹出框按钮.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        
        CGFloat top = CGRectGetMaxY(lineIn.frame)+10;
        CGRect frame = customView.frame;
        customView.frame = CGRectMake(30, top, self.frame.size.width -60, frame.size.height);
        //        customView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:customView];
        
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(customView.frame)+10, SCREEN_WIDTH-80, 40)];
        messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.text = message;
        messageLabel.font = [UIFont systemFontOfSize:12];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.numberOfLines = 0;
        CGSize size ;
        if (IOS_VERSION >=7)
        {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
            
            CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size = rect.size;
        }else{
            size = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
        messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, size.height);
        
        [self addSubview:messageLabel];
        NSLog(@"%f" , CGRectGetMaxY(messageLabel.frame)-10);
        showView.frame = CGRectMake(20, 20, SCREEN_WIDTH-40,CGRectGetMaxY(messageLabel.frame)-10);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(messageLabel.frame)+10);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
//        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH -38, self.center.x-(CGRectGetMaxY(messageLabel.frame)+10)/2+13, 30, 30)];
//        [btn setTitle:buttonTitle forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"icon_永辉钱包_关闭弹出框按钮.png"] forState:UIControlStateNormal];
////        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [[UIApplication sharedApplication].keyWindow addSubview:btn];
    }
    return self;
}


//old
-(id)initWithTitle:(NSString *)title message:(NSString *)message message:(NSMutableAttributedString *)attString  delegate:(id)delegate upButtonTitle:(NSString *)buttonTitle  Left:(BOOL) Left;
{
    self = [super init];
    if (self)
    {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        //        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.tag = 9999;
        //        self.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        UIView * showView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 200)];
        showView.layer.cornerRadius = 8;
        showView.clipsToBounds = YES;
        showView.layer.masksToBounds = YES;
        showView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        [self addSubview:showView];
        if (delegate)
        {
            self.delegate = delegate;
        }
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.frame.size.width-40, 50)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        //        titleLabel.layer.cornerRadius = 8;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        BOOL isHasTitle = NO;
        if (title)
        {
            [self addSubview:titleLabel];
            isHasTitle = YES;
            lineIn = [[UIView alloc]initWithFrame:CGRectMake(20, 20+titleLabel.frame.size.height-1, SCREEN_WIDTH -40, 1)];
            lineIn.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
            [self addSubview:lineIn];
        }
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 8, 30, 30)];
        //        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_永辉钱包_关闭弹出框按钮.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(lineIn.frame)+3, self.frame.size.width -60, 40)];
        messageLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //iOS7的系统不设置clearColor会有一条灰色的横线在最上方
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.attributedText = attString;
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        messageLabel.numberOfLines = 0;
        CGSize size ;
        if (IOS_VERSION >=7) {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:messageLabel.font forKey:NSFontAttributeName];
            
            CGRect rect = [messageLabel.text boundingRectWithSize:CGSizeMake(messageLabel.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size = rect.size;
        }else{
            size = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(messageLabel.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
        messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, messageLabel.frame.size.width, size.height);
        [self addSubview:messageLabel];
        
        self.textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(messageLabel.frame)+20, 1, 1)];
        self.textFiled.delegate = self;
        self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.textFiled];
        
        //        ima_1 = [[UIImageView alloc] initWithFrame:];
        //        ima_1.image = [self getImge:ima_1.frame];
        
        UIView * view11 = [self getView:CGRectMake(40, CGRectGetMaxY(messageLabel.frame)+20, self.frame.size.width-80, 40)];
        [self addSubview:view11];
        
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(view11.frame)+10, self.frame.size.width-80, 20)];
        lab.font = [UIFont systemFontOfSize:12];
        lab.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        lab.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        if (message)
        {
            lab.text = message;
            [self addSubview:lab];
            totalHeight = CGRectGetMaxY(lab.frame);
        }
        else
        {
            totalHeight = CGRectGetMaxY(view11.frame);
        }
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, totalHeight +20);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self.textFiled resignFirstResponder];
}

-(UIView *)getView:(CGRect)rect
{
//    CGRect rect = CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+20, self.frame.size.width-40, 40);
    UIView * view_temp = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    view_temp.layer.borderColor = [PublicMethod colorWithHexValue1:@"#9F9F9F"].CGColor;
    view_temp.backgroundColor = [PublicMethod colorWithHexValue1:@"#FFFFFF"];
    view_temp.layer.borderWidth = 1;
//    view_temp.layer.borderColor = [PublicMethod colorWithHexValue1:@"#333333"].CGColor;
//    view_temp.layer.borderWidth = 0.5;
    for (int i = 0 ; i < 5; i++)
    {
        UIView * view_t = [[UIView alloc] initWithFrame:CGRectMake((i+1)*40, 0, 1, 40)];
        view_t.backgroundColor = [PublicMethod colorWithHexValue1:@"#CDCDCD"];
        [view_temp addSubview:view_t];
    }
    ima_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0, rect.size.width/6-1, rect.size.height)];
//    ima_1.image = [UIImage imageNamed:@"box_empty"];
    [view_temp addSubview:ima_1];
    
    ima_2 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width/6+0.5, 0, rect.size.width/6-1, rect.size.height)];
//    ima_2.image = [UIImage imageNamed:@"box_empty"];
    [view_temp addSubview:ima_2];
    
    ima_3 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width/6*2+0.5, 0, rect.size.width/6-1, rect.size.height)];
//    ima_3.image = [UIImage imageNamed:@"box_empty"];
    [view_temp addSubview:ima_3];
    
    ima_4 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width/6*3+0.5, 0, rect.size.width/6-1, rect.size.height)];
//    ima_4.image = [UIImage imageNamed:@"box_empty"];
    [view_temp addSubview:ima_4];
    
    ima_5 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width/6*4+0.5, 0, rect.size.width/6-1, rect.size.height)];
//    ima_5.image = [UIImage imageNamed:@"box_empty"];
    [view_temp addSubview:ima_5];
    
    ima_6 = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width/6*5+0.5, 0, rect.size.width/6-1, rect.size.height)];
//    ima_6.image = [UIImage imageNamed:@"box_empty"];
    [view_temp addSubview:ima_6];
    
    return view_temp;
}
-(void)setLine
{
    lineIn.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
}

-(id)initWithOtherTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self)
    {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -40, 200);
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.tag = 9999;
        self.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        if (delegate) {
            self.delegate = delegate;
        }
        
        //添加标题
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.layer.cornerRadius = 8;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        BOOL isHasTitle = NO;
        if (title)
        {
            [self addSubview:titleLabel];
            isHasTitle = YES;
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height-1, SCREEN_WIDTH -40, 1)];
            line.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
            [self addSubview:line];
        }
        //自定义视图
        CGFloat top = isHasTitle ? titleLabel.frame.size.height : 10;
        CGRect frame = customView.frame;
        customView.frame = CGRectMake(10, top, self.frame.size.width -20, frame.size.height);
        //        customView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:customView];
        totalHeight = frame.size.height + top;
        //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
        CGFloat space = 11;
        CGFloat width = (self.frame.size.width - space -10*2)/2;
        CGFloat height = 40;
//        CGFloat x = 0;
//        CGFloat y = 0;
        UIView * downLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(customView.frame)+9, SCREEN_WIDTH -40, 1)];
        downLine.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
        [self addSubview:downLine];
        
        if (buttonTitles.count == 2)
        {
            for (int i = 0 ; i < 2; i ++)
            {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(5+(width +space) * i,  CGRectGetMaxY(customView.frame) +10 , width, height);
                //            button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
                button.titleLabel.textColor = [PublicMethod colorWithHexValue:0x2181F7 alpha:1.0];
                [button setTitleColor:[PublicMethod colorWithHexValue:0x2181F7 alpha:1.0] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:18];
                button.tag = 100 + i;
                //            button.layer.cornerRadius = 5;
                [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                if (i == 0 )
                {
                    UIView * lin_L = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+(space-1)/2, CGRectGetMaxY(downLine.frame)+3, 1, button.frame.size.height-6)];
                    lin_L.backgroundColor = [PublicMethod colorWithHexValue1:@"#cccccc"];
                    [self addSubview:lin_L];
                    
                }
                
                totalHeight = CGRectGetMaxY(button.frame) ;
            }
        }
        /*
        for (int i = 0 ; i < buttonTitles.count; i ++)
        {
            x = i %2;
            y = i /2;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((width +space) * x, customView.frame.size.height + customView.frame.origin.y +10 + (10 +height) *y, width, height);
//            button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            button.titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
            [button setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.tag = 100 + i;
//            button.layer.cornerRadius = 5;
            [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (buttonTitles.count %2 != 0){
                if (i == buttonTitles.count -1) {
                    button.frame = CGRectMake(10, customView.frame.size.height + customView.frame.origin.y +10 + (10 +height) *y, (self.frame.size.width -10*2), height);
                    totalHeight = button.frame.origin.y + button.frame.size.height;
                }
            }else{
                if (i == buttonTitles.count -1) {
                    totalHeight = button.frame.origin.y + button.frame.size.height ;
                    
                    
                }
            }
            
        }
         */
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -40, totalHeight);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return self;
}

//可以自定义内容
- (id)initWithTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self)
    {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -40, 200);
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.tag = 9999;
        self.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        if (delegate) {
            self.delegate = delegate;
        }
        
        //添加标题
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.layer.cornerRadius = 8;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        BOOL isHasTitle = NO;
        if (title)
        {
            [self addSubview:titleLabel];
            isHasTitle = YES;
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height-1, SCREEN_WIDTH -40, 1)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            [self addSubview:line];
        }
        //自定义视图
        CGFloat top = isHasTitle ? titleLabel.frame.size.height : 10;
        CGRect frame = customView.frame;
        customView.frame = CGRectMake(10, top, self.frame.size.width -20, frame.size.height);
        //        customView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:customView];
        totalHeight = frame.size.height + top;
        //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
        CGFloat space = 10;
        CGFloat width = (self.frame.size.width - space -10*2)/2;
        CGFloat height = 40;
        CGFloat x = 0;
        CGFloat y = 0;
        for (int i = 0 ; i < buttonTitles.count; i ++) {
            x = i %2;
            y = i /2;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + (width +space) * x, customView.frame.size.height + customView.frame.origin.y +10 + (10 +height) *y, width, height);
            button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            button.titleLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.tag = 100 + i;
            button.layer.cornerRadius = 5;
            [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (buttonTitles.count %2 != 0){
                if (i == buttonTitles.count -1) {
                    button.frame = CGRectMake(10, customView.frame.size.height + customView.frame.origin.y +10 + (10 +height) *y, (self.frame.size.width -10*2), height);
                    totalHeight = button.frame.origin.y + button.frame.size.height;
                }
            }else{
                if (i == buttonTitles.count -1) {
                    totalHeight = button.frame.origin.y + button.frame.size.height ;
                }
            }
            
        }
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -40, totalHeight +10);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitle:(NSString *)buttonTitle{

    self = [super init];
    if (self)
    {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -68, 296);
        self.tag = 9999;
        self.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        if (delegate) {
            self.delegate = delegate;
        }
        
        //添加标题
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        titleLabel.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
        BOOL isHasTitle = NO;
        UIView * line;
        if (title)
        {
            [self addSubview:titleLabel];
            isHasTitle = YES;
            line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height, self.frame.size.width, 1)];
            line.backgroundColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0];
            [self addSubview:line];
        }
        
        
        //自定义视图
        CGFloat top = isHasTitle ? CGRectGetMaxY(line.frame) : 10;
        CGRect frame = customView.frame;
        customView.frame = CGRectMake(0, top, self.frame.size.width, frame.size.height);
        //        customView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:customView];
        totalHeight = CGRectGetMaxY(customView.frame);
        //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(customView.frame.origin.x, customView.bottom,  156, 30);
        button.centerX = self.centerX;
        button.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
        button.titleLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.tag = 100;
        //button.layer.cornerRadius = 5;
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        totalHeight = CGRectGetMaxY(button.frame);
 
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH -68, totalHeight +10);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return self;
}
- (void)buttonClick:(UIButton *)btn{


    if ([_delegate respondsToSelector:@selector(yhAlertView:willDismissWithButtonIndex:)]) {
        [_delegate yhAlertView:self willDismissWithButtonIndex:btn.tag -100];
    }
    if ([_delegate respondsToSelector:@selector(yhAlertView:clickedButtonAtIndex:)]) {
        [_delegate yhAlertView:self clickedButtonAtIndex:btn.tag - 100];
    }
    if ([_delegate respondsToSelector:@selector(yhAlertView:didDismissWithButtonIndex:)]) {
        [_delegate yhAlertView:self didDismissWithButtonIndex:btn.tag -100];
    }
    
    UIView * bgView = [self.superview viewWithTag:999];
    UIButton * btn1 = (UIButton *)[self.superview viewWithTag:888];
    if (btn1) {
        [btn1 removeFromSuperview];
    }
    [self removeFromSuperview];
    [bgView removeFromSuperview];
    
}

//类似于sheet的自定义图

-(id)initWithCustom:(UIView *)customView delegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        if (delegate) {
            self.delegate = delegate;
        }
        if (customView)
        {
            self.frame = CGRectMake(0, 0, 0, 0);
            [self addSubview:customView];
            self.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.bottom, customView.width, customView.height);
//            self.frame.origin.y = [UIApplication sharedApplication].keyWindow.bottom;
        }
    }
    return self;
}
//消失动态
-(void)dismiss:(BOOL)yesOrNo
{
    if (yesOrNo)
    {
        [UIView animateWithDuration:5 animations:^{
             [self setFrame:CGRectMake(0,[UIApplication sharedApplication].keyWindow.bottom-self.size.height , self.size.width, self.size.height)];
        } completion:^(BOOL finish){
           [self setFrame:CGRectMake( 0,[UIApplication sharedApplication].keyWindow.bottom , self.size.width, self.size.height)];
            [self removeFromSuperview];
            UIView * bgView = [self.superview viewWithTag:999];
            [bgView removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
        UIView * bgView = [self.superview viewWithTag:999];
        [bgView removeFromSuperview];
    }
    
}
//从底部弹出
-(void)showWithAnimation:(BOOL)yesOrNo
{
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentYhAlertView:)]) {
        [_delegate willPresentYhAlertView:self];
    }
    UIView * bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = 999;
    bgView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (yesOrNo)
    {
        [UIView animateWithDuration:5 animations:^{
            [self setFrame:CGRectMake( 0,[UIApplication sharedApplication].keyWindow.bottom , self.size.width, self.size.height)];
            
        } completion:^(BOOL finish){
            [self setFrame:CGRectMake(0,[UIApplication sharedApplication].keyWindow.bottom-self.size.height , self.size.width, self.size.height)];
        }];
    }
    else
    {
        [self setFrame:CGRectMake(0,[UIApplication sharedApplication].keyWindow.bottom-self.size.height , self.size.width, self.size.height)];
    }
    //已经出现
    if ([_delegate respondsToSelector:@selector(didPresentYhAlertView:)]) {
        [_delegate didPresentYhAlertView:self];
    }
}

- (void)show{
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentYhAlertView:)]) {
        [_delegate willPresentYhAlertView:self];
    }
    //添加背景
    UIView * bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = 999;
    bgView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //已经出现
    if ([_delegate respondsToSelector:@selector(didPresentYhAlertView:)]) {
        [_delegate didPresentYhAlertView:self];
    }
}
- (void)showInView:(UIView *)view
{
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentYhAlertView:)]) {
        [_delegate willPresentYhAlertView:self];
    }
    //添加背景
    UIView * bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = 999;
    bgView.alpha = 0.5;
    [view addSubview:bgView];
    CGPoint center =[UIApplication sharedApplication].keyWindow.center;
    self.center = CGPointMake(center.x, center.y -64);
    [view addSubview:self];
    //已经出现
    if ([_delegate respondsToSelector:@selector(didPresentYhAlertView:)]) {
        [_delegate didPresentYhAlertView:self];
    }
}
- (void)showCodeView
{
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentYhAlertView:)]) {
        [_delegate willPresentYhAlertView:self];
    }
    //添加背景
    UIView * bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = 999;
    bgView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //X视图
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor grayColor];
    cancelButton.frame = CGRectMake(self.frame.size.width +34 -11, self.frame.origin.y -11, 22, 22);
    cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.cornerRadius = 11;
    cancelButton.tag = 888;
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:cancelButton];
    //已经出现
    if ([_delegate respondsToSelector:@selector(didPresentYhAlertView:)]) {
        [_delegate didPresentYhAlertView:self];
    }
}
- (void)dismiss
{
    UIView * bgView = [self.superview viewWithTag:999];
    UIButton * btn = (UIButton *)[self.superview viewWithTag:888];
    [self removeFromSuperview];
    [bgView removeFromSuperview];
    [btn removeFromSuperview];
}
- (void)dismissCard
{
    UIView * bgView = [self.superview viewWithTag:999];
    UIButton * btn = (UIButton *)[self.superview viewWithTag:888];
    [self removeFromSuperview];
    [bgView removeFromSuperview];
    [btn removeFromSuperview];
    block(str_Text);
}

//检测充值输入的格式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text > 0)
    {
        if ([string length] > 0)
        {
            NSString * strValue = [textField.text stringByAppendingString:string];
            
            [self upDateImage:strValue];
            if ([strValue length] == 6)
            {
                str_Text = strValue;
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissCard) userInfo:nil repeats:NO];
               
//                [self dismissCard];
            }
            return YES;
        }
        else
        {
            NSUInteger length = [textField.text length];
            NSString * strValue = [textField.text substringToIndex:length-1];
            [self upDateImage:strValue];
            return YES;
        }
    }
    else
    {
        if ([string length] > 0)
        {
            NSString * strValue = [textField.text stringByAppendingString:string];
            [self upDateImage:strValue];
            return YES;
        }
        else
        {
            [self upDateImage:textField.text];
            return YES;
        }
    }
    return YES;
}

-(void)upDateImage:(NSString *)str
{
    if ([str length] == 0)
    {
        ima_1.image =nil;
        ima_2.image = nil;
        ima_3.image = nil;
        ima_4.image = nil;
        ima_5.image = nil;
        ima_6.image = nil;
    }
    else if ([str length] == 1)
    {
        ima_1.image = [UIImage imageNamed:@"box_point.png"];
        ima_2.image = nil;
        ima_3.image = nil;
        ima_4.image = nil;
        ima_5.image = nil;
        ima_6.image = nil;
    }
    else if ([str length] == 2)
    {
        ima_1.image = [UIImage imageNamed:@"box_point"];
        ima_2.image = [UIImage imageNamed:@"box_point"];
        ima_3.image = nil;
        ima_4.image = nil;
        ima_5.image = nil;
        ima_6.image = nil;
    }
    else if ([str length] == 3)
    {
        ima_1.image = [UIImage imageNamed:@"box_point"];
        ima_2.image = [UIImage imageNamed:@"box_point"];
        ima_3.image = [UIImage imageNamed:@"box_point"];
        ima_4.image = nil;
        ima_5.image = nil;
        ima_6.image = nil;
    }
    else if ([str length] == 4)
    {
        ima_1.image = [UIImage imageNamed:@"box_point"];
        ima_2.image = [UIImage imageNamed:@"box_point"];
        ima_3.image = [UIImage imageNamed:@"box_point"];
        ima_4.image = [UIImage imageNamed:@"box_point"];
        ima_5.image = nil;
        ima_6.image = nil;
    }
    else if ([str length] == 5)
    {
        ima_1.image = [UIImage imageNamed:@"box_point"];
        ima_2.image = [UIImage imageNamed:@"box_point"];
        ima_3.image = [UIImage imageNamed:@"box_point"];
        ima_4.image = [UIImage imageNamed:@"box_point"];
        ima_5.image = [UIImage imageNamed:@"box_point"];
        ima_6.image = nil;
    }
    else if ([str length] == 6)
    {
        ima_1.image = [UIImage imageNamed:@"box_point"];
        ima_2.image = [UIImage imageNamed:@"box_point"];
        ima_3.image = [UIImage imageNamed:@"box_point"];
        ima_4.image = [UIImage imageNamed:@"box_point"];
        ima_5.image = [UIImage imageNamed:@"box_point"];
        ima_6.image = [UIImage imageNamed:@"box_point"];
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
