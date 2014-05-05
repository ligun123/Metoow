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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [btnEmoji addTarget:self action:@selector(btnEmojiTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnEmoji];
    
    btnPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPicture.frame = CGRectMake(280, 6, 34, 34);
    [btnPicture setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [btnPicture addTarget:self action:@selector(btnPictureTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPicture];
}

- (void)btnEmojiTap
{
    UIWindow *win = [[UIApplication sharedApplication] windows][1];
    [win addSubview:emojiView];
}


- (void)btnPictureTap
{}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSValue *endFrame = [noti userInfo][@"UIKeyboardFrameEndUserInfoKey"];
    CGRect f;
    [endFrame getValue:&f];
    
    emojiView = [[UIView alloc] initWithFrame:f];
    emojiView.backgroundColor = [UIColor redColor];
    
    /*  找不到键盘啊，只能笨办法把emoji加到window上了
    NSArray *winds = [[UIApplication sharedApplication] windows];
    for (int i = 0; i < winds.count; i ++) {
        NSLog(@"%s -> i = %d, %@", __FUNCTION__, i, winds[i]);
        NSArray *winSubviews = [winds[i] subviews];
        for (int j = 0; j < winSubviews.count; j ++) {
            NSLog(@"%s -> i = %d, j = %d \n%@", __FUNCTION__, i, j, winSubviews[j]);
        }
    }
     */
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    [emojiView removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
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
