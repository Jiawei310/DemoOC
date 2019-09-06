//
//  DemoMapNaviUIDIYViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/29.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapNaviUIDIYViewController.h"
#import "MapManager.h"

@interface DemoMapNaviUIDIYViewController () <AMapNaviDriveViewDelegate, AMapNaviDriveManagerDelegate>

@property (nonatomic, strong) MapManager *mapManager;

@end

@implementation DemoMapNaviUIDIYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapManager.driveView];
    [self startNaviCar];
}

- (void)startNaviCar {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    [self.mapManager.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                           endPoints:@[endPoint]
                                                           wayPoints:nil
                                                     drivingStrategy:17];
}

- (void)polylineMethodOne {
    [self.mapManager.driveView setNormalTexture:[UIImage imageNamed:@"logo"]];
}

- (void)showModeAction:(UISegmentedControl *)sender
{
    //改变界面的显示模式
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            [self.mapManager.driveView setShowMode:AMapNaviDriveViewShowModeCarPositionLocked];//锁车状态
            break;
        case 1:
            [self.mapManager.driveView setShowMode:AMapNaviDriveViewShowModeOverview];//全览状态
            break;
        case 2:
            [self.mapManager.driveView setShowMode:AMapNaviDriveViewShowModeNormal];//普通状态
            break;
        default:
            break;
    }
}

- (void)trafficLayerAction
{
    //是否显示实时交通路况
    [self.mapManager.driveView setShowTrafficLayer:!self.mapManager.driveView.showTrafficLayer];
    
}
- (void)zoomInAction
{
    //改变地图的zoomLevel，会进入非锁车状态
    self.mapManager.driveView.mapZoomLevel = self.mapManager.driveView.mapZoomLevel+1;
}

- (void)zoomOutAction
{
    //改变地图的zoomLevel，会进入非锁车状态
    self.mapManager.driveView.mapZoomLevel = self.mapManager.driveView.mapZoomLevel-1;
}

- (void)trackingModeAction
{
    //改变地图的追踪模式
    if (self.mapManager.driveView.trackingMode == AMapNaviViewTrackingModeCarNorth)
    {
        self.mapManager.driveView.trackingMode = AMapNaviViewTrackingModeMapNorth;//地图指北
    }
    else if (self.mapManager.driveView.trackingMode == AMapNaviViewTrackingModeMapNorth)
    {
        self.mapManager.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;//车头指北
    }
}

#pragma mark - AMapNaviDriveViewDelegate
//- (void)driveManager:(AMapNaviDriveManager *)driveManager showCrossImage:(UIImage *)crossImage
//{
//    NSLog(@"showCrossImage");
//
//    //显示路口放大图
////    [self.crossImageView setImage:crossImage];
//}
//
//- (void)driveManagerHideCrossImage:(AMapNaviDriveManager *)driveManager
//{
//    NSLog(@"hideCrossImage");
//
//    //隐藏路口放大图
////    [self.crossImageView setImage:nil];
//}

- (id)driveView:(AMapNaviDriveView *)driveView needUpdatePolylineOptionForRoute:(AMapNaviRoute *)naviRoute {
//    //自定义普通路线Polyline的样式
//    AMapNaviRoutePolylineOption *polylineOption = [[AMapNaviRoutePolylineOption alloc] init];
//    polylineOption.lineWidth = 8;
//    polylineOption.drawStyleIndexes = [NSArray arrayWithArray:naviRoute.wayPointCoordIndexes];
//    polylineOption.replaceTrafficPolyline = NO;
//
//    //可以使用颜色填充,也可以使用纹理图片(当同时设置时,strokeColors设置将被忽略)
//    polylineOption.strokeColors = @[[UIColor purpleColor], [UIColor brownColor], [UIColor orangeColor]];
//    //polylineOption.textureImages = @[[UIImage imageNamed:@"arrowTexture2"], [UIImage imageNamed:@"arrowTexture3"], [UIImage imageNamed:@"arrowTexture4"]];
//
//    return polylineOption;
    return nil;
}

#pragma mark - AMapNaviDriveManagerDelegate
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    [self.mapManager.driveManager startEmulatorNavi];
    
}



#pragma mark - set and get
- (MapManager *)mapManager {
    if (!_mapManager) {
        _mapManager = [[MapManager alloc] init];
        _mapManager.driveView.frame = self.view.bounds;
        _mapManager.driveView.delegate = self;
        //将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
        _mapManager.driveView.showUIElements = NO;
        //关闭路况显示，以展示自定义Polyline的样式
        _mapManager.driveView.showTrafficLayer = YES;
        
        _mapManager.driveView.lineWidth = 8;
        
        _mapManager.driveManager.delegate = self;
        [_mapManager.driveManager addDataRepresentative:_mapManager.driveView];
        [_mapManager.driveView setShowMode:AMapNaviDriveViewShowModeOverview];//全览状态

        //设置自定义的Car图标和CarCompass图标
        [_mapManager.driveView setCarImage:[UIImage imageNamed:@"logo"]];
        [_mapManager.driveView setCarCompassImage:[UIImage imageNamed:@"logo"]];
        
        [_mapManager.driveView setStatusTextures:@{@(AMapNaviRouteStatusUnknow): [UIImage imageNamed:@"logo"],
                                                   @(AMapNaviRouteStatusSmooth): [UIImage imageNamed:@"logo"],
                                                   @(AMapNaviRouteStatusSlow): [UIImage imageNamed:@"logo"],
                                                   @(AMapNaviRouteStatusJam): [UIImage imageNamed:@"logo"],
                                                   @(AMapNaviRouteStatusSeriousJam): [UIImage imageNamed:@"logo"],}];
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
