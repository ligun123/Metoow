//
//  HWCell.h
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWCell : UITableViewCell

+ (CGFloat)height;
+ (NSString *)identifier;
+ (UINib *)nib;
+ (id)loadFromNib;

@end
