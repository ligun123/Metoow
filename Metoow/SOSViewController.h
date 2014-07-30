//
//  SOSViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  发布SOS

#import <UIKit/UIKit.h>
#import "QCheckBox.h"

@interface SOSViewController : UIViewController <UITextFieldDelegate, QCheckBoxDelegate>

@property (weak, nonatomic) IBOutlet QCheckBox *dangerLevel1;
@property (weak, nonatomic) IBOutlet QCheckBox *dangerLevel2;
@property (weak, nonatomic) IBOutlet QCheckBox *dangerLevel3;
@property (weak, nonatomic) IBOutlet QCheckBox *dangerLevel4;
@property (weak, nonatomic) IBOutlet UITextField *sosOther;

-(IBAction)btnDangerTap:(id)sender;

@end
