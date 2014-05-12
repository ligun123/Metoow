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
    if (self.frdName) {
        self.titleLabel.text = self.frdName;
    }
    if (self.msgID) {
        [self requestMessageDetail];
    }
}

- (void)requestMessageDetail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"id": self.msgID};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Message act:Mod_Message_get_message_detail Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s -> %@", __FUNCTION__, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s -> %@", __FUNCTION__, error);
    }];
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
    cell.frdIconView.image = [UIImage imageNamed:@"test_header_bkg"];
    cell.ownIconView.image = [UIImage imageNamed:@"test_header_bkg"];
    // 设置数据
    if ( indexPath.row % 2 == 0 ) {
        [cell refreshForFrdMsg:self.messageArray[indexPath.row]];
    }
    else {
        [cell refreshForOwnMsg:self.messageArray[indexPath.row]];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [MessageView sizeForContent:self.messageArray[indexPath.row]];
    
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

@end
