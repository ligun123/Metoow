//
//  FootViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "FootViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FootPubViewController.h"
#import "FootDetailViewController.h"
#import "MyFootViewController.h"


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
    self.btnSOS.layer.borderWidth = 2.0f;
    self.btnSOS.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnSOS.layer.cornerRadius = 3.f;
    page = 1;
    selectIndex = 0;
    self.heightCounter = [[RichLabelView alloc] initWithFrame:CGRectMake(0, 0, 300, 24)];
    [self.pullDownBtn setTitles:@[@"所有足迹", @"我的足迹", @"我关注的", @"我收藏的", @"我的路况", @"所有路况"]];
    [self.pullDownBtn setCallbackBlock:^(PulldownButton *btn, NSInteger sltIndex) {
        if (sltIndex == 1) {
            [btn setTitle:btn.pullList[selectIndex] forState:UIControlStateNormal];
            MyFootViewController *myfoot = [AppDelegateInterface awakeViewController:@"MyFootViewController"];
            myfoot.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            [self.navigationController pushViewController:myfoot animated:YES];
        } else {
            if (selectIndex != sltIndex) {
                page = 1;
                [self.dataList removeAllObjects];
                selectIndex = sltIndex;
                [self refreshData];
            }
        }
    }];
    [self refreshData];
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableView;
    self.headerView.delegate = self;
    self.searchList = [NSMutableArray arrayWithCapacity:10];
    
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

- (IBAction)btnPublishTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发布足迹", @"发布路况", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //发布足迹
        FootPubViewController *pub = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
        [self.navigationController pushViewController:pub animated:YES];
    }
    if (buttonIndex == 1) {
        //发布路况
        FootPubViewController *pub = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
        pub.editCategary = FootPubEditCategaryWeather;
        [self.navigationController pushViewController:pub animated:YES];
    }
}

#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isCellRegesterd) {
        isCellRegesterd = YES;
        [tableView registerNib:[RecordCell nib] forCellReuseIdentifier:[RecordCell identifier]];
        [tableView registerNib:[RoadCell nib] forCellReuseIdentifier:[RoadCell identifier]];
    }
    if (selectIndex < 4) {
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordCell identifier]];
        cell.delegate = self;
        NSDictionary *dic = nil;
        if (isSearching) {
            dic = self.searchList[indexPath.row];
        } else {
            dic = self.dataList[indexPath.row];
        }
        
        NSDictionary *userInfo = dic[@"user_info"];
        [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
        [cell.userName setText:userInfo[@"uname"]];
        cell.time.text = [dic[@"time"] apiDate];
        [cell.btnConnect setSelected:[dic[@"is_colslect"] boolValue]];
        [cell.btnConnect setTitle:dic[@"collect_count"] forState:UIControlStateNormal];
        [cell.btnTransmit setTitle:dic[@"share_count"] forState:UIControlStateNormal];
        [cell.btnReply setTitle:dic[@"comment_count"] forState:UIControlStateNormal];
        [cell.content showStringMessage:dic[@"desc"]];
        return cell;
    } else {
        RoadCell *cell = [tableView dequeueReusableCellWithIdentifier:[RoadCell identifier]];
        NSDictionary *dic = nil;
        if (isSearching) {
            dic = self.searchList[indexPath.row];
        } else {
            dic = self.dataList[indexPath.row];
        }
        
        NSDictionary *userInfo = dic[@"user_info"];
        [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
        [cell.userName setText:userInfo[@"uname"]];
        cell.time.text = [dic[@"time"] apiDate];
        [cell.content showStringMessage:dic[@"desc"]];
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return self.searchList.count;
    }
    return self.dataList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = nil;
    if (isSearching) {
        dic = self.searchList[indexPath.row];
    } else {
        dic = self.dataList[indexPath.row];
    }
    
    FootDetailViewController *footDetailVC = [AppDelegateInterface awakeViewController:@"FootDetailViewController"];
    footDetailVC.detailDic = dic;
    if (selectIndex < 3) {
        footDetailVC.detailCategary = FootDetailCategaryFoot;
    } else {
        footDetailVC.detailCategary = FootDetailCategaryRoad;
    }
    [self.navigationController pushViewController:footDetailVC animated:YES];
}


