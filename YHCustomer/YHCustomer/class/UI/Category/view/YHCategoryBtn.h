//
//  YHCategoryBtn.h
//  YHCustomer
//
//  Created by dujinxin on 14-10-10.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCategoryBtn : UIButton

@property (nonatomic ,strong)UIImageView * icon;
@property (nonatomic ,strong)UIImageView * arrow;
@property (nonatomic ,strong)UILabel * name;

@property (nonatomic ,strong)NSIndexPath * indexPath;



- (void)setSelectedImage:(UIImage *)image;
@end
