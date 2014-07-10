//
//  RichLabelView.m
//  Metoow
//
//  Created by HalloWorld on 14-5-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "RichLabelView.h"
#import "UIImage+Gif.h"

#define KFacialSizeWidth    20

#define KFacialSizeHeight   20

#define KCharacterWidth     8

#define VIEW_LINE_HEIGHT    24


#define VIEW_LEFT           2

#define VIEW_RIGHT          2

#define VIEW_TOP            2

#define VIEW_WIDTH_MAX      166

#define VIEW_WIDTH_FRAME (self.frame.size.width - 3.f)

static NSString *emojiRegular = @"\\[{1}[a-zA-Z]+\\]{1}";

@implementation RichLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)showMessage:(NSArray *)message {
    
    self.data = (NSMutableArray *)message;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.textColor) {
        [self.textColor setFill];
    }
    if (!CGRectEqualToRect(rect, self.bounds)) {
        //画省略号
    }
	if ( self.data ) {
        NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        
        isLineReturn = NO;
        
        upX = VIEW_LEFT;
        upY = VIEW_TOP;
        
		for (int index = 0; index < [self.data count]; index++) {
            
			NSString *str = [self.data objectAtIndex:index];
            
			if ( [str hasPrefix:@"["] && [str hasSuffix:@"]"]) {
                NSString *imageName = [faceMap objectForKey:str];
                NSString *gifPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"miniblog"] stringByAppendingPathComponent:[imageName stringByAppendingFormat:@".gif"]];
                
                UIImage *image = [UIImage imageGifFilePath:gifPath];
                
                if ( image ) {
                    
                    if ( upX > ( VIEW_WIDTH_FRAME ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    [image drawInRect:CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight)];
                    
                    upX += KFacialSizeWidth;
                    
                    lastPlusSize = KFacialSizeWidth;
                }
                else {
                    
                    [self drawText:str withFont:font];
                }
			}
            else {
                
                [self drawText:str withFont:font];
			}
        }
	}
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font{
    
    for ( int index = 0; index < string.length; index++) {
        
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];
        
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(VIEW_WIDTH_FRAME, VIEW_LINE_HEIGHT * 1.5)];
        
        if ( upX > ( VIEW_WIDTH_FRAME - KCharacterWidth ) ) {
            
            isLineReturn = YES;
            
            upX = VIEW_LEFT;
            upY += VIEW_LINE_HEIGHT;
        }
        [character drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:font];
        
        upX += size.width;
        
        lastPlusSize = size.width;
    }
}

/**
 * 判断字符串是否有效
 */
- (BOOL)isStrValid:(NSString *)srcStr forRule:(NSString *)ruleStr {
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:ruleStr
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];
    
    NSUInteger numberOfMatch = [regularExpression numberOfMatchesInString:srcStr
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, srcStr.length)];
    
    return ( numberOfMatch > 0 );
}

- (void)showStringMessage:(NSString *)strMsg
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [RichLabelView getMessageRange:strMsg :arr];
    [self showMessage:arr];
}

