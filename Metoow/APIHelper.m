//
//  APIHelper.m
//  Metoow
//
//  Created by HalloWorld on 14-4-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "APIHelper.h"

@implementation APIHelper

+ (NSString *)url
{
    return @"http://www.metoow.com/index.php?app=api";
}

+ (NSDictionary *)OauthParasUid:(NSString *)uid passwd:(NSString *)pswd
{
    return @{@"mod": @"Oauth",@"act": @"authorize",@"uid": uid, @"passwd": pswd};
}

+ (NSDictionary *)packageMod:(NSString *)mod act:(NSString *)act Paras:(NSDictionary *)dic
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:dic];
    [para setObject:mod forKey:@"mod"];
    [para setObject:act forKey:@"act"];
    [para setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token] forKey:kOauth_Token];
    [para setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token_Secret] forKey:kOauth_Token_Secret];
    
    return para;
}

@end

@implementation NSDictionary (CheckError)


- (BOOL)isOK
{
    return [[self objectForKey:@"code"] integerValue] == 0;
}

- (NSError *)error
{
    if ([self isOK]) {
        return nil;
    } else {
        return [NSError errorWithDomain:[self objectForKey:@"msg"] code:[[self objectForKey:@"code"] integerValue] userInfo:nil];
    }
}

@end
