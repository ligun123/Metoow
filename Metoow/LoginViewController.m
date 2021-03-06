//
//  LoginViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-10.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "LoginViewController.h"
#import "FootViewController.h"
#import "RegisterViewController.h"
#import <objc/runtime.h>
#import "BindingViewController.h"

@interface LoginViewController ()

@end

@interface UIAlertView (ThirdLogin)

@property (copy, nonatomic) NSString *user_id;
@property NSInteger auth_type;

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

- (void)dealloc
{
    self.tencentOAuth = nil;
    self.weiboOAuth = nil;
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    /*
    UIViewController *zj = [AppDelegateInterface awakeViewController:@"FootViewController"];
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:zj animated:NO];
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - QQ认证

- (IBAction)btnQQAuthTap:(id)sender
{
    NSArray *_permissions = [NSArray arrayWithObjects:
                             kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                             kOPEN_PERMISSION_ADD_ALBUM,
                             kOPEN_PERMISSION_ADD_IDOL,
                             kOPEN_PERMISSION_ADD_ONE_BLOG,
                             kOPEN_PERMISSION_ADD_PIC_T,
                             kOPEN_PERMISSION_ADD_SHARE,
                             kOPEN_PERMISSION_ADD_TOPIC,
                             kOPEN_PERMISSION_CHECK_PAGE_FANS,
                             kOPEN_PERMISSION_DEL_IDOL,
                             kOPEN_PERMISSION_DEL_T,
                             kOPEN_PERMISSION_GET_FANSLIST,
                             kOPEN_PERMISSION_GET_IDOLLIST,
                             kOPEN_PERMISSION_GET_INFO,
                             kOPEN_PERMISSION_GET_OTHER_INFO,
                             kOPEN_PERMISSION_GET_REPOST_LIST,
                             kOPEN_PERMISSION_LIST_ALBUM,
                             kOPEN_PERMISSION_UPLOAD_PIC,
                             kOPEN_PERMISSION_GET_VIP_INFO,
                             kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                             kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                             kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                             nil];
    
    [self.tencentOAuth authorize:_permissions inSafari:NO];
}

- (TencentOAuth *)tencentOAuth
{
    if (_tencentOAuth == nil) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppID
                                                andDelegate:self];
//        _tencentOAuth.redirectURI = @"www.qq.com";
    }
    return _tencentOAuth;
}

- (void)tencentDidLogin
{
	// 登录成功
    NSLog(@"%s -> accessToken : %@ ********** openid : %@", __FUNCTION__, _tencentOAuth.accessToken, _tencentOAuth.openId);
    NSString *user_id = self.tencentOAuth.openId;
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //app_login_type: sina=新浪，qzone=腾讯
    NSDictionary *para = @{@"app_token": user_id, @"app_login_type" : @"qzone"};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Login act:Mod_Login_app_login Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            NSLog(@"%s -> %@", __FUNCTION__, responseObject);
            [[NSUserDefaults standardUserDefaults] registerDefaults:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(didLoginSeccuss) withObject:nil afterDelay:1.f];
            });
            
        } else {
            if ([responseObject[@"code"] integerValue] == 20001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"绑定迷途账号" otherButtonTitles:@"注册迷途账号", nil];
                [alert setUser_id:user_id];
                [alert setAuth_type:2];
                [alert show];
            } else {
                [[responseObject error] showAlert];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [[NSError errorWithDomain:@"腾讯认证取消" code:100 userInfo:nil] showAlert];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    [[NSError errorWithDomain:@"无法连接到网络" code:100 userInfo:nil] showAlert];
}


#pragma mark - Weibo认证

- (WBAuthorizeRequest *)weiboOAuth
{
    if (_weiboOAuth == nil) {
        _weiboOAuth =  [WBAuthorizeRequest request];
        _weiboOAuth.redirectURI = kWeiboRedirectURI;
        _weiboOAuth.scope = @"all";
    }
    return _weiboOAuth;
}

- (IBAction)btnWeiboAuthTap:(id)sender
{
    [WeiboSDK sendRequest:self.weiboOAuth];
}


- (void)weiboAuthUserID:(NSString *)user_id
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //app_login_type: sina新浪，qzone腾讯
    NSDictionary *para = @{@"app_token": user_id, @"app_login_type" : @"sina"};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Login act:Mod_Login_app_login Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            [self didLoginSeccuss];
        } else {
            if ([responseObject[@"code"] integerValue] == 20001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"绑定迷途账号" otherButtonTitles:@"注册迷途账号", nil];
                [alert setUser_id:user_id];
                [alert setAuth_type:1];
                [alert show];
                /*
                [[NSError errorWithDomain:@"第一次登陆请绑定迷途账号" code:100 userInfo:nil] showAlert];
                RegisterViewController *reg = [AppDelegateInterface awakeViewController:@"RegisterViewController"];
                reg.auth_user_id = user_id;
                reg.auth_type = 1;
                [self.navigationController pushViewController:reg animated:YES];
                 */
            } else {
                [[responseObject error] showAlert];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //绑定迷途账号
        BindingViewController *bind = [AppDelegateInterface awakeViewController:@"BindingViewController"];
        bind.user_id = alertView.user_id;
        bind.auth_type = alertView.auth_type;
        [self.navigationController pushViewController:bind animated:YES];
    }
    if (buttonIndex == 1) {
        //注册迷途账号
        RegisterViewController *reg = [AppDelegateInterface awakeViewController:@"RegisterViewController"];
        reg.auth_user_id = alertView.user_id;
        reg.auth_type = alertView.auth_type;
        [self.navigationController pushViewController:reg animated:YES];
    }
}


@end



@implementation UIAlertView (ThirdLogin)

static void *kUserID;
static void *kAuthType;

- (NSString *)user_id
{
    return objc_getAssociatedObject(self, &kUserID);
}

- (void)setUser_id:(NSString *)user_id
{
    objc_setAssociatedObject(self, &kUserID, user_id, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSInteger)auth_type
{
    return [objc_getAssociatedObject(self, &kAuthType) integerValue];
}

- (void)setAuth_type:(NSInteger)auth_type
{
    objc_setAssociatedObject(self, &kAuthType, [NSNumber numberWithInteger:auth_type], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
