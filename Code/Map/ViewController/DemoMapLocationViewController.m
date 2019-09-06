//
//  DemoMapLocationViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/26.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapLocationViewController.h"
#import "MapManager.h"

@interface DemoMapLocationViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>
@property (nonatomic, strong) MapManager *mapManager;
@property (nonatomic, strong) NSMutableArray *regions;
@end

@implementation DemoMapLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    [self.view addSubview:self.mapManager.mapView];
    
    self.mapManager.locationManager.distanceFilter = 200;//地图围栏
    //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
    [self.mapManager.locationManager setPausesLocationUpdatesAutomatically:NO];
    //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        self.mapManager.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    //持续定位返回逆地理编码信息
    [self.mapManager.locationManager setLocatingWithReGeocode:YES];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.mapManager.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    [self.mapManager.locationManager setLocationTimeout:6];
    //   逆地理请求超时时间，最低2s，此处设置为10s
    [self.mapManager.locationManager setReGeocodeTimeout:3];
    
    //开始定位
    [self.mapManager.locationManager startUpdatingLocation];
    
    //显示定位
    self.mapManager.mapView.showsUserLocation = YES;
    //地图转移到定位位置
    self.mapManager.mapView.userTrackingMode = MAUserTrackingModeFollow;

//    [self niCode];
}


//如果需要持续定位返回逆地理编码信息
- (void)continueLocation {
    [self.mapManager.locationManager setLocatingWithReGeocode:YES];
    [self.mapManager.locationManager startUpdatingLocation];
}

- (void)stopLocation {
    [self.mapManager.locationManager stopUpdatingLocation];
}
#pragma mark 地理围栏
- (void)configLocationMananger {
    [self.mapManager.locationManager setPausesLocationUpdatesAutomatically:YES];
    [self.mapManager.locationManager setAllowsBackgroundLocationUpdates:YES];
}

#pragma mark 逆地理编码
- (void)niCode {
    [self.mapManager.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.mapManager.locationManager setLocationTimeout:6];
    [self.mapManager.locationManager setReGeocodeTimeout:3];
    
    [self locateAction];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.mapManager.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

#pragma mark - 地理围栏
- (void)addCircleReionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    int radius = 250;
    
    //创建circleRegion
    AMapLocationCircleRegion *cirRegion = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                    radius:radius
                                                                                identifier:@"circleRegion"];
    
    //添加地理围栏
    [self.mapManager.locationManager startMonitoringForRegion:cirRegion];
    
    //保存地理围栏
    [self.regions addObject:cirRegion];
    
    //添加Overlay
    MACircle *circle = [MACircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.mapManager.mapView addOverlay:circle];
    [self.mapManager.mapView setVisibleMapRect:circle.boundingMapRect];
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);

}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    [self addCircleReionForCoordinate:location.coordinate];
}


- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region
{
    NSLog(@"开始监听地理围栏:%@", region);
}

- (void)amapLocationManager:(AMapLocationManager *)manager monitoringDidFailForRegion:(AMapLocationRegion *)region withError:(NSError *)error
{
    NSLog(@"监听地理围栏失败:%@", error.localizedDescription);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
    NSLog(@"进入地理围栏:%@", region);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region
{
    NSLog(@"退出地理围栏:%@", region);
}


#pragma mark - set and get
- (MapManager *)mapManager {
    if (!_mapManager) {
        _mapManager = [[MapManager alloc] init];
        _mapManager.mapView.frame = self.view.bounds;
        _mapManager.mapView.rotateCameraEnabled = NO;

        _mapManager.mapView.delegate = self;
        
        _mapManager.locationManager.delegate = self;

    }
    return _mapManager;
}

- (NSMutableArray *)regions {
    if (!_regions) {
        _regions = [NSMutableArray array];
    }
    return _regions;
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
