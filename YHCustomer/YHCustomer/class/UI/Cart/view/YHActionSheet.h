//
//  YHActionSheet.h
//  YHCustomer
//
//  Created by dujinxin on 14-9-6.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHActionSheetDelegate <NSObject>

- (void)done;

@end
@interface YHActionSheet : UIActionSheet
{
    float customViewHeight;
}
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) id <YHActionSheetDelegate> target;

-(id)initWithViewHeight:(float)height;

@end
