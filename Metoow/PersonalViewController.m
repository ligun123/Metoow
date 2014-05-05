//
//  PersonalViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-19.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

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
    self.btnBack.hidden = _isMe;
    self.btnMessage.hidden = _isMe;
    self.btnFocus.hidden = _isMe;
    self.titleLabel.text = _isMe ? @"我的资料" : @"个人资料";
    [self requestUserInfo];
}

- (void)requestUserInfo
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *act = nil;
    NSDictionary *para = nil;
    if (self.user_id) {
        act = Mod_User_info;
        para = @{@"user_id": self.user_id};
    } else {
        act = Mod_User_myinfo;
        para = nil;
    }
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_User act:act Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            NSDictionary *data = responseObject[@"data"];
            [self layoutWithResponse:data];
        } else {
            [[responseObject error] showAlert];
        }
        NSLog(@"%s -> %@", __FUNCTION__, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

//将返回的数据显示到界面上
- (void)layoutWithResponse:(NSDictionary *)data
{
    NSString *uname = data[@"uname"];
    self.nameLabel.text = uname;
    
    NSString *headerURL = data[@"avatar_original"];
    [self.headerImgView setImageWithURL:[NSURL URLWithString:headerURL]];
    
    NSInteger sex = [data[@"sex"] integerValue];
    [self.sexImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sex%d", sex]]];
    
    NSString *locate = data[@"location"];
    self.introLabel.text = locate;
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

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMyFootsTap:(id)sender {
}
@end
