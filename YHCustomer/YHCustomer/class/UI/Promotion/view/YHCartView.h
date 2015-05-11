//
//  YHCartView.h
//  YHCustomer
//
//  Created by kongbo on 14-6-24.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  购物车按钮

#import <UIKit/UIKit.h>

@protocol CartViewDelegate <NSObject>

@required

-(void)cartViewClickAction;

@end



@interface YHCartView : UIView {

    UIImageView *image;
    UIImageView *corner;
    UILabel     *numLabel;
    
}

@property (nonatomic,assign) id<CartViewDelegate> delegate;

-(void)changeCartNum;

@end
