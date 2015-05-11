//
//  UIButton+OnlineImage.h
//  Mogujia4iPad
//
//  Created by dong wu on 12-5-25.
//  Copyright (c) 2012年 Mogujie, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"

@interface UIButton (OnlineImage) <AsyncImageDownloaderDelegate>

- (void)setOnlineImage:(NSString *)url;
- (void)setOnlineImage:(NSString *)url placeholderImage:(UIImage *)image;

@end
