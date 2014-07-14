//
//  HeaderUpdater.m
//  Metoow
//
//  Created by HalloWorld on 14-7-14.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HeaderUpdater.h"

@implementation HeaderUpdater


- (instancetype)initWithDelegate:(id<HeaderUpdaterProtocol>)dlgt
{
    self = [super init];
    if (self) {
        self.delegate = dlgt;
    }
    return self;
}

- (void)chooseHeader
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [sheet showInView:[AppDelegateInterface window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相册
        [AppDelegateInterface setTabBarHidden:YES];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [[AppDelegateInterface rootViewController] presentViewController:picker animated:YES completion:nil];
    }
    if (buttonIndex == 1) {
        //拍照
        [AppDelegateInterface setTabBarHidden:YES];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [[AppDelegateInterface rootViewController] presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [AppDelegateInterface setTabBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [self updateHeader:img];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [AppDelegateInterface setTabBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateHeader:(UIImage *)img
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = [APIHelper packageMod:Mod_User act:Mod_User_upload_face Paras:nil];
    [manager POST:API_URL parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.7) name:@"uploadfile" fileName:@"userface.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (_delegate && [_delegate respondsToSelector:@selector(updateHeaderSuccess:)]) {
                [_delegate updateHeaderSuccess:img];
            }
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[NSError errorWithDomain:@"网络连接超时，请稍后重试。" code:100 userInfo:nil] showAlert];
    }];
}

@end
