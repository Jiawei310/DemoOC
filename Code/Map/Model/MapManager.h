//
//  MapManager.h
//  Demo
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 SJW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface MapManager : NSObject
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
// 定位
@property (nonatomic, strong) MAUserLocationRepresentation *locationPoint;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviHUDView *hudView;

@property (nonatomic, strong) AMapNaviWalkManager *walkManager;
@property (nonatomic, strong) AMapNaviWalkView *walkView;
@property (nonatomic, strong) AMapNaviRideManager *rideManager;
@property (nonatomic, strong) AMapNaviRideView *rideView;


@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;

+ (void)setMapKey;
+ (void)openAMapHttpsService:(BOOL)enable;


    
@end

NS_ASSUME_NONNULL_END
