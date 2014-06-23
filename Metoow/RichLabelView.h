//
//  RichLabelView.h
//  Metoow
//
//  Created by HalloWorld on 14-5-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichLabelView : UIView
{
    CGFloat upX;
    
    CGFloat upY;
    
    CGFloat lastPlusSize;
    
    CGFloat viewWidth;
    
    CGFloat viewHeight;
    
    BOOL isLineReturn;
}

@property (nonatomic, retain) NSMutableArray *data;

- (void)showStringMessage:(NSString *)strMsg;
- (CGSize)contentSize;
- (CGSize)sizeForContent:(NSString *)msg;

@end
