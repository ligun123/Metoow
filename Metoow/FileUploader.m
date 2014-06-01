//
//  FileUploader.m
//  Metoow
//
//  Created by HalloWorld on 14-5-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "FileUploader.h"

#import "APIHelper.h"

@implementation FileUploader

+ (AFHTTPRequestOperationManager *)uploadTo:(UploadCategary)categary images:(NSArray *)aImgArr finished:(void(^)(NSArray *resultList))block;
{
    NSString *urlstring = [APIHelper urlUploadForCategary:categary];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block int count = aImgArr.count;
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < count; i ++) {
        AFHTTPRequestOperation *operation = [manager POST:urlstring parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            UIImage *img = aImgArr[i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.7) name:@"uploadfile" fileName:@"uploadfile.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
            count --;
            NSDictionary *dic =@{@"index": operation.userInfo[@"index"], @"response" : responseObject};
            [results addObject:dic];
            if (count == 0) {
                if (block) {
                    block(results);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%s -> %@", __FUNCTION__, error);
            count --;
            NSDictionary *dic =@{@"index": operation.userInfo[@"index"], @"response" : @{@"code": @"101", @"data" : @"server error", @"msg" : @"server error"}};
            [results addObject:dic];
            if (count == 0) {
                if (block) {
                    block(results);
                }
            }
        }];
        operation.userInfo = @{@"index":  [NSNumber numberWithInt:i]};
    }
    return manager;
}

@end
