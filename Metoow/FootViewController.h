//
//  FootViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-6.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  足迹

#import <UIKit/UIKit.h>
#import "RecordCell.h"
#import "RoadCell.h"
#import "PulldownButton.h"
#import "MJRefresh.h"

@interface FootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RecordCellProtocol, UIActionSheetDelegate, UITextFieldDelegate>
{
    BOOL isCellRegesterd;
    int selectIndex;
    BOOL isSearching;
    NSInteger page;
}

@property (weak, nonatomic) IBOutlet PulldownButton *pullDownBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSOS;


@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) NSMutableArray *dataList;     //table数据源

@property (strong, nonatomic) NSMutableArray *searchList;
@property (strong, nonatomic) RichLabelView *heightCounter;

- (IBAction)btnPublishTap:(id)sender;

@end
