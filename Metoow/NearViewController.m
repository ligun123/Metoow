//
//  NearViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "NearViewController.h"
#import "PersonCell.h"
#import "RecordCell.h"
#import "LocationManager.h"
#import "HuzhuCell.h"
#import "NSDictionary+Huzhu.h"
#import "UIImageView+AFNetworking.h"
#import "FootPubViewController.h"
#import "PersonalViewController.h"
#import "FootDetailViewController.h"
#import "HelpDetailViewController.h"
#import "AppDelegate.h"

@interface NearViewController ()

@end

@implementation NearViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.pulldownBtn setTitles:@[@"伙伴", @"足迹", @"路况", @"互助"]];
    currentCategary = NearCategaryPerson;
    page = 1;
    [self.pulldownBtn setCallbackBlock:^(PulldownButton *btn, NSInteger sltIndex) {
        page = 1;
        [self.dataList removeAllObjects];
        currentCategary = (NearCategaryEnum)sltIndex;
        [self requestCategary:currentCategary];
    }];
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableview;
    self.headerView.delegate = self;
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableview;
    self.footerView.delegate = self;
    
    [self requestCategary:currentCategary];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:NO];
}

- (void)requestCategary:(NearCategaryEnum)cate
{
    if (cate == NearCategaryPerson) {
        [self requestNearPerson];
    }
    if (cate == NearCategaryFoot) {
        [self requestNearFoot];
    }
    if (cate == NearCategaryRoadDynamic) {
        [self requestNearRoadDynamic];
    }
    if (cate == NearCategaryHelp) {
        [self requestNearHelp];
    }
}

/**
 *  附近的伙伴
 */
- (void)requestNearPerson
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    BMKAddrInfo *addrInfo = [LocationManager shareInterface].addrInfo;
    NSDictionary *para = @{@"lng": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.longitude], @"lat": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.latitude], @"page" : [NSNumber numberWithInteger:page]};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_User act:Mod_User_neighbors Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.dataList removeAllObjects];
            }
            [self.dataList addObjectsFromArray:responseObject[@"data"][@"data"]];
            [self.tableview reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

/**
 *  附近足迹
 */
- (void)requestNearFoot
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    BMKAddrInfo *addrInfo = [LocationManager shareInterface].addrInfo;
    NSDictionary *para = @{@"lng": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.longitude], @"lat": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.latitude], @"page" : [NSNumber numberWithInteger:page]};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Near act:Mod_Near_near_foot Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
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
        [error showAlert];
    }];
}

/**
 *  附近路况
 */
-(void)requestNearRoadDynamic
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    BMKAddrInfo *addrInfo = [LocationManager shareInterface].addrInfo;
    NSDictionary *para = @{@"lng": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.longitude], @"lat": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.latitude], @"page" : [NSNumber numberWithInteger:page]};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Near act:Mod_Near_near_road Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
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
        [error showAlert];
    }];
}

/**
 *  附近互助
 */
-(void)requestNearHelp
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    BMKAddrInfo *addrInfo = [LocationManager shareInterface].addrInfo;
    NSDictionary *para = @{@"lng": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.longitude], @"lat": [NSString stringWithFormat:@"%lf", addrInfo.geoPt.latitude], @"page" : [NSNumber numberWithInteger:page]};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Near act:Mod_Near_near_huzhu Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [error showAlert];
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

#pragma mark - UITableView Delegate & Datasource

//两种布局的cell
//一种足迹布局cell，显示足迹、互助、路况，另一种defaultStyle的cell显示附近小伙伴
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!hasLoadCell) {
        hasLoadCell = YES;
        [tableView registerNib:[PersonCell nib] forCellReuseIdentifier:[PersonCell identifier]];
        [tableView registerNib:[HuzhuCell nib] forCellReuseIdentifier:[HuzhuCell identifier]];
        [tableView registerNib:[RecordCell nib] forCellReuseIdentifier:[RecordCell identifier]];
    }
    if (currentCategary == NearCategaryPerson) {
        return [self personCellForTable:tableView atIndexPath:indexPath];
    }
    else if (currentCategary == NearCategaryHelp) {
        return [self huzhuCellForTable:tableView atIndexPath:indexPath];
    }
    else {
        return [self footCellForTable:tableView atIndexPath:indexPath];
    }
}


- (UITableViewCell *)personCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataList[indexPath.row];
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

