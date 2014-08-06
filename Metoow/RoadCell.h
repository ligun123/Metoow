//
//  RoadCell.h
//  Metoow
//
//  Created by HalloWorld on 14-6-19.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWCell.h"
#import "RichLabelView.h"

@interface RoadCell : HWCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *locate;
@property (weak, nonatomic) IBOutlet UIImageView *hasPic;
@property (weak, nonatomic) IBOutlet RichLabelView *content;

@end
