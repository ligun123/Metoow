//
//  HelpViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  互助

#import <UIKit/UIKit.h>
#import "PulldownButton.h"
#import "HuzhuCell.h"
#import "MJRefresh.h"


@interface HelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, HuzhuCellProtocol, MJRefreshBaseViewDelegate>
{
    BOOL hasRegister;
    int selectIndex;
    BOOL isSearching;
    NSInteger page;
}

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

@property (strong, nonatomic) NSMutableArray *searchList;

@property (weak, nonatomic) IBOutlet PulldownButton *pulldownBtn;

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *dataList;

- (IBAction)btnPublishTap:(id)sender;

- (IBAction)btnMyHelpTap:(id)sender;

- (void)refresh;

@end
