//
//  BaseTableViewController.m
//  Demo
//
//  Created by ZZ on 2019/9/5.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefresh.h"

@interface BaseTableViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    
    // 加载设置
    NSInteger _page;
    NSInteger _pageSize;
    NSInteger _totalPage;
    NSInteger _totalCount;
}
//上下 刷新 判断
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isOnlyHeaderRefresh;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *models;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
}

- (void)prepareData {
    self.models = [NSArray array];
    _page = 1;
    _totalPage = 1;
}

- (void)loadNetworkData {
    [super loadNetworkData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}

#pragma mark - config Refresh
- (void)configRefresh {
    if (self.isRefresh || self.isOnlyHeaderRefresh) {
        MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshData)];
        self.tableView.mj_header = headerRefresh;
    }
    if (self.isRefresh) {
        MJRefreshAutoNormalFooter *footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshData)];
        self.tableView.mj_footer = footerRefresh;
    }
}

- (void)headerRefreshData {
    _page = 1;
    [self loadNetworkData];
}

- (void)footerRefreshData {
    _page ++;
    if (_page > _totalPage) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [self loadNetworkData];
    }
}

/// 结束上下拉刷新
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -  UITableViewDelegate  UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark - set and get
- (void)setIsRefresh:(BOOL)isRefresh {
    _isRefresh = isRefresh;
    [self configRefresh];
}

- (void)setIsOnlyHeaderRefresh:(BOOL)isOnlyHeaderRefresh {
    _isOnlyHeaderRefresh = isOnlyHeaderRefresh;
    [self configRefresh];
}

- (void)setModels:(NSArray *)models {
    self.models = models;
    [self.tableView reloadData];
    if ((models.count % _pageSize) != 0 || models.count == _totalCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, PhoneScreen_Width, PhoneScreen_Height - SafeAreaTopHeight - SafeAreaBottomHeight);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = VC_BACKGROUND_COLOR;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
