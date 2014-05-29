//
//  FootPubViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  发布足迹

#import <UIKit/UIKit.h>
#import "MSGInputView.h"
#import "LoginCheckBox.h"
#import "PicRollView.h"

@interface FootPubViewController : UIViewController <UITextViewDelegate, InputViewProtocol, BMKSearchDelegate>
{
    BMKSearch *baiduSearch;
    BMKUserLocation *userLocation;
}

@property (weak, nonatomic) IBOutlet MSGInputView *inputBar;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet LoginCheckBox *isPublic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PicRollView *picRoll;
@property (copy, nonatomic) NSString *addrString;

@property (strong, nonatomic) NSDictionary *dataDic;        //当转发和回复时需要此字典

@property FootPubEditCategary editCategary;

@end
