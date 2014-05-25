//
//  FootDetailViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-5-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "FootDetailViewController.h"
#import "FootPubViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FootDetailViewController ()

@end

@implementation FootDetailViewController

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
    if (self.detailCategary == FootDetailCategaryRoad) {
        CGRect of = self.tableview.frame;
        self.tableview.frame = CGRectMake(of.origin.x, of.origin.y, of.size.width, of.size.height + self.bottomBar.frame.size.height);
        self.bottomBar.hidden = YES;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self.btnCollect setSelected:[self.detailDic[@"is_colslect"] boolValue]];
    }
}

- (DetailCell *)detailCell
{
    if (_detailCell == nil) {
        _detailCell = [DetailCell loadFromNib];
        NSLog(@"%s -> 加载了一次第一行cell", __FUNCTION__);
    }
    return _detailCell;
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

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCollectTap:(id)sender {
    
    if (!self.btnCollect.selected) {
        [SVProgressHUD show];
        NSDictionary *para = @{@"id": self.detailDic[@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_collect Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                [self.btnCollect setSelected:YES];
            } else {
                [[responseObject error] showAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showAlert];
        }];
    } else {
        [SVProgressHUD show];
        NSDictionary *para = @{@"id": self.detailDic[@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_no_collect Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                [self.btnCollect setSelected:NO];
            } else {
                [[responseObject error] showAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showAlert];
        }];
    }
}

- (IBAction)btnTransmitTap:(id)sender {
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryTransmit;
    publ.dataDic = self.detailDic;
    [self.navigationController pushViewController:publ animated:YES];
}

- (IBAction)btnReplyTap:(id)sender {
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryReply;
    publ.dataDic = self.detailDic;
    [self.navigationController pushViewController:publ animated:YES];
}


- (void)refresh
{
    [SVProgressHUD show];
    NSDictionary *dic = @{@"id": self.detailDic[@"id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_show Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.detailDic = responseObject[@"data"];
            [self.tableview reloadData];
        } else {
            [SVProgressHUD dismiss];
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [error showAlert];
    }];
}

#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.detailCell.headerImg setImageWithURL:[NSURL URLWithString:self.detailDic[@"user_info"][@"avatar_original"]]];
        self.detailCell.name.text = self.detailDic[@"user_info"][@"uname"];
        self.detailCell.time.text = [self.detailDic[@"time"] apiDate];
        [self.detailCell.content showStringMessage:self.detailDic[@"desc"]];
        return self.detailCell;
    } else {
        if (!hasRegister) {
            [tableView registerNib:[DetailCell nib] forCellReuseIdentifier:[DetailCell identifier]];
            hasRegister = YES;
        }
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[DetailCell identifier]];
        [cell setHasImages:NO];
        NSDictionary *dic = self.detailDic[@"comment_list"];
        if (dic) {
            NSArray *arr = dic[@"data"];
            NSDictionary *replyDic = arr[indexPath.row - 1];
            [cell.content showStringMessage:replyDic[@"content"]];
            cell.time.text = [replyDic[@"ctime"] apiDate];
        }
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int replyCount = [self.detailDic[@"comment_list"][@"count"] integerValue];
    return 1 + replyCount;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [DetailCell height];
    } else {
        return [DetailCell height] - 80;
    }
}


@end
