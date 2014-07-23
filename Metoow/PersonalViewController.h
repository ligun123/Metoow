//
//  PersonalViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-19.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSGSessionViewController.h"
#import "HeaderUpdater.h"

@interface PersonalViewController : UIViewController <UIActionSheetDelegate, HeaderUpdaterProtocol, UIAlertViewDelegate>
{
    BOOL is_follow;
}

@property BOOL isMe;    //是我的资料还是别人的资料，我的资料==更多

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
//如果是我的资料则隐藏下面私信和关注
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnFocus;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;   //性别
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *introLabel;       //简介
@property (weak, nonatomic) IBOutlet UILabel *focusNOLabel;     //关注数量
@property (weak, nonatomic) IBOutlet UILabel *fansNOLabel;      //粉丝数
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

@property (strong, nonatomic) HeaderUpdater *headerUpdate;

@property BOOL hideTabBar;


@property (copy, nonatomic) NSString *user_id;

- (IBAction)btnBackTap:(id)sender;
- (IBAction)btnMyFootsTap:(id)sender;       //发布的足迹

- (IBAction)btnFocusTap:(id)sender;

- (IBAction)btnMessageTap:(id)sender;

- (IBAction)btnLogoutTap:(id)sender;

- (IBAction)btnEditTap:(id)sender;

@end
