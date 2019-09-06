//
//  NetModel.m
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "NetModel.h"

@implementation NetModel
+ (NetModel *)getOneNetModel {
    return [[NetModel alloc] init];
}


#pragma mark set and get
- (NSString *)urlStr {
    
    return _urlStr;
}

@end
