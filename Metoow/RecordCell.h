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


@interface RecordCell : HWCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet RecordActionButton *btnConnect;        //收藏
@property (weak, nonatomic) IBOutlet RecordActionButton *btnTransmit;       //转发
@property (weak, nonatomic) IBOutlet RecordActionButton *btnReply;


@end
