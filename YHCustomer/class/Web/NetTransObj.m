//
//  NetTransObj.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/5.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "NetTransObj.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkReachabilityManager.h"


@implementation NetTransObj
@synthesize _nApiTag , _uinet ;
@synthesize _postRequst;
@synthesize _postDic;
@synthesize block_New;
@synthesize _filePath;


-(id)init:(id<UINetTransDelegate>)ui nApiTag:(int)nApiTag
{
    self._uinet = ui;
    self._nApiTag = nApiTag;
    self._postRequst = nil;
    self._postDic = nil;
    self._filePath = nil;
    return self;
}
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

-(id)testErroArray:(id)text
{
    if(text == [NSNull null])
    {
        return nil;
    }
    if(![text isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    return text;
}
-(NSString*)testErroStr:(id)text
{
    if([text isKindOfClass:[NSArray class]])
    {
        return @"";
    }
    if(text == nil)
        return @"";
    if(![text isKindOfClass:[NSString class]])
    {
        return text;
    }
    
    
    if(text == [NSNull null])
    {
        return @"";
    }
    
    if([text isEqualToString:@"<null>"])
    {
        return @"";
    }
    return text;
}
- (void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        block_New(@"0");

    }
    NSError *error = nil;
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *serializedRequest = [requestSerializer requestWithMethod:@"POST" URLString:request parameters:dic error:&error];
    
    if (error != nil)
    {
        block_New(@"0");
    }
    
    [serializedRequest setTimeoutInterval:OUTTIME];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:serializedRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *base64String = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         
         if (!base64String)
         {
             block_New(@"0");
         }
         NSError *error = nil;
         id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
         
         if (!error && jsonObject)
         {
             block_New(@"1");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         block_New(@"0");
     }];
    [operation start];
}

@end
