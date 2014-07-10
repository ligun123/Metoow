//
//  HuzhuCell.m
//  Metoow
//
//  Created by HalloWorld on 14-5-26.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HuzhuCell.h"

@implementation HuzhuCell

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

+ (CGFloat)height
{
    return 126.f;
}

- (IBAction)btnTransmitTap:(RecordActionButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(huzhuCell:tapBtn:)]) {
        [_delegate huzhuCell:self tapBtn:sender];
    }
}


- (IBAction)btnReplyTap:(RecordActionButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(huzhuCell:tapBtn:)]) {
        [_delegate huzhuCell:self tapBtn:sender];
    }
}

@end
