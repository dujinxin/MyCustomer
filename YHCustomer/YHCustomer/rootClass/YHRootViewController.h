//
//  YHRootViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-9.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRootViewController : UIViewController{

    float originY;
}
@property(nonatomic,assign)BOOL isVisible;
- (void)showAlert:(NSString *)message;
- (void)showAlert:(id)target Message:(NSString *)message;
- (void)showAlert:(id)target newMessage:(NSString *)message;
- (void)showNotice:(NSString *)string;
- (BOOL)checkNetreachability;

/*右侧按键*/
- (void)setRightBarButton:(id)trans Action:(SEL)action SetImage:(NSString *)imgString SelectImg:(NSString *)imgHight;
- (void)setRightBarButton:(id)trans Action:(SEL)action SetImage:(NSString *)imgString SelectImg:(NSString *)imgHight title:(NSString *)title;

- (void)setNavigationTitle:(NSString *)title;

@end
