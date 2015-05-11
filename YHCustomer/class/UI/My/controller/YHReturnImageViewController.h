//
//  YHReturnImageViewController.h
//  YHCustomer
//
//  Created by kongbo on 14-5-20.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^deleteBlock)(NSInteger tag);
@interface YHReturnImageViewController : YHRootViewController <UIActionSheetDelegate>
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,strong) deleteBlock block;
@end
