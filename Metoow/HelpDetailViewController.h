//
//  HelpDetailViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-6-3.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCell.h"
#import "MJRefresh.h"

@interface HelpDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
{
    BOOL hasRegister;
    NSInteger page;
}

@property (strong, nonatomic) NSDictionary *detailDic;
@property (strong, nonatomic) NSMutableArray *commentsList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) DetailCell *detailCell;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@property (strong, nonatomic) MJRefreshFooterView *footerView;
@property (strong, nonatomic) MJRefreshHeaderView *headerView;

- (IBAction)btnBackTap:(id)sender;
- (IBAction)btnTransmitTap:(id)sender;
- (IBAction)btnReplyTap:(id)sender;

@end
