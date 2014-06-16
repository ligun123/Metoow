//
//  FootDetailViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-5-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  路况无回复和转发

#import <UIKit/UIKit.h>
#import "DetailCell.h"
#import "MJRefresh.h"

@interface FootDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
{
    BOOL hasRegister;
    NSInteger page;
}

@property (strong, nonatomic) NSDictionary *detailDic;
@property (strong, nonatomic) NSMutableArray *commentsList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) DetailCell *detailCell;         //第一行显示的主题cell，同时帮助计算高度
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (strong, nonatomic) MJRefreshFooterView *footerView;
@property (strong, nonatomic) MJRefreshHeaderView *headerView;

@property FootDetailCategary detailCategary;

- (IBAction)btnBackTap:(id)sender;

- (IBAction)btnCollectTap:(id)sender;
- (IBAction)btnTransmitTap:(id)sender;
- (IBAction)btnReplyTap:(id)sender;

- (void)refresh;

@end
