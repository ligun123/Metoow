//
//  APIHelper.h
//  Metoow
//
//  Created by HalloWorld on 14-4-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 服务器预定义

#define API_URL @"http://www.metoow.com/index.php?app=api"

#define kOauth_Token @"oauth_token"
#define kOauth_Token_Secret @"oauth_token_secret"

#define Mod_Login @"Login"
#define Mod_Login_login @"login"        //Login模式下的login动作
#define Mod_Login_registe @"registe"

#define Mod_Foot @"Foot"
#define Mod_Foot_foot_list @"foot_list"
#define Mod_Foot_add_foot @"add_foot"

@interface APIHelper : NSObject

/**
 *  返回api的url字符串
 */
+ (NSString *)url;

/**
 *  返回申请token需要的参数
 *
 *  @param uid  用户id
 *  @param pswd 密码
 *
 *  @return AFNetworking库的参数字典
 */
+ (NSDictionary *)OauthParasUid:(NSString *)uid passwd:(NSString *)pswd;

/**
 *  返回一般api需要的参数字典，加入了token和mod、act到字典中
 *
 *  @param mod 模块
 *  @param act 动作
 *  @param dic 一些参数
 *
 *  @return 添加了mod和act的字典
 */
+ (NSDictionary *)packageMod:(NSString *)mod act:(NSString *)act Paras:(NSDictionary *)dic;


@end


@interface NSDictionary (CheckError)

- (BOOL)isOK;

- (NSError *)error;
@end
