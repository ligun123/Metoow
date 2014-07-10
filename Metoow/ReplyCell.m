//
//  ReplyCell.m
//  Metoow
//
//  Created by HalloWorld on 14-6-1.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "ReplyCell.h"

@implementation ReplyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    tapHeader.numberOfTapsRequired = 1;
    tapHeader.numberOfTouchesRequired = 1;
    [self.headerImg addGestureRecognizer:tapHeader];
}

- (void)headerTap:(id)sender
{
    if (self.headerTapBlock) {
        self.headerTapBlock(self);
    }
}

+ (CGFloat)height
{
    return 64.f;
}

@end
