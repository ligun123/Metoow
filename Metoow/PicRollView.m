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
        if (aImgArray == nil) {
            //测试代码,放空图片
            int vCount = 5;
            for (int vIndex = 0; vIndex < vCount; vIndex ++) {
                UIImageView *vImgView = [[UIImageView alloc] initWithFrame:CGRectMake(vIndex * PICROLLVIEW_WIDTH, 0, PICROLLVIEW_WIDTH, PICROLLVIEW_HEIGHT)];
                vImgView.backgroundColor = (vIndex % 2 == 0) ? [UIColor blueColor] : [UIColor brownColor];
                [self addSubview:vImgView];
                SAFE_ARC_RELEASE(vImgView);
                self.contentSize = CGSizeMake(PICROLLVIEW_WIDTH * vCount, PICROLLVIEW_HEIGHT);
            }
        } else {
            int vCount = [aImgArray count];
            for (int vIndex = 0; vIndex < vCount; vIndex ++) {
                UIImageView *vImgView = [[UIImageView alloc] initWithFrame:CGRectMake(vIndex * PICROLLVIEW_WIDTH, 0, PICROLLVIEW_WIDTH, PICROLLVIEW_HEIGHT)];
                vImgView.image = [aImgArray objectAtIndex:vIndex];
                [self addSubview:vImgView];
                SAFE_ARC_RELEASE(vImgView);
                self.contentSize = CGSizeMake(PICROLLVIEW_WIDTH * vCount, PICROLLVIEW_HEIGHT);
            }
        }
    }
    return self;
}

- (void)awakeFromNib {
    self.contentSize = self.frame.size;
}

- (void)setImageArray:(NSArray *)aArray {
    self.mImageArray = aArray;
    [self drawImages];
}


- (void)drawImages{
    for (id subview in [self subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    int vCount = [self.mImageArray count];
    for (int vIndex = 0; vIndex < vCount; vIndex ++) {
        UIImageView *vImgView = [[UIImageView alloc] initWithFrame:CGRectMake(vIndex * PICROLLVIEW_WIDTH, 0, PICROLLVIEW_WIDTH, PICROLLVIEW_HEIGHT)];
        vImgView.image = [self.mImageArray objectAtIndex:vIndex];
        [self addSubview:vImgView];
        SAFE_ARC_RELEASE(vImgView);
        self.contentSize = CGSizeMake(PICROLLVIEW_WIDTH * vCount, PICROLLVIEW_HEIGHT);
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

- (void)dealloc {
    SAFE_ARC_SUPER_DEALLOC();
}

@end
