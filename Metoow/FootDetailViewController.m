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
#import "ReplyCell.h"

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
    page = 1;
    // Do any additional setup after loading the view.
    if (self.detailCategary == FootDetailCategaryRoad) {
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGRect of = self.tableview.frame;
        self.tableview.frame = CGRectMake(of.origin.x, of.origin.y, of.size.width, of.size.height + self.bottomBar.frame.size.height);
        self.bottomBar.hidden = YES;
    } else {
        [self.btnCollect setSelected:[self.detailDic[@"is_colslect"] boolValue]];
//        [self refresh];
    }
}

- (DetailCell *)detailCell
{
    if (_detailCell == nil) {
        _detailCell = [DetailCell loadFromNib];
        [_detailCell.picScroll enableScan];
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
    if (self.detailCategary != FootDetailCategaryFoot) {
        return ;
    }
    [SVProgressHUD show];
    NSDictionary *dic = @{@"id": self.detailDic[@"id"], @"table_name" : @"foot", @"page" : [NSNumber numberWithInteger:page], @"count" : [NSNumber numberWithInteger:20]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_System act:Mod_System_get_comments Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.commentsList = responseObject[@"data"];
            [self.tableview reloadData];
        } else {
            [SVProgressHUD dismiss];
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.detailCell.headerImg setImageWithURL:[NSURL URLWithString:self.detailDic[@"user_info"][@"avatar_original"]]];
        self.detailCell.name.text = self.detailDic[@"user_info"][@"uname"];
        self.detailCell.time.text = [self.detailDic[@"time"] apiDate];
        //调整content的高度
        if ([self.detailDic[@"pic_ids"] length] == 0) {
            if ([self.detailCell.picScroll superview]) {
                [self.detailCell.picScroll removeFromSuperview];
            }
            CGRect f = self.detailCell.content.frame;
            f.size.height = f.size.height + 100;        //让content的size充满cell，cell绘制时会根据autoresiongMask属性将content的size调整到合适size
            self.detailCell.content.frame = f;
        } else {
            NSArray *picids = [self.detailDic[@"pic_ids"] componentsSeparatedByString:@"|"];
            [self.detailCell.picScroll showMetoowPicIDs:picids];
        }
        
        [self.detailCell.content showStringMessage:self.detailDic[@"desc"]];
        return self.detailCell;
    } else {
        if (!hasRegister) {
            [tableView registerNib:[ReplyCell nib] forCellReuseIdentifier:[ReplyCell identifier]];
            hasRegister = YES;
        }
        ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ReplyCell identifier]];
        NSDictionary *replyDic = self.commentsList[indexPath.row - 1];
        [cell.content showStringMessage:replyDic[@"content"]];
        cell.time.text = [replyDic[@"ctime"] apiDate];
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.commentsList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSString *content = self.detailDic[@"desc"];
        CGSize s = [[self.detailCell content] sizeForContent:content];
        CGFloat heightWithPics = [DetailCell height] + (s.height - [DetailCell defaultMSGViewHeight]);
        if ([self.detailDic[@"pic_ids"] length] == 0) {
            heightWithPics -= 100;
        }
        return heightWithPics;
    } else {
#warning 修改commnt的KEY
        NSString *content = self.commentsList[indexPath.row + 1][@"commnt"];
        CGSize s = [[self.detailCell content] sizeForContent:content];
        CGFloat height = [ReplyCell height] + s.height;
        return height;
    }
}


@end
