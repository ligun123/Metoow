//
//  DetailCell.m
//  Metoow
//
//  Created by HalloWorld on 14-5-21.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _hasImages = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _hasImages = YES;
}

- (void)setHasImage:(BOOL)hasImages
{
    self.hasImages = hasImages;
    self.picScroll.hidden = !hasImages;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (CGFloat)height
{
    return 190.f;
}

+ (CGFloat)defaultMSGViewHeight
{
    return 24.f;
}

@end
