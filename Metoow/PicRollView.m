//
//  PicRollView.m
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-1-2.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PicRollView.h"
#import "UIImageView+AFNetworking.h"
#import "APIHelper.h"
#import "ScanImageViewController.h"

@implementation PicRollView

- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)aImgArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
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
        [vImgView setUserInteractionEnabled:YES];
        [vImgView setMultipleTouchEnabled:YES];
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

- (void)showMetoowPicIDs:(NSArray *)pic_ids
{
    int vCount = pic_ids.count;
    for (int i = 0; i < pic_ids.count; i ++) {
        NSString *picid = pic_ids[i];
        NSString *url = [APIHelper urlDownloadID:picid];
        UIImageView *vImgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * PICROLLVIEW_WIDTH, 0, PICROLLVIEW_WIDTH, PICROLLVIEW_HEIGHT)];
        [vImgView setImageWithURL:[NSURL URLWithString:url]];
        [self addSubview:vImgView];
        self.contentSize = CGSizeMake(PICROLLVIEW_WIDTH * vCount, PICROLLVIEW_HEIGHT);
        vImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        vImgView.layer.borderWidth = 2.0f;
        [vImgView setUserInteractionEnabled:YES];
        [vImgView setMultipleTouchEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanTapOnImgView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [vImgView addGestureRecognizer:tap];
    }
}

- (NSArray *)images
{
    if (self.mImageArray.count > 0) {
        return self.mImageArray;
    } else {
        for (id subview in self.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                CGSize s = [subview frame].size;
                if (s.width < 99.999 || s.height < 99.999) {
                    continue ;
                }
                UIImage *img = [subview image];
                [self.mImageArray addObject:img];
            }
        }
        return self.mImageArray;
    }
    return nil;
}


- (void)enableScan
{
    /*
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanTapOnImgView:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [subview addGestureRecognizer:tap];
            [(UIImageView *)subview setUserInteractionEnabled:YES];
            [(UIImageView *)subview setMultipleTouchEnabled:YES];
        }
    }
     */
}

- (void)scanTapOnImgView:(UITapGestureRecognizer *)tap
{
    UIImageView *imgv = (UIImageView *)tap.view;
    NSInteger index = [[self images] indexOfObject:imgv.image];
    ScanImageViewController *scan = [[ScanImageViewController alloc] init];
    [scan setImageArray:[self images] currentIndex:index];
    [[AppDelegateInterface rootViewController] presentViewController:scan animated:YES completion:nil];
}


- (void)enableDelete
{}


@end
