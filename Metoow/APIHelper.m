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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token]) {
        [para setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token] forKey:kOauth_Token];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token_Secret]) {
        [para setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token_Secret] forKey:kOauth_Token_Secret];
    }
    
    return para;
}

+ (NSString *)urlUploadFootImage
{
    NSString *upurl = [self urlUploadForType:@"foot"];
    return upurl;
}

+ (NSString *)urlUploadWeatherImage
{
    NSString *upurl = [self urlUploadForType:@"weather"];
    return upurl;
}

+ (NSString *)urlUploadForCategary:(UploadCategary)cate
{
    if (cate == UploadCategaryFoot) {
        return [APIHelper urlUploadForType:@"foot"];
    }
    if (cate == UploadCategaryWeather) {
        return [APIHelper urlUploadForType:@"weather"];
    }
    if (cate == UploadCategaryHuzhu) {
        return [APIHelper urlUploadForType:@"huzhu"];
    }
    return nil;
}


+ (NSString *)urlUploadForType:(NSString *)type
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token];
    NSString *secrect = [[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token_Secret];
    NSString *upurl = [NSString stringWithFormat:@"%@&mod=%@&act=%@&upload_type=image&Thumb=0&width=1&Height=1&Cut=false&oauth_token=%@&oauth_token_secret=%@&attach_type=%@", API_URL, Mod_Attach,Mod_Attach_upload,token, secrect, type];
    return upurl;
}


+ (NSString *)urlDownloadID:(NSString *)attach_id
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token];
    NSString *secrect = [[NSUserDefaults standardUserDefaults] objectForKey:kOauth_Token_Secret];
    NSString *durl = [NSString stringWithFormat:@"%@&oauth_token=%@&oauth_token_secret=%@&mod=%@&act=%@&attach_id=%@", API_URL, token, secrect, Mod_Attach, Mod_Attach_down,attach_id];
    return durl;
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
