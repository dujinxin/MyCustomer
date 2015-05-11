//
//  YHFeedbackViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-19.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHFeedbackViewController : YHRootViewController <UITextViewDelegate> {
    NSString *feedBackText;
    UIButton *commitBtn;
}

@end
