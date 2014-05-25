//
//  PulldownButton.h
//  Metoow
//
//  Created by HalloWorld on 14-4-21.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PulldownButton;

typedef void(^PulldownCallback)(PulldownButton *btn, NSInteger sltIndex);

@interface PulldownButton : UIButton <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *pullListView;
    BOOL isSelect;
    UIFont *labelFont;
}

@property (strong, nonatomic) NSArray *pullList;

@property (copy, nonatomic) PulldownCallback callbackBlock;

+ (PulldownButton *)pulldownButtonWithTitles:(NSArray *)arr callback:(PulldownCallback)block;
- (void)setTitles:(NSArray *)arr;

@end
