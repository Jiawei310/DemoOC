//
//  BaseShowImagesViewController.h
//  Demo
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseShowImagesViewController : BaseViewController

@property (nonatomic, strong) NSArray *imgUrls;
@property (nonatomic, assign) NSInteger page;

@end

NS_ASSUME_NONNULL_END
