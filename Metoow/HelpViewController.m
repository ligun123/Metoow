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
#import "FootPubViewController.h"
#import "FileUploader.h"
#import "HelpDetailViewController.h"
#import "MyHelpViewController.h"
#import "SOSDetailViewController.h"

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
    [self.pulldownBtn setTitles:@[@"与我相关", @"结伴", @"顺风车", @"拼车", @"沙发客",  @"S O S"]];
    page = 1;
    selectIndex = 0;
    [self.pulldownBtn setCallbackBlock:^(PulldownButton *btn, NSInteger sltIndex) {
        [self.dataList removeAllObjects];
        page = 1;
        selectIndex = sltIndex;
        [self refresh];
    }];
    
    [self refresh];
    
    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.searchList = [NSMutableArray arrayWithCapacity:10];
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
        [SVProgressHUD show];
        NSDictionary *dic = @{@"page": [NSNumber numberWithInteger:page]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_SOS act:Mod_SOS_sos_list Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [error showTimeoutAlert];
        }];
    } else {
        [SVProgressHUD show];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (selectIndex != 0) {
            [dic setObject:[NSNumber numberWithInt:selectIndex] forKey:@"type"];
        }
        [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Huzhu act:Mod_Huzhu_get_hzlist Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [error showTimeoutAlert];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (selectIndex != 5) {
        NSDictionary *dic = [self huzhuAtIndex:indexPath];
        [cell.title setText:[dic huzhuTitle]];
//        [cell.content showStringMessage:dic[@"explain"]];
        cell.time.text= [dic[@"cTime"] apiDate];
        [cell.btnTransmit setTitle:dic[@"repost_count"] forState:UIControlStateNormal];
        [cell.btnReply setTitle:dic[@"commentCount"] forState:UIControlStateNormal];
        NSDictionary *userInfo = dic[@"user_info"];
        [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
        cell.userName.text = userInfo[@"uname"];
    } else {
        //显示SOS的cell
        NSDictionary *dic = [self huzhuAtIndex:indexPath];
        [cell.title setText:dic[@"sos_info"]];
        [cell.content showStringMessage:@"SOS求救"];
        cell.time.text= [dic[@"time"] apiDate];
        [cell.btnTransmit setTitle:dic[@"repost_count"] forState:UIControlStateNormal];
        [cell.btnReply setTitle:dic[@"comment_count"] forState:UIControlStateNormal];
        NSDictionary *userInfo = dic[@"user_info"];
        [cell.userHeader setImageWithURL:[NSURL URLWithString:userInfo[@"avatar_original"]]];
        cell.userName.text = userInfo[@"uname"];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return self.searchList.count;
    }
    return self.dataList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self huzhuAtIndex:indexPath];
    if (selectIndex == 5) {
        SOSDetailViewController *sosDetail = [AppDelegateInterface awakeViewController:@"SOSDetailViewController"];
        sosDetail.detailDic = dic;
        [self.navigationController pushViewController:sosDetail animated:YES];
    } else {
        HelpDetailViewController *detail = [AppDelegateInterface awakeViewController:@"HelpDetailViewController"];
        detail.detailDic = dic;
        [self.navigationController pushViewController:detail animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HuzhuCell height];
}


- (IBAction)btnPublishTap:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"结伴", @"顺风车", @"拼车", @"沙发客", nil];
    [sheet showInView:self.view];
}

- (IBAction)btnMyHelpTap:(id)sender
{
    MyHelpViewController *myhelp = [AppDelegateInterface awakeViewController:@"MyHelpViewController"];
    [self.navigationController pushViewController:myhelp animated:YES];
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


- (void)huzhuCell:(HuzhuCell *)cell tapBtn:(RecordActionButton *)btn
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSDictionary *dic = [self huzhuAtIndex:indexPath];
    
    if (btn == cell.btnTransmit) {
        //转发
        FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
        publ.editCategary = (selectIndex == 5) ? FootPubEditCategaryTransmitSOS : FootPubEditCategaryTransmitHuzhu;
        publ.dataDic = dic;
        [self.navigationController pushViewController:publ animated:YES];
    }
    if (btn == cell.btnReply) {
        //回复
        FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
        publ.editCategary = (selectIndex == 5) ? FootPubEditCategaryReplySOS : FootPubEditCategaryReplyHuzhu;
        publ.dataDic = dic;
        [self.navigationController pushViewController:publ animated:YES];
    }
}

#pragma mark - 搜索


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    isSearching = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    } else {
        /*
         if (textField.text.length == 0) {
         [self searchForWord:textField.text];
         }
         */
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    isSearching = NO;
    [self searchForWord:@""];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isSearching = textField.text.length > 0;
    [self searchForWord:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)searchForWord:(NSString *)word
{
    [self.searchList removeAllObjects];
    if (word.length > 0) {
        for (int i = 0; i < self.dataList.count; i ++) {
            NSDictionary *dic = self.dataList[i];
            NSString *content = [dic huzhuTitle];
            NSString *uname = dic[@"user_info"][@"uname"];
            NSString *explain = dic[@"explain"];
            if ([content rangeOfString:word].location != NSNotFound || [uname rangeOfString:word].location != NSNotFound || [explain rangeOfString:word].location != NSNotFound) {
                [self.searchList addObject:dic];
            }
        }
    }
    [self.tableview reloadData];
}

- (NSDictionary *)huzhuAtIndex:(NSIndexPath *)indexPath
{
    if (isSearching) {
        return self.searchList[indexPath.row];
    } else {
        return self.dataList[indexPath.row];
    }
}


#pragma mark - 上下拉刷新

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _dataList;
}

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
    [self refresh];
}

- (void)refreshFooter
{
    if (self.dataList.count < kCountLoadDefaul * page) {
        [self.tableview footerEndRefreshing];
        return ;
    }
    page ++;
    [self refresh];
}


@end
