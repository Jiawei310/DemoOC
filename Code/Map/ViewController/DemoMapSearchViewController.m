//
//  DemoMapSearchViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/23.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapSearchViewController.h"
#import "MapManager.h"

@interface DemoMapSearchViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, strong) MapManager *mapManager;

@end

@implementation DemoMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mapManager.mapView];
    self.mapManager.mapView.rotateCameraEnabled = NO;

    
    self.mapManager.mapView.delegate = self;
    self.mapManager.searchAPI.delegate = self;
    
//    [self searchBJU];
//    [self searchCinema];
//    [self searchApple];
//    [self searchAddress];
//    [self searchDistrict];
//    [self searchWeather];
    [self searchTraffic];
    
}

- (void)searchBJU {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords = @"北京大学";
    request.city = @"北京";
    request.types = @"高等院校";
    request.requireExtension = YES;
    
    request.cityLimit = YES;
    request.requireSubPOIs = YES;
    
    [self.mapManager.searchAPI AMapPOIKeywordsSearch:request];
}

- (void)searchCinema {
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.keywords = @"电影院";
    request.sortrule = 0;
    request.requireExtension = YES;
    [self.mapManager.searchAPI AMapPOIAroundSearch:request];
}

- (void)searchApple {

    NSArray *points = [NSArray arrayWithObjects:
                       [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476],
                       [AMapGeoPoint locationWithLatitude:39.890459 longitude:116.581476],
                       nil];
    AMapGeoPolygon *polygon = [AMapGeoPolygon polygonWithPoints:points];
    
    AMapPOIPolygonSearchRequest *request = [[AMapPOIPolygonSearchRequest alloc] init];
    
    request.polygon             = polygon;
    request.keywords            = @"Apple";
    request.requireExtension    = YES;
    
    [self.mapManager.searchAPI AMapPOIPolygonSearch:request];
}

- (void)searchAddress {
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = @"北京市朝阳区阜荣街10号";
    [self.mapManager.searchAPI AMapGeocodeSearch:geo];
}

- (void)searchDistrict {
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = @"北京市";
    dist.requireExtension = YES;
    
    [self.mapManager.searchAPI AMapDistrictSearch:dist];

}

- (void)searchWeather {
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = @"110000";
    request.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecase为预报天气
    
    [self.mapManager.searchAPI AMapWeatherSearch:request];
}

- (void)searchTraffic {
    AMapRoadTrafficSearchRequest *req = [[AMapRoadTrafficSearchRequest alloc] init];
    req.roadName = @"酒仙桥路";
    req.adcode = @"110000";
    req.requireExtension = YES;
    [self.mapManager.searchAPI AMapRoadTrafficSearch:req];
}

#pragma makr - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
        if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
            static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
            MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            }
            annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
            annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
            annotationView.pinColor = MAPinAnnotationColorPurple;
            return annotationView;
        }
    return nil;
}

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



#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    else {
        for (AMapPOI *poi in response.pois) {
            //    绘制点标记
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            pointAnnotation.title = poi.name;
            pointAnnotation.subtitle = poi.address;
            
            [self.mapManager.mapView addAnnotation:pointAnnotation];
        }
    }
    // 解析response获取POI信息，具体解析见 
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0) {
        return;
    }
    
    for (AMapGeocode *geo in response.geocodes) {
        //    绘制点标记
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(geo.location.latitude, geo.location.longitude);
        pointAnnotation.title = geo.city;
        pointAnnotation.subtitle = geo.formattedAddress;
        
        [self.mapManager.mapView addAnnotation:pointAnnotation];
    }
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    
    if (response == nil)
    {
        return;
    }
    
//    解析response获取行政区划，具体解析见 Demo
    if (response.districts.count) {
        AMapDistrict *district = response.districts[0];
        //    绘制点标记
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(district.center.latitude, district.center.longitude);
        pointAnnotation.title = district.name;
        pointAnnotation.subtitle = district.level;
        
        [self.mapManager.mapView addAnnotation:pointAnnotation];
        
        NSString *polyline = district.polylines[0];
        NSArray *arr = [polyline componentsSeparatedByString:@";"];
        
        CLLocationCoordinate2D commonPolylineCoords[arr.count];
        for (int i = 0; i < arr.count; i++ ) {
            NSString *point = arr[i];
            NSArray *arrPoint = [point componentsSeparatedByString:@","];
            commonPolylineCoords[i].longitude = [arrPoint[0] floatValue];
            commonPolylineCoords[i].latitude = [arrPoint[1] floatValue];
        }
        // 构造折线对象
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:arr.count];
        [self.mapManager.mapView addOverlay:commonPolyline];
    }
    
}

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response {
    //解析response获取天气信息，具体解析见 Demo
    if (response.lives.count) {
        AMapLocalWeatherLive *live = response.lives[0];
        NSLog(@"city:%@,weathter:%@,wind:%@%@,temperature:%@", live.city,live.weather,live.windDirection,live.windPower,live.temperature);
    }
}

/* 道路路况查询回调. */
- (void)onRoadTrafficSearchDone:(AMapRoadTrafficSearchRequest *)request response:(AMapRoadTrafficSearchResponse *)response
{
    if (response.trafficInfo) {
        NSLog(@"trafficInfo: %@", response.trafficInfo.statusDescription);
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - set and get
- (MapManager *)mapManager {
    if (!_mapManager) {
        _mapManager = [[MapManager alloc] init];
        _mapManager.mapView.frame = self.view.bounds;
        
        _mapManager.mapView.delegate = self;
    }
    return _mapManager;
}

@end
