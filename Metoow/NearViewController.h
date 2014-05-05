//
//  NearViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-20.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulldownButton.h"

typedef enum {
    NearCategaryPerson = 0,         //伙伴
    NearCategaryFoot = 1,           //足迹
    NearCategaryRoadDynamic =2,     //路况
    NearCategaryHelp = 3            //互助
} NearCategaryEnum;

@interface NearViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL hasLoadCell;
    NearCategaryEnum currentCategary;
}

@property (weak, nonatomic) IBOutlet PulldownButton *pulldownBtn;


@end
