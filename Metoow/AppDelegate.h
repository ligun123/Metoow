//
//  AppDelegate.h
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTabBar.h"
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, HWTabBarProtocol, WeiboSDKDelegate>
{
    BMKMapManager *mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootViewController;
@property (strong, nonatomic) UIStoryboard *mainStoryBoard;
@property (readonly, nonatomic) HWTabBar *tabBar;
@property BOOL hasLogin;

@property (strong, nonatomic) NSTimer *checkinTimer;

- (id)awakeViewController:(NSString *)identifier;

- (void)setTabBarHidden:(BOOL)hid;

@end
