//
//  FootViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  足迹

#import <UIKit/UIKit.h>
#import "RecordCell.h"
#import "PulldownButton.h"
#import "MJRefresh.h"

@interface FootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
{
    BOOL isCellRegesterd;
}

@property (weak, nonatomic) IBOutlet PulldownButton *pullDownBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

@property (strong, nonatomic) NSMutableArray *dataList;     //table数据源
@end
