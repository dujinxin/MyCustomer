//
//  YHRegisterViewController.h
//  YHCustomer
//
//  Created by lichentao on 13-12-12.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "KeyBoardTopBar.h"

@interface YHRegisterViewController : YHRootViewController{

}
@property (nonatomic, copy) THLoginSuccessBlock loginSuccessBlock;
@property (nonatomic, copy) THLoginViewBackBlock loginBackBlock;
@end
