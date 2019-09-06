//
//  ResponseObjectModel.m
//  Demo
//
//  Created by ZZ on 2019/8/14.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "ResponseObjectModel.h"

@implementation ResponseObjectModel

//Match model property to different JSON key
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"n",
             @"page" : @"p",
             @"desc" : @"ext.desc",
             @"orderID" : @[@"id",@"ID",@"book_id"]};
}

@end
