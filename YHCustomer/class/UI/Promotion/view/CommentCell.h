//
//  CommentCell.h
//  THCustomer
//
//  Created by lichentao on 13-9-5.
//  Copyright (c) 2013年 efuture. All rights reserved.
//  逛－商品详情－评论cell

#import <UIKit/UIKit.h>
#import "CommentEntity.h"

@interface CommentCell : UITableViewCell
{
    UIImageView *headImage;
    UILabel     *titleLabel;
    UILabel     *timeLabel;
    UILabel     *contextLabel;
}

@property (nonatomic, strong)UIImageView *headImage;
@property (nonatomic, strong)UILabel     *titleLabel;
@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UILabel     *contextLabel;

@end
