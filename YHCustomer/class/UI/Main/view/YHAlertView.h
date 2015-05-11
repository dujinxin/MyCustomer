//
//  YHAlertView.h
//  YHCustomer
//
//  Created by dujinxin on 14-11-21.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef  void (^DismissCard)(NSString * str);

@class YHAlertView;
@protocol YHAlertViewDelegate <NSObject>
@optional
- (void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)yhAlertViewCancel:(YHAlertView *)alertView;

- (void)willPresentYhAlertView:(YHAlertView *)alertView;  // before animation and showing view
- (void)didPresentYhAlertView:(YHAlertView *)alertView;  // after animation

- (void)yhAlertView:(YHAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)yhAlertView:(YHAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
- (BOOL)yhAlertViewShouldEnableFirstOtherButton:(YHAlertView *)alertView;
- (BOOL)dismiss;

@end


@interface YHAlertView : UIView<UITextFieldDelegate>
{
    
}
@property (nonatomic, assign)id<YHAlertViewDelegate> delegate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;

@property (nonatomic , strong) UITextField * textFiled;
@property(nonatomic , strong)DismissCard  block;
@property(nonatomic , strong) UIView * lineIn;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (id)initWithTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (id)initWithTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitle:(NSString *)buttonTitle;
-(id)initWithOtherTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (void)show;
- (void)showInView:(UIView *)view;

- (void)dismiss;
-(id)initWithCustom:(UIView *)customView delegate:(id)delegate;
-(void)dismiss:(BOOL)yesOrNo;
-(void)showWithAnimation:(BOOL)yesOrNo;
- (void)buttonClick:(UIButton *)btn;

- (void)showCodeView;

-(void)setLine;
//永辉钱包
- (void)dismissCard;
-(id)initWithTitle:(NSString *)title message:(NSString *)message message:(NSMutableAttributedString *)attString  delegate:(id)delegate upButtonTitle:(NSString *)buttonTitle Left:(BOOL)Left;
-(id)initWithOOTitle:(NSString *)title message:(NSString *)message  customView:(UIView *)customView delegate:(id)delegate upButtonTitle:(NSString *)buttonTitle;

-(id)initWithTitle:(NSMutableAttributedString *)title message:(NSString *)message delegate:(id)delegate Left:(BOOL)yesOrNo  button:(NSArray *)btnArr isPaa:(BOOL)isTextFiled;
//
-(id)initWithMessage:(NSString *)message delegate:(id)delegate;
@end
