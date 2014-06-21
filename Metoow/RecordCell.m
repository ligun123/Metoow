//
//  RecordCell.m
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (CGFloat)realHeight
{
    return 0.f;
}

+ (CGFloat)height
{
    return 90.f;
}

- (IBAction)btnConnectTap:(RecordActionButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(recordCell:tapedBtn:)]) {
        [_delegate recordCell:self tapedBtn:self.btnConnect];
    }
}


- (IBAction)btnTransmitTap:(RecordActionButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(recordCell:tapedBtn:)]) {
        [_delegate recordCell:self tapedBtn:self.btnTransmit];
    }
}


- (IBAction)btnReplyTap:(RecordActionButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(recordCell:tapedBtn:)]) {
        [_delegate recordCell:self tapedBtn:self.btnReply];
    }
}


- (void)setHelpStyle
{
    self.btnConnect.hidden = YES;
    self.btnTransmit.frame = CGRectOffset(self.btnTransmit.frame, -30, 0);
    self.btnReply.frame = CGRectOffset(self.btnReply.frame, -30, 0);
}


@end
