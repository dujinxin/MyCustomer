//
//  YHAccountManagerViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-16.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "UserInfoEntity.h"

@interface YHAccountManagerViewController : YHRootViewController<UITableViewDataSource, UITableViewDelegate,
UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView     *_tableView;
@property (nonatomic, strong) UserInfoEntity  *_userInfoEntity;

-(void)setUserInfoEntity:(UserInfoEntity*)entity;

@end
