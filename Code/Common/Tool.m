//
//  Tool.m
//  Demo
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 SJW. All rights reserved.
//

#import "Tool.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonDigest.h>
#import <Accelerate/Accelerate.h>
#import "sys/utsname.h"

@implementation Tool

#pragma mark User Defaults
+ (void)saveObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadObjectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

#pragma mark Navi
+ (UIView *)navigationTitleView:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(85,3,60,60)];
    //    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:23]}];
    //    if(size.width > label.width)
    //    {
    //        label.font = [UIFont systemFontOfSize:15];
    //        label.textAlignment = NSTextAlignmentLeft;
    //        label.numberOfLines = 2;
    //    }
    //    else
    //    {
    //        label.font = [UIFont systemFontOfSize:20];
    //        label.textAlignment = NSTextAlignmentCenter;
    //    }
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.numberOfLines = 2;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    NSMutableAttributedString *titleStr = [Tool ls_changeFontAndColor:[UIFont systemFontOfSize:19] Color:[UIColor whiteColor] TotalString:title SubStringArray:@[title]];
    label.attributedText = titleStr;
    //label.adjustsFontSizeToFitWidth = YES;
    return label;
}

+ (UIBarButtonItem *)customButtonItemTarget:(NSString *)text target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    [button setBackgroundImage:[UIImage imageNamed:@"selected_friend_btn9"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];//[UIFont fontWithName:@"Courier" size:15];
    [button  setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 48, 29);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back_buttton"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 48, 29);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)mainBarButtonItemTarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_go_back"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 36, 21);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)cancelBarButtonItemTarget:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 36, 21);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)makeViewToRadius:(UIView *)view borderColor:(UIColor *)color cornerRadius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;    //圆角半径
    view.layer.borderWidth = 0.5;   //边框宽度
    view.layer.borderColor = color.CGColor;
    view.layer.masksToBounds = YES;
}

#pragma mark Image
+ (UIImage *)createGaussianImage:(UIImage *)image
{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage,@"inputRadius", @(70.5), nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return resultImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if ((blur < 0.1f) || (blur > 2.0f))
    {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    //    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)resizableImage:(UIImage *)image
{
    //default is 2
    CGFloat top = image.size.height / 5; // 顶端盖高度
    CGFloat bottom = image.size.height / 5 ; // 底端盖高度
    CGFloat left = image.size.width / 5; // 左端盖宽度
    CGFloat right = image.size.width / 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}

+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage =[[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return resultImage;
}

+ (UIImage *)shotScreen
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)shotWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size
{
    UIImage *resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (NSData *)compressOriginalImageforData:(UIImage *)image
{
    NSData *reData;
    CGFloat length = [UIImagePNGRepresentation(image) length]/1024;
    length = length/1024;
    
    //图片压缩规则：小于1M 70%   1-2M 50%   2-3M 30%    超过3M 20%
    if (length < 1)
    {
        reData = UIImageJPEGRepresentation(image, 0.7);
    }
    else if (length > 1 && length < 2)
    {
        reData = UIImageJPEGRepresentation(image, 0.5);
    }
    else if (length > 2 && length < 3)
    {
        reData = UIImageJPEGRepresentation(image, 0.3);
    }
    else
    {
        reData = UIImageJPEGRepresentation(image, 0.2);
    }
    
    //    UIImage *showImage = [UIImage imageWithData:reData];
    return reData;
}

#pragma mark UIViewController
+ (UIViewController *)getRootVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIViewController *)viewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


#pragma mark - 富文本操作
/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSMutableArray *array = [self ls_getRangeWithTotalString:totalStr SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        
    }
    
    return attributedStr;
}

/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    long number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt64Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    return attributedStr;
}

/**
 改变行间距和字体颜色、字体大小
 
 @param totalString 总得字符串
 @param subArray    需要更改的字符串
 @param font        字体大小
 @param color       字体颜色
 @param lineSpace   行间距
 
 @return 生产的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineSpaceAndFontAndColorWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray Font:(UIFont *)font Color:(UIColor *)color LineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributStr = [self ls_changeFontAndColor:font Color:color TotalString:totalString SubStringArray:subArray];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    return attributStr;
}

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt64Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

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
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        //        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        //
        //        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        //        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        NSMutableArray *array = [self ls_getRangeWithTotalString:totalString SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    
    
    return attributedStr;
}

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSLinkAttributeName value:totalString range:range];
    }
    
    return attributedStr;
}

#pragma mark - 获取某个子字符串在某个总字符串中位置数组
/**
 *  获取某个字符串中子字符串的位置数组
 *
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *
 *  @return 位置数组
 */
