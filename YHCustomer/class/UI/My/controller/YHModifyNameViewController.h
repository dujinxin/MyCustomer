//
//  YHModifyNameViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHModifyNameViewController : YHRootViewController<UITextFieldDelegate>

@property (nonatomic,   copy) NSString *_strNewName;
@property (nonatomic,   copy) NSString *_oldName;
@property (nonatomic, retain) UIButton *_commitBtn;
-(void)setOriName:(NSString*)name;

@end
