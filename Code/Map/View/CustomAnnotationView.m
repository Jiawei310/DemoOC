//
//  CustomAnnotationView.m
//  Demo
//
//  Created by ZZ on 2019/8/22.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "CustomAnnotationView.h"

#define kCalloutWidth 200.0
#define kCalloutHeight 70.0

@interface CustomAnnotationView ()

@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;

@end

@implementation CustomAnnotationView
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (self.calloutView == nil) {
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0f  + self.calloutOffset.x, -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        self.calloutView.image = [UIImage imageNamed:@"logo"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        [self addSubview:self.calloutView];
    }
    else {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