+ (NSMutableArray *)ls_getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString {
    
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    if (subString == nil || [subString isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [totalString rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange      rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (int i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = totalString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                
                location = rang1.location + rang1.length;
                length = totalString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [totalString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        
        return arrayRanges;
    }
    
    return nil;
}

#pragma mark - 时间戳 <-> 时间字符串 转换

/// 时间戳 -> 时间字符串 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStamp {
    return [self getTimeStrBytimeStamp:timeStamp dateFormat:@"yyyy-MM-dd"];
}

+ (NSString *)getTimeStrWithHourBytimeStamp:(NSString *)timeStamp {
    return [self getTimeStrBytimeStamp:timeStamp dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)getTimeStrBytimeStamp:(NSString *)timeStamp dateFormat:(NSString *)dataFormat {
    if ([timeStamp hasPrefix:@"201"]) {
        return timeStamp;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dataFormat];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString ? dateString : @"";
}

/// 时间字符串 -> 时间戳 dateFormat默认为yyyy-MM-dd
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr {
    return [self getTimeStampBytimeStr:timeStr dateFormat:@"yyyy-MM-dd"];
}
+ (NSString *)getTimeStampWithHourBytimeStr:(NSString *)timeStr {
    return [self getTimeStampBytimeStr:timeStr dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)getTimeStampBytimeStr:(NSString *)timeStr dateFormat:(NSString *)dataFormat {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = dataFormat;
    NSDate *date = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    return timeSp;
}


+ (NSString *)getNowWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    return dateStr;
}

+ (NSDate *)getDate:(NSString *)timeStr Format:(NSString *)dataFormat {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = dataFormat;
    NSDate *date = [formatter dateFromString:timeStr];
    return date;
}

+ (NSString *)getDateStr:(NSDate *)date Format:(NSString *)dataFormat {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat = dataFormat;
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getDateStr:(NSString *)timeStr FromFormat:(NSString *)fromFormat ToFormat:(NSString *)toFormat {
    NSDate *date = [Tool getDate:timeStr Format:fromFormat];
    NSString *dateStr = [Tool getDateStr:date Format:toFormat];
    return dateStr;
}

+ (NSArray *)getMonthBeginAndEndWith:(NSString *)dateStr {
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @[];
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    return @[beginString,endString];
}

+ (NSString *)getLastMonthSameDay:(NSString *)dateStr {
    NSString *lastSameDay = @"";
    NSRange range = NSMakeRange(4, 2);
    NSInteger month = [[dateStr substringWithRange:range] integerValue];
    if (month == 1) {
        month = 12;
    }
    else {
        month = month - 1;
    }
    NSString *monthStr = [NSString stringWithFormat:@"%.2ld",month];
    lastSameDay = [dateStr stringByReplacingCharactersInRange:range withString:monthStr];
    return lastSameDay;
}


#pragma mark - 拨打电话
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length == 11 || phoneNumber.length == 10)
    {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",phoneNumber];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    else
    {
        SHOWALERT(@"暂无手机号", [Tool getRootVC]);
    }
}

#pragma mark - 秒数转换
+ (NSString *)secondToMinAndSecond:(NSInteger)second {
    NSInteger min = second / 60;
    NSInteger sec = second % 60;
    NSString *str = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)min, (long)sec];
    return str;
}


// 将字典或者数组转化为JSON串
+ (NSString *)toJSONString:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:nil];
    
    if ([jsonData length]&&error== nil){
        NSString *string = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
        return string;
    }else{
        return nil;
    }
}


// 将JSON串转化为字典或者数组
+ (id)JSONToArrayOrNSDictionary:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}



#pragma mark - 单位换算 （元 万 亿）
+ (NSArray *)uintChange:(NSString *)value {
    NSString *uint = @"元";
    NSString *changedValue = @"0";
    if (value.length > 0) {
        changedValue = value;
        if ([value integerValue] > 100000) {
            float balance = (float)([value integerValue]/10000);
            
            changedValue = [NSString stringWithFormat:@"%0.0f",balance];
            changedValue = [Tool numDecimal:changedValue];
            uint = @"万";
            
            //            if (balance < 10000)
            //            {
            //                changedValue = [NSString stringWithFormat:@"%0.0f",balance];
            //                changedValue = [YLCoreTool numDecimal:changedValue];
            //                uint = @"万";
            //            }
            //            else
            //            {
            //                changedValue = [NSString stringWithFormat:@"%0.4f",(float)balance/10000];
            //                changedValue = [YLCoreTool numDecimal:changedValue];
            //                uint = @"亿";
            //            }
        }
    }
    return @[changedValue, uint];
}


#pragma mark - 手机信息
+ (NSString *)getDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    else if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    else if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    else if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    else if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    else if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    else if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    else if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    else if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    else if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    else if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    else if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    else if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    else if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    else if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    else if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    else if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    else if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    else if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    // iPod
    else if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    else if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    else if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    else if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    else if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    // iPad
    else if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    else if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    else if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    else if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    else if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    else if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    else if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    else if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    else if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    else if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    else if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    else if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    else if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    else if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    else if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    else if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    else if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    else if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    else if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    else if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    // iPhone Simulator
    else if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    else if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    else return deviceString;
}


+ (NSString *)numDecimal:(NSString *) numStr {
    NSNumberFormatter *numFormmatter = [[NSNumberFormatter alloc] init];
    numFormmatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *num = [NSNumber numberWithLongLong:[numStr longLongValue]];
    if ([numStr containsString:@"."]) {
        num = [NSNumber numberWithDouble:[numStr doubleValue]];
    }
    NSString *str = [numFormmatter stringFromNumber:num];
    return str;
}


+ (NSString *)bankNum:(NSString *)numStr {
    NSMutableString *str = [numStr mutableCopy];
    NSInteger count = str.length;
    for (int i = 1; i <= count/4; i++) {
        [str insertString:@" " atIndex:i * 4 + i - 1];
    }
    return str;
}

#pragma mark - 行间距
+ (void)changeLineHeight:(CGFloat)height Label:(UILabel *)label {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = height - (label.font.lineHeight - label.font.pointSize);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:attributes];
}

@end
