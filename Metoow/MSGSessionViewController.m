//
//  MSGSessionViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-5-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MSGSessionViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "MessageListCell.h"
#import "UIImageView+AFNetworking.h"

@interface MSGSessionViewController ()

@end

@implementation MSGSessionViewController

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
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self.inputView.delegate = self;
    [self.inputView setSendStyle];
    if (self.frdName) {
        self.titleLabel.text = self.frdName;
    }
    if (self.msgID) {
        [self requestMessageDetail];
    } else {
        if (self.frdUid) {
            [self requestMessageByFrd];
        }
    }
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

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageListCell";
    if (!isRegistered) {
        isRegistered = YES;
        UINib *nib = [MessageListCell nib];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    }
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *dic = self.messageArray[indexPath.row];
    NSString *myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([myuid isEqualToString:dic[@"from_uid"]]) {
        //我发的信息
        [cell refreshForOwnMsg:dic[@"content"]];
        [[cell ownIconView] setImageWithURL:[NSURL URLWithString:dic[@"from_face"]]];
    } else {
        //别人发得信息
        [cell refreshForFrdMsg:dic[@"content"]];
        [[cell frdIconView] setImageWithURL:[NSURL URLWithString:dic[@"from_face"]]];
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [MessageView sizeForContent:self.messageArray[indexPath.row][@"content"]];
    
    CGFloat span = size.height - MSG_VIEW_MIN_HEIGHT;
    CGFloat height = MSG_CELL_MIN_HEIGHT + span;
    return height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - MSGInputView Delegate

/**
 *  发文字
 *
 *  @param inputView MSGInputView
 *  @param txt       文字内容包含表情的标示符字符串
 */
- (void)inputView:(MSGInputView *)inputView didSendCotent:(NSString *)txt
{
    if (self.msgID) {
        //回复消息
        [self replyMessage:txt];
    } else {
        //创建一个新的回话
        [self createMessage:txt];
    }
}

/**
 *  发图片
 *
 *  @param inputView MSGInputView
 *  @param img       发送的图片UIImage对象
 */
- (void)inputView:(MSGInputView *)inputView didSendPicture:(UIImage *)img
{
}

- (void)createMessage:(NSString *)ms
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"content": ms, @"to_uid" : self.frdUid, @"title" : self.frdName};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Message act:Mod_Message_create Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            self.msgID = responseObject[@"data"];
            [self requestMessageDetail];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

- (void)replyMessage:(NSString *)ms
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"content": ms, @"id" : self.msgID};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Message act:Mod_Message_reply Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            [self requestMessageDetail];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


- (void)requestMessageDetail
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"id": self.msgID, @"page" : @"1"};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Message act:Mod_Message_get_message_detail Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            NSArray *tempArray = responseObject[@"data"];
            //以时间先后排序
            self.messageArray = [NSMutableArray arrayWithArray:[tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1[@"ctime"] integerValue] > [obj2[@"ctime"] integerValue]) {
                    return NSOrderedDescending;
                } else return NSOrderedAscending;
            }]];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


- (void)requestMessageByFrd
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"to_uid": self.frdUid};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Message act:Mod_Message_get_list_to_uid Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            NSArray *tempArray = responseObject[@"data"];
            //以时间先后排序
            self.messageArray = [NSMutableArray arrayWithArray:[tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1[@"ctime"] integerValue] > [obj2[@"ctime"] integerValue]) {
                    return NSOrderedDescending;
                } else return NSOrderedAscending;
            }]];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}


@end
