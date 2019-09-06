//
//  ViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "ViewController.h"

#import "NetworkManager.h"

#import "DemoMapViewController.h"
#import "DemoMapSearchViewController.h"
#import "DemoMapLocationViewController.h"
#import "DemoGeoFenceViewController.h"
#import "DemoMapNaviViewController.h"
#import "DemoMapCompositeViewController.h"
#import "DemoMapNaviCarViewController.h"
#import "DemoMapNaviUIDIYViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_titleArr;
}
    
@property (weak, nonatomic) IBOutlet UITableView *tableView;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Demo";
    
}

- (void)loadData {
    NetModel *model = [NetModel getOneNetModel];
    model.urlStr = @"http://test.zhongzhonghuanbao.com/index.php/api/v1/5d1186fb76046";
    model.httpType = POST;
    model.dataType = LOGIN_IN;
    model.parameters = @{};//@{@"mobile":@"13062659772",@"password":@"1234567"};
    
    NetworkManager *networkManager = [NetworkManager sharedManager];
    networkManager.model = model;
    
    //第一种方式
//        networkManager.finishBlock = ^(id dataModel) {
//            NSLog(@"%@",dataModel);
//        };
//        [networkManager requestData];
    
    //第二种方式
    [networkManager requestData:^(id  _Nonnull dataModel) {
        NSLog(@"%@",dataModel);
    }];
}

- (void)toMapView {
    DemoMapViewController *mapVC = [[DemoMapViewController alloc] init];
//    [self.navigationController pushViewController:mapVC animated:YES];
    [self presentViewController:mapVC animated:YES completion:nil];
}

- (void)toMapSearchView {
    DemoMapSearchViewController *mapSearchVC = [[DemoMapSearchViewController alloc] init];
    [self presentViewController:mapSearchVC animated:YES completion:nil];
}

- (void)toMapLocationVC {
    DemoMapLocationViewController *mapLocationVC = [[DemoMapLocationViewController alloc] init];
    [self presentViewController:mapLocationVC animated:YES completion:nil];
}

- (void)toGeoFenceVC {
    DemoGeoFenceViewController *mapGeoFenceVC = [[DemoGeoFenceViewController alloc] init];
    [self presentViewController:mapGeoFenceVC animated:YES completion:nil];
}

- (void)toNaviVC {
    DemoMapNaviViewController *mapNaviVC = [[DemoMapNaviViewController alloc] init];
    [self presentViewController:mapNaviVC animated:YES completion:nil];
}

- (void)toCompositeVC {
    DemoMapCompositeViewController *compositeVC = [[DemoMapCompositeViewController alloc] init];
    [self presentViewController:compositeVC animated:YES completion:nil];
}

- (void)toNaviCarVC {
    DemoMapNaviCarViewController *naviCarVC = [[DemoMapNaviCarViewController alloc] init];
    [self presentViewController:naviCarVC animated:YES completion:nil];
}

- (void)toNaviUIDIYVC {
    DemoMapNaviUIDIYViewController *naviUIDIYVC = [[DemoMapNaviUIDIYViewController alloc] init];
    [self presentViewController:naviUIDIYVC animated:YES completion:nil];
}

#pragma mark tableView
    
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellID = @"DemoCellID";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}
    
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self loadData];
    }
    else if (indexPath.row == 1) {
        [self toMapView];
    }
    else if (indexPath.row == 2) {
        [self toMapSearchView];
    }
    else if (indexPath.row == 3) {
        [self toMapLocationVC];
    }
    else if (indexPath.row == 4) {
        [self toGeoFenceVC];
    }
    else if (indexPath.row == 5) {
        [self toNaviVC];
    }
    else if (indexPath.row == 6) {
        [self toCompositeVC];
    }
    else if (indexPath.row == 7) {
        [self toNaviCarVC];
    }
    else if (indexPath.row == 8) {
        [self toNaviUIDIYVC];
    }
}

#pragma set and get
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"NetLoad",@"Map", @"MapSearchAPI", @"MapLocation", @"MapGeoFence", @"MapNavi", @"MapComposite", @"MapNaviCar", @"MapNaviUIDIY"];
    }
    return _titleArr;
}
    
@end
