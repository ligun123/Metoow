//
//  MSGCenterViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MSGCenterViewController.h"
#import "SVSegmentedControl.h"
#import "HWSegment.h"
#import "PersonalViewController.h"
#import "MSGSessionViewController.h"
#import "UIKit+AFNetworking.h"

@interface MSGCenterViewController ()

@end

@implementation MSGCenterViewController

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
    CGRect frame;
    if ([HWDevice systemVersion] < 7.0) {
        frame = CGRectMake(50, 44, 220, 30);
    } else {
        frame = CGRectMake(50, 64, 220, 30);
    }
    HWSegment *seg = [[HWSegment alloc] initWithFrame:frame];
    seg.layer.cornerRadius = 5.0;
    seg.layer.borderWidth = 2.0;
    seg.layer.borderColor = COLOR_RGB(0, 159, 0).CGColor;
    [seg setTitles:@[@"私信", @"系统消息"]];
    [seg setSelectIndex:0];
    [self.view addSubview:seg];
    [seg setCallbackBlock:^(HWSegment *vseg, int selectIndex) {
        if (selectIndex == 0) {
            [self requestPrivateMessage];
        } else if (selectIndex == 1) {
            [self requestSystemNotify];
        }
    }];
    
    [self requestPrivateMessage];
}

- (void)requestPrivateMessage
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Message act:Mod_Message_get_message_list Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        self.msgList = responseObject[@"data"];
        [self.msgTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data = [operation responseData];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%s -> %@", __FUNCTION__, str);
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

- (void)requestSystemNotify
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Notifytion act:Mod_Notifytion_get_system_notify Paras:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%s -> %@", __FUNCTION__, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView Delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UIImageView *header = (UIImageView *)[cell.contentView viewWithTag:5];
//    [btn addTarget:self action:@selector(cellHeaderTap:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:4];
    
    NSDictionary *dic = self.msgList[indexPath.row];
    NSString *fromFace = dic[@"from_face"];
    [header setImageWithURL:[NSURL URLWithString:fromFace]];
    contentLabel.text = dic[@"content"];
    timeLabel.text = [self convertDate:dic[@"ctime"]];
    nameLabel.text = dic[@""];
    
    return cell;
}

- (NSString *)convertDate:(NSString *)dt
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *date = [fmt dateFromString:dt];
    [fmt setDateFormat:@"MM月dd日 hh:mm"];
    NSString *ndt = [fmt stringFromDate:date];
    return ndt;
}

- (void)cellHeaderTap:(UIButton *)sender
{
    UITableViewCell *cell = nil;
    if ([HWDevice systemVersion] < 7.0) {
        cell = (UITableViewCell *)[[sender superview] superview];
    } else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    NSIndexPath *path = [self.msgTableView indexPathForCell:cell];
    //push to personal view controller
    [AppDelegateInterface setTabBarHidden:YES];
    PersonalViewController *personal = [AppDelegateInterface awakeViewController:@"PersonalViewController"];
    [self.navigationController pushViewController:personal animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AppDelegateInterface setTabBarHidden:YES];
    MSGSessionViewController *msgSession = [[AppDelegateInterface mainStoryBoard] instantiateViewControllerWithIdentifier:@"MSGSessionViewController"];
    [self.navigationController pushViewController:msgSession animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}


@end
