//
//  LoginCheckBox.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "LoginCheckBox.h"

@implementation LoginCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (self.bounds.size.height - 12) / 2, 14, 12);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(14 + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - 14 - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

- (void)initView
{
    [super initView];
    [self setImage:[UIImage imageNamed:@"login_checkDisel_btn"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"login_checkSel_btn"] forState:UIControlStateSelected];

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
