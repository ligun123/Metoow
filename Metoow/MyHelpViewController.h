//
//  MyHelpViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  某人的互助

#import <UIKit/UIKit.h>

@interface MyHelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL hasRegister;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataList;

@end
