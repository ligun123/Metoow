//
//  LoginViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-10.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "LoginViewController.h"

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:YES];
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
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[APIHelper url] parameters:[APIHelper OauthParasUid:@"376438624@qq.com" passwd:@"5815057"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isOK]) {
            NSDictionary *dic = responseObject[@"data"];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
            [manager GET:[APIHelper url] parameters:[APIHelper packageMod:@"Login" act:@"login" Paras:@{@"uname": @"376438624@qq.com", @"upwd" : @"5815057"}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject isOK]) {
                    [self dismissModalViewControllerAnimated:YES];
                } else {
                    [[responseObject error] showAlert];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [error showAlert];
            }];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}


@end
