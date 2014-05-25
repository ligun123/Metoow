//
//  HPsfcViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-5-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  发布顺风车

#import "HelpPubViewController.h"

@interface HPsfcViewController : HelpPubViewController

@property (weak, nonatomic) IBOutlet UIView *tripMethodView;
@property (weak, nonatomic) IBOutlet UITextField *placeFrom;
@property (weak, nonatomic) IBOutlet UITextField *placeTo;
@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@end
