//
//  APIHelper.h
//  Metoow
//
//  Created by HalloWorld on 14-4-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileUploader.h"

#pragma mark - 服务器预定义

#define API_URL @"http://www.metoow.com/index.php?app=api"

#define kOauth_Token @"oauth_token"
#define kOauth_Token_Secret @"oauth_token_secret"

#define Mod_Login @"Login"
#define Mod_Login_login @"login"        //Login模式下的login动作
#define Mod_Login_register @"register"
#define Mod_Login_getArea   @"getArea"  //注册时候
#define Mod_Login_set_tags @"set_tags"
#define Mod_Login_app_login @"app_login"    //第三方登陆
#define Mod_Login_mett_binding_app @"mett_binding_app"  //绑定存在的账号

#define Mod_Foot @"Foot"
#define Mod_Foot_del @"del"
#define Mod_Foot_foot_list @"foot_list"                         //足迹列表
#define Mod_Foot_add_foot @"add_foot"                           //发布足迹
#define Mod_Foot_get_myfoot @"get_myfoot"                       //获取我的足迹
#define Mod_Foot_foot_collect @"foot_collect"                   //获取我收藏的足迹
#define Mod_Foot_my_attention @"my_attention"                   //我关注的人的足迹
#define Mod_Foot_collect @"collect"                             //收藏一条足迹
#define Mod_Foot_no_collect @"no_collect"                       //取消收藏
#define Mod_Foot_show @"show"                                   //查看一条足迹

#define Mod_Weather @"Weather"                                  //路况
#define Mod_Weather_weather_list @"weather_list"                //所有路况列表
#define Mod_Weather_get_myweather @"get_myweather"              //我的路况列表
#define Mod_Weather_show @"show"                                //查看一条详情
#define Mod_Weather_add_weather @"add_weather"                  //添加路况
#define Mod_Weather_del @"del"


#define Mod_User @"User"
#define Mod_User_baidu_binding_uid @"baidu_binding_uid"         //百度云推送uid映射
#define Mod_User_info @"info"
#define Mod_User_myinfo @"myinfo"
#define Mod_User_checkin @"checkin"                             //记录用户最后位置
#define Mod_User_neighbors @"neighbors"                         //附近小伙伴
#define Mod_User_upload_face @"upload_face"
#define Mod_User_update_uname @"update_uname"                   //修改昵称


#define Mod_Message @"Message"
#define Mod_Message_get_message_list @"get_message_list"        //获取我的私信列表  list_id和是第一条的message的id
#define Mod_Message_get_message_detail @"get_message_detail"    //获取私信的详情
#define Mod_Message_reply @"reply"                              //回复私信
#define Mod_Message_create @"create"
#define Mod_Message_get_list_to_uid @"get_list_to_uid"          //查询和某人的私信记录，to_uid对方的uid

#define Mod_Notifytion @"Notifytion"                            //系统消息
#define Mod_Notifytion_get_system_notify @"get_system_notify"


#define Mod_Huzhu @"Huzhu"
#define Mod_Huzhu_add_hz @"add_hz"                              //添加互助
#define Mod_Huzhu_get_hzlist @"get_hzlist"
#define Mod_Huzhu_get_one_hz @"get_one_hz"                      //获取一条互助


#define Mod_System @"System"
#define Mod_System_comment @"comment"                           //回复互助
#define Mod_System_share @"share"                               //转发互助

#define Mod_Comment @"System"
#define Mod_Comment_get_comments @"get_comments"                 //获取回复

#define Mod_Attach @"Attach"                                    //附件
#define Mod_Attach_upload @"upload"                             //上传附件
#define Mod_Attach_down @"down"                                 //下载附件


#define Mod_SOS @"Sos"
#define Mod_SOS_sos_list @"sos_list"
#define Mod_SOS_add_sos @"add_sos"
#define Mod_SOS_show @"show"
#define Mod_SOS_is_pation @"is_pation"                          //参与或者取消参与
#define Mod_SOS_sos_pation @"sos_pation"                        //根据sos的id获取参与的用户列表
#define Mod_SOS_close_sos @"close_sos"                          //关闭SOS

#define Mod_Near @"Near"                                        //附近
#define Mod_Near_near_road @"near_road"                         //附近路况
#define Mod_Near_near_foot @"near_foot"                         //附近足迹
#define Mod_Near_near_huzhu @"near_huzhu"                       //附近互助



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


/**
 *  上传附件的url，根据上传表类型
 *
 *  @param cate 足迹、互助。。。
 */
+ (NSString *)urlUploadForCategary:(UploadCategary)cate;


+ (NSString *)urlDownloadID:(NSString *)attach_id;

@end


@interface NSDictionary (CheckError)

- (BOOL)isOK;

- (NSError *)error;

- (int)code;

@end
