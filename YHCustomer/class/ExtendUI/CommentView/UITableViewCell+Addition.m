//
//  UITableViewCell+Addition.m
//  YHCustomer
//
//  Created by kongbo on 13-12-20.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "UITableViewCell+Addition.h"

@implementation UITableViewCell (Addition)
- (void)setBackgroundImage:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.backgroundView = imageView;  
}

- (void)setBackgroundImageByName:(NSString*)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName]];
}
@end
