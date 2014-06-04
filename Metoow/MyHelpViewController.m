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
    // Do any additional setup after loading the view.
    [self refresh];
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
    NSDictionary *dic = @{@"uid": uid, @"page" : [NSNumber numberWithInteger:1]};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Huzhu act:Mod_Huzhu_get_hzlist Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.dataList = [NSMutableArray arrayWithArray:responseObject[@"data"]];
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
    [cell.content showStringMessage:dic[@"explain"]];
    cell.time.text= [dic[@"ctime"] apiDate];
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

- (void)cell:(HuzhuCell *)cell tapBtn:(RecordActionButton *)btn
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


@end
