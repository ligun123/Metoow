//
//  Header.h
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#ifndef Metoow_Header_h
#define Metoow_Header_h

#import "HWDevice.h"
#import "JSONKit.h"
#import "NSError+Alert.h"
#import "AppDelegate.h"
#import "QCheckBox.h"
#import "AFNetworking.h"
#import "APIHelper.h"
#import "SVProgressHUD.h"

#define AppDelegateInterface	(AppDelegate*)([UIApplication sharedApplication].delegate)

#define kLoginUserID @"kLoginUserID"
#define kLoginPswd @"kLoginPswd"
#define kBoolAutoLogin @"kBoolAutoLogin"        //自动登录
#define kBoolRmbSec @"kBoolRmbSec"              //记住密码

#endif
