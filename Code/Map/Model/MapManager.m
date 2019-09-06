//
//  MapManager.m
//  Demo
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "MapManager.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#define kTileOverlayRemoteServerTemplate @"http://cache1.arcgisonline.cn/arcgis/rest/services/ChinaCities_Community_BaseMap_ENG/BeiJing_Community_BaseMap_ENG/MapServer/tile/{z}/{y}/{x}"
#define kTileOverlayRemoteMinZ      4
#define kTileOverlayRemoteMaxZ      17

#define kTileOverlayLocalMinZ       11
#define kTileOverlayLocalMaxZ       13

@implementation MapManager

+ (void)setMapKey {
    [AMapServices sharedServices].apiKey = AMapKey;
}

+ (void)openAMapHttpsService:(BOOL)enable {
    [[AMapServices sharedServices] setEnableHTTPS:enable];
}

+ (void)deallocDriveMananger {
    [[AMapNaviDriveManager sharedInstance] stopNavi];
//    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    
    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
}

- (MATileOverlay *)constructTileOverlayWithType:(NSInteger)type
{
    MATileOverlay *tileOverlay = nil;
    if (type == 0)
    {
//        tileOverlay = [[LocalTileOverlay alloc] init];
        tileOverlay.minimumZ = kTileOverlayLocalMinZ;
        tileOverlay.maximumZ = kTileOverlayLocalMaxZ;
    }
    else // type == 1
    {
        tileOverlay = [[MATileOverlay alloc] initWithURLTemplate:kTileOverlayRemoteServerTemplate];
        
        /* minimumZ 是tileOverlay的可见最小Zoom值. */
        tileOverlay.minimumZ = kTileOverlayRemoteMinZ;
        /* minimumZ 是tileOverlay的可见最大Zoom值. */
        tileOverlay.maximumZ = kTileOverlayRemoteMaxZ;
        
        /* boundingMapRect 是用来 设定tileOverlay的可渲染区域. */
        tileOverlay.boundingMapRect = MAMapRectWorld;
    }
    
    return tileOverlay;
}


#pragma mark set and get

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
    }
    return _mapView;
}

- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
    }
    return _searchAPI;
}

// 自定义定位小蓝点
- (MAUserLocationRepresentation *)locationPoint {
    if (!_locationPoint) {
        _locationPoint = [[MAUserLocationRepresentation alloc] init];
        // 精度圈是否显示
        _locationPoint.showsAccuracyRing = NO;
        // 是否显示方向指示
        _locationPoint.showsHeadingIndicator = NO;
        // 精度圈 填充颜色
        _locationPoint.fillColor = [UIColor redColor];
        // 精度圈 边线颜色
        _locationPoint.strokeColor = [UIColor blueColor];
        // 精度圈 边线宽度
        _locationPoint.lineWidth = 2;
        // 内部蓝色圆点是否使用律动效果
        _locationPoint.enablePulseAnnimation = NO;
        // 定位点背景色，不设置默认白色
        _locationPoint.locationDotBgColor = [UIColor greenColor];
        // 定位点蓝色圆点颜色，不设置默认蓝色
        _locationPoint.locationDotFillColor = [UIColor grayColor];
        // 定位图标, 与蓝色原点互斥
//        _locationPoint.image = [UIImage imageNamed:@"你的图片"];

    }
    return _locationPoint;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    return _locationManager;
}

- (AMapGeoFenceManager *)geoFenceManager {
    if (!_geoFenceManager) {
        _geoFenceManager = [[AMapGeoFenceManager alloc] init];
    }
    return _geoFenceManager;
}

- (AMapNaviDriveManager *)driveManager {
    if (!_driveManager) {
        _driveManager = [AMapNaviDriveManager sharedInstance];
        _driveManager.detectedMode = AMapNaviDetectedModeSpecialRoad;
        _driveManager.allowsBackgroundLocationUpdates = YES;
        _driveManager.pausesLocationUpdatesAutomatically = NO;
    }
    return _driveManager;
}

- (AMapNaviDriveView *)driveView {
    if (!_driveView) {
        _driveView = [[AMapNaviDriveView alloc] init];
        _driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _driveView;
}

- (AMapNaviHUDView *)hudView {
    if (!_hudView) {
        _hudView = [[AMapNaviHUDView alloc] init];
        _hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _hudView.isMirror = NO;
    }
    return _hudView;
}

- (AMapNaviCompositeManager *)compositeManager {
    if (!_compositeManager) {
        _compositeManager = [[AMapNaviCompositeManager alloc] init];
    }
    return _compositeManager;
}

- (AMapNaviWalkManager *)walkManager {
    if (!_walkManager) {
        _walkManager = [[AMapNaviWalkManager alloc] init];
    }
    return _walkManager;
}

- (AMapNaviWalkView *)walkView {
    if (!_walkView) {
        _walkView = [[AMapNaviWalkView alloc] init];
    }
    return _walkView;
}

- (AMapNaviRideManager *)rideManager {
    if (!_rideManager) {
        _rideManager = [[AMapNaviRideManager alloc] init];
    }
    return _rideManager;
}

- (AMapNaviRideView *)rideView {
    if (!_rideView) {
        _rideView = [[AMapNaviRideView alloc] init];
    }
    return _rideView;
}
@end
