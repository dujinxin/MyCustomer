//
//  YHShareFriendsViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/12/4.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "YHAlertView.h"
#import <AddressBookUI/AddressBookUI.h>
#import "YHCardBag.h"
#import "EGORefreshTableFooterOtherView.h"
@interface YHShareFriendsViewController : YHRootViewController<YHAlertViewDelegate , UITextFieldDelegate , ABPeoplePickerNavigationControllerDelegate, EGORefreshTableOtherDelegate , UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong)EGORefreshTableFooterOtherView *refreshFooterOtherView;
@property (nonatomic , strong)YHCardBag * entityCard;
@property (nonatomic , assign)BOOL forWard;

@end
