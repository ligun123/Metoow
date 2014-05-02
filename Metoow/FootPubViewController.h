//
//  FootPubViewController.h
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//  发布足迹

#import <UIKit/UIKit.h>

@interface FootPubViewController : UIViewController <UITextViewDelegate>
{
    BOOL isFirstEditing;        //当textView第一次进入编辑状态时清空其内容
}

@end
