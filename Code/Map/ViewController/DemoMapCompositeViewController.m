//
//  DemoMapCompositeViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/27.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DemoMapCompositeViewController.h"
#import "MapManager.h"

@interface DemoMapCompositeViewController () <AMapNaviCompositeManagerDelegate>
@property (nonatomic, strong) MapManager *mapMananger;

@end

@implementation DemoMapCompositeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self compositeUserConfig];
    [self compositeUserConfig2];
//    [self startComposite];
//    [self vehicleComposite];
}

//传入终点坐标和名称，不传高德POIId示例：
- (void)compositeUserConfig {
    //导航组件配置类 since 5.2.0
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    //传入终点坐标
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:39.918058 longitude:116.397026] name:@"故宫" POIId:nil];
    //启动
    [self.mapMananger.compositeManager presentRoutePlanViewControllerWithOptions:config];
}

- (void)compositeUserConfig2 {
    //导航组件配置类 since 5.2.0
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    //传入起点，并且带高德POIId
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeStart location:[AMapNaviPoint locationWithLatitude:27.537835175427546 longitude:121.37605314843752] name:@"虹桥机场" POIId:@"B000A28DAE"];
    //传入途径点，并且带高德POIId
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeWay location:[AMapNaviPoint locationWithLatitude:31.153499735408836 longitude:121.37073164575197] name:@"中春路" POIId:@"B000A816R6"];
    //传入终点，并且带高德POIId
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:31.138146906344367 longitude:121.59826880090334] name:@"秀沿路" POIId:@"B000A8UIN8"];
    //启动
    [self.mapMananger.compositeManager presentRoutePlanViewControllerWithOptions:config];

}

- (void)startComposite {
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    //传入终点
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:39.918058 longitude:116.397026] name:@"故宫" POIId:nil];
    //直接进入导航界面
    [config setStartNaviDirectly:YES];
    [config setMultipleRouteNaviMode:YES];
    [config setNeedCalculateRouteWhenPresent:YES];
    [config setNeedDestoryDriveManagerInstanceWhenDismiss:YES];
    [config setThemeType:AMapNaviCompositeThemeTypeDark];
    
    [self.mapMananger.compositeManager presentRoutePlanViewControllerWithOptions:config];
}

- (void)vehicleComposite {
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    
    //设置车辆信息
    AMapNaviVehicleInfo *info = [[AMapNaviVehicleInfo alloc] init];
    info.vehicleId = @"京N66Y66"; //设置车牌号
    info.type = 1;              //设置车辆类型,0:小车; 1:货车. 默认0(小车).
    info.size = 4;              //设置货车的类型(大小)
    info.width = 3;             //设置货车的宽度,范围:(0,5],单位：米
    info.height = 3.9;          //设置货车的高度,范围:(0,10],单位：米
    info.length = 15;           //设置货车的长度,范围:(0,25],单位：米
    info.weight = 50;           //设置货车的总重量,范围:(0,100]
    info.load = 45;             //设置货车的核定载重,范围:(0,100],核定载重应小于总重量
    info.axisNums = 6;          //设置货车的轴数（用来计算过路费及限重）
    [config setVehicleInfo:info];
    
    [self.mapMananger.compositeManager presentRoutePlanViewControllerWithOptions:config];
}

#pragma mark - AMapNaviCompositeManagerDelegate
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *_Nonnull)compositeManager {
    NSLog(@"onCalculateRouteSuccess,%ld",(long)compositeManager.naviRouteID);

}

// 发生错误时,会调用此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 开始导航的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi,%ld",(long)naviMode);
}

// 当前位置更新回调
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager updateNaviLocation:(AMapNaviLocation *)naviLocation {
    NSLog(@"updateNaviLocation,%@",naviLocation);
}

// 导航到达目的地后的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didArrivedDestination:(AMapNaviMode)naviMode {
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
}

//在iOS9、iOS10的系统下，系统 AVSpeechSynthesizer 的语音合成接口存在内存泄漏的情况，由于SDK内部引用了 AVSpeechSynthesizer，所以也会在iOS9和iOS10上出现内存泄漏，您可以使用第三方的语音合成服务，如科大讯飞语音包来规避问题。
// SDK需要实时的获取是否正在进行导航信息播报，需要开发者根据实际播报情况返回布尔值
- (BOOL)compositeManagerIsNaviSoundPlaying:(AMapNaviCompositeManager *)compositeManager {
    return YES;
//    [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}
// 导航播报信息回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
//    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}
// 停止导航语音播报的回调函数，当导航SDK需要停止外部语音播报时，会调用此方法
- (void)compositeManagerStopPlayNaviSound:(AMapNaviCompositeManager *)compositeManager {
//    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}

#pragma mark - set and get
- (MapManager *)mapMananger {
    if (!_mapMananger) {
        _mapMananger = [[MapManager alloc] init];
        
        _mapMananger.compositeManager.delegate = self;
        [_mapMananger.compositeManager presentRoutePlanViewControllerWithOptions:nil];
    }
    return _mapMananger;
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