- (void)recordCell:(RecordCell *)cell tapedBtn:(RecordActionButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (cell.btnConnect == btn) {
        [self connectFootAt:indexPath];
    } else if (cell.btnTransmit == btn) {
        [self transmitFootAt:indexPath];
    } else if (cell.btnReply == btn) {
        [self replyFootAt:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    if (isSearching) {
        dic = self.searchList[indexPath.row];
    } else {
        dic = self.dataList[indexPath.row];
    }
    
    if (selectIndex < 4) {
        return [RecordCell height] + [self.heightCounter sizeForContent:dic[@"desc"]].height;
    } else {
        return [RoadCell height] + [self.heightCounter sizeForContent:dic[@"desc"]].height;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((selectIndex == 1 || selectIndex == 4) && !isSearching) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (selectIndex == 1) {
            [self deleteFootAtIndex:indexPath];
        }
        if (selectIndex == 4) {
            [self deleteRoadAtIndex:indexPath];
        }
    }
}


- (void)deleteRoadAtIndex:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    NSDictionary *dic = self.dataList[indexPath.row];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Weather act:Mod_Weather_del Paras:@{@"id": dic[@"id"]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            [self.dataList removeObject:dic];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)deleteFootAtIndex:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    NSDictionary *dic = self.dataList[indexPath.row];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_del Paras:@{@"id": dic[@"id"]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            [self.dataList removeObject:dic];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    [self refreshData];
}

- (void)refreshFooter
{
    if (self.dataList.count < kCountLoadDefaul * page) {
        [self.footerView endRefreshing];
        return ;
    }
    page ++;
    [self refreshData];
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}


- (void)refreshData
{
    if (selectIndex == 0) {
        //所有足迹
        [self requestAllFoot];
    } else if (selectIndex == 1) {
        //我的足迹
        [self requestMyFoot];
    } else if (selectIndex == 2) {
        //我关注的
        [self requestMyAttention];
    } else if (selectIndex == 3) {
        //我收藏的
        [self requestMyConnect];
    } else if (selectIndex == 4){
        //我的路况
        [self requestMyRoad];
    } else if (selectIndex == 5){
        [self requestAllRoad];
    }
}


- (void)requestAllFoot
{
    [SVProgressHUD show];
    NSDictionary *para = @{@"page": [NSNumber numberWithInteger:page]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_foot_list Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            if ([responseObject[@"code"] integerValue] != 1) {
                [[responseObject error] showAlert];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)requestMyFoot
{
    [SVProgressHUD show];
    NSDictionary *para = @{@"page": [NSNumber numberWithInteger:page]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_get_myfoot Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            if ([responseObject[@"code"] integerValue] != 1) {
                [[responseObject error] showAlert];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)requestMyAttention
{
    [SVProgressHUD show];
    NSDictionary *para = @{@"page": [NSNumber numberWithInteger:page]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_my_attention Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)requestMyConnect
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_foot_collect Paras:@{@"page": [NSNumber numberWithInteger:page]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)requestMyRoad
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL
      parameters:[APIHelper packageMod:Mod_Weather
                                   act:Mod_Weather_get_myweather
                                 Paras:@{@"page": [NSNumber numberWithInteger:page]}]
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)requestAllRoad
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL
      parameters:[APIHelper packageMod:Mod_Weather
                                   act:Mod_Weather_weather_list
                                 Paras:@{@"page": [NSNumber numberWithInteger:page]}]
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

#pragma mark - 收藏、转发、回复

- (void)connectFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self footAtIndex:indexPath];
    
    if (![dic[@"is_collect"] boolValue]) {
        [SVProgressHUD show];
        NSDictionary *para = @{@"id": dic[@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_collect Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                RecordCell *cell = (RecordCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.btnConnect setSelected:YES];
            } else {
                [[responseObject error] showAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showTimeoutAlert];
        }];
    } else {
        [SVProgressHUD show];
        NSDictionary *dic = self.dataList[indexPath.row];
        NSDictionary *para = @{@"id": dic[@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_no_collect Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                NSLog(@"%s -> %@", __FUNCTION__, responseObject);
                RecordCell *cell = (RecordCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.btnConnect setSelected:NO];
            } else {
                [[responseObject error] showAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showTimeoutAlert];
        }];
    }
}

- (void)transmitFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self footAtIndex:indexPath];
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryTransmit;
    publ.dataDic = dic;
    [self.navigationController pushViewController:publ animated:YES];
}

- (void)replyFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self footAtIndex:indexPath];
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryReply;
    publ.dataDic = dic;
    [self.navigationController pushViewController:publ animated:YES];
}


- (void)requestRoadDetail:(NSDictionary *)roadDic
{
    [SVProgressHUD show];
    NSDictionary *para = @{@"id": roadDic[@"id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Weather act:Mod_Weather_show Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            FootDetailViewController *footDetailVC = [AppDelegateInterface awakeViewController:@"FootDetailViewController"];
            footDetailVC.detailDic = responseObject[@"data"];
            footDetailVC.detailCategary = FootDetailCategaryRoad;
            [self.navigationController pushViewController:footDetailVC animated:YES];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


- (void)requestFootDetail:(NSDictionary *)footDic
{
    [SVProgressHUD show];
    NSDictionary *dic = @{@"id": footDic[@"id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_show Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            FootDetailViewController *footDetailVC = [AppDelegateInterface awakeViewController:@"FootDetailViewController"];
            footDetailVC.detailDic = responseObject[@"data"];
            footDetailVC.detailCategary = FootDetailCategaryFoot;
            [self.navigationController pushViewController:footDetailVC animated:YES];
        } else {
            [SVProgressHUD dismiss];
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [error showTimeoutAlert];
    }];
}


#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    isSearching = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    } else {
        /*
        if (textField.text.length == 0) {
            [self searchForWord:textField.text];
        }
         */
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    isSearching = NO;
    [self searchForWord:@""];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isSearching = textField.text.length > 0;
    [self searchForWord:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)searchForWord:(NSString *)word
{
    [self.searchList removeAllObjects];
    if (word.length > 0) {
        for (int i = 0; i < self.dataList.count; i ++) {
            NSDictionary *dic = self.dataList[i];
            NSString *content = dic[@"desc"];
            NSString *uname = dic[@"user_info"][@"uname"];
            if ([content rangeOfString:word].location != NSNotFound || [uname rangeOfString:word].location != NSNotFound) {
                [self.searchList addObject:dic];
            }
        }
    }
    [self.tableView reloadData];
}

- (NSDictionary *)footAtIndex:(NSIndexPath *)indexPath
{
    if (isSearching) {
        return self.searchList[indexPath.row];
    } else {
        return self.dataList[indexPath.row];
    }
}

@end
