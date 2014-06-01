//
//  ReplyCell.h
//  Metoow
//
//  Created by HalloWorld on 14-6-1.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWCell.h"
#import "RichLabelView.h"

@interface ReplyCell : HWCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet RichLabelView *content;

@end
