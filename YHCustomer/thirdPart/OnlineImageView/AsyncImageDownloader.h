//
//  AsyncImageDownloader.h
//  AImageDownloader
//
//  Created by Jason Lee on 12-3-8.
//  Copyright (c) 2012年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCacheQueue.h"

@class AsyncImageDownloader;

@protocol AsyncImageDownloaderDelegate <NSObject>

@optional
- (void)imageDownloader:(AsyncImageDownloader *)downloader didFinishWithImage:(UIImage *)image forUrl:(NSString*)url;
- (void)imageDownloader:(AsyncImageDownloader *)downloader didFailWithError:(NSError *)error;

@end

@interface AsyncImageDownloader : NSObject
{
    NSOperationQueue *asyncQueue;
    ImageCacheQueue *cacheQueue;
    
    id<AsyncImageDownloaderDelegate> _delegate;
}

@property (nonatomic, strong) id<AsyncImageDownloaderDelegate> delegate;

+ (id)sharedImageDownloader;
- (void)startWithUrl:(NSString *)url delegate:(id<AsyncImageDownloaderDelegate>)aDelegate;

@end