+ (void)getMessageRange:(NSString*)message :(NSMutableArray*)array {
    NSRegularExpression *reguler = [NSRegularExpression regularExpressionWithPattern:emojiRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchs = [reguler matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    if (matchs.count == 0) {
        [array addObject:message];
        return ;
    }
    for (int i = 0; i < matchs.count; i ++) {
        NSRange rang  = [(NSTextCheckingResult *)matchs[i] range];
        if (i == 0) {
            if (rang.location > 0) {
                //通过rang将message拆分成表情和文字
                NSString *str = [message substringWithRange:NSMakeRange(0, rang.location)];
                [array addObject:str];
                
                NSString *emoji = [message substringWithRange:rang];
                [array addObject:emoji];
            } else {
                NSString *emoji = [message substringWithRange:rang];
                [array addObject:emoji];
            }
        } else if (i < matchs.count) {
            NSRange lastRange = ((NSTextCheckingResult *)matchs[i-1]).range;
            if (rang.location > lastRange.location + lastRange.length) {
                NSString *str = [message substringWithRange:NSMakeRange(lastRange.location+lastRange.length, rang.location - lastRange.location - lastRange.length)];
                [array addObject:str];
            }
            
            NSString *emoj = [message substringWithRange:rang];
            [array addObject:emoj];
        }
        if (i == matchs.count - 1) {
            if (rang.location + rang.length < message.length) {
                NSString *str = [message substringWithRange:NSMakeRange(rang.location + rang.length, message.length - rang.location - rang.length)];
                [array addObject:str];
            }
        }
    }
}


/**
 *  获取文本尺寸
 */

- (CGSize)contentSize
{
    return [self sizeForMsgArr:self.data];
}

- (CGSize)sizeForContent:(NSString *)msg {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    [RichLabelView getMessageRange:msg :arr];
    return [self sizeForMsgArr:arr];
}


- (CGSize)sizeForMsgArr:(NSArray *)messageRange
{
    CGFloat _upX;
    
    CGFloat _upY;
    
    CGFloat _lastPlusSize;
    
    CGFloat _viewWidth;
    
    CGFloat _viewHeight;
    
    BOOL bisLineReturn;
    
    NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    
    bisLineReturn = NO;
    
    _upX = VIEW_LEFT;
    _upY = VIEW_TOP;
    
    for (int index = 0; index < [messageRange count]; index++) {
        
        NSString *str = [messageRange objectAtIndex:index];
        if ([str hasPrefix:@"["] && [str hasSuffix:@"]"]) {
            
            //NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
            NSString *imageName = [faceMap objectForKey:str];
            NSString *imagePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"miniblog"] stringByAppendingPathComponent:[imageName stringByAppendingFormat:@".gif"]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                
                if ( _upX > ( VIEW_WIDTH_FRAME - KFacialSizeWidth ) ) {
                    
                    bisLineReturn = YES;
                    
                    _upX = VIEW_LEFT;
                    _upY += VIEW_LINE_HEIGHT;
                }
                
                _upX += KFacialSizeWidth;
                
                _lastPlusSize = KFacialSizeWidth;
            }
            else {
                
                for ( int index = 0; index < str.length; index++) {
                    
                    NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                    
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(VIEW_WIDTH_FRAME, VIEW_LINE_HEIGHT * 1.5)];
                    
                    if ( _upX > ( VIEW_WIDTH_FRAME - KCharacterWidth ) ) {
                        
                        bisLineReturn = YES;
                        
                        _upX = VIEW_LEFT;
                        _upY += VIEW_LINE_HEIGHT;
                    }
                    
                    _upX += size.width;
                    
                    _lastPlusSize = size.width;
                }
            }
        }
        else {
            
            for ( int index = 0; index < str.length; index++) {
                
                NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                
                CGSize size = [character sizeWithFont:font
                                    constrainedToSize:CGSizeMake(VIEW_WIDTH_FRAME, VIEW_LINE_HEIGHT * 1.5)];
                
                if ( _upX > ( VIEW_WIDTH_FRAME - KCharacterWidth ) ) {
                    
                    bisLineReturn = YES;
                    
                    _upX = VIEW_LEFT;
                    _upY += VIEW_LINE_HEIGHT;
                }
                
                _upX += size.width;
                
                _lastPlusSize = size.width;
            }
        }
    }
    
    if ( bisLineReturn ) {
        
        _viewWidth = VIEW_WIDTH_FRAME + VIEW_LEFT;
    }
    else {
        
        _viewWidth = _upX + VIEW_LEFT;
    }
    
    _viewHeight = _upY + VIEW_LINE_HEIGHT + VIEW_TOP;
    
    return CGSizeMake( _viewWidth, _viewHeight );
}
@end
