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

@interface MSGInputView : UIView <UITextFieldDelegate>
{
    UIImageView *bgView;
    UITextField *inputText;
    UIButton *btnEmoji;
    UIButton *btnPicture;
    
    BOOL isSystemBoard;
    BOOL isEmojiBtnClick;     //判断是否是表情按钮引起的键盘隐藏
}

@property (weak, nonatomic) id<InputViewProtocol> delegate;

@end
