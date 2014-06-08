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
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_get_myfoot Paras:@{@"uid": self.user_id}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.dataList = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [self.tableview reloadData];
        } else {
            if ([responseObject[@"code"] integerValue] != 1) {
                [[responseObject error] showAlert];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}


#pragma mark - UITableView Delegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isCellRegesterd) {
        isCellRegesterd = YES;
        [tableView registerNib:[RecordCell nib] forCellReuseIdentifier:[RecordCell identifier]];
    }
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordCell identifier]];
    cell.delegate = self;
    NSDictionary *dic = self.dataList[indexPath.row];
    
    NSDictionary *userInfo = dic[@"user_info"];
    [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
    [cell.userName setText:userInfo[@"uname"]];
    cell.time.text = [dic[@"time"] apiDate];
    [cell.content showStringMessage:dic[@"desc"]];
    [cell.btnConnect setSelected:[dic[@"is_colslect"] boolValue]];
    
    [cell.btnConnect setTitle:dic[@"collect_count"] forState:UIControlStateNormal];
    [cell.btnTransmit setTitle:dic[@"share_count"] forState:UIControlStateNormal];
    [cell.btnReply setTitle:dic[@"comment_count"] forState:UIControlStateNormal];
    
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
    return [RecordCell height];
}



- (void)connectFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    
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
                NSLog(@"%s -> %@", __FUNCTION__, responseObject);
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
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryTransmit;
    publ.dataDic = dic;
    [self.navigationController pushViewController:publ animated:YES];
}

- (void)replyFootAt:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
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
        [error showAlert];
    }];
}



@end
