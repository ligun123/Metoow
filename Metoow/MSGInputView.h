//
//  MSGInputView.h
//  Metoow
//
//  Created by HalloWorld on 14-5-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSGInputView : UIView <UITextFieldDelegate>
{
    UIImageView *bgView;
    UITextField *inputText;
    UIButton *btnEmoji;
    UIButton *btnPicture;
    
    UIView *emojiView;
}

@end
