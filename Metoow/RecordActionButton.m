//
//  RecordActionButton.m
//  Metoow
//
//  Created by HalloWorld on 14-4-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "RecordActionButton.h"

@implementation RecordActionButton


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, CGRectGetHeight(contentRect), CGRectGetHeight(contentRect));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(CGRectGetHeight(contentRect)+1, 0, CGRectGetWidth(contentRect) - CGRectGetHeight(contentRect)-1, CGRectGetHeight(contentRect));
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
