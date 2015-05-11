//
//  ZbarViewController.m
//
//
//  Created by liuzhichao  on 12-9-28.
//  Copyright (c) 2013年 TianHong. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "ZbarViewController.h"
#import "YHQuickScanOrderViewController.h"
#import "OrderEntity.h"
#import "YHSearchOrderViewController.h"
#import "YHGoodsDetailViewController.h"
#import "GoodSaoDetailEntity.h"
@interface ZbarViewController ()

@end

@implementation ZbarViewController
@synthesize saoType;
@synthesize imgView;
@synthesize lab_imgV;
#pragma mark --------------------------初始化

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (iPhone5)
        {
            scanHeight = 211;
            originY = 20;
        }else{
            scanHeight = 175;
            originY = 0;
        }
        isScan = YES;
    }
    return self;
}

#pragma mark --------------------------声明周期
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [readerView start];
//    [self reloadView];
    if (saoType == Sao_Pay)
    {
        if (![UserAccount instance].isLogin)
        {
            saoType = Sao_Goods;
        }
        else
        {
            saoType = Sao_Pay;
        }
    }
    [self reloadView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //blw 手机快速支付 14-10-17
    if (saoType== Sao_Goods)
    {
        self.navigationItem.title =@"扫商品";
    }
    else
    {
        self.navigationItem.title =@"快捷支付";
        
    }
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(backButtonClickHandle:));
    //    self.navigationItem.rightBarButtonItem = BARBUTTON(@"账单号搜索", @selector(payButtonAction:));
//    [self setRightBarButton:self Action:@selector(payButtonAction:) SetImage:@"my_input.png" SelectImg:@"my_input_Select.png"];
    [self setRightItem];
    if (readerView)
    {
        readerView = nil;
        [readerView removeFromSuperview];
    }
    
//    CGRectGetMinY(self.navigationController.navigationBar.frame);
    
    readerView = [[ZBarReaderView alloc] init];
    readerView.backgroundColor = [UIColor clearColor];
    readerView.frame = CGRectMake(0 , 0 , ScreenSize.width , ScreenSize.height);
    CGRect all =  CGRectMake(0 , 0 , ScreenSize.width , ScreenSize.height);
    readerView.backgroundColor=[UIColor clearColor];
    readerView.readerDelegate = self;
    readerView.allowsPinchZoom = NO;
    readerView.tracksSymbols = NO;
//    [readerView setZoom:1.5 animated:YES];
   
    CGRect rect_scan = CGRectMake((ScreenSize.width-227)/2,CGRectGetMinY(self.navigationController.navigationBar.frame)+30, 227, 260);
     readerView.scanCrop = [self getScanCrop:rect_scan readerViewBounds:all];
//    readerView.showsFPS =YES;
    //关闭闪光灯
    readerView.torchMode = 0;
    [self.view addSubview:readerView];
    // 扫瞄
    scanImage = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenSize.width-227)/2+4, CGRectGetMinY(self.navigationController.navigationBar.frame)+30, 219, 14.5)];
    scanImage.image = [UIImage imageNamed:@"zbarScan.png"];
    
    [self addSharwView];
    [self setTextContent];
    [self beginAnimation:YES];
    
    [self addUITabBar];
}
- (void) setRightItem{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 40);
    rightBtn.titleLabel.numberOfLines = 2;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn setTitle:@"手动输入" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
//设置可扫描区的scanCrop的方法
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}
-(void)addReadview
{
     //添加解码view
    if (readerView)
    {
        readerView = nil;
        [readerView removeFromSuperview];
    }
    readerView = [[ZBarReaderView alloc] init];
    readerView.backgroundColor = [UIColor clearColor];
    readerView.frame = CGRectMake(0,0, ScreenSize.width, ScreenSize.height);
    readerView.backgroundColor=[UIColor clearColor];
    readerView.readerDelegate = self;
    readerView.allowsPinchZoom = NO;
    readerView.tracksSymbols = YES;
    //关闭闪光灯
    readerView.torchMode = 0;
    
    [self.view insertSubview:readerView belowSubview:imgView];
}

