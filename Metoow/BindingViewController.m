//
//  BindingViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-6-23.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "BindingViewController.h"
#import "FootViewController.h"

@interface BindingViewController ()

@end

@implementation BindingViewController

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

- (IBAction)btnBindTap:(id)sender
{
    if (self.userIDText.text.length == 0 || self.pswdText.text.length == 0) {
        [[NSError errorWithDomain:@"请输入正确的用户名和密码" code:100 userInfo:nil] showAlert];
    }
    [SVProgressHUD show];
    __block AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    [manager GET:API_URL parameters:[APIHelper OauthParasUid:self.userIDText.text passwd:self.pswdText.text]
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ([responseObject isOK]) {
                 NSDictionary *dic = responseObject[@"data"];
                 [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
                 
                 NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
                 NSString *type = _auth_type == 1 ? @"sina" : @"qzone";
                 NSDictionary *para = @{@"type": type, @"is_sync" : [NSNumber numberWithInteger:1], @"user_id" : self.user_id, @"uid" : uid};
                 [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Login act:Mod_Login_mett_binding_app Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [SVProgressHUD dismiss];
                     if ([responseObject isOK]) {
                         [self didLoginSeccuss];
                     } else {
                         [[responseObject error] showAlert];
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [SVProgressHUD dismiss];
                     [error showTimeoutAlert];
                 }];
             } else {
                 [SVProgressHUD dismiss];
                 [[responseObject error] showAlert];
             }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];
             [error showTimeoutAlert];
    }];
    
}


- (void)didLoginSeccuss
{
    [AppDelegateInterface setHasLogin:YES];
    [AppDelegateInterface bindBPush];
    for (id foot in self.navigationController.viewControllers) {
        if ([foot isKindOfClass:[FootViewController class]]) {
            [self.navigationController popToViewController:foot animated:YES];
            return ;
        }
    }
    UIViewController *zj = [AppDelegateInterface awakeViewController:@"FootViewController"];
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:zj animated:NO];
}


- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
