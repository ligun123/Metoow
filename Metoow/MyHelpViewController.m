//
//  MyHelpViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MyHelpViewController.h"
#import "MessageView.h"
#import "HuzhuCell.h"
#import "UIImageView+AFNetworking.h"
#import "FootPubViewController.h"
#import "NSDictionary+Huzhu.h"
#import "HelpDetailViewController.h"

@interface MyHelpViewController ()

@end

@implementation MyHelpViewController

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
    page = 1;
    // Do any additional setup after loading the view.
    [self refresh];
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableview;
    self.headerView.delegate = self;
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableview;
    self.footerView.delegate = self;
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

- (void)refresh
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSDictionary *dic = @{@"uid": uid, @"page" : [NSNumber numberWithInteger:page]};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Huzhu act:Mod_Huzhu_get_hzlist Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!hasRegister) {
        hasRegister = YES;
        [tableView registerNib:[HuzhuCell nib] forCellReuseIdentifier:[HuzhuCell identifier]];
    }
    HuzhuCell *cell = [tableView dequeueReusableCellWithIdentifier:[HuzhuCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    NSDictionary *dic = [self huzhuAtIndex:indexPath];
    
    [cell.title setText:[dic huzhuTitle]];
//    [cell.content showStringMessage:dic[@"explain"]];
    cell.time.text= [dic[@"cTime"] apiDate];
    [cell.btnTransmit setTitle:dic[@"attentionCount"] forState:UIControlStateNormal];
    [cell.btnReply setTitle:dic[@"commentCount"] forState:UIControlStateNormal];
    NSDictionary *userInfo = dic[@"user_info"];
    [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
    cell.userName.text = userInfo[@"uname"];
    
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
    NSDictionary *dic = [self huzhuAtIndex:indexPath];
    HelpDetailViewController *detail = [AppDelegateInterface awakeViewController:@"HelpDetailViewController"];
    detail.detailDic = dic;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HuzhuCell height];
}


- (NSDictionary *)huzhuAtIndex:(NSIndexPath *)indexPath
{
    return self.dataList[indexPath.row];
}

- (void)huzhuCell:(HuzhuCell *)cell tapBtn:(RecordActionButton *)btn
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSDictionary *dic = [self huzhuAtIndex:indexPath];
    
    if (btn == cell.btnTransmit) {
        //转发
        FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
        publ.editCategary = FootPubEditCategaryTransmitHuzhu;
        publ.dataDic = dic;
        [self.navigationController pushViewController:publ animated:YES];
    }
    if (btn == cell.btnReply) {
        //回复
        FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
        publ.editCategary = FootPubEditCategaryReplyHuzhu;
        publ.dataDic = dic;
        [self.navigationController pushViewController:publ animated:YES];
    }

}


#pragma mark - 上下拉刷新

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}

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

- (void)endRefresh
{
    if ([self.headerView isRefreshing]) {
        [self.headerView endRefreshing];
    }
    if ([self.footerView isRefreshing]) {
        [self.footerView endRefreshing];
    }
}

- (void)refreshHeader
{
    page = 1;
    [self refresh];
}

- (void)refreshFooter
{
    if (self.dataList.count < kCountLoadDefaul * page) {
        [self.footerView endRefreshing];
        return ;
    }
    page ++;
    [self refresh];
}



@end
