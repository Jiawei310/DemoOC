//
//  NetworkManager.h
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseModel.h"
#import "NetModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishBlock)(id);

@interface NetworkManager : BaseModel
//httptype parameters url
@property(nonatomic, strong) NetModel *model;
@property(nonatomic, copy) FinishBlock finishBlock;

+ (instancetype)sharedManager;
+ (void)networkReachabilityStartMonitoring;

- (void)requestData;
- (void)requestData:(void (^)(id dataModel))block;

@end

NS_ASSUME_NONNULL_END
