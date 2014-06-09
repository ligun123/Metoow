//
//  LoginViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-10.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  登录

#import <UIKit/UIKit.h>
#import "LoginCheckBox.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
}
@property (weak, nonatomic) IBOutlet LoginCheckBox *autoLoginCheck;
@property (weak, nonatomic) IBOutlet LoginCheckBox *rememberSecCheck;
@property (weak, nonatomic) IBOutlet UITextField *userIDText;
@property (weak, nonatomic) IBOutlet UITextField *pswdText;

- (IBAction)btnQQAuthTap:(id)sender;

@end
