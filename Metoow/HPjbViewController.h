//
//  HPjbViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-5-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HelpPubViewController.h"

@interface HPjbViewController : HelpPubViewController

@property (weak, nonatomic) IBOutlet UITextField *placeFrom;
@property (weak, nonatomic) IBOutlet UITextField *placeTo;
@property (weak, nonatomic) IBOutlet UIView *tripMethodView;
@property (weak, nonatomic) IBOutlet UIButton *dateFrom;
@property (weak, nonatomic) IBOutlet UITextField *timeCost;
@property (weak, nonatomic) IBOutlet UITextField *moneyCost;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@end