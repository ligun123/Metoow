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
#import "SelectLabelViewController.h"

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
    self.btnBack.hidden = !_hideTabBar;
    self.btnMessage.hidden = _isMe;
    self.btnFocus.hidden = _isMe;
    self.btnLogout.hidden = !_isMe;
    self.btnEdit.hidden = !_isMe;
    self.titleLabel.text = _isMe ? @"我的迷途" : @"个人资料";
    [self requestUserInfo];
    self.headerUpdate = [[HeaderUpdater alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:_hideTabBar];
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
    [[[UIImageView class] sharedImageCache] removeCacheForKey:headerURL];
    [self.headerImgView setImageWithURL:[NSURL URLWithString:headerURL]];
    
    NSInteger sex = [data[@"sex"] integerValue];
    [self.sexImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sex%d", sex]]];
    
    NSString *tag = data[@"tag"];
    if (![tag isKindOfClass:[NSNull class]]) {
        self.introLabel.text = tag;
    } else self.introLabel.text = @"未设置个性标签";
    
    
    self.addrLabel.text = data[@"location"];
    
    self.focusNOLabel.text = [data[@"feed_count"] stringValue];
    self.fansNOLabel.text = [data[@"following_count"] stringValue];
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

- (IBAction)btnLogoutTap:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    HWTabBarItem *zjItem = [[AppDelegateInterface tabBar] tabItems][0];
    [[AppDelegateInterface tabBar] tabBarItemTap:zjItem];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBoolAutoLogin];
    [AppDelegateInterface displayLogin];
}


- (IBAction)btnMessageTap:(id)sender
{
    MSGSessionViewController *session = [AppDelegateInterface awakeViewController:@"MSGSessionViewController"];
    session.frdName = self.nameLabel.text;
    session.frdUid = self.user_id;
    [self.navigationController pushViewController:session animated:YES];
}

- (IBAction)btnEditTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"编辑" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"头像", @"昵称", @"个人标签", nil];
    [sheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //编辑头像
        [self.headerUpdate chooseHeader];
    }
    if (buttonIndex == 1) {
        //编辑昵称
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入新昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
    if (buttonIndex == 2) {
        //个人标签
        SelectLabelViewController *slectLabel = [AppDelegateInterface awakeViewController:@"SelectLabelViewController"];
        slectLabel.isEditing = YES;
        [self.navigationController pushViewController:slectLabel animated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self changeNickName:[[alertView textFieldAtIndex:0] text]];
    }
}

- (void)updateHeaderSuccess:(UIImage *)header
{
    [self.headerImgView setImage:header];
}

- (void)changeNickName:(NSString *)nickname
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_User act:Mod_User_update_uname Paras:@{@"uname": nickname}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isOK]) {
            self.nameLabel.text = nickname;
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSError errorWithDomain:@"网络超时" code:100 userInfo:nil] showAlert];
    }];
}

@end
