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
    }
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonCell identifier]];
    cell.headerView.image = [UIImage imageNamed:@"test_header_bkg"];
    cell.titleLabel.text = @"玛丽莲梦露";
    cell.contentLabel.text = @"这次的西藏之行简直太完美了";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentCategary == NearCategaryPerson) {
        return [PersonCell height];
    } else return [RecordCell height];
}


@end
