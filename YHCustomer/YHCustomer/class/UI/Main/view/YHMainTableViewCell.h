//
//  YHMainTableViewCell.h
//  YHCustomer
//
//  Created by kongbo on 13-12-18.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHMainViewController.h"
#import "CategoryEntity.h"

@interface YHMainTableViewCell : UITableViewCell {
    UIView *leftView;
    UIView *rightView;
    UIImageView *image;
    UIButton *btn;
    UIButton *tab1;
    UIButton *tab2;
    UIButton *tab3;
    UIButton *tab4;
    UIButton *tab5;
    UIButton *tab6;

    NSMutableArray  *dataArray;
    CategoryEntity  *categoryEntity;
}

@property (nonatomic, assign) YHMainViewController *mainVC;
@property (nonatomic, assign) NSInteger rowNum;
-(void)setCellView:(CategoryEntity *)data;
@end
