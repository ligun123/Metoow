//
//  HWSegment.h
//  Metoow
//
//  Created by HalloWorld on 14-4-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWSegment;

typedef void(^HWSegmentCallback)(HWSegment *seg, int selectIndex);

@interface HWSegment : UIView
{
    int selectedIndex;
}

@property (copy, nonatomic) HWSegmentCallback callbackBlock;

+ (HWSegment *)segmentWithFrame:(CGRect)frame;
- (void)setTitles:(NSArray *)titles;
- (void)setSelectImage:(UIImage *)img;
- (int)selectedIndex;

- (void)setSelectIndex:(int)index;

@end
