//
//  BaseViewController.h
//  Demo
//
//  Created by ZZ on 2019/8/16.
//  Copyright © 2019 SJW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

#pragma mark - navigation
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *leftNavImageName;
@property (nonatomic, copy) NSString *rightNavImageName;
@property (nonatomic, copy) NSString *leftNavTitle;
@property (nonatomic, copy) NSString *rightNavTitle;


#pragma mark - network
- (void)loadNetworkData;

@end

NS_ASSUME_NONNULL_END
