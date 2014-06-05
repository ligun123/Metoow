//
//  HuzhuCell.h
//  Metoow
//
//  Created by HalloWorld on 14-5-26.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWCell.h"
#import "RecordActionButton.h"
#import "RichLabelView.h"

@class HuzhuCell;

@protocol HuzhuCellProtocol <NSObject>

- (void)huzhuCell:(HuzhuCell *)cell tapBtn:(RecordActionButton *)btn;

@end

@interface HuzhuCell : HWCell


@property (weak, nonatomic) id<HuzhuCellProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet RichLabelView *content;
@property (weak, nonatomic) IBOutlet RecordActionButton *btnTransmit;       //转发
@property (weak, nonatomic) IBOutlet RecordActionButton *btnReply;          //回复


- (IBAction)btnTransmitTap:(RecordActionButton *)sender;
- (IBAction)btnReplyTap:(RecordActionButton *)sender;

@end
