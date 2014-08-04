//
//  RecordCell.h
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCell.h"
#import "RecordActionButton.h"
#import "RichLabelView.h"

@class RecordCell;

@protocol RecordCellProtocol <NSObject>

- (void)recordCell:(RecordCell *)cell tapedBtn:(RecordActionButton *)btn;

@end

@interface RecordCell : HWCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UIImageView *hasPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *locate;
@property (weak, nonatomic) IBOutlet RichLabelView *content;
@property (weak, nonatomic) IBOutlet RecordActionButton *btnConnect;        //收藏
@property (weak, nonatomic) IBOutlet RecordActionButton *btnTransmit;       //转发
@property (weak, nonatomic) IBOutlet RecordActionButton *btnReply;

@property (weak, nonatomic) id <RecordCellProtocol> delegate;

- (IBAction)btnConnectTap:(RecordActionButton *)sender;
- (IBAction)btnTransmitTap:(RecordActionButton *)sender;
- (IBAction)btnReplyTap:(RecordActionButton *)sender;

- (CGFloat)realHeight;

- (void)setHelpStyle;           //互助显示模式，影藏收藏按钮，调整转发、回复按钮位置

@end
