//
//  MSGInputView.h
//  Metoow
//
//  Created by HalloWorld on 14-5-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoard.h"

@class MSGInputView;
@protocol InputViewProtocol <NSObject>

@required
/**
 *  发文字
 *
 *  @param inputView MSGInputView
 *  @param txt       文字内容包含表情的标示符字符串
 */
- (void)inputView:(MSGInputView *)inputView didSendCotent:(NSString *)txt;

/**
 *  发图片
 *
 *  @param inputView MSGInputView
 *  @param img       发送的图片UIImage对象
 */
- (void)inputView:(MSGInputView *)inputView didSendPicture:(UIImage *)img;

@end

@interface MSGInputView : UIView <UITextFieldDelegate, UITextViewDelegate>
{
    UIImageView *bgView;
    
    UIButton *btnEmoji;
    UIButton *btnPicture;
    UIButton *btnSend;
    UITextView *inputTextOutside;
    UITextField *inputText;             //inputText和inputTextOutside只能有一项起效，默认inputText，但inputTextOutside优先更高
    
    BOOL isSystemBoard;
    BOOL isEmojiBtnClick;     //判断是否是表情按钮引起的键盘隐藏
}

@property (weak, nonatomic) id<InputViewProtocol> delegate;

/**
 *  默认是现实发图片的按钮，调用次函数会将发图片的按钮替换为发送按钮，在某些不用发图片的页面中使用
 */
- (void)setSendStyle;

/**
 *  将隐藏图片按钮和发送按钮，在互助发布页面中使用
 */
- (void)setJustEmojiStyle;


- (void)setOutsideInput:(UITextView *)txtView;
@end
