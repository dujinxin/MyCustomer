//
//  YHCardOpenViewController.h
//  YHCustomer
//
//  Created by 白利伟 on 14/12/1.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHBaseTableViewController.h"
#import "YHCardBag.h"
#import "KeyBoardTopBar.h"
@interface YHCardOpenViewController : YHRootViewController<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate, keyBoardTopBarDelegate , UIWebViewDelegate>
{
     KeyBoardTopBar *keyBoard;
}

@property(nonatomic ,strong)YHCardBag * entityCard;
@property(nonatomic , assign)BOOL forWard;
@end
