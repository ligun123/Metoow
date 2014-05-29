//
//  PicRollView.m
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-1-2.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PicRollView.h"

@implementation PicRollView

- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)aImgArray {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSUInteger vCount = [aImgArray count];
        for (int vIndex = 0; vIndex < vCount; vIndex ++) {
            UIImageView *vImgView = [[UIImageView alloc] initWithFrame:CGRectMake(vIndex * PICROLLVIEW_WIDTH, 0, PICROLLVIEW_WIDTH, PICROLLVIEW_HEIGHT)];
            vImgView.image = [aImgArray objectAtIndex:vIndex];
            [self addSubview:vImgView];
            self.contentSize = CGSizeMake(PICROLLVIEW_WIDTH * vCount, PICROLLVIEW_HEIGHT);
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentSize = self.frame.size;
}

- (void)addImage:(UIImage *)img
{
    [self.mImageArray addObject:img];
    for (id subview in [self subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    [self drawImages];
}

- (NSMutableArray *)mImageArray
{
    if (_mImageArray == nil) {
        _mImageArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _mImageArray;
}

- (void)setImageArray:(NSArray *)aArray {
    [self.mImageArray setArray:aArray];
    for (id subview in [self subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    [self drawImages];
}


- (void)drawImages{
    NSUInteger vCount = [self.mImageArray count];
    for (int vIndex = 0; vIndex < vCount; vIndex ++) {
        UIImageView *vImgView = [[UIImageView alloc] initWithFrame:CGRectMake(vIndex * PICROLLVIEW_WIDTH, 0, PICROLLVIEW_WIDTH, PICROLLVIEW_HEIGHT)];
        vImgView.image = [self.mImageArray objectAtIndex:vIndex];
        [self addSubview:vImgView];
        self.contentSize = CGSizeMake(PICROLLVIEW_WIDTH * vCount, PICROLLVIEW_HEIGHT);
        vImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        vImgView.layer.borderWidth = 2.0f;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
