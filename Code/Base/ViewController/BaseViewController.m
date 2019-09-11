//
//  BaseViewController.m
//  Demo
//
//  Created by ZZ on 2019/8/16.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"


@interface BaseViewController () <MBProgressHUDDelegate>
/**加载菊花**/
@property (nonatomic,strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UIView *coverView;//遮罩
@property (nonatomic, strong) UILabel *nodataLabel;//暂无数据显示

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = VC_BACKGROUND_COLOR;
    
}

#pragma mark - network
- (void)loadNetworkData {
    
}

// 警告显示
- (void)showAlertMessage:(NSString *)msg {
    SHOWALERT(msg, self);
}

#pragma mark - Navigation set
- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.navigationItem.title = navTitle;
}

- (void)setLeftNavTitle:(NSString *)leftNavTitle {
    _leftNavTitle = leftNavTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:leftNavTitle
                                                                             style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                            action:@selector(didClickLeftNavAction)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
}

- (void)setLeftNavImageName:(NSString *)leftNavImageName
{
    _leftNavImageName = leftNavImageName;
    UIImage *image = [[UIImage imageNamed:leftNavImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(didClickLeftNavAction)];
}

- (void)setRightNavTitle:(NSString *)rightNavTitle {
    _rightNavTitle = rightNavTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightNavTitle
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didClickRightNavAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
}

- (void)setRightNavImageName:(NSString *)rightNavImageName {
    _rightNavImageName = rightNavImageName;
    UIImage *image = [[UIImage imageNamed:rightNavImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didClickRightNavAction)];
}

- (void)didClickLeftNavAction {
    
}

- (void)didClickRightNavAction {
    
}

#pragma mark - ProgressHUD
- (void)showProgressHUD {
    [self showHUDWithMode:MBProgressHUDModeIndeterminate andText:ON_LOADING];
}

- (void)hideProgressHUD {
    [self.progressHUD hideAnimated:YES];
}

- (void)showProgressHUDWithText:(NSString *)text {
    [self showHUDWithMode:MBProgressHUDModeText andText:text];
}

- (void)showHUDWithMode:(MBProgressHUDMode)mode andText:(NSString *)Text
{
    self.progressHUD.delegate = self;
    self.progressHUD.mode = mode;
    self.progressHUD.label.text = Text;
    self.progressHUD.removeFromSuperViewOnHide = NO;
    [self.progressHUD showAnimated:YES];
}

#pragma mark - nodataView

- (void)showNodataView {
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.nodataLabel];
    
    self.coverView.hidden = NO;
    self.nodataLabel.hidden = NO;
}

- (void)hideNoDataView {
    self.coverView.hidden = YES;
    self.nodataLabel.hidden = YES;
    
    [self.coverView removeFromSuperview];
    [self.nodataLabel removeFromSuperview];
}


#pragma mark - coverView
- (void)tapCoverViewAction:(UITapGestureRecognizer *)tap {
    //如果显示暂无数据，点击加载一次数据
    if (self.nodataLabel.hidden == NO) {
        [self loadNetworkData];
    }
}

#pragma mark - set and get
- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    return _progressHUD;
}

- (UIView *)coverView {
    if (!_coverView) {
//        CGFloat h = PhoneScreen_Height - SafeAreaTopHeight - SafeAreaBottomHeight;
        _coverView = [[UIView alloc] init];
        _coverView.frame = self.view.bounds;
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.3;
        _coverView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapCoverViewAction:)];
        [_coverView addGestureRecognizer:tapG];
    }
    return _coverView;
}

- (UILabel *)nodataLabel {
    if (!_nodataLabel) {
        _nodataLabel = [[UILabel alloc] init];
        _nodataLabel.frame = CGRectMake(0, 200, PhoneScreen_Width, 44);
        _nodataLabel.text = @"暂无数据";
    }
    return _nodataLabel;
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
