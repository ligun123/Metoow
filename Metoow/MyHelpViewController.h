//
//  MyHelpViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  某人的互助

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface MyHelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>
{
    BOOL hasRegister;
    NSInteger page;
}

@property (strong, nonatomic) MJRefreshHeaderView *headerView;
@property (strong, nonatomic) MJRefreshFooterView *footerView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataList;

@end