//blw 14-10-20 添加uitabbar

-(void)addUITabBar
{
    //    myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenSize.height-kTabBarHeight, ScreenSize.width, kTabBarHeight)];
    UIBarButtonItem * payBtn;
    UIBarButtonItem * goodsBtn;
    UIBarButtonItem * fixBtn;
    fixBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenSize.height-kTabBarHeight*3+7, ScreenSize.width, kTabBarHeight*2)];
    myToolBar.barStyle = UIBarStyleBlackOpaque;
//    myToolBar.backgroundColor = [UIColor blackColor];
    if (saoType == Sao_Pay)
    {
        if (!pay_but)
        {
            pay_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 82)];
        }
        UIImage * ima_01 = [UIImage imageNamed:@"iosfirstpay-1.png"];
        pay_but.backgroundColor = [UIColor colorWithPatternImage:ima_01];
        pay_but.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, 0 );
        pay_but.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0);
//        [pay_but setBackgroundImage:ima_01 forState:UIControlStateNormal];
        [pay_but setTitle:@"快捷支付" forState:UIControlStateNormal];
        pay_but.titleLabel.font = [UIFont systemFontOfSize:12];
        [pay_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        UIImage * ima_02 = [ZbarViewController scaleAndRotateImage:ima_01 resolution:72];
//        [pay_but setBackgroundImage:ima_01 forState:UIControlStateNormal];
        [pay_but setBackgroundColor:[UIColor clearColor]];
        payBtn = [[UIBarButtonItem alloc] initWithCustomView:pay_but];
        [pay_but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (!goods_but)
        {
            goods_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 82)];
        }
        
        UIImage * ima_03 = [UIImage imageNamed:@"ioslook-4.png"];
//        UIImage * ima_04 = [ZbarViewController scaleAndRotateImage:ima_03 resolution:72];
        goods_but.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, 0 );
        goods_but.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0);
        [goods_but setBackgroundImage:ima_03 forState:UIControlStateNormal];
        [goods_but setTitle:@"扫商品" forState:UIControlStateNormal];
        goods_but.titleLabel.font = [UIFont systemFontOfSize:12];
        [goods_but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [goods_but setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
         [goods_but setBackgroundColor:[UIColor clearColor]];
        goodsBtn = [[UIBarButtonItem alloc] initWithCustomView:goods_but];
        
        myToolBar.items = @[fixBtn , payBtn , goodsBtn , fixBtn ];
    }
    else
    {
        if (!pay_but)
        {
            pay_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 82)];
        }
        UIImage * ima_01 = [UIImage imageNamed:@"iosfirstpay-2.png"];
//        UIImage * ima_02 = [ZbarViewController scaleAndRotateImage:ima_01 resolution:72];
        pay_but.backgroundColor = [UIColor colorWithPatternImage:ima_01];
        pay_but.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, 0 );
        pay_but.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0);
//        [pay_but setBackgroundImage:ima_01 forState:UIControlStateNormal];
        [pay_but setTitle:@"快捷支付" forState:UIControlStateNormal];
        pay_but.titleLabel.font = [UIFont systemFontOfSize:12];
        [pay_but setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        
        [pay_but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
         [pay_but setBackgroundColor:[UIColor clearColor]];
        payBtn = [[UIBarButtonItem alloc] initWithCustomView:pay_but];
        
        if (!goods_but)
        {
            goods_but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 82)];
        }
        UIImage * ima_03 = [UIImage imageNamed:@"ioslook-3.png"];
