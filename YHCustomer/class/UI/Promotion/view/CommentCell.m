//
//  CommentCell.m
//  THCustomer
//
//  Created by lichentao on 13-9-5.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize headImage,titleLabel,timeLabel,contextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
