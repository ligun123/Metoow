//
//  HWSegment.m
//  Metoow
//
//  Created by HalloWorld on 14-4-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWSegment.h"

@implementation HWSegment

+ (HWSegment *)segmentWithFrame:(CGRect)frame
{
    return [[HWSegment alloc] initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}


#define kTagRoot 100

- (void)setTitles:(NSArray *)titles
{
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kTagRoot + i;
        float width = self.frame.size.width / titles.count;
        btn.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"pb_mainColor_bkg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"pb_mainColor3_bkg"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

- (void)selectItem:(UIButton *)btn
{
    [self setSelectIndex:btn.tag - kTagRoot];
}


- (int)selectedIndex
{
    return selectedIndex;
}

- (void)setSelectIndex:(int)index
{
    selectedIndex = index;
    if (self.callbackBlock) {
        self.callbackBlock(self, selectedIndex);
    }
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setSelected:(view.tag == kTagRoot + index)];
        }
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
