//
//  THNavigationController.h
//  THCustomer
//
//  Created by lichentao on 13-8-11.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHNavigationController : UINavigationController<UINavigationControllerDelegate>{
@private
    CALayer *_barBackLayer;
}
@property (nonatomic,strong)NSString *navigationBarImage;

@end

@interface UIViewController (ITNavigationCustom)
- (YHNavigationController *)defaultNavigationController;
@end
