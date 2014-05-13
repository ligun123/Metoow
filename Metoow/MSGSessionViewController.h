//
//  MSGSessionViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-5-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSGInputView.h"

@interface MSGSessionViewController : UIViewController <InputViewProtocol>
{
    BOOL isRegistered;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (weak, nonatomic) IBOutlet MSGInputView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (copy, nonatomic) NSString *msgID;
@property (copy, nonatomic) NSString *frdName;
@property (copy, nonatomic) NSString *frdUid;

@end
