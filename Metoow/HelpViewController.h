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


@interface HelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    BOOL hasRegister;
    int selectIndex;
}

@property (weak, nonatomic) IBOutlet PulldownButton *pulldownBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *dataList;

- (IBAction)btnPublishTap:(id)sender;

- (void)refresh;

@end
