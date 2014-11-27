//
//  SOSPeopleViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-7-24.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SOSPeopleViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PersonalViewController.h"

@interface SOSPeopleViewController ()

@end

@implementation SOSPeopleViewController

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
    page = 1;
    //上下拉刷新加载
    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self requestPeoples];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)requestPeoples
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //, @"page" : [NSNumber numberWithInteger:page]
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_SOS act:Mod_SOS_sos_pation Paras:@{@"sos_id": self.sos_id}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableview reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

#pragma mark - 上下拉刷新Delegate

// 开始进入刷新状态就会调用
- (void)headerRereshing
{
    [self refreshHeader];
}


- (void)footerRereshing
{
    [self refreshFooter];
}

- (void)endRefresh
{
    if ([self.tableview isHeaderRefreshing]) {
        [self.tableview headerEndRefreshing];
    }
    
    if ([self.tableview isFooterRefreshing]) {
        [self.tableview footerEndRefreshing];
    }
}

- (void)refreshHeader
{
    page = 1;
    [self requestPeoples];
}

- (void)refreshFooter
{
    if (self.dataList.count < kCountLoadDefaul * page) {
        [self.tableview footerEndRefreshing];
        return ;
    }
    page ++;
    [self requestPeoples];
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!hasLoadCell) {
        hasLoadCell = YES;
        [tableView registerNib:[PersonCell nib] forCellReuseIdentifier:[PersonCell identifier]];
    }
    return [self personCellForTable:tableView atIndexPath:indexPath];
}


- (UITableViewCell *)personCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataList[indexPath.row][@"user_info"];
    NSString *hurl = dic[@"avatar_original"];
    [cell.headerView setImageWithURL:[NSURL URLWithString:hurl]];
    cell.titleLabel.text = dic[@"uname"];
    NSString *tag = dic[@"tag"];
    if (![tag isKindOfClass:[NSNull class]]) {
        cell.contentLabel.text = dic[@"tag"];
    } else cell.contentLabel.text = dic[@"未设置个性标签"];
    NSInteger sex = [dic[@"sex"] integerValue];
    NSString *sexImg = [NSString stringWithFormat:@"sex%d.png", sex];
    UIImage *simg = [UIImage imageNamed:sexImg];
    [cell.sexImgView setImage:simg];
    
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
    NSDictionary *dic = self.dataList[indexPath.row];
    NSString *uid = dic[@"uid"];
    PersonalViewController *pers = [AppDelegateInterface awakeViewController:@"PersonalViewController"];
    pers.user_id = uid;
    pers.isMe = [uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    pers.hideTabBar = YES;
    [self.navigationController pushViewController:pers animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonCell height];
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

@end
