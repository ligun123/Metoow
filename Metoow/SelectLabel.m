//
//  SelectLabel.m
//  Metoow
//
//  Created by HalloWorld on 14-4-16.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SelectLabel.h"

@implementation SelectLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)resizeSize
{
    UIFont *font = self.titleLabel.font;
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize size = [title sizeWithFont:font];
    self.frame = CGRectMake(0, 0, size.width + 28, 27);
}

- (void)layoutStyle
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    [self setImage:[UIImage imageNamed:@"login_labelSelect_bkg"] forState:UIControlStateSelected];
    int kd = rand() % 10;
    NSString *imgName = [NSString stringWithFormat:@"login_label_bkg%d", kd];
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateSelected];
    [self addTarget:self action:@selector(myselfTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)myselfTap:(id)sender
{
    [self setSelected:!self.selected];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (SelectLabel *)labelWithString:(NSString *)title
{
    SelectLabel *label =[SelectLabel buttonWithType:UIButtonTypeCustom];
    [label setTitle:title];
    [label resizeSize];
    [label layoutStyle];
    return label;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(CGRectGetWidth(contentRect) - 12, CGRectGetHeight(contentRect) - 12, 10, 10);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return contentRect;
}

@end
