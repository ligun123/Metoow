//
//  UIImage+Gif.m
//  Metoow
//
//  Created by HalloWorld on 14-5-12.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "UIImage+Gif.h"
#import <ImageIO/ImageIO.h>


@implementation UIImage (Gif)

+ (UIImage *)imageGifFilePath:(NSString *)path
{
    NSData *gifData = [NSData dataWithContentsOfFile: path];
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        CGImageRef img = CGImageSourceCreateImageAtIndex(src, 0, NULL);
        if (img) {
            return [UIImage imageWithCGImage:img];
        }
    }
    return nil;
}


@end
