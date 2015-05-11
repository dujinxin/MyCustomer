//
//  MMLocationManager.m
//  MMLocationManager
//
//  Created by Chen Yaoqiang on 13-12-24.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "MMLocationManager.h"

@interface MMLocationManager ()

@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation MMLocationManager

+ (MMLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        
        _mapView = [[BMKMapView alloc]init];
//        // 定位server
//        _locService = [[BMKLocationService alloc]init];
//        _locService.delegate = self;
//2015-01-15,不建议在此实例，arc下，有可能被提前release，导致反检索失败，已经移到其他位置
//        // 反地理编码
//        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//        _geocodesearch.delegate = self;
    }
    return self;
}

// 获取城市信息
- (void) getCity:(NSStringBlock)cityBlock WithLocationError:(LocationErrorBlock)errorBlock
{
    
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}


-(void)startLocation
{
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.delegate = self;
    // 定位server
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}

-(void)stopLocation
{
    if (_mapView) {
        _mapView = nil;
    }
    [_locService stopUserLocationService];
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    NSLog(@"willStartLocatingUser");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser{
    NSLog(@"didStopLocatingUser");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"didFailToLocateUserWithError:%@",error.description);
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self stopLocation];

    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    

    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (userLocation.location.coordinate.latitude && userLocation.location.coordinate.longitude) {
        pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    }
    // 反地理编码
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = NO;
    if ([_geocodesearch respondsToSelector:@selector(reverseGeoCode:)]) {
        flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    }
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    NSString *errorString;
    [self stopLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 1001;
    [alert show];
}

// 反向地理编码 － 根据经纬度 －》城市名称和城市id
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
	if (error == 0) {
        if (result.addressDetail.city) {
  
            BMKOfflineMap *_offlineMap = [[BMKOfflineMap alloc]init];

            NSArray* city = [_offlineMap searchCity:result.addressDetail.city];
            if (city.count > 0) {
                BMKOLSearchRecord* oneCity = [city objectAtIndex:0];
                NSString *cityId =  [NSString stringWithFormat:@"%d", oneCity.cityID];
     
                    if (cityId.length > 0)
                    {
                        _cityBlock(result.addressDetail.city,cityId);
                    }
            }
        }else{
            _errorBlock(nil);
        }
	}
}



@end
