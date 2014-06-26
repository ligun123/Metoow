//
//  HWDevice.h
//  WanKe
//
//  Created by HalloWorld on 14-3-30.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_RGB(x, y, z) [UIColor colorWithRed:(x)/255.f green:(y)/255.f blue:(z)/255.f alpha:1.0]
#define COLOR_RGBA(x, y, z, a) [UIColor colorWithRed:(x)/255.f green:(y)/255.f blue:(z)/255.f alpha:(a)/255.f]

@interface HWDevice : NSObject

/**
 *  返回IOS版本浮点
 */
+ (float)systemVersion;

+ (NSString *)dateString:(NSDate *)date;

+ (NSString *)uuidString;

/**
 *  返回是否是4英寸屏幕
 */
+ (BOOL)isIphone5;

@end

@interface NSDictionary (HalloWorld)

/**
 *  返回:k1,k2,k3
 */
- (NSString *)sqliteKeys;

/**
 *  返回:v1','v2','v3,注意前后缺少'
 */
- (NSString *)sqliteValues;

@end

@interface NSString (HalloWorld)

- (NSString *)md5Encode;

- (NSString *)apiDate;

- (NSString *)apiDateCn;

@end


@interface NSNumber (Metoow)

- (NSString *)apiDate;

@end
