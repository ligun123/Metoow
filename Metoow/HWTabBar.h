//
//  HWTabBar.h
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeight_HWTabBar 49.f

@class HWTabBar, HWTabBarItem;

@protocol HWTabBarProtocol <NSObject>

- (void)hwtabbar:(HWTabBar *)tabbar selectIndex:(NSUInteger)index;

@end

@interface HWTabBar : UIView
{
    NSUInteger selectIndex;
}

@property (strong, nonatomic) NSArray *tabItems;
@property (weak, nonatomic) id<HWTabBarProtocol> delegate;

+ (HWTabBar *)tabBarWithItems:(NSArray *)arr;

- (void)tabBarItemTap:(HWTabBarItem *)item;

- (void)setSelectIndex:(NSUInteger)index;

- (NSUInteger)selectedIndex;

@end


@interface HWTabBarItem : UIButton

+ (HWTabBarItem *)itemWithTitle:(NSString *)title normalImage:(UIImage *)nImg selectImage:(UIImage *)sImg;

- (void)setBrigdeEnable:(BOOL)enb;

@end