//
//  YHScreenViewCell.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHScreenViewCell : UITableViewCell
{
    UILabel * selectName;
    UILabel * categoryName;
}
@property (nonatomic ,strong)UILabel * selectName;
@property (nonatomic ,strong)UILabel * categoryName;
@property (nonatomic ,strong)UIImageView * arrow;

@end
