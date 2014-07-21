//
//  MyFootViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-6-8.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordCell.h"
#import "MJRefresh.h"
#import "RichLabelView.h"

@interface MyFootViewController : UIViewController <RecordCellProtocol, MJRefreshBaseViewDelegate, UITableViewDataSource>
{
    BOOL isCellRegesterd;
    NSInteger page;
}

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) RichLabelView *heightCount;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *originalList;

@property (copy, nonatomic) NSString *user_id;

- (IBAction)btnBackTap:(id)sender;


@end
