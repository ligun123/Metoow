//
//  RegisterViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "RegisterViewController.h"
#import "SelectAreaViewController.h"
#import "NSError+Alert.h"
#import "SelectLabelViewController.h"
#import "IQKeyboardManager.h"
#import "JSONKit.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    NSData *areaData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"getarea" ofType:nil]];
    if (areaData) {
        NSDictionary *dic = [areaData objectFromJSONData];
        self.areaDic = dic[@"data"];
    }
    
    /*
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Login act:Mod_Login_getArea Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.areaDic = responseObject[@"data"];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAreaTitle
{
    [self.btnArea setTitle:[self cityNames] forState:UIControlStateNormal];
}

- (NSString *)cityNames
{
    NSDictionary *area0 = [[NSUserDefaults standardUserDefaults] objectForKey:[kAreaLevel stringByAppendingFormat:@"0"]];
    NSDictionary *area1 = [[NSUserDefaults standardUserDefaults] objectForKey:[kAreaLevel stringByAppendingFormat:@"1"]];
    NSDictionary *area2 = [[NSUserDefaults standardUserDefaults] objectForKey:[kAreaLevel stringByAppendingFormat:@"2"]];
    if (!(area0 == nil || area1 == nil || area2 == nil)) {
        NSString *names = [NSString stringWithFormat:@"%@ %@ %@", area0[@"title"], area1[@"title"], area2[@"title"]];
        return names;
    } else return @"";
}

- (NSString *)cityIds
{
    NSDictionary *area0 = [[NSUserDefaults standardUserDefaults] objectForKey:[kAreaLevel stringByAppendingFormat:@"0"]];
    NSDictionary *area1 = [[NSUserDefaults standardUserDefaults] objectForKey:[kAreaLevel stringByAppendingFormat:@"1"]];
    NSDictionary *area2 = [[NSUserDefaults standardUserDefaults] objectForKey:[kAreaLevel stringByAppendingFormat:@"2"]];
    if (!(area0 == nil || area1 == nil || area2 == nil)) {
        NSString *ids = [NSString stringWithFormat:@"%@,%@,%@", area0[@"id"], area1[@"id"], area2[@"id"]];
        return ids;
    } else return @"";
}

- (NSNumber *)sexNumber
{
    if (self.sex.selectedSegmentIndex == 0) {
        //男1， 女2
        return [NSNumber numberWithInt:1];
    }
    if (self.sex.selectedSegmentIndex == 1) {
        return [NSNumber numberWithInt:2];
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
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

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAreaTap:(id)sender {
    SelectAreaViewController *area = [[AppDelegateInterface mainStoryBoard] instantiateViewControllerWithIdentifier:@"SelectAreaViewController"];
    area.areaDic = self.areaDic;
    [self.navigationController pushViewController:area animated:YES];
}


- (IBAction)btnRegisterTap:(id)sender {
    if (![self.password.text isEqualToString:self.passwordAgain.text]) {
        [[NSError errorWithDomain:@"两次输入的密码必须保持一致" code:100 userInfo:nil] showAlert];
        return ;
    }
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *mailPre = [NSPredicate predicateWithFormat:@"SELF matches %@", strRegex];
    if (self.email.text.length == 0 || ![mailPre evaluateWithObject:self.email.text]) {
        [[NSError errorWithDomain:@"Email格式不正确" code:100 userInfo:nil] showAlert];
        return ;
    }
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"email": self.email.text, @"password" : self.password.text, @"uname" : self.nickname.text, @"sex" : [self sexNumber], @"city_names" : [self cityNames], @"city_ids" : [self cityIds]}];
    if (self.auth_user_id != nil && self.auth_type != 0) {
        [para setObject:self.auth_user_id forKey:@"app_token"];
        [para setObject:[NSNumber numberWithInteger:self.auth_type] forKey:@"register_type"];
    }
    
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Login act:Mod_Login_register Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            NSDictionary *dic = responseObject[@"data"];
            SelectLabelViewController *slectLabel = [[AppDelegateInterface mainStoryBoard] instantiateViewControllerWithIdentifier:@"SelectLabelViewController"];
            slectLabel.userRegister = dic;
            slectLabel.password = self.password.text;
            [self.navigationController pushViewController:slectLabel animated:YES];
        } else {
            [[responseObject error] showAlert];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

@end
