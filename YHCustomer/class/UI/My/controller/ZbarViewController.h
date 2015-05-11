//
//  ZbarViewController.h
//
//
//  Created by liuzhic on 12-9-28.
//  Copyright (c) 2012年 TianHong. All rights reserved.
//  二维码扫码界面

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ZbarViewController   : YHRootViewController
<ZBarReaderDelegate, ZBarReaderViewDelegate,ZBarHelpDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UINetTransDelegate,UIAlertViewDelegate>
{
    ZBarReaderView *readerView;
    UITextView *resultText;
    ZBarCameraSimulator *cameraSim;
    ZBarHelpController *helpController;
    
    SaoType saoType;
    UIImageView     *scanImage;
    float           scanHeight;
    BOOL            isScan;
    
    UIToolbar * myToolBar;
    
    UIButton * pay_but;
    UIButton * goods_but;
}

@property(nonatomic , assign)SaoType saoType;
@property(nonatomic , strong)UIImageView *imgView;
@property(nonatomic , strong)UIImageView * lab_imgV;
@end
