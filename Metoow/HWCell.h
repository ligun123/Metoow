//
//  HWCell.h
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  类名、文件名、identifier保持一致

#import <UIKit/UIKit.h>

@interface HWCell : UITableViewCell

+ (CGFloat)height;
+ (NSString *)identifier;
+ (UINib *)nib;
+ (id)loadFromNib;

@end
