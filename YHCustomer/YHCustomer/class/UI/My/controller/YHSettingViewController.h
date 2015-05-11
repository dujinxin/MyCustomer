//
//  YHSettingViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHSettingViewController : YHRootViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL isForceUpdate;
    UIButton *_logoutBtn;
}
@end
