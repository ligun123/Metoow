//
//  MessageView.m
//  FaceBoardDome
//
//  Created by kangle1208 on 13-12-12.
//  Copyright (c) 2013年 Blue. All rights reserved.
//

#import "MessageView.h"

#import "FaceBoard.h"


#define FACE_ICON_NAME      @"^[0][0-8][0-5]$"

static NSString *emojiRegular = @"\\[{1}[a-zA-Z]+\\]{1}";

@implementation MessageView

@synthesize data;

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showMessage:(NSArray *)message {

    self.data = (NSMutableArray *)message;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

	if ( data ) {

        NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];

        UIFont *font = [UIFont systemFontOfSize:16.0f];

        isLineReturn = NO;

        upX = VIEW_LEFT;
        upY = VIEW_TOP;

		for (int index = 0; index < [data count]; index++) {

			NSString *str = [data objectAtIndex:index];
			if ( [str hasPrefix:@"["] && [str hasSuffix:@"]"]) {
                NSString *imageName = [faceMap objectForKey:str];
				//NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                
                /*
                NSArray *imageNames = [faceMap allKeysForObject:str];
                NSString *imageName = nil;
                
                if ( imageNames.count > 0 ) {
                    
                    imageName = [imageNames objectAtIndex:0];
                }
                 */

                UIImage *image = [UIImage imageNamed:imageName];

                if ( image ) {

//                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                    if ( upX > ( VIEW_WIDTH_MAX ) ) {

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
                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];

        if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {

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
    [regularExpression release];
    
    return ( numberOfMatch > 0 );
}

- (void)showStringMessage:(NSString *)strMsg
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [self getMessageRange:strMsg :arr];
    [self showMessage:arr];
    [arr autorelease];
}

- (void)getMessageRange:(NSString*)message :(NSMutableArray*)array {
    NSRegularExpression *reguler = [NSRegularExpression regularExpressionWithPattern:emojiRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchs = [reguler matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    for (int i = 0; i < matchs.count; i ++) {
        NSRange rang  = [(NSTextCheckingResult *)matchs[i] range];
        if (i == 0) {
            if (rang.location > 0) {
                //通过rang将message拆分成表情和文字
                NSString *str = [message substringWithRange:NSMakeRange(0, rang.location)];
                [array addObject:str];
                
                NSString *emoji = [message substringWithRange:rang];
                [array addObject:emoji];
            }
        } else if (i < matchs.count) {
            NSRange lastRange = ((NSTextCheckingResult *)matchs[i-1]).range;
            NSString *str = [message substringWithRange:NSMakeRange(lastRange.location+lastRange.length, rang.location - lastRange.location - lastRange.length)];
            [array addObject:str];
            
            NSString *emoj = [message substringWithRange:rang];
            [array addObject:emoj];
            if (i == matchs.count - 1) {
                if (rang.location + rang.length < message.length) {
                    NSString *str = [message substringWithRange:NSMakeRange(rang.location + rang.length, message.length - rang.location - rang.length)];
                }
                [array addObject:str];
            }
        }
    }
    /*
	NSRange range = [message rangeOfString:FACE_NAME_HEAD];
    
    //判断当前字符串是否存在表情的转义字符串
    if ( range.length > 0 ) {
        
        if ( range.location > 0 ) {
            
            [array addObject:[message substringToIndex:range.location]];
            
            message = [message substringFromIndex:range.location];
            
            if ( message.length > FACE_NAME_LEN ) {
                
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else
                // 排除空字符串
                if ( message.length > 0 ) {
                    
                    [array addObject:message];
                }
        }
        else {
            
            if ( message.length > FACE_NAME_LEN ) {
                
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else
                // 排除空字符串
                if ( message.length > 0 ) {
                    
                    [array addObject:message];
                }
        }
    }
    else {
        
        [array addObject:message];
    }
     */
}


- (void)dealloc {

    [super dealloc];
}

@end
