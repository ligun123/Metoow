//
//  LoginViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-10.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "LoginViewController.h"
#import "FootViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_RGB(188, 255, 201);
    [self.autoLoginCheck setChecked:[[NSUserDefaults standardUserDefaults] boolForKey:kBoolAutoLogin]];
    [self.rememberSecCheck setChecked:[[NSUserDefaults standardUserDefaults] boolForKey:kBoolRmbSec]];
    if (self.autoLoginCheck.checked || self.rememberSecCheck.checked) {
        self.userIDText.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserID];
        self.pswdText.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginPswd];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kBoolAutoLogin]) {
        [self btnLoginTap:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Actions


- (IBAction)btnLoginTap:(id)sender
{
    //如果userid和密码都为空则直接返回
    if (!(self.userIDText.text.length > 0 && self.pswdText.text.length > 0)) {
        [[NSError errorWithDomain:@"账号或密码为空" code:100 userInfo:nil] showAlert];
        return ;
    }
    if (self.autoLoginCheck.checked) {
        [[NSUserDefaults standardUserDefaults] setObject:self.userIDText.text forKey:kLoginUserID];
        [[NSUserDefaults standardUserDefaults] setObject:self.pswdText.text forKey:kLoginPswd];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBoolAutoLogin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBoolRmbSec];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBoolAutoLogin];
        if (self.rememberSecCheck.checked) {
            [[NSUserDefaults standardUserDefaults] setObject:self.userIDText.text forKey:kLoginUserID];
            [[NSUserDefaults standardUserDefaults] setObject:self.pswdText.text forKey:kLoginPswd];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBoolRmbSec];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginPswd];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUserID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBoolRmbSec];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[APIHelper url] parameters:[APIHelper OauthParasUid:self.userIDText.text passwd:self.pswdText.text] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isOK]) {
            NSDictionary *dic = responseObject[@"data"];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
            [manager GET:[APIHelper url] parameters:[APIHelper packageMod:@"Login" act:@"login" Paras:@{@"uname": self.userIDText.text, @"upwd" : self.pswdText.text}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject isOK]) {
                    [AppDelegateInterface setHasLogin:YES];
                    for (id foot in self.navigationController.viewControllers) {
                        if ([foot isKindOfClass:[FootViewController class]]) {
                            [self.navigationController popToViewController:foot animated:YES];
                        }
                    }
                } else {
                    [[responseObject error] showAlert];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [error showAlert];
            }];
        } else {
            [SVProgressHUD dismiss];
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
