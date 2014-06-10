//
//  RegisterViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  注册

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) NSDictionary *areaDic;
@property (weak, nonatomic) IBOutlet UIButton *btnArea;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sex;

@property (copy, nonatomic) NSString *auth_user_id;     //第三方登陆的user_id
@property NSInteger auth_type;                          //第三方登陆类型1新浪，2腾讯

- (void)setAreaTitle;

@end