- (UITableViewCell *)footCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordCell identifier]];
    cell.delegate = self;
    NSDictionary *dic = nil;
    dic = self.dataList[indexPath.row];
    NSDictionary *userInfo = dic[@"user_info"];
    [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
    [cell.userName setText:userInfo[@"uname"]];
    cell.time.text = [dic[@"time"] apiDate];
    [cell.content showStringMessage:dic[@"desc"]];
    [cell.btnConnect setSelected:[dic[@"is_colslect"] boolValue]];
    
    [cell.btnConnect setTitle:dic[@"collect_count"] forState:UIControlStateNormal];
    [cell.btnTransmit setTitle:dic[@"share_count"] forState:UIControlStateNormal];
    [cell.btnReply setTitle:dic[@"comment_count"] forState:UIControlStateNormal];
    BOOL isRoad = currentCategary == NearCategaryRoadDynamic;
    [cell.btnConnect setHidden:isRoad];
    [cell.btnReply setHidden:isRoad];
    [cell.btnTransmit setHidden:isRoad];
    
    return cell;
}

- (UITableViewCell *)huzhuCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    HuzhuCell *cell = [tableView dequeueReusableCellWithIdentifier:[HuzhuCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    NSDictionary *dic = self.dataList[indexPath.row];
    [cell.title setText:[dic huzhuTitle]];
    [cell.content showStringMessage:dic[@"explain"]];
    cell.time.text= [dic[@"cTime"] apiDateCn];
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
    NSDictionary *dic = self.dataList[indexPath.row];
    if (currentCategary == NearCategaryFoot) {
        FootDetailViewController *footDetailVC = [AppDelegateInterface awakeViewController:@"FootDetailViewController"];
        footDetailVC.detailCategary = FootDetailCategaryFoot;
        footDetailVC.detailDic = dic;
        [self.navigationController pushViewController:footDetailVC animated:YES];
    }
    if (currentCategary == NearCategaryRoadDynamic) {
        FootDetailViewController *footDetailVC = [AppDelegateInterface awakeViewController:@"FootDetailViewController"];
        footDetailVC.detailCategary = FootDetailCategaryRoad;
        footDetailVC.detailDic = dic;
        [self.navigationController pushViewController:footDetailVC animated:YES];
    }
    if (currentCategary == NearCategaryHelp) {
        HelpDetailViewController *detail = [AppDelegateInterface awakeViewController:@"HelpDetailViewController"];
        detail.detailDic = dic;
        [self.navigationController pushViewController:detail animated:YES];
    }
    if (currentCategary == NearCategaryPerson) {
        NSString *uid = dic[@"uid"];
        if ([uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]) {
            HWTabBar *tab = [AppDelegateInterface tabBar];
            [tab tabBarItemTap:tab.tabItems[4]];
        } else {
            PersonalViewController *pers = [AppDelegateInterface awakeViewController:@"PersonalViewController"];
            pers.user_id = uid;
            pers.isMe = NO;
            [self.navigationController pushViewController:pers animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentCategary == NearCategaryPerson) {
        return [PersonCell height];
    } else if (currentCategary == NearCategaryHelp) {
        return [HuzhuCell height];
    } else {
        if (currentCategary == NearCategaryFoot) {
            return [RecordCell height];
        }
        if (currentCategary == NearCategaryRoadDynamic){
            return [RecordCell height] - 25;
        }
        return 44.f;
    }
}

#pragma mark - Cell Delegate



- (void)huzhuCell:(HuzhuCell *)cell tapBtn:(RecordActionButton *)btn
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    
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

#pragma mark - 足迹Cell
- (void)recordCell:(RecordCell *)cell tapedBtn:(RecordActionButton *)btn
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    if (cell.btnConnect == btn) {
        [self connectFootAt:indexPath];
    } else if (cell.btnTransmit == btn) {
        [self transmitFootAt:indexPath];
    } else if (cell.btnReply == btn) {
        [self replyFootAt:indexPath];
    }
}

- (void)connectFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    if (![dic[@"is_collect"] boolValue]) {
        [SVProgressHUD show];
        NSDictionary *para = @{@"id": dic[@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_collect Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                RecordCell *cell = (RecordCell *)[self.tableview cellForRowAtIndexPath:indexPath];
                [cell.btnConnect setSelected:YES];
            } else {
                [[responseObject error] showAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showAlert];
        }];
    } else {
        [SVProgressHUD show];
        NSDictionary *dic = self.dataList[indexPath.row];
        NSDictionary *para = @{@"id": dic[@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_no_collect Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                RecordCell *cell = (RecordCell *)[self.tableview cellForRowAtIndexPath:indexPath];
                [cell.btnConnect setSelected:NO];
            } else {
                [[responseObject error] showAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showAlert];
        }];
    }
}

- (void)transmitFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryTransmit;
    publ.dataDic = dic;
    [self.navigationController pushViewController:publ animated:YES];
}

- (void)replyFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryReply;
    publ.dataDic = dic;
    [self.navigationController pushViewController:publ animated:YES];
}


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
    [self requestCategary:currentCategary];
}

- (void)refreshFooter
{
    if (self.dataList.count < kCountLoadDefaul * page) {
        [self.footerView endRefreshing];
        return ;
    }
    page ++;
    [self requestCategary:currentCategary];
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}



@end
