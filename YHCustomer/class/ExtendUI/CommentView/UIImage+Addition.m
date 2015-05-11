//
//  UIImage+Addition.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-27.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

+ (UIImage *)imageWithName:(NSString *)name{
    UIImage *image = nil;
    if (IOS_VERSION >=7)
    { // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}
+ (UIImage *)resizedImage:(NSString *)name{
    UIImage *image = [UIImage imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
