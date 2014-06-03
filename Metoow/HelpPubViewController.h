//
//  HelpPubViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSGInputView.h"
#import "PicRollView.h"

@interface HelpPubViewController : UIViewController <BMKSearchDelegate, BMKUserLocationDelegate, UITextViewDelegate, InputViewProtocol>
{
    BMKSearch *baiduSearch;
    BMKUserLocation *userLocation;
}

@property (strong, nonatomic) MSGInputView *myAccessaryView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (strong, nonatomic) BMKAddrInfo *addrInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeSet;
@property (copy, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet PicRollView *picRoll;

- (void)done;           //子类重写

- (IBAction)btnSignleCheckTap:(QCheckBox *)sender;       //单选框选择

- (IBAction)btnTimeTap:(id)sender;


@end
