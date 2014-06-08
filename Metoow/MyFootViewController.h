//
//  MyFootViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-6-8.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordCell.h"

@interface MyFootViewController : UIViewController <RecordCellProtocol>
{
    BOOL isCellRegesterd;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray *dataList;

@property (copy, nonatomic) NSString *user_id;

- (IBAction)btnBackTap:(id)sender;

@end
