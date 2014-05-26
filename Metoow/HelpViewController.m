//
//  HelpViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HelpViewController.h"
#import "HPsfcViewController.h"
#import "HPjbViewController.h"
#import "HPpcViewController.h"
#import "HPsfkViewController.h"
#import "NSDictionary+Huzhu.h"
#import "UIImageView+AFNetworking.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    [self.pulldownBtn setTitles:@[@"全部互助", @"结伴", @"顺风车", @"拼车", @"沙发客",  @"SOS"]];
    selectIndex = 0;
    [self.pulldownBtn setCallbackBlock:^(PulldownButton *btn, NSInteger sltIndex) {
        selectIndex = sltIndex;
        [self refresh];
    }];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:NO];
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


#pragma mark - Actions

- (void)refresh
{
    if (selectIndex == 5) {
        //SOS
    } else {
        [SVProgressHUD show];
        NSDictionary *dic = nil;
        if (selectIndex != 0) {
            dic = @{@"type": [NSNumber numberWithInt:selectIndex]};
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Huzhu act:Mod_Huzhu_get_hzlist Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject isOK]) {
                self.dataList = [NSMutableArray arrayWithArray:responseObject[@"data"]];
                [self.tableview reloadData];
            } else {
                [[responseObject error] showAlert];
            }
            NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [error showAlert];
        }];
    }
}


#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!hasRegister) {
        hasRegister = YES;
        [tableView registerNib:[HuzhuCell nib] forCellReuseIdentifier:[HuzhuCell identifier]];
    }
    HuzhuCell *cell = [tableView dequeueReusableCellWithIdentifier:[HuzhuCell identifier]];
    
    NSDictionary *dic = self.dataList[indexPath.row];
    
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
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HuzhuCell height];
}


- (IBAction)btnPublishTap:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"结伴", @"顺风车", @"拼车", @"沙发客", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //结伴
        HelpPubViewController *pub = [[HPjbViewController  alloc] initWithNibName:@"HPjbViewController" bundle:nil];
        [self.navigationController pushViewController:pub animated:YES];
    }
    if (buttonIndex == 1) {
        //顺风车
        HelpPubViewController *pub = [[HPsfcViewController  alloc] initWithNibName:@"HPsfcViewController" bundle:nil];
        [self.navigationController pushViewController:pub animated:YES];
    }
    if (buttonIndex == 2) {
        //拼车
        HelpPubViewController *pub = [[HPpcViewController  alloc] initWithNibName:@"HPpcViewController" bundle:nil];
        [self.navigationController pushViewController:pub animated:YES];
    }
    if (buttonIndex == 3) {
        //沙发客
        HelpPubViewController *pub = [[HPsfkViewController  alloc] initWithNibName:@"HPsfkViewController" bundle:nil];
        [self.navigationController pushViewController:pub animated:YES];
    }
}



@end
