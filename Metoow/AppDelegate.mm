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

#define BaiduMapAppKey @"A5OMm1Qm4w1XIR6vfN0887BX"

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR_RGB(0, 111, 0);
    NSLog(@"IOS : %@ Version : %@  SreenBounds%@",[[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], NSStringFromCGRect([UIScreen mainScreen].bounds));
    self.mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.rootViewController = [[AppDelegateInterface mainStoryBoard] instantiateInitialViewController];
    self.window.rootViewController = self.rootViewController;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:BaiduMapAppKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [LocationManager shareInterface];   //开启定位
    
    [self.window makeKeyAndVisible];
    [self customTabbar];
    [self hwtabbar:self.tabBar selectIndex:0];
    if (!self.hasLogin) {
        [self displayLogin];
    }
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
