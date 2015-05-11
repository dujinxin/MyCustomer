//
//  CommentShareView.h
//  YHCustomer
//
//  Created by lichentao on 14-6-24.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  评论－分享 公共ui控件

#import <UIKit/UIKit.h>
#import "PromotionShareEntity.h"

typedef void(^CommentButtonBlock)(NSString *dm_id);
@interface CommentShareView : UIView<YHAlertViewDelegate,ISSShareViewDelegate>

@property (nonatomic, strong) CommentButtonBlock commentBlock;
@property (nonatomic, copy) NSString *dmId;
@property (nonatomic,strong) UITextView *shareTextView;
@property (nonatomic, strong) PromotionShareEntity * entity;
@property (nonatomic , assign) id viewC;


- (id)initCommentShareView:(CGRect)frame Dm_ID:(NSString *)dm_id CommentButtonBlock:(CommentButtonBlock)commentBlock1;
- (id)initCommentShareView:(CGRect)frame viewController:(id)viewController Dm_ID:(NSString *)dm_id CommentButtonBlock:(CommentButtonBlock)commentBlock1;

@end
