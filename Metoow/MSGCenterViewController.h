//
//  MSGCenterViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSGCenterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int msgCategaryIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@property (strong, nonatomic) NSArray *msgList;

@end
