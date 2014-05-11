//
//  FaceButton.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood
//


#import "FaceButton.h"
#import <ImageIO/ImageIO.h>

@implementation FaceButton


@synthesize buttonIndex = _buttonIndex;


- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageName:(NSString *)nm
{
    self.name = nm;
    NSString *gifPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"miniblog"] stringByAppendingPathComponent:[self.name stringByAppendingFormat:@".gif"]];
    NSData *gifData = [NSData dataWithContentsOfFile: gifPath];
    NSMutableArray *frames = nil;
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    double total = 0;
    NSTimeInterval gifAnimationDuration;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        if (l > 1){
            frames = [NSMutableArray arrayWithCapacity: l];
            for (size_t i = 0; i < l; i++) {
                CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                NSDictionary *dict = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, 0, NULL);
                if (dict){
                    NSDictionary *tmpdict = [dict objectForKey: @"{GIF}"];
                    total += [[tmpdict objectForKey: @"DelayTime"] doubleValue] * 100;
                    [dict release];
                }
                if (img) {
                    [frames addObject: [UIImage imageWithCGImage: img]];
                    CGImageRelease(img);
                }
            }
            gifAnimationDuration = total / 100;
            
            /*
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.animationImages = frames;
            imageView.animationDuration = gifAnimationDuration;
            [imageView startAnimating];
             */
            [self setImage:frames[0] forState:UIControlStateNormal];
        } else {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, 0, NULL);
            if (img) {
                [self setImage:[UIImage imageWithCGImage:img] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)dealloc
{
    self.name = nil;
    [super dealloc];
}

@end
