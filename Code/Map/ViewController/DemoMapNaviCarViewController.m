//
//  DemoMapNaviCarViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/28.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapNaviCarViewController.h"
#import "MapManager.h"

@interface DemoMapNaviCarViewController () <MAMapViewDelegate, AMapNaviDriveManagerDelegate, AMapNaviWalkManagerDelegate, AMapNaviRideManagerDelegate>
@property (nonatomic, strong) MapManager *mapManager;
@end

@implementation DemoMapNaviCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mapManager.mapView];
//    [self startNaviCar];
//    [self startNaviVehicle];
//    [self startWalk];
    [self startRide];
}

- (void)startNaviCar {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    [self.mapManager.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                           endPoints:@[endPoint]
                                                           wayPoints:nil
                                                     drivingStrategy:17];
}

- (void)startNaviVehicle {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    //设置车辆信息
    AMapNaviVehicleInfo *info = [[AMapNaviVehicleInfo alloc] init];
    info.vehicleId = @"京N66Y66"; //设置车牌号
    info.type = 1;              //设置车辆类型,0:小车; 1:货车. 默认0(小车).
    info.size = 4;              //设置货车的类型(大小)
    info.width = 3;             //设置货车的宽度,范围:(0,5],单位：米
    info.height = 3.9;          //设置货车的高度,范围:(0,10],单位：米
    info.length = 15;           //设置货车的长度,范围:(0,25],单位：米
    info.weight = 50;           //设置货车的总重量,范围:(0,100]
    info.load = 45;             //设置货车的核定载重,范围:(0,100],核定载重应小于总重
    info.axisNums = 6;          //设置货车的轴数（用来计算过路费及限重）
    [[AMapNaviDriveManager sharedInstance] setVehicleInfo:info];
    
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[startPoint]
                                                                    endPoints:@[endPoint]
                                                                    wayPoints:nil
                                                              drivingStrategy:17];
}

- (void)startWalk {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    [self.mapManager.walkManager calculateWalkRouteWithStartPoints:@[startPoint]
                                              endPoints:@[endPoint]];
}

- (void)startRide {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    [self.mapManager.rideManager calculateRideRouteWithStartPoint:startPoint endPoint:endPoint];
}

#pragma mark = AMapNaviDriveManagerDelegate
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //显示路径或开启导航
//    1）通过 AMapNaviDriveManager 的 naviRoutes 获取规划路线的列表，线路详细信息请参考 AMapNaviRoute 类。
//
//    2）若进行线路展示，可通过 AMapNaviRoute 的 routeCoordinates 属性，可获取导航路线的所有形状点，然后通过在 MAMapView 上绘制线进行线路展示。
//
//    3）若想开启导航，请参考在地图上导航。
    
    //货车
    //禁行信息if (driveManager.naviRoute.forbiddenInfo.count) {
//    for (AMapNaviRouteForbiddenInfo *info in driveManager.naviRoute.forbiddenInfo) {
//        NSLog(@"禁行信息：类型：%ld，车型：%@，道路名：%@，禁行时间段：%@，经纬度：%@",(long)info.type,info.vehicleType,info.roadName,info.timeDescription,info.coordinate);
//    }
//    //限行设施
//    if (driveManager.naviRoute.roadFacilityInfo.count) {
//        for (AMapNaviRoadFacilityInfo *info in driveManager.naviRoute.roadFacilityInfo) {
//            if (info.type == AMapNaviRoadFacilityTypeTruckHeightLimit || info.type == AMapNaviRoadFacilityTypeTruckWidthLimit || info.type == AMapNaviRoadFacilityTypeTruckWeightLimit) {
//                NSLog(@"限行信息：类型：%ld，道路名：%@，经纬度：%@",(long)info.type,info.roadName,info.coordinate);
//            }
//        }
//    }
    
}

#pragma mark - AMapNaviWalkManagerDelegate
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //显示路径或开启导航
}

#pragma mark - AMapNaviRideManagerDelegate
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    NSLog(@"onCalculateRouteSuccess");
    [self.mapManager.rideManager startEmulatorNavi];
}

#pragma mark set and get

- (MapManager *)mapManager {
    if (!_mapManager) {
        _mapManager = [[MapManager alloc] init];
        _mapManager.mapView.frame = self.view.bounds;
        _mapManager.mapView.delegate = self;
        
        _mapManager.driveManager.delegate = self;
        
//        _mapManager.walkManager.delegate = self;
        _mapManager.rideManager.delegate = self;
    }
    return _mapManager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
