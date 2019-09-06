//
//  DataToModelTool.h
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, DataType) {
    NONE,
    LOGIN_IN
};

@interface DataToModelTool : BaseModel

//@property (nonatomic, assign) DataType type;

+ (instancetype)sharedManager;

- (id)dataToModel:(id)responseObjectData DataType:(DataType)type;

@end

NS_ASSUME_NONNULL_END
