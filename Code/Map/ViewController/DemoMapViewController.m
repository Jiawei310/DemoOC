//
//  DemoMapViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapViewController.h"

#import "MapManager.h"

#import "CustomAnnotationView.h"




@interface DemoMapViewController () <MAMapViewDelegate>
@property (nonatomic, strong) MapManager *mapManager;
@end

@implementation DemoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    
    
    [self.view addSubview:self.mapManager.mapView];
    
    self.mapManager.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.mapManager.mapView setMapType:MAMapTypeStandard];
    
    self.mapManager.mapView.showsUserLocation = YES;
    self.mapManager.mapView.showsIndoorMap = YES;
    self.mapManager.mapView.showTraffic = YES;
    
    self.mapManager.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds) - 55, 450);

    
    self.mapManager.mapView.showsCompass = YES;
    self.mapManager.mapView.compassOrigin = CGPointMake(self.mapManager.mapView.compassOrigin.x, 22);

    self.mapManager.mapView.showsScale = YES;
    self.mapManager.mapView.scaleOrigin = CGPointMake(self.mapManager.mapView.scaleOrigin.x, 22);
    
    //滑动手势
//    self.mapManager.mapView.scrollEnabled = NO;
    
    //缩放手势
    //    self.mapManager.mapView.zoomEnabled = NO;
    [self.mapManager.mapView setZoomLevel:17.5 animated:YES];
    
//    self.mapManager.mapView setCenterCoordinate:<#(CLLocationCoordinate2D)#> animated:<#(BOOL)#>
    
    //旋转手势
    self.mapManager.mapView.rotateEnabled = NO;
//    [self.mapManager.mapView setRotationDegree:60.0f animated:YES duration:0.5];
    
    //倾斜手势
    self.mapManager.mapView.rotateCameraEnabled = NO;
//    [self.mapManager.mapView setCameraDegree:30.0f animated:YES duration:0.5];
    
    //指定屏幕中心点的手势操作
    MAMapStatus *status = [self.mapManager.mapView getMapStatus];
    status.screenAnchor = CGPointMake(0.5, 0.76);
    [self.mapManager.mapView setMapStatus:status animated:NO];
    
    
//    绘制点标记
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [self.mapManager.mapView addAnnotation:pointAnnotation];

    // 画折线
    [self drawLine];
    
    // 画圆
    [self drawCircle];
    
    // 热力图
    [self drawHeatMap];
    
    // 自定义图层
    [self drawSelfDefine];
    
}

//绘制折线
- (void)drawLine {
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    // 构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    [self.mapManager.mapView addOverlay:commonPolyline];
}

// 绘制圆
- (void)drawCircle {
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:5000];
    [self.mapManager.mapView addOverlay:circle];
}

// 绘制热力图
- (void)drawHeatMap {
    MAHeatMapTileOverlay *heatMapTileOverlay = [[MAHeatMapTileOverlay alloc] init];
    NSMutableArray *data = [NSMutableArray array];
    
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"locations" ofType:@"json"]];
    
    @autoreleasepool {
        
        if (jsdata)
        {
            NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
            
            for (NSDictionary *dic in dicArray)
            {
                MAHeatMapNode *node = [[MAHeatMapNode alloc] init];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [dic[@"lat"] doubleValue];
                coordinate.longitude = [dic[@"lng"] doubleValue];
                node.coordinate = coordinate;
                
                node.intensity = 1;//设置权重
                [data addObject:node];
            }
        }
        heatMapTileOverlay.data = data;
        
        //构造渐变色对象
        MAHeatMapGradient *gradient = [[MAHeatMapGradient alloc] initWithColor:@[[UIColor blueColor],[UIColor greenColor], [UIColor redColor]] andWithStartPoints:@[@(0.2),@(0.5),@(0.9)]];
        heatMapTileOverlay.gradient = gradient;
        
        //将热力图添加到地图上
        [self.mapManager.mapView addOverlay: heatMapTileOverlay];
    }
}

// 绘制overlay（自定义图层）
- (void)drawSelfDefine {
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
                                                                 (39.939577, 116.388331),CLLocationCoordinate2DMake(39.935029, 116.384377));
    
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"logo"]];
    
    [self.mapManager.mapView addOverlay:groundOverlay];
    self.mapManager.mapView.visibleMapRect = groundOverlay.boundingMapRect;
}

// 绘制瓦片图层

#pragma mark - MAMapViewDelegate
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager {
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
}

- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}



- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
//        }
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
//        return annotationView;
//    }
    
    
    
    
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:reuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"logo"];
//        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
//    }
    
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"logo"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
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
    
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth = 5.f;
        circleRenderer.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleRenderer.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        return circleRenderer;
    }
    
    if ([overlay isKindOfClass:[MATileOverlay class]]) {
        MATileOverlayRenderer *tileOverlayRenderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        
        return tileOverlayRenderer;
    }
    
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayRenderer *groundOverlayRenderer = [[MAGroundOverlayRenderer alloc] initWithGroundOverlay:overlay];
        
        return groundOverlayRenderer;
    }
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *renderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    } 
    
    return nil;
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
