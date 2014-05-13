//
//  FootViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "FootViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FootViewController ()

@end

@implementation FootViewController

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
    
    [self performSelector:@selector(displayLogin) withObject:nil afterDelay:0.05];
    [self.pullDownBtn setTitles:@[@"我的足迹", @"我关注的", @"我收藏的", @"我的路况"]];
    [self.pullDownBtn setCallbackBlock:^(NSInteger sltIndex) {
        selectIndex = sltIndex;
        [self refreshData];
    }];
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableView;
    self.headerView.delegate = self;
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableView;
    self.footerView.delegate = self;
}



- (void)displayLogin
{
    UIViewController *login = [AppDelegateInterface awakeViewController:@"LoginViewController"];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:login];
    navLogin.navigationBarHidden = YES;
    [self presentViewController:navLogin animated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isCellRegesterd) {
        isCellRegesterd = YES;
        [tableView registerNib:[RecordCell nib] forCellReuseIdentifier:[RecordCell identifier]];
    }
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordCell identifier]];
    
    NSDictionary *dic = self.dataList[indexPath.row];
    NSDictionary *userInfo = dic[@"user_info"];
    [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
    [cell.userName setText:userInfo[@"uname"]];
    cell.time.text = [dic[@"time"] apiDate];
    cell.content.text = dic[@"desc"];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RecordCell height];
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

#pragma mark - 上下拉刷新Delegate

// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.headerView) {
        //加载最新的
        [self refreshHeader];
    }
    if (refreshView == self.footerView) {
        //加载更多旧的
        [self refreshFooter];
    }
}

- (void)refreshHeader
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_foot_list Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.headerView endRefreshing];
        if ([responseObject isOK]) {
            self.dataList = responseObject[@"data"];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self.headerView endRefreshing];
    }];
}

- (void)refreshFooter
{
}


- (void)refreshData
{
    if (selectIndex == 0) {
        //我的足迹
        [self requestMyFoot];
    } else if (selectIndex == 1) {
        //我关注的
        [self requestMyAttention];
    } else if (selectIndex == 2) {
        //我收藏的
        [self requestMyConnect];
    } else {
        //我的路况
        [self requestMyRoad];
    }
}

- (void)requestMyFoot
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_get_myfoot Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.dataList = responseObject[@"data"];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

- (void)requestMyAttention
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_my_attention Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.dataList = responseObject[@"data"];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

- (void)requestMyConnect
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_foot_collect Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.dataList = responseObject[@"data"];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

- (void)requestMyRoad
{
    NSLog(@"%s -> ", __FUNCTION__);
}


@end
