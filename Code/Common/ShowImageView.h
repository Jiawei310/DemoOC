//
//  ShowImageView.h
//  Demo
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 SJW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef  void(^didRemoveImage)(void);

@interface ShowImageView : UIView <UIScrollViewDelegate> {
    UIImageView *showImage;
}

@property (nonatomic,copy) didRemoveImage removeImg;

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;

- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray;

/**事例**/
/*
YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
[ymImageV show:maskview didFinish:^(){
    
    [UIView animateWithDuration:0.5f animations:^{
        
        ymImageV.alpha = 0.0f;
        maskview.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        weakSelf.navigationController.navigationBarHidden = NO;
        [ymImageV removeFromSuperview];
        [maskview removeFromSuperview];
    }];
}];
 */

@end

NS_ASSUME_NONNULL_END
