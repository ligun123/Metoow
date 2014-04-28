//
//  AppDelegate.h
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, HWTabBarProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootViewController;
@property (strong, nonatomic) UIStoryboard *mainStoryBoard;
@property (readonly, nonatomic) HWTabBar *tabBar;

- (id)awakeViewController:(NSString *)identifier;

- (void)setTabBarHidden:(BOOL)hid;

@end
