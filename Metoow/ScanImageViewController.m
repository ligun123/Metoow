//
//  ScanImageViewController.m
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-1-23.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ScanImageViewController.h"

@interface ScanImageViewController ()

@end

@implementation ScanImageViewController

- (id)init
{
    self = [super initWithNibName:@"ScanImageViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mScaleView.backgroundColor = [UIColor blackColor];
    self.mScaleView.maximumZoomScale = 2.0;
    self.mScaleView.minimumZoomScale = 1.0;
    // Do any additional setup after loading the view from its nib.
    
    //增加滑动切换图片手势
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeSelector:)];
    swip.numberOfTouchesRequired = 1;
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swip];
    
    UISwipeGestureRecognizer *swip2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeSelector:)];
    swip2.numberOfTouchesRequired = 1;
    swip2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip2];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self showImageAtIndex:mCurrentIndex];
}

- (void)showImageAtIndex:(NSInteger)index
{
    UIImage *vImage = [self.mImageArray objectAtIndex:index];
    CGSize vImgSize = vImage.size;
    CGRect vFrame;
    float vShowWidth = self.mScaleView.frame.size.width;
    float vShowHeight = self.mScaleView.frame.size.height;
    float width = vShowWidth;
    float height = vShowWidth / vImgSize.width * vImgSize.height;
    if (height > vShowHeight) {
        width = width * vShowHeight / height;
        height = vShowHeight;
    }
    vFrame.size = CGSizeMake(width, height);
    self.mCurrentImageView.frame = vFrame;
    self.mScaleView.contentSize = self.mScaleView.frame.size;
    self.mCurrentImageView.center = CGPointMake(self.mScaleView.contentSize.width/2, self.mScaleView.contentSize.height/2);
    self.mCurrentImageView.image = vImage;
}

- (void)swipeSelector:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        //previous
        [self previousImage];
    }
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft) {
        //next
        [self nextImage];
    }
}

- (void)nextImage
{
    if (mCurrentIndex < self.mImageArray.count - 1) {
        mCurrentIndex ++;
    } else {
        mCurrentIndex = 0;
    }
    [self showImageAtIndex:mCurrentIndex];
    
    CATransition *ani = [CATransition animation];
    ani.type = kCATransitionPush;
    ani.subtype = kCATransitionFromRight;
    ani.duration = 0.3;
    [self.mScaleView.layer addAnimation:ani forKey:nil];
}

- (void)previousImage
{
    if (mCurrentIndex > 0) {
        mCurrentIndex --;
    } else {
        mCurrentIndex = self.mImageArray.count - 1;
    }
    [self showImageAtIndex:mCurrentIndex];
    CATransition *ani = [CATransition animation];
    ani.type = kCATransitionPush;
    ani.subtype = kCATransitionFromLeft;
    ani.duration = 0.3;
    [self.mScaleView.layer addAnimation:ani forKey:nil];
}


- (IBAction)btnBackTap:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageArray:(NSArray *)aArr currentIndex:(NSInteger)aIndex {
    self.mImageArray = aArr;
    mCurrentIndex = aIndex;
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mCurrentImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat width = MAX(scrollView.frame.size.width, scrollView.contentSize.width);
    CGFloat height = MAX(scrollView.frame.size.height, scrollView.contentSize.height);
    CGPoint center = CGPointMake(width/2, height/2);
    self.mCurrentImageView.center = center;
}

@end
