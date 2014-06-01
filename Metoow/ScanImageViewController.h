//
//  ScanImageViewController.h
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-1-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanImageViewController : UIViewController <UIScrollViewDelegate>{
    NSInteger mCurrentIndex;
}

- (void)setImageArray:(NSArray *)aArr currentIndex:(NSInteger)aIndex;

@property (nonatomic, strong) NSArray *mImageArray;
@property (nonatomic, strong) IBOutlet UIScrollView *mScaleView;
@property (nonatomic, strong) IBOutlet UIImageView *mCurrentImageView;

- (IBAction)btnBackTap:(id)sender;

@end
