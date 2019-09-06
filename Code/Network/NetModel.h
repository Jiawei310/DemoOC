//
//  NetModel.h
//  Demo
//
//  Created by ZZ on 2019/8/13.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseModel.h"
#import "DataToModelTool.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HttpType) {
    POST = 0,
    GET,
    DELETE
};



@interface NetModel : BaseModel

@property(nonatomic, copy) NSString *urlStr;
@property(nonatomic, strong) NSDictionary *parameters;
@property(nonatomic, assign) HttpType httpType;
@property(nonatomic, assign) DataType dataType;
@property(nonatomic, assign) BOOL isAnimation;

+ (NetModel *)getOneNetModel;


@end

NS_ASSUME_NONNULL_END
