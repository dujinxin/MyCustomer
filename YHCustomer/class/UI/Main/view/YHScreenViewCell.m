//
//  YHScreenViewCell.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHScreenVIewCell.h"

@implementation YHScreenViewCell

@synthesize selectName = _selectName;
@synthesize categoryName = _categoryName;
@synthesize arrow = _arrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.backgroundColor = [PublicMethod colorWithHexValue:0x3d3d3d alpha:1.0];
        //
        //        self.categoryName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 39)];
        //        self.categoryName.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //        self.categoryName.font = [UIFont systemFontOfSize:15.f];
        //        [self.contentView addSubview:self.categoryName];
        //
        //        self.selectName = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 140, 39)];
        //        self.selectName.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        //        self.selectName.font = [UIFont systemFontOfSize:15.f];
        //        self.selectName.textAlignment = NSTextAlignmentRight;
        //        [self.contentView addSubview:self.selectName];
        
        self.arrow = [[UIImageView alloc]initWithFrame:CGRectMake(320 -65, 5, 30, 30)];
        //        arrow.image = [UIImage imageNamed:@"icon_arrow"];
        //        self.arrow.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.arrow];
        
        //        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40 -0.5, 320 -40, 0.5)];
        //        line.backgroundColor = [UIColor darkGrayColor];
        //        [self.contentView addSubview:line];
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
