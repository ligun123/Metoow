//
//  SOSDetailViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-7-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCell.h"
#import "MJRefresh.h"

@interface SOSDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL hasRegister;
    NSInteger page;
    BOOL mustRefreshHelpList;
}

@property (strong, nonatomic) NSDictionary *detailDic;
@property (strong, nonatomic) NSMutableArray *commentsList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) DetailCell *detailCell;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSOS;

- (IBAction)btnBackTap:(id)sender;
- (IBAction)btnTransmitTap:(id)sender;
- (IBAction)btnReplyTap:(id)sender;
- (IBAction)btnStarTap:(id)sender;
- (IBAction)btnPeoPleTap:(id)sender;
- (IBAction)btnCloseSOSTap:(id)sender;

@end
