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
    [self.pulldownBtn setCallbackBlock:^(PulldownButton *btn, NSInteger sltIndex) {
        currentCategary = (NearCategaryEnum)sltIndex;
        page = 1;
        [self requestCategary:currentCategary];
    }];
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
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Near act:Mod_Near_neighbors Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        if ([responseObject isOK]) {
            
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        if ([responseObject isOK]) {
            
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        if ([responseObject isOK]) {
            
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        if ([responseObject isOK]) {
            self.dataList = responseObject[@"data"];
            [self.tableview reloadData];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    cell.headerView.image = [UIImage imageNamed:@"test_header_bkg"];
    cell.titleLabel.text = @"玛丽莲梦露";
    cell.contentLabel.text = @"这次的西藏之行简直太完美了";
    return cell;
}

- (UITableViewCell *)footCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentCategary == NearCategaryPerson) {
        return [PersonCell height];
    } else if (currentCategary == NearCategaryHelp) {
        return [HuzhuCell height];
    } else {
        return [RecordCell height];
    }
}

#pragma mark - Cell Delegate

- (void)recordCell:(RecordCell *)cell tapedBtn:(RecordActionButton *)btn
{}


- (void)huzhuCell:(HuzhuCell *)cell tapBtn:(RecordActionButton *)btn
{}


@end
