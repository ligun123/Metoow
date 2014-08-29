//
//  HWDevice.m
//  WanKe
//
//  Created by HalloWorld on 14-3-30.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWDevice.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HWDevice

+ (float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)dateString:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:(date == nil ? [NSDate date] : date)];
}

+ (NSString *)uuidString
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (BOOL)isIphone5
{
    if ([[UIScreen mainScreen] bounds].size.height > 539.f) {
        return YES;
    } else return NO;
}

@end

@implementation NSDictionary (HalloWorld)

- (NSString *)sqliteKeys
{
    return [[self allKeys] componentsJoinedByString:@","];
}

- (NSString *)sqliteValues
{
    return [[self allValues] componentsJoinedByString:@"','"];
}

@end


@implementation NSString (HalloWorld)

- (NSString *)md5Encode
{
    const char * cStrValue = [self UTF8String];
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, strlen(cStrValue), theResult);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            theResult[0], theResult[1], theResult[2], theResult[3],
            theResult[4], theResult[5], theResult[6], theResult[7],
            theResult[8], theResult[9], theResult[10], theResult[11],
            theResult[12], theResult[13], theResult[14], theResult[15]] lowercaseString];
}

- (NSString *)apiDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [fmt stringFromDate:date];
}

- (NSString *)apiDateShort
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"HH:mm"];
    return [fmt stringFromDate:date];
}

- (NSString *)apiDateCn
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy年MM月dd号 HH点mm分"];
    return [fmt stringFromDate:date];
}

@end


@implementation NSNumber (Metoow)

- (NSString *)apiDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [fmt stringFromDate:date];
}

- (NSString *)apiDateShort
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"HH:mm"];
    return [fmt stringFromDate:date];
}

@end
