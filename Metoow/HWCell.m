//
//  HWCell.m
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HWCell.h"

@implementation HWCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height
{
    return 44.f;
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

+ (id)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:[self identifier] owner:nil options:nil] lastObject];
}

@end
