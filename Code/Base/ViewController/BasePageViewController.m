//
//  BasePageViewController.m
//  Demo
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BasePageViewController.h"

@interface BasePageViewController ()
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *VCArr;
@end

@implementation BasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configMenuView {
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.titleColorSelected = [UIColor greenColor];
    self.titleColorNormal = [UIColor darkGrayColor];
    
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 18;
}

#pragma mark - wmPage协议实现


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleArr[index];
}

- (CGRect )pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 20, PhoneScreen_Width, 44);
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleArr.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UIViewController *vc = [[UIViewController alloc] init];
    return vc;
}

- (CGRect )pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 44, PhoneScreen_Width, PhoneScreen_Height);
}

#pragma mark - set and get

- (void)setTitleArr:(NSArray *)titleArr {
    self.titleArr = titleArr;
    if (titleArr.count < 5) {
        self.menuItemWidth = PhoneScreen_Width/titleArr.count;
    }
    else {
        self.menuItemWidth = PhoneScreen_Width/4;
    }
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
