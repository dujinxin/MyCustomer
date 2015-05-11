//
//  YHCommentViewController.h
//  YHCustomer
//
//  Created by kongbo on 13-12-23.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"

@interface YHCommentViewController : YHBaseTableViewController <UITextFieldDelegate>{
    UITextField *sendField;
    NSMutableArray *commentDataArray;
    UIImageView *sendView;
    UIView *noCommentView;
}
@property (nonatomic, assign) CommentType commentStyle;
@property (nonatomic,   copy) NSString       *goods_id;
@property (nonatomic,   copy) NSString       *dm_id;
@property (nonatomic, assign) BOOL           _isBought; //如果是商品评论，需要购买才可以评论

-(void)setCommentListDataAndType:(NSString*)strID Type:(CommentType)type IsBought:(BOOL)isBought;
@end
