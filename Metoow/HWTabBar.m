//
//  HWTabBar.m
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWTabBar.h"

@implementation HWTabBar


- (id)initWithItems:(NSArray *)arr
{
    self = [super initWithFrame:CGRectMake(0, [AppDelegateInterface window].frame.size.height - kHeight_HWTabBar, [AppDelegateInterface window].frame.size.width, kHeight_HWTabBar)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        selectIndex = arr.count;
        self.tabItems = arr;
        for (int i = 0; i < [arr count]; i ++) {
            HWTabBarItem *item = arr[i];
            float width = self.frame.size.width / [arr count];
            item.frame = CGRectMake(i * width, 0, width, kHeight_HWTabBar);
            [item addTarget:self action:@selector(tabBarItemTap:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
        }
    }
    return self;
}

+ (HWTabBar *)tabBarWithItems:(NSArray *)arr
{
    return [[HWTabBar alloc] initWithItems:arr];
}

- (void)tabBarItemTap:(HWTabBarItem *)item
{
    if (selectIndex == [self.tabItems indexOfObject:item]) {
        return ;
    }
    selectIndex = [self.tabItems indexOfObject:item];
    if (_delegate && [_delegate respondsToSelector:@selector(hwtabbar:selectIndex:)]) {
        [_delegate hwtabbar:self selectIndex:selectIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

#pragma mark - HWTabBarItem implementation

@implementation HWTabBarItem

+ (HWTabBarItem *)itemWithTitle:(NSString *)title normalImage:(UIImage *)nImg selectImage:(UIImage *)sImg
{
    HWTabBarItem *item = [HWTabBarItem buttonWithType:UIButtonTypeCustom];
    item.titleLabel.textAlignment = UITextAlignmentCenter;
    item.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [item setTitleColor:COLOR_RGB(31, 104, 31) forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:nImg forState:UIControlStateNormal];
    [item setImage:sImg forState:UIControlStateSelected];
    return item;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 30.f, contentRect.size.width, kHeight_HWTabBar - 30.f);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 30.f) / 2, 1.f, 30.f, 30.f);
}

@end
