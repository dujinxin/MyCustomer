//
//  GJGLAlertView.h
//  SJGL
//
//  Created by lichentao on 14-2-6.
//  Copyright (c) 2014年 liushunfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SJGLCallBackBlock)(NSString *companyName,NSString *order_no); // alertView 按钮触发
typedef void(^SJGLCallCancelBlock)();;

@interface GJGLAlertView : UIView<UITextFieldDelegate>{
    UITextField *companyField;
    UITextField *orderField;
}

@property (nonatomic, strong) SJGLCallBackBlock callBackBlock;
@property (nonatomic, strong) SJGLCallCancelBlock cancelBlock;
+ (GJGLAlertView *)shareInstance;
- (void)setAlertViewBlock:(SJGLCallBackBlock)callBackBlock1 CancelBlock:(SJGLCallCancelBlock)cancelBlock1;

@end
