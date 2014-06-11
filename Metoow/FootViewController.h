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

@interface FootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate, RecordCellProtocol, UIActionSheetDelegate, UITextFieldDelegate>
{
    BOOL isCellRegesterd;
    int selectIndex;
    BOOL isSearching;
    NSInteger page;
}

@property (weak, nonatomic) IBOutlet PulldownButton *pullDownBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) NSMutableArray *dataList;     //table数据源

@property (strong, nonatomic) NSMutableArray *searchList;

- (IBAction)btnPublishTap:(id)sender;

@end
