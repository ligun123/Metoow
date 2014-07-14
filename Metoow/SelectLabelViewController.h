//
//  SelectLabelViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  选择兴趣标签

#import <UIKit/UIKit.h>
#import "SelectLabel.h"

@interface SelectLabelViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *userRegister;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *customTagText;
@property (strong, nonatomic) NSMutableArray *selectLabels;

@property (nonatomic) BOOL isEditing;   //是否是个人资料-编辑-个人标签

@property (copy, nonatomic) NSString *password;


@end
