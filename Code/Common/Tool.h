//
//  Tool.h
//  Demo
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 SJW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject

#pragma mark User Defaults
/**
 *  将对象存到本地沙盒
 *
 *  @param value       对象
 *  @param defaultName 对应键值
 */
+ (void)saveObject:(id)value forKey:(NSString *)defaultName;
/**
 *  从本地沙盒取出对象
 *
 *  @param defaultName 对应键值
 *
 *  @return 得到的对象
 */
+ (id)loadObjectForKey:(NSString *)defaultName;


#pragma mark UIViewController

/**
 *  获取最底层的controller
 *
 */
+ (UIViewController *)getRootVC;

/**
 *  获取当前view所在controller
 *
 *  @param view 传进来的view
 *
 *  @return view所在controller
 */
+ (UIViewController *)viewController:(UIView *)view;

#pragma mark Navi
/**
 *  导航栏标题
 *
 *  @param title 标题内容
 *
 *  @return 返回标题视图
 */
+ (UIView *)navigationTitleView:(NSString *)title;

/**
 *  导航栏返回上一页按钮
 *
 *  @param target self
 *  @param action 按钮触发事件
 *
 *  @return 返回按钮视图
 */
+ (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action;
/**
 *  万能按钮
 *
 *  @param target self
 *  @param action 按钮触发事件
 *
 *  @return 返回
 */
+ (UIBarButtonItem *)customButtonItemTarget:(NSString *)text target:(id)target action:(SEL)action;
/**
 *  导航栏返回首页按钮
 *
 *  @param target self
 *  @param action 按钮触发事件
 *
 *  @return 返回首页视图
 */
+ (UIBarButtonItem *)mainBarButtonItemTarget:(id)target action:(SEL)action;

//取消按钮
+ (UIBarButtonItem *)cancelBarButtonItemTarget:(id)target action:(SEL)action;

/**
 *  对视图进行圆角设置
 *
 *  @param view 需要设置的视图
 */
+ (void)makeViewToRadius:(UIView *)view borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;

#pragma mark Image

/**
 *  对图片进行高斯模糊处理
 *
 *  @param image 目标图片
 *
 *  @return 生成的图片
 */
+ (UIImage *)createGaussianImage:(UIImage *)image;
/**
 *  这个高斯模糊处理可以控制清晰度
 *
 *  @param image 目标图片
 *  @param blur  清晰度  范围：0.1~2.0（范围之外的设置为0.5）
 *
 *  @return 生成的图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**
 *  根据颜色生成图片
 *
 *  @param color 目标颜色
 *
 *  @return 生成的图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  对图片进行拉伸
 *
 *  @param image 需要拉伸的图
 *
 *  @return 返回
 */
+ (UIImage *)resizableImage:(UIImage *)image;

/**
 *  创建一块模糊的view（覆盖到哪里哪里就有模糊效果，和高斯模糊效果差不多）
 *
 *  @param frame 覆盖范围
 *
 *  @return 返回模糊view
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

/**
 *  对图片进行滤镜处理
 *  怀旧 --> CIPhotoEffectInstant   单色 --> CIPhotoEffectMono
 *  黑白 --> CIPhotoEffectNoir      褪色 --> CIPhotoEffectFade
 *  色调 --> CIPhotoEffectTonal     冲印 --> CIPhotoEffectProcess
 *  岁月 --> CIPhotoEffectTransfer  铬黄 --> CIPhotoEffectChrome
 *  @param image 需要过滤的图
 *  @param name 以字符串的形式填写需要过滤成什么样式（样式类型如上介绍）
 *
 *  @return 返回
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

/**
 *  全屏截图
 *
 *  @return 截取的图
 */
+ (UIImage *)shotScreen;

/**
 *  截取view生成图片(截图功能)
 *
 *  @param view 截取的view
 *
 *  @return 生成图片
 */
+ (UIImage *)shotWithView:(UIView *)view;

/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 需要压缩的图片
 *  @param size  压缩的size
 *
 *  @return 返回
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  压缩图片文件大小(稍微修改可以换成返回data形式)
 *
 *  @param image 需要压缩的图
 *
 *  @return 返回
 */
+ (NSData *)compressOriginalImageforData:(UIImage *)image;

#pragma mark - 富文本操作
/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;
/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space;

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace;


/**
 改变行间距和字体颜色、字体大小
 
 @param totalString 总得字符串
 @param subArray    需要更改的字符串
 @param font        字体大小
 @param color       字体颜色
 @param lineSpace   行间距
 
 @return 生产的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineSpaceAndFontAndColorWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray Font:(UIFont *)font Color:(UIColor *)color LineSpace:(CGFloat)lineSpace;

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;
/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;


#pragma mark - 时间戳转换
/// 时间戳 -> 时间字符串 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStam;
+ (NSString *)getTimeStrWithHourBytimeStamp:(NSString *)timeStamp;
+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStamp dateFormat:(NSString *)dataFormat;
/// 时间字符串 -> 时间戳 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr;
+ (NSString *)getTimeStampWithHourBytimeStr:(NSString *)timeStr;
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr dateFormat:(NSString *)dataFormat;
//根据格式，获取当前时间字符串
+ (NSString *)getNowWithFormatter:(NSString *)formatter;
+ (NSDate *)getDate:(NSString *)timeStr Format:(NSString *)dataFormat;
+ (NSString *)getDateStr:(NSDate *)date Format:(NSString *)dataFormat;

+ (NSString *)getDateStr:(NSString *)timeStr FromFormat:(NSString *)fromFormat ToFormat:(NSString *)toFormat;

+ (NSArray *)getMonthBeginAndEndWith:(NSString *)dateStr;
+ (NSString *)getLastMonthSameDay:(NSString *)dateStr;

#pragma mark - 拨打电话
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber;

#pragma mark - 秒数转换
+ (NSString *)secondToMinAndSecond:(NSInteger)second;

#pragma mark - Json and Object
// 将字典或者数组转化为JSON串
+ (NSString *)toJSONString:(id)theData;
// 将JSON串转化为字典或者数组
+ (id)JSONToArrayOrNSDictionary:(NSString *)jsonStr;

//亿 万 元 转换
+ (NSArray *)uintChange:(NSString *)value;

#pragma mark - 手机信息
//获取手机信息
+ (NSString *)getDeviceVersion;

//千位分隔符
+ (NSString *)numDecimal:(NSString *) numStr;

//bank分隔符
+ (NSString *)bankNum:(NSString *)numStr;

#pragma mark - 行间距
+ (void)changeLineHeight:(CGFloat)height Label:(UILabel *)label;
@end

NS_ASSUME_NONNULL_END
