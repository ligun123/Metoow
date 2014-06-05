//
//  NearViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulldownButton.h"
#import "RecordCell.h"
#import "HuzhuCell.h"

typedef enum {
    NearCategaryPerson = 0,         //伙伴
    NearCategaryFoot = 1,           //足迹
    NearCategaryRoadDynamic =2,     //路况
    NearCategaryHelp = 3            //互助
} NearCategaryEnum;

@interface NearViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RecordCellProtocol, HuzhuCellProtocol>
{
    BOOL hasLoadCell;
    NearCategaryEnum currentCategary;
    NSInteger page;
}

@property (weak, nonatomic) IBOutlet PulldownButton *pulldownBtn;
@property (strong, nonatomic) NSArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end