//        UIImage * ima_04 = [ZbarViewController scaleAndRotateImage:ima_03 resolution:72];
        goods_but.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, 0 );
        goods_but.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0);
        [goods_but setBackgroundImage:ima_03 forState:UIControlStateNormal];
        [goods_but setTitle:@"扫商品" forState:UIControlStateNormal];
        goods_but.titleLabel.font = [UIFont systemFontOfSize:12];
        [goods_but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [goods_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        [goods_but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
         [goods_but setBackgroundColor:[UIColor clearColor]];
        goodsBtn = [[UIBarButtonItem alloc] initWithCustomView:goods_but];
        
        myToolBar.items = @[fixBtn , payBtn , goodsBtn , fixBtn ];
    }
    [self.view addSubview:myToolBar];
}

-(void)btnClick:(id)sender
{
    
    UIButton * btn = (UIButton *)sender;
    if (pay_but == btn)
    {
        if ([[YHAppDelegate appDelegate] checkLogin])
        {
            saoType = Sao_Pay;
            [pay_but setBackgroundImage:[UIImage imageNamed:@"iosfirstpay-1.png"] forState:UIControlStateNormal];
            [pay_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [ goods_but setBackgroundImage:[UIImage imageNamed:@"ioslook-4.png"] forState:UIControlStateNormal];
            [goods_but setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        }
        else
        {
            saoType = Sao_Pay;
        }
    }
    else
    {
        saoType = Sao_Goods;
    }
    [self reloadView];
   
}

-(void)reloadView
{
//    [self addReadview];
    if (saoType == Sao_Pay)
    {
        self.navigationItem.title = @"快捷支付";
        lab_imgV.image = [UIImage imageNamed:@"ios扫码_2.png"];
        
        UIImage * ima_01 = [UIImage imageNamed:@"iosfirstpay-1.png"];
        [pay_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        UIImage * ima_02 = [ZbarViewController scaleAndRotateImage:ima_01 resolution:144];
        [pay_but setBackgroundImage:ima_01 forState:UIControlStateNormal];
        UIImage * ima_03 = [UIImage imageNamed:@"ioslook-4.png"];
//        UIImage * ima_04 = [ZbarViewController scaleAndRotateImage:ima_03 resolution:144];
        [goods_but setBackgroundImage:ima_03 forState:UIControlStateNormal];
        [goods_but setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
//        [pay_but setBackgroundImage:[UIImage imageNamed:@"iosfirstpay-1.png"] forState:UIControlStateNormal];
//        [ goods_but setBackgroundImage:[UIImage imageNamed:@"ioslook-4.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.navigationItem.title = @"扫商品";
       lab_imgV.image = [UIImage imageNamed:@"ios扫码_1.png"];
        UIImage * ima_01 = [UIImage imageNamed:@"iosfirstpay-2.png"];
//        UIImage * ima_02 = [ZbarViewController scaleAndRotateImage:ima_01 resolution:144];
        [pay_but setBackgroundImage:ima_01 forState:UIControlStateNormal];
        [pay_but setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        UIImage * ima_03 = [UIImage imageNamed:@"ioslook-3.png"];
//        UIImage * ima_04 = [ZbarViewController scaleAndRotateImage:ima_03 resolution:144];
        [goods_but setBackgroundImage:ima_03 forState:UIControlStateNormal];
        [goods_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

//        [pay_but setBackgroundImage:[UIImage imageNamed:@"iosfirstpay-2.png"] forState:UIControlStateNormal];
//        [goods_but setBackgroundImage:[UIImage imageNamed:@"ioslook-3.png"] forState:UIControlStateNormal];
    }
}

+(UIImage *)scaleAndRotateImage:(UIImage *)image resolution:(int)kMaxResolution
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(floorf(bounds.size.width), floorf(bounds.size.height)));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, floorf(width), floorf(height)), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
/*
 @brief PAD快速扫瞄－手动输入订单号
 **/
- (void)payButtonAction:(id)sender
{
    YHSearchOrderViewController *searchPadNumber = [[YHSearchOrderViewController alloc] init];
    searchPadNumber.saoType = saoType;
    [self.navigationController pushViewController:searchPadNumber animated:YES];
}

//  动画
- (void)beginAnimation:(BOOL)isAnimation{
    if (!isAnimation)
    {
        isScan = NO;
        return;
    }else{
        [self.view addSubview:scanImage];
        scanImage.hidden = NO;
        [UIView animateWithDuration:2 animations:^{
            [scanImage setFrame:CGRectMake( (ScreenSize.width-227)/2+4, CGRectGetMinY(self.navigationController.navigationBar.frame)+20+220, 219, 14.5)];
           
                } completion:^(BOOL finish){
             [scanImage setFrame:CGRectMake((ScreenSize.width-227)/2+4, CGRectGetMinY(self.navigationController.navigationBar.frame)+23, 219, 14.5)];
            if (isScan == YES)
            {
                [self beginAnimation:YES];
            }
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ------------------------- add UI
- (void)addNavView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, NAV_BACK_WIDTH, NAV_BACK_HEIGTH);
    [backBtn addTarget:self action:@selector(backButtonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UIBarButtonItem *barbackbtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = barbackbtn;
}

-(void)setTextContent
{
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenSize.width-227)/2,CGRectGetMinY(self.navigationController.navigationBar.frame)+30, 227, 220)];
    imgView.backgroundColor = [UIColor clearColor];
    //blw 14-10-20
    imgView.image = [UIImage imageNamed:@"image_resize_frame4.png"];
    [self.view addSubview:imgView];
    lab_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(97,CGRectGetMaxY(imgView.frame)+30 , 126, 32)];
    
    [lab_imgV setBackgroundColor:[UIColor blackColor]];
    lab_imgV.layer.cornerRadius = 5.0;
    lab_imgV.layer.masksToBounds = YES;
    lab_imgV.alpha = 0.5;
    [self.view addSubview:lab_imgV];
    if (saoType == Sao_Pay)
    {
        lab_imgV.image = [UIImage imageNamed:@"ios扫码_2.png"];
    }
    else
    {
      lab_imgV.image = [UIImage imageNamed:@"ios扫码_1.png"];
    }
}
-(void)addSharwView
{
    UIView * view_top = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.navigationController.navigationBar.frame)-20, ScreenSize.width, 50)];
    view_top.backgroundColor = [UIColor blackColor];
    view_top.alpha = 0.5;
    
    UIView * view_but = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(self.navigationController.navigationBar.frame)+250 , ScreenSize.width, ScreenSize.height-250)];
    view_but.backgroundColor = [UIColor blackColor];
    view_but.alpha = 0.5;
    
    UIView * view_left = [[UIView alloc] initWithFrame:CGRectMake(0, 50, (ScreenSize.width-227)/2, 220)];
    view_left.backgroundColor = [UIColor blackColor];
    view_left.alpha = 0.5;
    
    UIView * view_rigrt = [[UIView alloc] initWithFrame:CGRectMake(ScreenSize.width- (ScreenSize.width-227)/2, 50,  (ScreenSize.width-227)/2, 220)];
    view_rigrt.backgroundColor = [UIColor blackColor];
    view_rigrt.alpha = 0.5;
    [self.view addSubview:view_but];
    [self.view addSubview:view_left];
    [self.view addSubview:view_rigrt];
    [self.view addSubview:view_top];
}


