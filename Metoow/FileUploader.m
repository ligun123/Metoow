//
//  FileUploader.m
//  Metoow
//
//  Created by HalloWorld on 14-5-28.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "FileUploader.h"
#import "AFHTTPRequestOperationManager.h"
#import "APIHelper.h"

@implementation FileUploader

- (void)uploadTo:(UploadCategary)categary images:(NSArray *)aImgArr finished:(void(^)(NSArray *errorList))block;
{
    NSString *urlstring = [APIHelper urlUploadForCategary:categary];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block int count = aImgArr.count;
    NSMutableArray *errors = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < count; i ++) {
        AFHTTPRequestOperation *operation = [manager POST:urlstring parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            UIImage *img = aImgArr[i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.7) name:@"uploadfile" fileName:@"uploadfile.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
            count --;
            if ([responseObject isOK]) {
            } else {
                NSError *err = [responseObject error];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:operation.userInfo];
                [dic setObject:err forKey:@"error"];
                [errors addObject:dic];
            }
            if (count == 0) {
                if (block) {
                    block(errors);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%s -> %@", __FUNCTION__, error);
            count --;
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:operation.userInfo];
            [dic setObject:error forKey:@"error"];
            [errors addObject:dic];
            if (count == 0) {
                if (block) {
                    block(errors);
                }
            }
        }];
        operation.userInfo = @{@"index":  [NSNumber numberWithInt:i]};
    }
}

@end
