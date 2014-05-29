//
//  PicRollView.h
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-1-2.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PICROLLVIEW_HEIGHT 100.f
#define PICROLLVIEW_WIDTH 100.f

@interface PicRollView : UIScrollView

@property (nonatomic, retain) NSMutableArray *mImageArray;

- (void)setImageArray:(NSArray *)aArray;


- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)aImgArray;

- (void)addImage:(UIImage *)img;

@end