-(void)backButtonClickHandle:(id)sender
{
    [self beginAnimation:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------------------------解码
//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample)
{
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
    //    CFRelease(sample);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    [readerView stop];
    ZBarSymbol *symbol = nil;
    // do something useful with results
    for(symbol in syms)
    {
        CFBundleRef mainBundle;
        SystemSoundID soundID;
        mainBundle = CFBundleGetMainBundle ();
        
        // Get the URL to the sound file to play
        CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (mainBundle,
                                                             CFSTR ("scan_tip"),
                                                             CFSTR ("wav"),
                                                             NULL
                                                             );
        // Create a system sound object representing the sound file
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
        // Add sound completion callback
        AudioServicesAddSystemSoundCompletion (soundID, NULL, NULL,
                                               SoundFinished,
                                               (void *) CFBridgingRetain(self));
        // Play the audio
        AudioServicesPlaySystemSound(soundID);
        NSString *symbolStr= symbol.data;
        NSLog(@"type:%@",symbolStr);
        break;
    }
    [self parseResultString:symbol.data ];
}

/***
 *  @brief 解析扫瞄结果
 */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag)
    {
        case 10000:
            [readerView flushCache];
            [readerView start];
            break;
            case 10001:
            [readerView flushCache];
            [readerView start];
            break;
            case 10002:
            [readerView flushCache];
            [readerView start];
            break;
            case 10003:
            [readerView flushCache];
            [readerView start];
            break;
            case 10004:
            [readerView flushCache];
            [readerView start];
            break;
            
        default:
            break;
    }
    [self reloadInputViews];
}
-(void)parseResultString:(NSString*)resultString
{
    //    [self beginAnimation:NO];
    scanImage.hidden = YES;
    NSLog(@"292929229----------resultString = %@" ,resultString);
    if (resultString == nil)
    {
        if (saoType == Sao_Pay)
        {
//             [self showAlert:@"没有扫描结果"];
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有扫描结果" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            view.tag = 10000;
            [readerView stop];
            [view show];
        }
        else
        {
//            [[iToast makeText:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！"]show];
//            [self showAlert:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！"];
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            view.tag = 10001;
            [readerView stop];
            [view show];
        }
//         [readerView flushCache];
        return;
    }
    //  根据扫瞄结果下单
    if (saoType == Sao_Pay)
    {
        [[NetTrans getInstance] API_ScanQuick:self Order_List_No:resultString coupon_id:nil];
    }
    else
    {
        [[NetTrans getInstance] API_Goods_Saomiao:self Code:resultString];
        /*
         */
    }
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader withRetry: (BOOL) retry
{
    NSLog(@"false");
}
#pragma mark --------------------------Request Delegate

-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
   
    if (nTag == t_API_SCAN_CODE)
    {
        OrderSubmitEntity *submitOrder = (OrderSubmitEntity *)netTransObj;
        YHQuickScanOrderViewController *quickScan = [[YHQuickScanOrderViewController alloc] init];
        quickScan.submitOrder = submitOrder;
        quickScan.couponList = submitOrder.couponList;
        NSLog(@"292929292929 -------t_API_SCAN_CODE  成功")
        [readerView stop];
        [readerView flushCache];
        [self.navigationController pushViewController:quickScan animated:YES];
    }
    else if (nTag == t_API_SAOMIAO)
    {
        GoodSaoDetailEntity *submitOrder = (GoodSaoDetailEntity *)netTransObj;
        if ([submitOrder.is_published isEqualToString:@"0"])
        {
//            [self showAlert:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！"];
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本商品暂未在永辉微店售卖，请试试其他商品，谢谢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            view.tag = 10002;
            [readerView stop];
            [view show];
        }
        else
        {
            YHGoodsDetailViewController *detaiVC = [[YHGoodsDetailViewController alloc]init];
            NSString *url = [NSString stringWithFormat:GOODS_DETAIL,submitOrder.good_id,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            detaiVC.url = url;
            [detaiVC setMainGoodsUrl:url goodsID:submitOrder.good_id];
            [readerView stop];
            [readerView flushCache];
            NSLog(@"292929292929 -------t_API_SAOMIAO  成功")
            [self.navigationController pushViewController:detaiVC animated:YES];
        }
    }
//     [readerView flushCache];
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
//    [readerView flushCache];
    if (t_API_SCAN_CODE == nTag)
    {
        //        [self showAlert:errMsg];
        if ([status isEqualToString:WEB_STATUS_3])
        {
            YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
            [[YHAppDelegate appDelegate] changeCartNum:@"0"];
            [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
            [[UserAccount instance] logoutPassive];
            [delegate LoginPassive];
            return;
        }
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:errMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        view.tag = 10003;
        [readerView stop];
        NSLog(@"292929292929 -------t_API_SCAN_CODE  失败");
        [view show];
    }
    else if (t_API_SAOMIAO == nTag)
    {
        //        [self showAlert:errMsg];
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:errMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        view.tag = 10004;
        
        [readerView stop];
        NSLog(@"292929292929 -------t_API_SAOMIAO  失败");
        [view show];
    }

}


@end
