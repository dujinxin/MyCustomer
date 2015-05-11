//
//  MMLocationManager.h
//  MMLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"


typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityName,NSString *cityId);

@interface MMLocationManager : NSObject<BMKMapViewDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService      * _locService;
    BMKMapView              * _mapView;
    BMKGeoCodeSearch        *_geocodesearch;
    
    BOOL                    isfirst;
}


+ (MMLocationManager *)shareLocation;


/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock WithLocationError:(LocationErrorBlock)errorBlock;


@end
