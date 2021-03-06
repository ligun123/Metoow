//
//  MyFootViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-6-8.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MyFootViewController.h"
#import "MJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "FootDetailViewController.h"
#import "FootPubViewController.h"

@interface MyFootViewController ()

@end

@implementation MyFootViewController

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
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([self.user_id isEqualToString:userid]) {
        [self.titleLabel setText:@"我的足迹"];
    } else {
        [self.titleLabel setText:@"足迹"];
    }
    
    page = 1;
    self.heightCount = [[RichLabelView alloc] initWithFrame:CGRectMake(0, 0, 300, 24)];
    
    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self requestMyFoot];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestMyFoot
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_get_myfoot Paras:@{@"uid": self.user_id, @"page" : [NSNumber numberWithInteger:page]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.originalList removeAllObjects];
            }
            [self.dataList removeAllObjects];
            [self.originalList addObjectsFromArray:responseObject[@"data"]];
            NSArray *cateByDay = [self categaryByDay:self.originalList];
            
            [self.dataList addObjectsFromArray:cateByDay];
            [self.tableview reloadData];
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


- (NSArray *)categaryByDay:(NSArray *)origList
{
    NSMutableArray *rootArr = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *tempArr = nil;
    NSInteger tempDay = 0;
    for (int i = 0; i < origList.count; i ++) {
        NSDictionary *dic = origList[i];
        NSInteger day = [dic[@"time"] integerValue] / (24 * 60 * 60);
        if (tempDay != day) {
            tempDay = day;
            if (tempArr != nil) {
                [rootArr addObject:tempArr];
            }
            tempArr = [NSMutableArray arrayWithCapacity:10];
            [tempArr addObject:dic];
        } else {
            [tempArr addObject:dic];
        }
    }
    return rootArr;
}



#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isCellRegesterd) {
        isCellRegesterd = YES;
        [tableView registerNib:[RecordCell nib] forCellReuseIdentifier:[RecordCell identifier]];
    }
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordCell identifier]];
    cell.delegate = self;
    NSDictionary *dic = self.dataList[indexPath.section][indexPath.row];
    
    NSDictionary *userInfo = dic[@"user_info"];
    if ([dic[@"pic_ids"] length] > 0) {
        cell.hasPic.image = [UIImage imageNamed:@"pic_norm"];
    } else {
        cell.hasPic.image = nil;
    }
    [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
    [cell.userName setText:userInfo[@"uname"]];
    cell.time.text = [dic[@"time"] apiDateShort];
    [cell.content showStringMessage:dic[@"desc"]];
    [cell.btnConnect setSelected:[dic[@"is_colslect"] boolValue]];
    cell.locate.text = [NSString stringWithFormat:@"我在：%@", dic[@"pos"]];
    [cell.btnConnect setTitle:dic[@"collect_count"] forState:UIControlStateNormal];
    [cell.btnTransmit setTitle:dic[@"share_count"] forState:UIControlStateNormal];
    [cell.btnReply setTitle:dic[@"comment_count"] forState:UIControlStateNormal];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataList[section][0];
    NSInteger time = [dic[@"time"] integerValue];
    NSDate *today = [NSDate date];
    NSInteger todayTime = [today timeIntervalSince1970];
    
    NSInteger dayDate = time / (24 * 60 * 60);
    NSInteger dayToday = todayTime / (24 * 60 * 60);
    if (dayDate == dayToday) {
        return @"今天";
    }
    if (dayToday - 1 == dayDate) {
        return @"昨天";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList[section] count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataList[indexPath.section][indexPath.row];
    FootDetailViewController *footDetailVC = [AppDelegateInterface awakeViewController:@"FootDetailViewController"];
    footDetailVC.detailDic = dic;
    footDetailVC.detailCategary = FootDetailCategaryFoot;
    [self.navigationController pushViewController:footDetailVC animated:YES];
}


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.section][indexPath.row];
    return [RecordCell height] + [self.heightCount sizeForContent:dic[@"desc"]].height;
}



- (void)connectFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.section][indexPath.row];
    
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
                RecordCell *cell = (RecordCell *)[self.tableview cellForRowAtIndexPath:indexPath];
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
    NSDictionary *dic = self.dataList[indexPath.section][indexPath.row];
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryTransmit;
    publ.dataDic = dic;
    [self.navigationController pushViewController:publ animated:YES];
}

- (void)replyFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.section][indexPath.row];
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
    [self requestMyFoot];
}

- (void)refreshFooter
{
    if (self.dataList.count < kCountLoadDefaul * page) {
        [self.tableview footerEndRefreshing];
        return ;
    }
    page ++;
    [self requestMyFoot];
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}


- (NSMutableArray *)originalList
{
    if (_originalList == nil) {
        _originalList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _originalList;
}


@end
