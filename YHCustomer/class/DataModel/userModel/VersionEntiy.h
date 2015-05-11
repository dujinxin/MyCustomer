//
//  VersionEntiy.h
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionEntiy : NSObject
{
    NSString  *_id;
    NSString  *_agent_id;
    NSString  *_is_current;
    NSString  *_url;
    NSString  *_version;
    NSString  *_version_name;
    NSString  *_version_caption;
}

@property (nonatomic, retain) NSString  *_id;
@property (nonatomic, retain) NSString  *_agent_id;
@property (nonatomic, retain) NSString  *_is_current;
@property (nonatomic, retain) NSString  *_url;
@property (nonatomic, retain) NSString  *_version;
@property (nonatomic, retain) NSString  *_version_name;
@property (nonatomic, strong) NSString *force_update;
@property (nonatomic, copy) NSString * version_caption;

@end

@interface VersionTrans : NetTransObj
{
    
}
@end
