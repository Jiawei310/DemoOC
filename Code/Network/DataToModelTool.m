//
//  DataToModelTool.m
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "DataToModelTool.h"
#import "YYModel.h"

#import "ResponseObjectModel.h"

@implementation DataToModelTool
+ (instancetype)sharedManager {
    static DataToModelTool *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)dataToModel:(id)responseObjectData DataType:(DataType)type {
    if (type == LOGIN_IN) {
        return [self loginInDataToModel:responseObjectData];
    }
    return nil;
}

// Convert json to model:
//User *user = [User yy_modelWithJSON:json];

// Convert model to json:
//NSDictionary *json = [user yy_modelToJSONObject];


- (id)loginInDataToModel:(id)responseObjectData {
    ResponseObjectModel *model = [ResponseObjectModel yy_modelWithJSON:responseObjectData];
    
    return model;
//    block(model);
}




@end
