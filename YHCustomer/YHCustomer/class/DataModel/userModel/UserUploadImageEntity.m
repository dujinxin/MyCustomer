//
//  UserUploadImageEntity.m
//  YHCustomer
//
//  Created by 白利伟 on 15/1/6.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "UserUploadImageEntity.h"

@implementation UserUploadImageEntity
@synthesize image_id,image_url;
@end

@implementation UserUploadImageTrans

-(void)request:(NSString *)request andDic:(NSDictionary *)dic
{
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)]) {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"请检查网络连接！"];
        }
        return;
    }
    NSError *error = nil;
    NSMutableURLRequest *requestSerializer = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:request parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL * fileURL = [[NSURL alloc] initFileURLWithPath:self._filePath];
        [formData appendPartWithFileURL:fileURL name:@"image" fileName:@"userImage.jpg" mimeType:@"image/jpeg" error:nil];
    } error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestSerializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *base64String = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (!base64String)
        {
            [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:@"数据上传错误，请重新上传！"];
            return ;
        }
        id jsonObject = [NSJSONSerialization JSONObjectWithData:[base64String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject)
        {
            if (_uinet && [_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
            {
                NSString *status = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"status"]];
                NSString * message = [jsonObject objectForKey:@"message"];
                
                if ([status isEqualToString:@"0"])
                {
                    [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:message];
                    return;
                }
                else if ([status isEqualToString:@"1"])
                {
                    NSDictionary* dataDic = [jsonObject objectForKey:@"data"];
                    if (!dataDic || (dataDic == nil))
                    {
                        //                        [[NetTrans getInstance] cancelRequest:self];
                        [_uinet requestFailed:self._nApiTag withStatus:@"0" withMessage:@"网络请求错误"];
                        return ;
                    }
                    else
                    {
                        UserUploadImageEntity *useren = [[UserUploadImageEntity alloc] init];
                        if ([dataDic objectForKey:@"image_url"])
                        {
                            useren.image_url = [dataDic objectForKey:@"image_url"];
                        }
                        if ([dataDic objectForKey:@"image_id"])
                        {
                            useren.image_id = [dataDic objectForKey:@"image_id"];
                        }
                        [_uinet responseSuccessObj:useren nTag:self._nApiTag];
                        return;
                    }
                }
                else if ([status isEqualToString:WEB_STATUS_3])
                {
                    [_uinet requestFailed:_nApiTag withStatus:WEB_STATUS_3 withMessage:message];
                    return;
                }
                else
                {
                    [_uinet requestFailed:_nApiTag withStatus:status withMessage:message];
                    return;
                }
            }
        }
        else
        {
           [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_uinet && [_uinet respondsToSelector:@selector(requestFailed:withStatus:withMessage:)])
        {
            //            [_delegate torNetwork:self didFailLoadWithError:error];
           [_uinet requestFailed:_nApiTag withStatus:@"0" withMessage:[PublicMethod changeStr:error.localizedDescription]];        }
    }];
    [operation start];
}
/*
-(BOOL) responseSuccess:(ASIHTTPRequest *)request{
    if(![super responseSuccess:request])
    {
        return NO;
    }
    NSData * myResponseData = [request responseData];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingUTF8);//kCFStringEncodingUTF8
    NSString * myResponseStr = [[[NSString alloc] initWithData:myResponseData encoding:enc] autorelease];
    NSDictionary  *jsonDic = [myResponseStr objectFromJSONString];
    //返回结果是以Dictionary存在
    NSDictionary* dataDic = [jsonDic objectForKey:@"data"];
    
    // 数据处理
    NSString *status = [NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"status"]];
    if([dataDic count] == 0)
    {
        if ([status isEqualToString:WEB_STATUS_3])
        {
            [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"没有数据。"];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
        else
        {
            [_uinet requestFailed:self._nApiTag withStatus:@"999" withMessage:@"没有数据。"];
            [[NetTrans getInstance]cancelRequest:self];
            return YES;
        }
    }
    
    UserUploadImageEntity *useren = [[UserUploadImageEntity alloc] init];
    if([status isEqualToString:@"1"] )
    {
        if ([dataDic objectForKey:@"image_url"]) {
            useren.image_url = [dataDic objectForKey:@"image_url"];
        }
        if ([dataDic objectForKey:@"image_id"]) {
            useren.image_id = [dataDic objectForKey:@"image_id"];
        }
    }
    else if ([status isEqualToString:WEB_STATUS_3])
    {
        [_uinet requestFailed:self._nApiTag withStatus:WEB_STATUS_3 withMessage:@"没有数据。"];
        [[NetTrans getInstance]cancelRequest:self];
        return YES;
    }
 
    if ([_uinet respondsToSelector:@selector(responseSuccessObj:nTag:)])
    {
        [_uinet responseSuccessObj:useren nTag:self._nApiTag];
    }
    
    [useren release];
    [[NetTrans getInstance]cancelRequest:self];
    return YES;
}  */
@end
