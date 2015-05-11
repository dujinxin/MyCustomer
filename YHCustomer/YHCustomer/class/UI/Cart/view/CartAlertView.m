//
//  CustomAlertView.m
//
//  Created by kongbo on 14-5-18.
//  Copyright (c) 2014年 Wimagguc. All rights reserved.
//

#import "CartAlertView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kAlertViewDefaultButtonHeight       = 43.5;
const static CGFloat kAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kAlertViewCornerRadius              = 7;
const static CGFloat kMotionEffectExtent                 = 10.0;

@implementation CartAlertView
{
        NSString * priceText;
}
CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@synthesize parentView, containerView, dialogView, buttonView, onButtonTouchUpInside;
@synthesize delegate;
@synthesize buttonTitles;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
//        delegate = self;
        useMotionEffects = false;
        buttonTitles = @[@"取消",@"确定"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [self initContainerView];
    }
    return self;
}

-(id)initCard:(NSString *)strNum
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        //        delegate = self;
        useMotionEffects = false;
        buttonTitles = @[@"取消",@"确定"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        priceText = strNum;
        [self initContainerViewCard];
    }
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show
{
    dialogView = [self createContainerView];
    
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:dialogView];
    
    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];
        
        // Attached to the top most window (make sure we are using the right orientation):
    } else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];
}

// Button has been touched
- (IBAction)dialogButtonTouchUpInside:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if (delegate != NULL) {
        [delegate dialogButtonTouchUpInside:self clickedButtonAtIndex:[btn tag]];
    }
    
    if (onButtonTouchUpInside != NULL) {
        if ([btn tag] == 1) {//确定
            if ([_goodsNumField.text intValue]>999) {
                [[iToast makeText:@"不能大于999"] show];
                return;
            }
            if ([_goodsNumField.text intValue]<1) {
                [[iToast makeText:@"不能小于1"] show];
                return;
            }
            onButtonTouchUpInside( _goodsNumField.text);
        }
        [self close];
    }
}

// Default button behaviour
- (void)dialogButtonTouchUpInside: (CartAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %ld, %ld", (long)buttonIndex, (long)[alertView tag]);
    [self close];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    CATransform3D currentTransform = dialogView.layer.transform;
    
    CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }
    
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc]initWithFrame:CGRectMake(25, (screenSize.height-dialogSize.height)/2, 270, 189)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = kAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    
    // There is a line above the button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [dialogContainer addSubview:lineView];
    // ^^^
    
    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];
    
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
    if (buttonTitles==NULL) { return; }
    
    CGFloat buttonWidth = 135;
    
    for (int i=0; i<[buttonTitles count]; i++) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        [closeButton addTarget:self action:@selector(dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [closeButton.layer setCornerRadius:kAlertViewCornerRadius];
        [container addSubview:closeButton];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(135, container.bounds.size.height - buttonHeight, 1, buttonHeight)];
    line.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];;
    [container addSubview:line];
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height + buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = tmp;
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kMotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kMotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kMotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kMotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.transform = rotation;
					 }
					 completion:^(BOOL finished){
                         // fix errors caused by being rotated one too many times
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             UIInterfaceOrientation endInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                             if (interfaceOrientation != endInterfaceOrientation) {
                                 // TODO user moved phone again before than animation ended: rotation animation can introduce errors here
                             }
                         });
                     }
	 ];
    
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
}

