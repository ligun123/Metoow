//
//  DetailCell.h
//  Metoow
//
//  Created by HalloWorld on 14-5-21.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWCell.h"
#import "RichLabelView.h"
#import "PicRollView.h"

@interface DetailCell : HWCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet RichLabelView *content;
@property (weak, nonatomic) IBOutlet PicRollView *picScroll;

@property BOOL hasImages;

- (void)setHasImage:(BOOL)hi;

@end
