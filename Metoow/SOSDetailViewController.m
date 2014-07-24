//
//  SOSDetailViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-7-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SOSDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ReplyCell.h"
#import "FootPubViewController.h"
#import "NSDictionary+Huzhu.h"
#import "PersonalViewController.h"
#import "SOSPeopleViewController.h"
#import "HelpViewController.h"

@interface SOSDetailViewController ()

@end

@implementation SOSDetailViewController

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
    page = 1;
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"SOS正文";
    if ([self.detailDic[@"uid"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]) {
        self.btnCollect.hidden = YES;
        self.btnCloseSOS.hidden = NO;
        if ([self.detailDic[@"is_end"] boolValue]) {
            [self.btnCloseSOS setTitle:@"已关闭" forState:UIControlStateNormal];
            [self.btnCloseSOS setEnabled:NO];
        } else {
            [self.btnCloseSOS setTitle:@"关闭SOS" forState:UIControlStateNormal];
            [self.btnCloseSOS setEnabled:YES];
        }
    } else {
        self.btnCollect.hidden = NO;
        self.btnCloseSOS.hidden = YES;
        
        [self.btnCollect setSelected:[self.detailDic[@"is_pation"] boolValue]];
    }
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableview;
    self.headerView.delegate = self;
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableview;
    self.footerView.delegate = self;
    
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

- (IBAction)btnBackTap:(id)sender
{
    if (mustRefreshHelpList) {
        for (UIViewController *help in [self.navigationController viewControllers]) {
            if ([help isKindOfClass:[HelpViewController class]]) {
                [(HelpViewController *)help refreshHeader];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnTransmitTap:(id)sender
{
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryTransmitSOS;
    publ.dataDic = self.detailDic;
    [self.navigationController pushViewController:publ animated:YES];
}


- (IBAction)btnReplyTap:(id)sender
{
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    publ.editCategary = FootPubEditCategaryReplySOS;
    publ.dataDic = self.detailDic;
    [self.navigationController pushViewController:publ animated:YES];
}


- (IBAction)btnStarTap:(id)sender
{
    [SVProgressHUD show];
    NSString *is_pation = nil;
    if (self.btnCollect.selected) {
        is_pation = @"0";
    } else {
        is_pation = @"1";
    }
    NSDictionary *para = @{@"type": is_pation, @"sos_id" : self.detailDic[@"sos_id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_SOS act:Mod_SOS_is_pation Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            mustRefreshHelpList = YES;
            [self.btnCollect setSelected:!self.btnCollect.selected];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


- (IBAction)btnPeoPleTap:(id)sender
{
    SOSPeopleViewController *people = [AppDelegateInterface awakeViewController:@"SOSPeopleViewController"];
    people.sos_id = self.detailDic[@"sos_id"];
    [self.navigationController pushViewController:people animated:YES];
}

- (IBAction)btnCloseSOSTap:(id)sender
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_SOS act:Mod_SOS_close_sos Paras:@{@"sos_id": self.detailDic[@"sos_id"]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            [self.btnCloseSOS setTitle:@"已关闭" forState:UIControlStateNormal];
            [self.btnCloseSOS setEnabled:NO];
            mustRefreshHelpList = YES;
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)refresh
{
    [SVProgressHUD show];
    NSString *huzhuid = self.detailDic[@"sos_id"];
    NSString *table_name = @"sos";
    NSDictionary *dic = @{@"id": huzhuid, @"table_name" : table_name, @"page" : [NSNumber numberWithInteger:page], @"count" : [NSNumber numberWithInteger:20]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Comment act:Mod_Comment_get_comments Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            if (page == 1) {
                [self.commentsList removeAllObjects];
            }
            [self.commentsList addObjectsFromArray:responseObject[@"data"]];
            NSMutableArray *ips = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < self.commentsList.count; i ++) {
                NSIndexPath *ind = [NSIndexPath indexPathForRow:i+1 inSection:0];
                [ips addObject:ind];
            }
            [self.tableview reloadData];
        } else {
            [SVProgressHUD dismiss];
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


- (NSMutableArray *)commentsList
{
    if (_commentsList == nil) {
        _commentsList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _commentsList;
}


- (DetailCell *)detailCell
{
    if (_detailCell == nil) {
        _detailCell = [DetailCell loadFromNib];
        [_detailCell.picScroll enableScan];
    }
    return _detailCell;
}

- (void)pushPersonalUid:(NSString *)uid
{
    PersonalViewController *pers = [AppDelegateInterface awakeViewController:@"PersonalViewController"];
    pers.user_id = uid;
    pers.isMe = [uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    pers.hideTabBar = YES;
    [self.navigationController pushViewController:pers animated:YES];
}

#pragma mark - 上下拉刷新Delegate

// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.headerView) {
        //加载更多旧的
        [self refreshHeader];
    }
    if (refreshView == self.footerView) {
        //加载更多旧的
        [self refreshFooter];
    }
}

- (void)endRefresh
{
    if ([self.headerView isRefreshing]) {
        [self.headerView endRefreshing];
    }
    if ([self.footerView isRefreshing]) {
        [self.footerView endRefreshing];
    }
}

- (void)refreshHeader
{
    page = 1;
    [self refresh];
}

- (void)refreshFooter
{
    if (self.commentsList.count < kCountLoadDefaul * page) {
        [self.footerView endRefreshing];
        return ;
    }
    page ++;
    [self refresh];
}


#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.detailCell.time.text = [self.detailDic[@"time"] apiDate];
        [self.detailCell.content showStringMessage:self.detailDic[@"sos_info"]];
        
        //调整content的高度
        if ([self.detailDic[@"pic_ids"] length] == 0) {
            if ([self.detailCell.picScroll superview]) {
                [self.detailCell.picScroll removeFromSuperview];
            }
        } else {
            NSArray *picids = [self.detailDic[@"pic_ids"] componentsSeparatedByString:@"|"];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < picids.count; i ++) {
                NSString *pd = picids[i];
                if (pd.length > 0) {
                    [arr addObject:pd];
                }
            }
            [self.detailCell.picScroll showMetoowPicIDs:arr];
        }
        CGRect f = self.detailCell.content.frame;
        f.size = [self.detailCell.content contentSize];
        self.detailCell.content.frame = f;
        f.origin = CGPointMake(f.origin.x, f.origin.y + f.size.height);
        f.size = [self.detailCell.huzhuExplain contentSize];
        self.detailCell.huzhuExplain.frame = f;
        [self.detailCell.headerImg setImageWithURL:[NSURL URLWithString:self.detailDic[@"user_info"][@"avatar_original"]]];
        self.detailCell.name.text = self.detailDic[@"user_info"][@"uname"];
        
        [_detailCell setHeaderTapBlock:^(HWCell *aCell){
            NSString *headerUid = self.detailDic[@"user_info"][@"uid"];
            [self pushPersonalUid:headerUid];
        }];
        
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
        cell.name.text = replyDic[@"user_info"][@"uname"];
        [cell.headerImg setImageWithURL:[NSURL URLWithString:replyDic[@"user_info"][@"avatar_original"]]];
        
        [cell setHeaderTapBlock:^(HWCell *aCell){
            NSIndexPath *aIndexPath = [tableView indexPathForCell:aCell];
            NSDictionary *areplyDic = self.commentsList[aIndexPath.row - 1];
            NSString *headerUid = areplyDic[@"user_info"][@"uid"];
            [self pushPersonalUid:headerUid];
        }];
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
        NSString *explain = self.detailDic[@"explain"];
        if (explain == nil) {
            explain = self.detailDic[@"sos_info"];
        }
        CGSize es = [[self.detailCell huzhuExplain] sizeForContent:explain];
        
        CGFloat heightWithPics = [DetailCell height] + (es.height - [DetailCell defaultMSGViewHeight]);
        if ([self.detailDic[@"pic_ids"] length] == 0) {
            heightWithPics -= 100;
        }
        return heightWithPics;
    } else {
        NSString *content = self.commentsList[indexPath.row - 1][@"content"];
        CGSize s = [[self.detailCell content] sizeForContent:content];
        CGFloat height = [ReplyCell height] + s.height;
        return height;
    }
}


@end
