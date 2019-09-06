//
//  DemoGeoFenceViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/26.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoGeoFenceViewController.h"
#import "MapManager.h"

@interface DemoGeoFenceViewController () <MAMapViewDelegate, AMapGeoFenceManagerDelegate>
@property (nonatomic, strong) MapManager *mapManager;

@end

@implementation DemoGeoFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapManager.mapView];
    
    
    //设置一个目标经纬度
    CLLocationCoordinate2D coodinate = CLLocationCoordinate2DMake(39.948691, 116.492479);
    //返回是否在大陆或以外地区，返回YES为大陆地区，NO为非大陆。
    BOOL flag= AMapLocationDataAvailableForCoordinate(coodinate);
    
    //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
    self.mapManager.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed;
    self.mapManager.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
//    //创建围栏
//    //关键字创建围栏：
//    [self.mapManager.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:@"北京大学" POIType:@"高等院校" city:@"北京" size:20 customID:@"poi_1"];
//    //周边POI创建围栏：
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
//    [self.mapManager.geoFenceManager addAroundPOIRegionForMonitoringWithLocationPoint:coordinate aroundRadius:10000 keyword:@"肯德基" POIType:@"050301" size:20 customID:@"poi_2"];
    //行政区域围栏
    [self.mapManager.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"海淀区" customID:@"district_1"];
    //自定义圆形围栏
////    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
//    [self.mapManager.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:300 customID:@"circle_1"];
//    //自定义多边形围栏
//    NSInteger count = 4;
//    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * count);
//    coorArr[0] = CLLocationCoordinate2DMake(39.933921, 116.372927);     //平安里地铁站
//    coorArr[1] = CLLocationCoordinate2DMake(39.907261, 116.376532);     //西单地铁站
//    coorArr[2] = CLLocationCoordinate2DMake(39.900611, 116.418161);     //崇文门地铁站
//    coorArr[3] = CLLocationCoordinate2DMake(39.941949, 116.435497);     //东直门地铁站
//    [self.mapManager.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:count customID:@"polygon_1"];
    
//    free(coorArr);
//    coorArr = NULL;
}
//- (void)removeTheGeoFenceRegion:(AMapGeoFenceRegion *)region; //移除指定围栏
//- (void)removeGeoFenceRegionsWithCustomID:(NSString *)customID; //移除指定customID的围栏
//- (void)removeAllGeoFenceRegions;  //移除所有围栏


#pragma mark - MAMapViewDelegate
//draw line
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapGeoFenceManagerDelegate
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功");
    }
}

- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSLog(@"status changed success %@",[region description]);
        // 可以判断是否在某区域
        AMapGeoFenceDistrictRegion *districtRegion = (AMapGeoFenceDistrictRegion *)region;
        NSArray *arr = districtRegion.polylinePoints[0];
        
        CLLocationCoordinate2D commonPolylineCoords[arr.count];
        for (int i = 0; i < arr.count; i++ ) {
            AMapLocationPoint *point = arr[i];
            commonPolylineCoords[i].longitude = point.longitude;
            commonPolylineCoords[i].latitude = point.latitude;
        }
        // 构造折线对象
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:arr.count];
        [self.mapManager.mapView addOverlay:commonPolyline];
    }
}

#pragma mark - set and get
- (MapManager *)mapManager {
    if (!_mapManager) {
        _mapManager = [[MapManager alloc] init];
        _mapManager.mapView.frame = self.view.bounds;
        _mapManager.mapView.rotateCameraEnabled = NO;
        
        _mapManager.mapView.delegate = self;
        _mapManager.geoFenceManager.delegate = self;
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
