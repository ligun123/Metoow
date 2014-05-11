//
//  MSGInputView.m
//  Metoow
//
//  Created by HalloWorld on 14-5-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MSGInputView.h"

#define kTextHeight 26.f

@implementation MSGInputView

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, 44)];
}

- (void)dealloc
{
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initLayout];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initLayout];
}

- (void)initLayout
{
    isSystemBoard = YES;
    isEmojiBtnClick = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgView.image = [UIImage imageNamed:@"pb_mainColor_bkg"];
    [self addSubview:bgView];
    
    inputText = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-kTextHeight)/2, 230, kTextHeight)];
    [self addSubview:inputText];
    inputText.placeholder = @"请输入...";
    inputText.borderStyle = UITextBorderStyleRoundedRect;
    inputText.returnKeyType = UIReturnKeySend;
    inputText.delegate = self;
    
    btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmoji.frame = CGRectMake(245, 6, 34, 34);
    [btnEmoji setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [btnEmoji addTarget:self action:@selector(btnEmojiTap:) forControlEvents:UIControlEventTouchUpInside];
    [btnEmoji setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
    [self addSubview:btnEmoji];
    
    btnPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPicture.frame = CGRectMake(280, 6, 34, 34);
    [btnPicture setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [btnPicture addTarget:self action:@selector(btnPictureTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPicture];
}

- (void)btnEmojiTap:(UIButton *)emjBtn
{
    [btnEmoji setSelected:![btnEmoji isSelected]];
    if ([btnEmoji isSelected]) {
        isSystemBoard = NO;
        inputText.inputView = [self faceBoard];
    } else {
        isSystemBoard = YES;
        inputText.inputView = nil;
    }
    
    if ([inputText isEditing]) {
        isEmojiBtnClick = YES;
        [inputText resignFirstResponder];
    } else {
        [inputText becomeFirstResponder];
    }
}


- (void)btnPictureTap
{}

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if (isEmojiBtnClick == YES) {
        isEmojiBtnClick = NO;
        [inputText becomeFirstResponder];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:didSendCotent:)]) {
        [_delegate inputView:self didSendCotent:inputText.text];
    }
    return YES;
}


- (FaceBoard *)faceBoard
{
    FaceBoard *face = [[FaceBoard alloc] init];
    face.inputTextField = inputText;
    return face;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
