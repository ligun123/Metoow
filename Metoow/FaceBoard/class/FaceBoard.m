//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"


#define FACE_COUNT_ALL  85

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44


@implementation FaceBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (void)initFaceMap
{
    _faceMap = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"] retain];
}

- (id)init {

    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
        [self initFaceMap];
        /*
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {

            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"_expression_cn"
                                                         ofType:@"plist"]] retain];
        }
        else {

            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                         ofType:@"plist"]] retain];
            NSLog([_faceMap description]);
        }
       
        [[NSUserDefaults standardUserDefaults] setObject:_faceMap forKey:@"FaceMap"];
         */

        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * 320, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        NSArray *arr = [_faceMap allValues];
        for (int i = 1; i < arr.count; i++) {
            
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            [faceButton setImageName:arr[i]];
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 6 + ((i - 1) / FACE_COUNT_PAGE * 320);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
            faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);

            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        /*
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(272, 182, 38, 28);
        [self addSubview:back];
         */
    }

    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [facePageControl setCurrentPage:faceView.contentOffset.x / 320];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * 320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {

    NSString *name = ((FaceButton*)sender).name;
    if (self.inputTextField) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:[NSString stringWithFormat:@"[%@]", name]];
                self.inputTextField.text = faceString;
        [faceString release];
    }

    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[NSString stringWithFormat:@"[%@]", name]];
        self.inputTextView.text = faceString;
        [faceString release];
        [delegate textViewDidChange:self.inputTextView];
    }
}

- (void)backFace{

    NSString *inputString;
    inputString = self.inputTextField.text;
    if ( self.inputTextView ) {

        inputString = self.inputTextView.text;
    }

    if ( inputString.length ) {
        
        NSString *string = nil;
        NSInteger stringLength = inputString.length;
        if ( stringLength >= FACE_NAME_LEN ) {
            
            string = [inputString substringFromIndex:stringLength - FACE_NAME_LEN];
            NSRange range = [string rangeOfString:FACE_NAME_HEAD];
            if ( range.location == 0 ) {
                
                string = [inputString substringToIndex:
                          [inputString rangeOfString:FACE_NAME_HEAD
                                             options:NSBackwardsSearch].location];
            }
            else {
                
                string = [inputString substringToIndex:stringLength - 1];
            }
        }
        else {
            
            string = [inputString substringToIndex:stringLength - 1];
        }
        
        if ( self.inputTextField ) {
            
            self.inputTextField.text = string;
        }
        
        if ( self.inputTextView ) {
            
            self.inputTextView.text = string;
            
            [delegate textViewDidChange:self.inputTextView];
        }
    }
}

- (void)dealloc {
    
    [_faceMap release];
    [_inputTextField release];
    [_inputTextView release];
    [faceView release];
    [facePageControl release];
    
    [super dealloc];
}

@end
