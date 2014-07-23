//
//  HelpDetailViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-6-3.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ReplyCell.h"
#import "FootPubViewController.h"
#import "NSDictionary+Huzhu.h"
#import "PersonalViewController.h"

@interface HelpDetailViewController ()

@end

@implementation HelpDetailViewController

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
    
    if (self.detailDic[@"sos_id"]) {
        self.titleLabel.text = @"SOS";
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

- (void)refresh
{
    [SVProgressHUD show];
    NSString *huzhuid = self.detailDic[@"id"];
    NSString *table_name = @"huzhu";
    
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

- (DetailCell *)detailCell
{
    if (_detailCell == nil) {
        _detailCell = [DetailCell loadFromNib];
        [_detailCell.picScroll enableScan];
    }
    return _detailCell;
}


- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTransmitTap:(id)sender {
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    if (self.detailDic[@"id"]) {
        publ.editCategary = FootPubEditCategaryTransmitHuzhu;
    } else {
        publ.editCategary = FootPubEditCategaryTransmitSOS;
    }
    
    publ.dataDic = self.detailDic;
    [self.navigationController pushViewController:publ animated:YES];
}

- (IBAction)btnReplyTap:(id)sender {
    FootPubViewController *publ = [AppDelegateInterface awakeViewController:@"FootPubViewController"];
    if (self.detailDic[@"id"]) {
        publ.editCategary = FootPubEditCategaryReplyHuzhu;
    } else {
        publ.editCategary = FootPubEditCategaryReplySOS;
    }
    publ.dataDic = self.detailDic;
    [self.navigationController pushViewController:publ animated:YES];
}


- (void)pushPersonalUid:(NSString *)uid
{
    PersonalViewController *pers = [AppDelegateInterface awakeViewController:@"PersonalViewController"];
    pers.user_id = uid;
    pers.isMe = [uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    pers.hideTabBar = YES;
    [self.navigationController pushViewController:pers animated:YES];
}


#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.detailDic[@"sos_id"]) {
            self.detailCell.time.text = [self.detailDic[@"time"] apiDate];
            [self.detailCell.content showStringMessage:self.detailDic[@"sos_info"]];
        } else {
            self.detailCell.time.text = [self.detailDic[@"cTime"] apiDate];
            NSString *huzhu = [self.detailDic huzhuTitle];
            self.detailCell.content.textColor = [UIColor colorWithRed:0 green:99/255.f blue:0 alpha:1];
            [self.detailCell.content showStringMessage:huzhu];
            
            NSString *explain = self.detailDic[@"explain"];
            [self.detailCell.huzhuExplain showStringMessage:explain];
        }
        
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
            NSString *headerUid = _detailDic[@"user_info"][@"uid"];
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
        NSString *content = [self.detailDic huzhuTitle];
        NSString *explain = self.detailDic[@"explain"];
        if (explain == nil) {
            explain = self.detailDic[@"sos_info"];
        }
        CGSize es = [[self.detailCell huzhuExplain] sizeForContent:explain];
        CGSize s = [[self.detailCell content] sizeForContent:content];
        
        CGFloat heightWithPics = [DetailCell height] + (s.height + es.height - [DetailCell defaultMSGViewHeight]);
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

- (NSMutableArray *)commentsList
{
    if (_commentsList == nil) {
        _commentsList = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _commentsList;
}


@end
