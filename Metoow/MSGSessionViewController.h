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

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (weak, nonatomic) IBOutlet MSGInputView *inputView;

@end
