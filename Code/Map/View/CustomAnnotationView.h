//
//  CustomAnnotationView.h
//  Demo
//
//  Created by ZZ on 2019/8/22.
//  Copyright © 2019 SJW. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "CustomCalloutView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, readonly) CustomCalloutView *calloutView;

@end

NS_ASSUME_NONNULL_END
