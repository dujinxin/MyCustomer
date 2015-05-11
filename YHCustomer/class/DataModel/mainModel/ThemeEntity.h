//
//  ThemeEntity.h
//  YHCustomer
//
//  Created by dujinxin on 14-8-28.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//  主题区图片实体

#import <Foundation/Foundation.h>

@interface ThemeEntity : NSObject

@property(nonatomic,copy)NSString *show_type;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *jump_type;
@property(nonatomic,copy)NSString *jump_parametric;
@property(nonatomic,copy)NSString *title;

@end


@interface ThemeTransObj : NetTransObj

@end
