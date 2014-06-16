//
//  SelectLabelViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SelectLabelViewController.h"
#import "FootViewController.h"

@interface SelectLabelViewController ()

@end

@implementation SelectLabelViewController

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
    self.scrollView.contentSize = CGSizeMake(320, 485);
}

- (NSMutableArray *)selectLabels
{
    if (_selectLabels == nil) {
        _selectLabels = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _selectLabels;
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

#pragma mark - actions

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneTap:(id)sender {
    NSArray *tags = [self mytags];
    if (tags.count > 5) {
        [[NSError errorWithDomain:@"最多能添加5个标签" code:100 userInfo:nil] showAlert];
        return ;
    } else {
        [SVProgressHUD show];
        NSString *uid = self.userRegister[@"uid"];
        NSDictionary *para = @{@"id": uid, @"user_tags" : [tags componentsJoinedByString:@","]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Login act:Mod_Login_set_tags Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                [self authAndLogin];
            } else {
                [[responseObject error] showAlert];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showAlert];
        }];
    }
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)authAndLogin
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[APIHelper url] parameters:[APIHelper OauthParasUid:self.userRegister[@"login"] passwd:self.password] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isOK]) {
            NSDictionary *dic = responseObject[@"data"];
            //kOauth_Token 将token信息注册到userDefaults
            [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
            [manager GET:[APIHelper url] parameters:[APIHelper packageMod:@"Login" act:@"login" Paras:@{@"uname": self.userRegister[@"login"], @"upwd" : self.password}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject isOK]) {
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


- (NSArray *)mytags
{
    NSArray *arr = nil;
    if (self.customTagText.text.length > 0) {
        NSMutableString *cus = [NSMutableString stringWithString:self.customTagText.text];
        [cus replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, cus.length)];
        [cus replaceOccurrencesOfString:@"，" withString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(0, cus.length)];
        arr = [cus componentsSeparatedByString:@","];
    }
    
    NSMutableArray *mutiTags = [NSMutableArray arrayWithArray:arr];
    
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[SelectLabel class]]) {
            if ([view isSelected]) {
                [mutiTags addObject:[view titleForState:UIControlStateNormal]];
            }
        }
    }
    return mutiTags;
}

@end
