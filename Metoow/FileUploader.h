//
//  FileUploader.h
//  Metoow
//
//  Created by HalloWorld on 14-5-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

/*  批量上传图片如下调用
 FileUploader *fu = [[FileUploader alloc] init];
 NSArray *imgs = @[[UIImage imageNamed:@"test0.jpg"], [UIImage imageNamed:@"test1.jpg"], [UIImage imageNamed:@"test2.jpg"]];
 [fu uploadTo:UploadCategaryFoot images:imgs finished:^(NSArray *errorList) {
 if (errorList.count > 0) {
 [[NSError errorWithDomain:@"图片上传出错" code:101 userInfo:nil] showAlert];
 }
 }];
 */

#import <Foundation/Foundation.h>

typedef enum {
    UploadCategaryFoot,
    UploadCategaryHuzhu,
    UploadCategaryWeather
} UploadCategary;

@interface FileUploader : NSObject


/**
 *  批量上传图片
 *
 *  @param categary 上传到目标模块
 *  @param aImgArr  UIImage数组
 *  @param block    所有的图片都上传通信完成后回调，errorList是NSDictionary数组，@{@“index” : NSNumber, @"error" : NSerror}
 */
- (void)uploadTo:(UploadCategary)categary images:(NSArray *)aImgArr finished:(void(^)(NSArray *errorList))block;

@end
