//
//  MSGInputView.m
//  Metoow
//
//  Created by HalloWorld on 14-5-5.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MSGInputView.h"

#define kTextHeight 28.5f

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
    bgView.image = [UIImage imageNamed:@"pb_input_bkg"];
    [self addSubview:bgView];
    
    inputText = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.frame.size.height-kTextHeight)/2, 225, kTextHeight)];
    [self addSubview:inputText];
    inputText.placeholder = @"请输入...";
    inputText.borderStyle = UITextBorderStyleRoundedRect;
    inputText.returnKeyType = UIReturnKeySend;
    inputText.delegate = self;
    
    btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmoji.frame = CGRectMake(245, 10, 26, 26);
    [btnEmoji setImage:[UIImage imageNamed:@"pb_fb_btn"] forState:UIControlStateNormal];
    [btnEmoji addTarget:self action:@selector(btnEmojiTap:) forControlEvents:UIControlEventTouchUpInside];
    [btnEmoji setImage:[UIImage imageNamed:@"pb_kbd_btn"] forState:UIControlStateSelected];
    [self addSubview:btnEmoji];
    
    btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(282, 8, 30, 30);
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    btnSend.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(btnSendTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSend];
    btnSend.hidden = YES;
    
    btnPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPicture.frame = CGRectMake(282, 10, 26, 26);
    [btnPicture setImage:[UIImage imageNamed:@"pb_pic_btn"] forState:UIControlStateNormal];
    [btnPicture addTarget:self action:@selector(btnPictureTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPicture];
}

- (void)btnEmojiTap:(UIButton *)emjBtn
{
    if (inputTextOutside == nil) {
        //内置的textField
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
    else {
        //外部的textView
        if (![inputTextOutside isFirstResponder]) {
            [inputTextOutside becomeFirstResponder];
            return ;
        }
        [btnEmoji setSelected:![btnEmoji isSelected]];
        if ([btnEmoji isSelected]) {
            isSystemBoard = NO;
            inputTextOutside.inputView = [self faceBoard];
        } else {
            isSystemBoard = YES;
            inputTextOutside.inputView = nil;
        }
        
        if ([inputTextOutside isFirstResponder]) {
            isEmojiBtnClick = YES;
            [inputTextOutside resignFirstResponder];
        } else {
            [inputText becomeFirstResponder];
        }
    }
}


- (void)btnSendTap
{
    NSString *content = (inputTextOutside == nil) ? inputText.text : inputTextOutside.text;
    if (content.length == 0) {
        return ;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:didSendCotent:)]) {
        [_delegate inputView:self didSendCotent:content];
        inputText.text = @"";
    }
}

- (void)btnPictureTap
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    [[AppDelegateInterface rootViewController] presentViewController:picker animated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if (isEmojiBtnClick == YES) {
        isEmojiBtnClick = NO;
        if (inputTextOutside == nil) {
            [inputText becomeFirstResponder];
        } else {
            [inputTextOutside becomeFirstResponder];
        }
    }
}

- (FaceBoard *)faceBoard
{
    FaceBoard *face = [[FaceBoard alloc] init];
    if (inputTextOutside == nil) {
        face.inputTextField = inputText;
    } else {
        face.inputTextView = inputTextOutside;
    }
    
    return face;
}

- (void)setSendStyle
{
    btnSend.hidden = NO;
    btnPicture.hidden = YES;
}

- (void)setJustEmojiStyle
{
    btnEmoji.frame = btnPicture.frame;
    btnPicture.hidden = YES;
    btnSend.hidden = YES;
}

- (void)setOutsideInput:(UITextView *)txtView
{
    inputTextOutside = txtView;
    inputTextOutside.delegate = self;
    inputText.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UITextView Delegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text UTF8String][0] == '\n') {
        if (inputTextOutside.text.length > 1) {
            if (_delegate && [_delegate respondsToSelector:@selector(inputView:didSendCotent:)]) {
                [_delegate inputView:self didSendCotent:inputTextOutside.text];
//                inputTextOutside.text = @"";
            }
        }
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (inputText.text.length != 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(inputView:didSendCotent:)]) {
            [_delegate inputView:self didSendCotent:inputText.text];
            inputText.text = @"";
        }
    }
    return YES;
}


#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:didSendPicture:)]) {
        [_delegate inputView:self didSendPicture:img];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:didSendPicture:)]) {
        [_delegate inputView:self didSendPicture:nil];
    }
}

@end
