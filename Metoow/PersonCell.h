//
//  PersonCell.h
//  Metoow
//
//  Created by HalloWorld on 14-5-3.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWCell.h"

@interface PersonCell : HWCell
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;

@end
