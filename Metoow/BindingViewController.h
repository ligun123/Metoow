//
//  BindingViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-6-23.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingViewController : UIViewController

@property (copy, nonatomic) NSString *user_id;
@property NSInteger auth_type;

@property (weak, nonatomic) IBOutlet UITextField *userIDText;
@property (weak, nonatomic) IBOutlet UITextField *pswdText;

- (IBAction)btnBindTap:(id)sender;
- (IBAction)btnBackTap:(id)sender;

@end
