//
//  PersonalViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-19.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalViewController : UIViewController

@property BOOL isMe;    //是我的资料还是别人的资料，我的资料==更多
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnFocus;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)btnBackTap:(id)sender;

@end