-(void)initContainerView {
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 145)];
    textView.backgroundColor = [UIColor clearColor];
    
    UILabel *title1 = [PublicMethod addLabel:CGRectMake(0, 20, 270, 18) setTitle:@"修改商品数量" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:18]];
    title1.textAlignment = NSTextAlignmentCenter;
    [textView addSubview:title1];
    
    UILabel *title2 = [PublicMethod addLabel:CGRectMake(0, title1.bottom+10, 270, 14) setTitle:@"输入您想购买的商品数量" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
    title2.textAlignment = NSTextAlignmentCenter;
    [textView addSubview:title2];
    
    UILabel *title3 = [PublicMethod addLabel:CGRectMake(0, title2.bottom+7, 270, 14) setTitle:@" 最大购买数999个" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
    title3.textAlignment = NSTextAlignmentCenter;
    [textView addSubview:title3];
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    [minus setBackgroundImage:[UIImage imageNamed:@"ps_cut"] forState:UIControlStateNormal];
    [minus setBackgroundImage:[UIImage imageNamed:@"ps_cut_Select"] forState:UIControlStateHighlighted];
    minus.frame = CGRectMake(55, title3.bottom+12, 30, 30);
    [minus addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:minus];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    [plus setBackgroundImage:[UIImage imageNamed:@"ps_plus"] forState:UIControlStateNormal];
    [plus setBackgroundImage:[UIImage imageNamed:@"ps_plus_Select"] forState:UIControlStateHighlighted];
    plus.frame = CGRectMake(55+130, title3.bottom+12, 30, 30);
    [plus addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:plus];
    
    _goodsNumField = [[UITextField alloc]initWithFrame:CGRectMake(105, title3.bottom+7, 60, 40)];
    _goodsNumField.layer.borderWidth = 1;
    _goodsNumField.tag = 1;
    _goodsNumField.layer.borderColor = [PublicMethod colorWithHexValue:0xbfbfbf alpha:1.0].CGColor;
    _goodsNumField.textAlignment = NSTextAlignmentCenter;
    _goodsNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _goodsNumField.backgroundColor = [UIColor whiteColor];
    _goodsNumField.keyboardType = UIKeyboardTypeNumberPad;
    _goodsNumField.delegate = self;
    [textView addSubview:_goodsNumField];
    containerView = textView;
}

-(void)initContainerViewCard
{
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 145)];
    textView.backgroundColor = [UIColor clearColor];
    
    UILabel *title1 = [PublicMethod addLabel:CGRectMake(0, 20, 270, 18) setTitle:@"修改永辉卡数量" setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:18]];
    title1.textAlignment = NSTextAlignmentCenter;
    [textView addSubview:title1];
    
    UILabel *title2 = [PublicMethod addLabel:CGRectMake(0, title1.bottom+10, 270, 14) setTitle:@"输入您想购买的永辉卡数量" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
    title2.textAlignment = NSTextAlignmentCenter;
    [textView addSubview:title2];
    
    UILabel *title3 = [PublicMethod addLabel:CGRectMake(0, title2.bottom+7, 270, 14) setTitle:@" 消费金额最大不能超过10000元" setBackColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] setFont:[UIFont systemFontOfSize:14]];
    title3.textAlignment = NSTextAlignmentCenter;
    [textView addSubview:title3];
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    [minus setBackgroundImage:[UIImage imageNamed:@"ps_cut"] forState:UIControlStateNormal];
    [minus setBackgroundImage:[UIImage imageNamed:@"ps_cut_Select"] forState:UIControlStateHighlighted];
    minus.frame = CGRectMake(55, title3.bottom+12, 30, 30);
    [minus addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:minus];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    [plus setBackgroundImage:[UIImage imageNamed:@"ps_plus"] forState:UIControlStateNormal];
    [plus setBackgroundImage:[UIImage imageNamed:@"ps_plus_Select"] forState:UIControlStateHighlighted];
    plus.frame = CGRectMake(55+130, title3.bottom+12, 30, 30);
    [plus addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:plus];
    
    _goodsNumField = [[UITextField alloc]initWithFrame:CGRectMake(105, title3.bottom+7, 60, 40)];
    _goodsNumField.layer.borderWidth = 1;
    _goodsNumField.layer.borderColor = [PublicMethod colorWithHexValue:0xbfbfbf alpha:1.0].CGColor;
    _goodsNumField.textAlignment = NSTextAlignmentCenter;
    _goodsNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _goodsNumField.backgroundColor = [UIColor whiteColor];
    _goodsNumField.keyboardType = UIKeyboardTypeNumberPad;
    _goodsNumField.tag = 2;
    _goodsNumField.delegate = self;
    [textView addSubview:_goodsNumField];
    containerView = textView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text length] == 0)
    {
        unichar single=[string characterAtIndex:0];
        if (single == '0')
        {
            [[iToast makeText:@"第一位不能为0"] show];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        if (string)
        {
            if (textField.tag == 1)
            {
                if (range.location >= 3){
                    return NO;
                }
                
            }
            else if (textField.tag == 2)
            {
                NSString * strValue = [textField.text stringByAppendingString:string];
                if ([strValue intValue]*[priceText intValue] > 10000)
                {
                    [[iToast makeText:@"购买总金额不能大于10000元"] show];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
            }
        }

    }
    return YES;
}

#pragma mark --------- action 
-(void)minusAction {
    if ([_goodsNumField.text intValue] - 1<= 0) {
        [[iToast makeText:@"不能小于1"] show];
        return;
    }
   _goodsNumField.text = [NSString stringWithFormat:@"%d",[_goodsNumField.text intValue] - 1];
}

-(void)plusAction
{
    if (_goodsNumField.tag == 2)
    {
        if(([_goodsNumField.text intValue]+1)*[priceText intValue] >10000)
        {
            [[iToast makeText:@"购买总金额不能大于10000元"] show];
            return;
        }
        _goodsNumField.text = [NSString stringWithFormat:@"%d",[_goodsNumField.text intValue] + 1];
    }
   else if (_goodsNumField.tag == 1)
   {
       if ([_goodsNumField.text intValue] +1 >999) {
           [[iToast makeText:@"不能大于999"] show];
           return;
       }
       _goodsNumField.text = [NSString stringWithFormat:@"%d",[_goodsNumField.text intValue] + 1];
   }
}

@end
