//
//  YHOperationView.h
//  YHCustomer
//
//  Created by dujinxin on 14-12-25.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHImageView.h"
//运营视图

typedef enum {
    kOperationOne = 0,  //一图
    kOperationTwo,      //二图：左右
    kOperationThree,    //三图：左，右上，右下
    kOperationFour,     //四图：左，右上，右左下，右右下
}kOperationType;

@class YHOperationView;
@protocol YHOperationDelegate <NSObject>

- (void)yhImageViewAction:(YHImageView *)imageView;
@optional
- (void)yhOperationAction:(YHOperationView *)operation;

@end

@interface YHOperationView : UIView<YHImageViewDelegate>
@property (nonatomic,assign)kOperationType type;
@property (nonatomic,assign)id<YHOperationDelegate>delegate;

@property (nonatomic,strong)YHImageView * superImageView;
@property (nonatomic,strong)YHImageView * bigLeftImageView;
@property (nonatomic,strong)YHImageView * bigRightImageView;
@property (nonatomic,strong)YHImageView * mediumTopImageView;
@property (nonatomic,strong)YHImageView * mediumBottomImageView;
@property (nonatomic,strong)YHImageView * smallLeftImageView;
@property (nonatomic,strong)YHImageView * smallRightImageView;


- (id)initWithFrame:(CGRect)frame type:(kOperationType)operationType;

@end
