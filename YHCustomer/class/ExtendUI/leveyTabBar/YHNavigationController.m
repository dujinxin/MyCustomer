//
//  THNavigationController.m
//  THCustomer
//
//  Created by lichentao on 13-8-11.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "YHNavigationController.h"

@interface YHNavigationController ()

@end

@implementation YHNavigationController

- (id)init {
    self = [super init];
    self.delegate = self;
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    self.delegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarImage = _navigationBarImage;
}

- (void)setNavigationBarImage:(NSString *)navigationBarImage {
    _navigationBarImage = [navigationBarImage copy];
    
    UINavigationBar *bar = self.navigationBar;
    
    if ([[UIDevice currentDevice].systemVersion compare:@"5.0"]<0) {
        CALayer *layer = [CALayer layer];
        UIImage *navBarImage = [[UIImage imageNamed:_navigationBarImage] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        layer.contents = (id)navBarImage.CGImage;
        layer.frame = CGRectMake(0, 0, 320, navBarImage.size.height);
        [bar.layer insertSublayer:layer atIndex:0];
        _barBackLayer = layer;
    }else {
        bar.backgroundColor =  [UIColor clearColor];
        bar.layer.borderColor = [UIColor clearColor].CGColor;
        [bar performSelector:@selector(setBackgroundImage:forBarMetrics:) withObject:[UIImage imageNamed:_navigationBarImage]];
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([[UIDevice currentDevice].systemVersion compare:@"5.0"]<0) {
        [_barBackLayer removeFromSuperlayer];
        [navigationController.navigationBar.layer insertSublayer:_barBackLayer atIndex:0];
    }
    
}

- (void)popBackWithAnimation {
    [self popViewControllerAnimated:YES];
}

@end

@implementation UIViewController (ITNavigationCustom)

- (YHNavigationController *)defaultNavigationController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return (YHNavigationController *)self;
    }else if (self.navigationController) {
        return (YHNavigationController *)self.navigationController;
    }
    
    YHNavigationController *navController = [[YHNavigationController alloc] initWithRootViewController:self];
    if (IOS_VERSION < 7) {
//        navController.navigationBarImage = @"nav_Bg.png";
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [[UINavigationBar appearance] setTintColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
        [navController.navigationBar setTranslucent:NO];
        
        NSDictionary *attributes = @{ UITextAttributeFont: [UIFont fontWithName:@"Futura" size:20],
                                      UITextAttributeTextColor: [UIColor blackColor]};
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //这是iOS7以前的方法
//        [[UINavigationBar appearance] setTintColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
        //这是iOS8的方法
        [[UINavigationBar appearance] setBarTintColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0]];
        [navController.navigationBar setTranslucent:NO];
//        navController.navigationBar.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
//        navController.navigationBar.tintColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        /*
         NSDictionary *attributes = @{ UITextAttributeFont: [UIFont fontWithName:@"Futura" size:20],
         UITextAttributeTextColor: [UIColor blackColor]};
         [[UINavigationBar appearance] setTitleTextAttributes:attributes];
         */
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Futura" size:20],
                                      NSForegroundColorAttributeName: [UIColor blackColor]};
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
    }

//    navController.navigationBar.tintColor = [UIColor whiteColor];
    return navController;
}


@end
