//
//  YHSearchListTableViewController.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol PassValueDelegate <NSObject>
- (void)passValue:(NSString *)value;
@end

@interface YHSearchListTableViewController : UITableViewController {
	NSString		*_searchText;
	NSString		*_selectedText;
	NSMutableArray	*_resultList;
}

@property (nonatomic, copy)NSString		*searchText;
@property (nonatomic, copy)NSString		*selectedText;
@property (nonatomic, strong)NSMutableArray	*resultList;
@property (nonatomic, assign) id <PassValueDelegate> target;

- (void)updateData;

@end

