//
//  DemoMapNaviViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/27.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapNaviViewController.h"
#import "MapManager.h"

@interface DemoMapNaviViewController () <AMapNaviDriveViewDelegate, AMapNaviDriveManagerDelegate, AMapNaviHUDViewDelegate, AMapNaviRideManagerDelegate, AMapNaviRideViewDelegate>
@property (nonatomic, strong) MapManager *mapManager;
@end

@implementation DemoMapNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:self.mapManager.driveView];
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.mapManager.hudView];
    
    [self.view addSubview:self.mapManager.rideView];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.toolbarHidden = YES;
    
//    [self startDrive];
    [self startRide];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self startDrive];
}

- (void)startDrive {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.98 longitude:116.47];
    AMapNaviPoint *endPoint   = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.45];
    
    //路径规划
    [self.mapManager.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                           endPoints:@[endPoint]
                                                           wayPoints:nil
                                                     drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

- (void)startRide {
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
//    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:31.19409196662218 longitude:121.32672776196287];

//    [self.mapManager.rideManager calculateRideRouteWithStartPoint:startPoint endPoint:endPoint];
    [self.mapManager.rideManager calculateRideRouteWithEndPoint:endPoint];
}

//- (void)multipleRoutePlan {
//    BOOL isMultipleRoutePlan = YES;
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.98 longitude:116.47];
//    AMapNaviPoint *endPoint   = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.45];
//    [self.mapManager.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
//                                                           endPoints:@[endPoint]
//                                                           wayPoints:nil
//                                                     drivingStrategy:[self.preferenceView strategyWithIsMultiple:isMultipleRoutePlan]];
//
//    //选择其中一条路线导航
//    [self.mapManager.driveManager selectNaviRouteWithRouteID:routeID]
//}


#pragma mark - AMapNaviDriveManagerDelegate
//路径规划成功后，开始模拟导航
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
//    [self.mapManager.driveManager startEmulatorNavi];
    [self.mapManager.driveManager startGPSNavi];
}
//获取巡航统计数据
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateCruiseInfo:(AMapNaviCruiseInfo *)cruiseInfo
{
    NSLog(@"updateCruiseInfo:%@", cruiseInfo);
}
//获取道路设施数据
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTrafficFacilities:(NSArray<AMapNaviTrafficFacilityInfo *> *)trafficFacilities
{
    NSLog(@"updateTrafficFacilities:%@", trafficFacilities);
}

//- (void)driveManager:(AMapNaviDriveManager *)driveManager showCrossImage:(UIImage *)crossImage
//{
//    NSLog(@"showCrossImage");
//
//    //显示路口放大图
//    [self.crossImageView setImage:crossImage];
//}
//
//- (void)driveManagerHideCrossImage:(AMapNaviDriveManager *)driveManager
//{
//    NSLog(@"hideCrossImage");
//
//    //隐藏路口放大图
//    [self.crossImageView setImage:nil];
//}



//- (void)startGPSEmulator
//{
//
//    //设置采用外部传入定位信息
//    [[AMapNaviDriveManager sharedInstance] setEnableExternalLocation:YES];
//
//    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
//
//    __weak typeof(self) weakSelf = self;
//    [self.gpsEmulator startEmulatorUsingLocationBlock:^(CLLocation *location, NSUInteger index, NSDate *addedTime, BOOL *stop) {
//
//        //注意：需要使用当前时间作为时间戳
//        CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate:location.coordinate
//                                                                altitude:location.altitude
//                                                      horizontalAccuracy:location.horizontalAccuracy
//                                                        verticalAccuracy:location.verticalAccuracy
//                                                                  course:location.course
//                                                                   speed:location.speed
//                                                               timestamp:[NSDate dateWithTimeIntervalSinceNow:0]];
//
//        //外部传入定位信息(enableExternalLocation为YES时有效)
//        [[AMapNaviDriveManager sharedInstance] setExternalLocation:newLocation isAMapCoordinate:NO];
//
//    }];
//}


#pragma mark - AMapNaviHUDViewDelegate
- (void)hudViewCloseButtonClicked:(AMapNaviHUDView *)hudView {
    [self.mapManager.driveManager stopNavi];
    [self.mapManager.driveManager removeDataRepresentative:self.mapManager.hudView];

    //停止语音
//    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.mapManager.driveView removeFromSuperview];

}


#pragma mark - AMapNaviRideManagerDelegate
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    NSLog(@"onCalculateRouteSuccess");
//    [self.mapManager.rideManager startGPSNavi];
    [self.mapManager.rideManager startEmulatorNavi];
}

#pragma mark - set and get
- (MapManager *)mapManager {
    if (!_mapManager) {
        _mapManager = [[MapManager alloc] init];
//        _mapManager.driveManager.delegate = self;
//        [_mapManager.driveManager addDataRepresentative:_mapManager.driveView];
//        _mapManager.driveView.frame = self.view.bounds;
//        _mapManager.driveView.delegate = self;
        
        //        _mapManager.hudView.frame = self.view.bounds;
        //        _mapManager.hudView.delegate = self;
        //        [_mapManager.driveManager addDataRepresentative:_mapManager.hudView];
        
        _mapManager.rideView.frame = self.view.bounds;
        _mapManager.rideView.delegate = self;
        _mapManager.rideManager.delegate = self;
        [_mapManager.rideManager addDataRepresentative:_mapManager.rideView];
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
