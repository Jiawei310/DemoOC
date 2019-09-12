//
//  BaseTabBarController.m
//  Demo
//
//  Created by ZZ on 2019/9/11.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

+ (instancetype)sharedTabBarC {
    static BaseTabBarController *_sharedTabBarC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTabBarC = [[self alloc] init];
    });
    
    return _sharedTabBarC;
}

+ (void)initialize {
    // 判断是否是该类本身,子类也返回
    if(self != [BaseTabBarController class])return;
    
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态
    NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:14];//字体
    normalDict[NSForegroundColorAttributeName] = [UIColor grayColor];//颜色
    [item setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    
    // 选中状态
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
    selectedDict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBar.translucent     = NO;
        self.tabBar.shadowImage     = [[UIImage alloc] init];
        self.tabBar.backgroundImage = [[UIImage alloc] init];
        self.viewControllers = @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
