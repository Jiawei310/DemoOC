//
//  ShowImageModel.h
//  Demo
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowImageModel : BaseModel
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *adddate;//上传时间
@property (nonatomic, copy) NSString *name;//文件名称
@property (nonatomic, copy) NSString *url;//视频地址或者图片地址
@property (nonatomic, assign) NSInteger imgtype;//1:身份证正面 2:身份证反面 3:银行卡正面 4:打款凭证 5:视频
@property (nonatomic, assign) NSInteger isverify;//是否可以删除（1、不能删除  0、可以删除）
@end

NS_ASSUME_NONNULL_END
