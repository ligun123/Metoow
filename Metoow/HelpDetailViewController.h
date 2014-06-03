//
//  HelpDetailViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-6-3.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCell.h"

@interface HelpDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL hasRegister;
    NSInteger page;
}

@property (strong, nonatomic) NSDictionary *detailDic;
@property (strong, nonatomic) NSArray *commentsList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) DetailCell *detailCell;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

- (IBAction)btnBackTap:(id)sender;
- (IBAction)btnTransmitTap:(id)sender;
- (IBAction)btnReplyTap:(id)sender;

@end
