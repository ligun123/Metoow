//
//  PersonalViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-19.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MyFootViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:!_isMe];
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
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

//将返回的数据显示到界面上
- (void)layoutWithResponse:(NSDictionary *)data
{
    self.user_id = data[@"uid"];
    NSString *uname = data[@"uname"];
    self.nameLabel.text = uname;
    
    NSString *headerURL = data[@"avatar_original"];
    [self.headerImgView setImageWithURL:[NSURL URLWithString:headerURL]];
    
    NSInteger sex = [data[@"sex"] integerValue];
    [self.sexImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sex%d", sex]]];
    
    NSString *tag = data[@"tag"];
    if (![tag isKindOfClass:[NSNull class]]) {
        self.introLabel.text = tag;
    } else self.introLabel.text = @"未设置个性标签";
    
    
    self.addrLabel.text = data[@"location"];
    
    self.fansNOLabel.text = [data[@"follower_count"] stringValue];
    self.focusNOLabel.text = [data[@"following_count"] stringValue];
    is_follow = [data[@"is_follow"] boolValue];
    if (is_follow == FALSE) {
        [self.btnFocus setTitle:@"关注" forState:UIControlStateNormal];
    } else {
        [self.btnFocus setTitle:@"取消关注" forState:UIControlStateNormal];
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

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMyFootsTap:(id)sender {
    MyFootViewController *myfoot = [AppDelegateInterface awakeViewController:@"MyFootViewController"];
    myfoot.user_id = self.user_id;
    [self.navigationController pushViewController:myfoot animated:YES];
}

- (IBAction)btnFocusTap:(id)sender
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = @{@"is_follow": [NSNumber numberWithBool:!is_follow], @"user_id" : self.user_id};
    [manager GET:API_URL parameters:[APIHelper packageMod:@"Userfocus" act:@"follow_create" Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            is_follow = !is_follow;
            if (is_follow) {
                [self.btnFocus setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [self.btnFocus setTitle:@"关注" forState:UIControlStateNormal];
            }
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}


- (IBAction)btnMessageTap:(id)sender
{
    MSGSessionViewController *session = [AppDelegateInterface awakeViewController:@"MSGSessionViewController"];
    session.frdName = self.nameLabel.text;
    session.frdUid = self.user_id;
    [self.navigationController pushViewController:session animated:YES];
}

@end
