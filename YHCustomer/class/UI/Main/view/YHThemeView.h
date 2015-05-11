//
//  YHThemeView.h
//  YHCustomer
//
//  Created by dujinxin on 14-12-29.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHImageView.h"



//typedef enum {
//    kOperationOne = 0,
//    kOperationTwo,
//    kOperationThree,
//    kOperationFour,
//}kOperationType;

@protocol YHThemeDelegate <NSObject>

- (void)yhThemeViewAction:(YHImageView *)imageView;

@end

@interface YHThemeView : UIView<YHImageViewDelegate>
//@property (nonatomic,assign)kOperationType type;
@property (nonatomic,assign)id<YHThemeDelegate>delegate;

@property (nonatomic,strong)YHImageView * leftTopImageView;
@property (nonatomic,strong)YHImageView * leftBottomImageView;
@property (nonatomic,strong)YHImageView * rightTopImageView;
@property (nonatomic,strong)YHImageView * rightBottomImageView;
@end
