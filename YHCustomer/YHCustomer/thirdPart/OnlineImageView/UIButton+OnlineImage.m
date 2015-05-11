//
//  UIButton+OnlineImage.m
//  Mogujia4iPad
//
//  Created by dong wu on 12-5-25.
//  Copyright (c) 2012年 Mogujie, Inc. All rights reserved.
//

#import "UIButton+OnlineImage.h"
@implementation UIButton (OnlineImage)

- (void)setOnlineImage:(NSString *)url
{
    [self setOnlineImage:url placeholderImage:nil];
}

- (void)setOnlineImage:(NSString *)url placeholderImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    AsyncImageDownloader *downloader = [AsyncImageDownloader sharedImageDownloader];
    [downloader startWithUrl:url delegate:self];
}

#pragma mark -
#pragma mark - AsyncImageDownloader Delegate
- (void)imageDownloader:(AsyncImageDownloader *)downloader didFinishWithImage:(UIImage *)image forUrl:(NSString *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundImage:image forState:UIControlStateNormal];
        if ([url hasSuffix:@".gif"]) {
            [self setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    });
}

@end
