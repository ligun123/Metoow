//
//  AppDelegate.m
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "PersonalViewController.h"
#import "LocationManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginViewController.h"
#import "BPush.h"

@implementation AppDelegate

+ (void)initialize
{
    NSString *faceFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"miniblog"];
    NSArray *faceItems = [[NSFileManager defaultManager] subpathsAtPath:faceFolder];
    NSMutableDictionary *facemap = [NSMutableDictionary dictionary];
    for (NSString *item in faceItems) {
        NSString *name = [item componentsSeparatedByString:@"."][0];
        [facemap setObject:name forKey:[NSString stringWithFormat:@"[%@]", name]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:facemap forKey:@"FaceMap"];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s -> %@", __FUNCTION__, userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:nil];
    NSString *type = [userInfo objectForKey:@"type"];
    if ([type isEqualToString:@"msg"]) {
        HWTabBarItem *item = [self.tabBar tabItems][2];
        [item setBrigdeEnable:YES];
        //消息页面未被选中时
    }
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"迷途网"
                                                            message:alert
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    [BPush handleNotification:userInfo];
}

- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"%s -> UserId : %@", __FUNCTION__, [BPush getUserId]);
    NSLog(@"data:%@", [data description]);
    /*
    NSLog(@"On method:%@", method);
    
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
    }
     */
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWeiboAppKey];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] setScheduledLocalNotifications:nil];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR_RGB(0, 111, 0);
    NSLog(@"IOS : %@ Version : %@  SreenBounds%@",[[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], NSStringFromCGRect([UIScreen mainScreen].bounds));
    self.mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.rootViewController = [[AppDelegateInterface mainStoryBoard] instantiateInitialViewController];
    self.window.rootViewController = self.rootViewController;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.99) {
        [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:35.f];
    }
    */
     
    mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:BaiduMapAppKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [LocationManager shareInterface];   //开启定位
    
    //开发通知
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    [self.window makeKeyAndVisible];
    [self customTabbar];
    [self hwtabbar:self.tabBar selectIndex:0];
    if (!self.hasLogin) {
        [self displayLogin];
    }
    [self checkIn];
    return YES;
}

- (void)displayLogin
{
    UIViewController *login = [AppDelegateInterface awakeViewController:@"LoginViewController"];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:login];
    navLogin.navigationBarHidden = YES;
    [self.rootViewController pushViewController:login animated:NO];
}

- (void)customTabbar
{
    HWTabBarItem *item1 = [HWTabBarItem itemWithTitle:@"足迹" normalImage:[UIImage imageNamed:@"zj"] selectImage:nil];
    HWTabBarItem *item2 = [HWTabBarItem itemWithTitle:@"互助" normalImage:[UIImage imageNamed:@"hz"] selectImage:nil];
    HWTabBarItem *item3 = [HWTabBarItem itemWithTitle:@"消息" normalImage:[UIImage imageNamed:@"xx"] selectImage:nil];
    HWTabBarItem *item4 = [HWTabBarItem itemWithTitle:@"附近" normalImage:[UIImage imageNamed:@"fj"] selectImage:nil];
    HWTabBarItem *item5 = [HWTabBarItem itemWithTitle:@"更多" normalImage:[UIImage imageNamed:@"gd"] selectImage:nil];
    _tabBar = [HWTabBar tabBarWithItems:@[item1,item2, item3, item4, item5]];
    self.tabBar.delegate = self;
    [self.window addSubview:self.tabBar];
}

- (void)hwtabbar:(HWTabBar *)tabbar selectIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            [self.rootViewController popToRootViewControllerAnimated:NO];
            UIViewController *zj = [self awakeViewController:@"FootViewController"];
            [self.rootViewController pushViewController:zj animated:NO];
        }
            break;
        case 1:
        {
            [self.rootViewController popToRootViewControllerAnimated:NO];
            UIViewController *hz = [self awakeViewController:@"HelpViewController"];
            [self.rootViewController pushViewController:hz animated:NO];
        }
            break;
        case 2:
        {
            [self.rootViewController popToRootViewControllerAnimated:NO];
            UIViewController *xx = [self awakeViewController:@"MSGCenterViewController"];
            [self.rootViewController pushViewController:xx animated:NO];
        }
            break;
        case 3:
        {
            [self.rootViewController popToRootViewControllerAnimated:NO];
            UIViewController *fj = [self awakeViewController:@"NearViewController"];
            [self.rootViewController pushViewController:fj animated:NO];
        }
            break;
        case 4:
        {
            [self.rootViewController popToRootViewControllerAnimated:NO];
            PersonalViewController *gd = [self awakeViewController:@"PersonalViewController"];
            gd.isMe = YES;
            [self.rootViewController pushViewController:gd animated:NO];
        }
            break;
        default:
            break;
    }
}

- (id)awakeViewController:(NSString *)identifier
{
    return [self.mainStoryBoard instantiateViewControllerWithIdentifier:identifier];
}

- (void)setTabBarHidden:(BOOL)hid
{
    if (hid) {
        [self.tabBar removeFromSuperview];
    } else {
        if (![self.tabBar superview]) {
            [self.window addSubview:self.tabBar];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.checkinTimer invalidate];
    self.checkinTimer = nil;
    [[LocationManager shareInterface] stopLocationService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self checkIn];
}

- (void)checkIn
{
    [[LocationManager shareInterface] fatchMapLocation];
    self.checkinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkInTimer:) userInfo:nil repeats:YES];
}


- (void)bindBPush
{
    NSString *buid = [BPush getUserId];
    if (buid.length == 0) {
        NSLog(@"%s -> [BPush getUserId]为空，请开启IOS推送服务", __FUNCTION__);
        return ;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_User act:Mod_User_baidu_binding_uid Paras:@{@"b_uid": buid}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isOK]) {
            NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        } else NSLog(@"绑定BPush-》UserId成功!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s -> %@", __FUNCTION__, error);
    }];
}


- (void)checkInTimer:(NSTimer *)timer
{
    if ([LocationManager shareInterface].addrInfo != nil && self.hasLogin) {
        [self.checkinTimer invalidate];
        self.checkinTimer = nil;
        //request数据
        BMKAddrInfo *info = [LocationManager shareInterface].addrInfo;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *para = @{@"lng": [NSString stringWithFormat:@"%lf", info.geoPt.longitude], @"lat": [NSString stringWithFormat:@"%lf", info.geoPt.latitude]};
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_User act:Mod_User_checkin Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isOK]) {
                NSLog(@"%s -> check in OK", __FUNCTION__);
            } else {
                [[responseObject error] showAlert];
                if ([(NSDictionary *)responseObject code] == 1) {
                    [self displayLogin];
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%s -> check in error", __FUNCTION__);
        }];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - QQ && Weibo

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            NSString *user_id = [(WBAuthorizeResponse *)response userID];
            [[self currentLoginVC] weiboAuthUserID:user_id];
        } else {
            [[NSError errorWithDomain:@"微博登陆授权失败" code:100 userInfo:nil] showAlert];
        }
    }
}

- (LoginViewController *)currentLoginVC
{
    for (id vc in self.rootViewController.viewControllers) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            return vc;
        }
    }
    return nil;
}


@end
