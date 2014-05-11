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

@implementation AppDelegate

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
    [self.window makeKeyAndVisible];
    [self customTabbar];
    [self hwtabbar:self.tabBar selectIndex:0];
    
    
    
    return YES;
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
    /*
    UITabBar *bar = self.tabBarController.tabBar;
    NSArray *items = [bar items];
    UITabBarItem *item0 = items[0];
    [item0 setTitle:@"足迹"];
    [item0 setImage:[UIImage imageNamed:@"zj"]];
    
    UITabBarItem *item1 = items[1];
    [item1 setTitle:@"互助"];
    [item1 setImage:[UIImage imageNamed:@"hz"]];
    
    UITabBarItem *item2 = items[2];
    [item2 setTitle:@"消息"];
    [item2 setImage:[UIImage imageNamed:@"xx"]];
    
    UITabBarItem *item3 = items[3];
    [item3 setTitle:@"附近"];
    [item3 setImage:[UIImage imageNamed:@"fj"]];
    
    UITabBarItem *item4 = items[4];
    [item4 setTitle:@"更多"];
    [item4 setImage:[UIImage imageNamed:@"gd"]];
     */
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
