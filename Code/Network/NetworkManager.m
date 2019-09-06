//
//  NetworkManager.m
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>
#import "DataToModelTool.h"

static AFNetworkReachabilityStatus netWorkState = 0;//网络状态

@interface NetworkManager() {
    
}
//@property(nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) DataToModelTool *dataToModelManager;

@end


@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - 检测网路状态
+ (void)networkReachabilityStartMonitoring {
    [[AFNetworkReachabilityManager manager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability:%@", AFStringFromNetworkReachabilityStatus(status));
        netWorkState = status;
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 属性finishBlock
- (void)requestData  {
    if (self.model.isAnimation) {
        
    }
    if (self.model.httpType == POST) {
        [self postRequestData:nil];
    }
    else if (self.model.httpType == GET) {
        [self getRequestData:nil];
    }
}


#pragma mark - 函数finishBlock
- (void)requestData:(void (^)(id dataModel))finishBlock  {
    if (self.model.isAnimation) {
        
    }
    if (self.model.httpType == POST) {
        [self postRequestData:finishBlock];
    }
    else if (self.model.httpType == GET) {
        [self getRequestData:finishBlock];
    }
}

// POST Request Data
- (void)postRequestData:(void (^)(id dataModel))finishBlock {
    //    NSURLSessionDataTask * task
    [self.sessionManager POST:self.model.urlStr
                   parameters:self.model.parameters
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                         //Progress Code
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //Success Code
                          [self dataToModel:responseObject finish:finishBlock];
                     }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         //Failure Code
                          NSLog(@"failure");
                          [self failureData];
                     }
     ];
}

// GET Request Data 
- (void)getRequestData:(void (^)(id dataModel))finishBlock {
    [self.sessionManager GET:self.model.urlStr
                  parameters:self.model.parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                        //Progress Code
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //Success Code
                         [self dataToModel:responseObject finish:finishBlock];
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         //Fialure Code
                         [self failureData];
                     }
     ];
}

// Upload Task
- (void)uploadFile {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

#pragma mark - 数据处理
- (void)dataToModel:(id)responseObjectData finish:(void (^)(id dataModel))finishBlock {
    id model = [self.dataToModelManager dataToModel:responseObjectData DataType:self.model.dataType];
    if (finishBlock) {
        finishBlock(model);
    }
    else if (self.finishBlock){
        self.finishBlock(model);
    }
}

- (void)failureData {
    if (netWorkState == 0) {
        //没有网络
    } else {
        //网络请求失败
    }
}

#pragma mark set and get
//- (AFNetworkReachabilityManager *)reachabilityManager {
//    if (!_reachabilityManager) {
//        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
//    }
//    return _reachabilityManager;
//}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        //缓存策略
        _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        //时间限制
        [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sessionManager.requestSerializer.timeoutInterval = 30;
        [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
    }
    return _sessionManager;
}

- (DataToModelTool *)dataToModelManager {
    if (!_dataToModelManager) {
        _dataToModelManager = [DataToModelTool sharedManager];
    }
    return _dataToModelManager;
}

@end
