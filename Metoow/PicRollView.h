//
//  PicRollView.h
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-1-2.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PICROLLVIEW_HEIGHT 100.f
#define PICROLLVIEW_WIDTH 100.f

@interface PicRollView : UIScrollView

//不要调用这参数去获取UIImage数组，请[self images];
@property (nonatomic, retain) NSMutableArray *mImageArray;

- (void)setImageArray:(NSArray *)aArray;

- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)aImgArray;

- (void)addImage:(UIImage *)img;

- (void)showMetoowPicIDs:(NSArray *)pic_ids;

//返回正在显示UIImage数组
- (NSArray *)images;

//开启大图浏览功能,默认关闭
- (void)enableScan;

//开启删除功能，默认关闭
- (void)enableDelete;

@end
