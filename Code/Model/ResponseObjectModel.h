//
//  ResponseObjectModel.h
//  Demo
//
//  Created by ZZ on 2019/8/14.
//  Copyright © 2019 SJW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*{
 code = "-900";
 data =     (
 );
 info = "mobile\U4e0d\U80fd\U4e3a\U7a7a";
 user = "";
 }*/

@interface ResponseObjectModel : NSObject

@property(nonatomic, copy) NSString *code;
@property(nonatomic, strong) NSDictionary *data;
@property(nonatomic, copy) NSString *info;
@property(nonatomic, copy) NSString *user;

@end

NS_ASSUME_NONNULL_END
