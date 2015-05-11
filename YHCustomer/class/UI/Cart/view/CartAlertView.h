//
//  CustomAlertView.h
//
//  Created by kongbo on 14-5-18.
//  Copyright (c) 2014年 Wimagguc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CartAlertViewDelegate

- (void)dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface CartAlertView : UIView <CartAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<CartAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (nonatomic, retain) UITextField *goodsNumField;

@property (copy) void (^onButtonTouchUpInside)(NSString *goodsNum);

- (id)init;
-(id)initCard:(NSString *)strNum;
/*!
 DEPRECATED: Use the [CartAlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

- (IBAction)dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^) (NSString *goodsNum))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;
@end
