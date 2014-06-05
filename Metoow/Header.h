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

#define kAreaLevel @"kAreaLevel"                //各级地区key值：kAreaLevel0,kAreaLevel1,kAreaLevel2

//发布足迹页面同时作为回复足迹、转发足迹的页面
typedef enum {
    FootPubEditCategaryPublish,
    FootPubEditCategaryReply,
    FootPubEditCategaryTransmit,
    FootPubEditCategaryWeather,                  //发布路况
    FootPubEditCategaryReplyHuzhu,               //回复互助
    FootPubEditCategaryTransmitHuzhu,             //转发互助
    FootPubEditCategaryReplySOS,               //回复SOS
    FootPubEditCategaryTransmitSOS             //转发SOS
} FootPubEditCategary;


//足迹正文页面同时也展示路况正文，路况不回复收藏转发
typedef enum {
    FootDetailCategaryFoot,
    FootDetailCategaryRoad
} FootDetailCategary;

#endif
