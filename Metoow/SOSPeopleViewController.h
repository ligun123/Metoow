//
//  SOSPeopleViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-7-24.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  参与某救援的好心人列表

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "PersonCell.h"

@interface SOSPeopleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
{
    BOOL hasLoadCell;
    NSInteger page;
}

@property (copy, nonatomic) NSString *sos_id;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

- (IBAction)btnBackTap:(id)sender;

@end
